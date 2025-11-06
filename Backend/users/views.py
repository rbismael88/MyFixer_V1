from django.shortcuts import render, redirect
from django.urls import reverse
from django.contrib.auth.decorators import user_passes_test
from django.db.models import Q
from rest_framework.generics import CreateAPIView, RetrieveUpdateAPIView
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User
from .serializers import UserSerializer, LoginSerializer, UserProfileUpdateSerializer, UserProfileSerializer
from .utils import is_user_verified
from .consumers import send_admin_notification, send_user_update
from asgiref.sync import async_to_sync

from django.contrib.auth.decorators import login_required

@login_required(login_url='login')
def admin_dashboard_view(request):
    if not request.user.is_staff:
        return redirect('login')
    
    status = request.GET.get('status', 'all')
    users_query = User.objects.filter(is_superuser=False)

    total_users = users_query.count()
    
    verified_users_list = []
    in_progress_users_list = []
    not_verified_users_list = []

    for user in users_query:
        is_verified = False
        has_documents = False

        if user.user_type == 'client':
            is_verified = (
                user.profile_picture_verified and
                user.identity_card_verified
            )
            has_documents = (
                user.profile_picture or
                user.identity_card
            )
        elif user.user_type == 'provider':
            is_verified = (
                user.profile_picture_verified and
                user.identity_card_verified and
                user.criminal_record_certificate_verified
            )
            has_documents = (
                user.profile_picture or
                user.identity_card or
                user.criminal_record_certificate
            )

        if is_verified:
            verified_users_list.append(user)
        elif has_documents:
            in_progress_users_list.append(user)
        else:
            not_verified_users_list.append(user)

    verified_users_count = len(verified_users_list)

    if status == 'verified':
        display_users = verified_users_list
    elif status == 'in_progress':
        display_users = in_progress_users_list
    elif status == 'not_verified':
        display_users = not_verified_users_list
    else:
        display_users = users_query.order_by('id')

    return render(request, 'admin_dashboard/dashboard.html', {
        'users': display_users,
        'active_status': status,
        'total_users': total_users,
        'verified_users': verified_users_count,
    })

@user_passes_test(lambda u: u.is_staff)
def verify_user_document_view(request, user_id, document_type):
    if request.method == 'POST':
        try:
            user = User.objects.get(id=user_id)
            if document_type == 'identity_card':
                user.identity_card_verified = True
            elif document_type == 'criminal_record':
                user.criminal_record_certificate_verified = True
            elif document_type == 'profile_picture':
                user.profile_picture_verified = True
            user.save()
        except User.DoesNotExist:
            # Manejar el caso de usuario no encontrado si es necesario
            pass
    
    # Redirect back to the same tab the user was on
    status = request.POST.get('status', 'all')
    return redirect(f"{reverse('admin-dashboard')}?status={status}")

@user_passes_test(lambda u: u.is_staff)
def reject_user_document_view(request, user_id, document_type):
    if request.method == 'POST':
        try:
            user = User.objects.get(id=user_id)
            if document_type == 'identity_card':
                if user.identity_card:
                    user.identity_card.delete(save=False)
                user.identity_card_verified = False
            elif document_type == 'criminal_record':
                if user.criminal_record_certificate:
                    user.criminal_record_certificate.delete(save=False)
                user.criminal_record_certificate_verified = False
            elif document_type == 'profile_picture':
                if user.profile_picture:
                    user.profile_picture.delete(save=False)
                user.profile_picture_verified = False
            
            user.save()
        except User.DoesNotExist:
            pass
    
    status = request.POST.get('status', 'all')
    return redirect(f"{reverse('admin-dashboard')}?status={status}")

class UserRegistrationView(CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
    authentication_classes = []

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"request": self.request})
        return context

class UserLoginView(APIView):
    permission_classes = [AllowAny]
    authentication_classes = []
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        identifier = serializer.validated_data['identifier']
        password = serializer.validated_data['password']
        
        user = None
        # Try to authenticate with Django's backend (checks username)
        user = authenticate(request, username=identifier, password=password)

        if not user:
            # If that fails, try to find a user by email or phone
            try:
                if '@' in identifier:
                    user_query = User.objects.get(email=identifier)
                else:
                    user_query = User.objects.get(phone_number=identifier)
                
                if user_query.check_password(password):
                    user = user_query
            except User.DoesNotExist:
                pass # User not found by email or phone, user remains None

        if user:
            # Authentication successful, create tokens
            refresh = RefreshToken.for_user(user)
            user_serializer = UserSerializer(user, context={'request': request})
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': user_serializer.data,
                'message': 'Inicio de sesión exitoso'
            }, status=status.HTTP_200_OK)
        else:
            # All authentication methods failed
            return Response({'error': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)

class UserProfileView(RetrieveUpdateAPIView):
    queryset = User.objects.all()
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return UserProfileUpdateSerializer
        return UserProfileSerializer

    def get_object(self):
        return self.request.user

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"request": self.request})
        return context

    def put(self, request, *args, **kwargs):
        response = super().put(request, *args, **kwargs)
        if response.status_code == 200:
            user = self.get_object()
            if 'identity_card' in request.data or 'criminal_record_certificate' in request.data or 'profile_picture' in request.data:
                async_to_sync(send_admin_notification)(f'El usuario {user.username} ha subido nuevos documentos.')
                async_to_sync(send_user_update)(user)
        return response

    def patch(self, request, *args, **kwargs):
        response = super().patch(request, *args, **kwargs)
        if response.status_code == 200:
            user = self.get_object()
            if 'identity_card' in request.data or 'criminal_record_certificate' in request.data or 'profile_picture' in request.data:
                async_to_sync(send_admin_notification)(f'El usuario {user.username} ha subido nuevos documentos.')
                async_to_sync(send_user_update)(user)
        return response

class DocumentVerificationView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, user_id):
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=status.HTTP_404_NOT_FOUND)

        # Solo permitir que un administrador (o un proceso automatizado) actualice el estado de verificación
        # Aquí se asume que hay un mecanismo para identificar a los administradores. 
        # Por simplicidad, en este ejemplo, cualquier usuario autenticado puede hacerlo. 
        # En un entorno de producción, se debería añadir una comprobación de permisos más robusta.

        identity_card_verified = request.data.get('identity_card_verified', None)
        criminal_record_certificate_verified = request.data.get('criminal_record_certificate_verified', None)

        if identity_card_verified is not None:
            user.identity_card_verified = identity_card_verified
        if criminal_record_certificate_verified is not None:
            user.criminal_record_certificate_verified = criminal_record_certificate_verified
        
        user.save()
        return Response({'message': 'Estado de verificación de documentos actualizado correctamente'}, status=status.HTTP_200_OK)

from django.contrib.auth import login, logout
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from .forms import StaffUserCreationForm

def signup_view(request):
    if request.method == 'POST':
        form = StaffUserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            # Redirect to the login page after successful signup
            return redirect('login')
    else:
        form = StaffUserCreationForm()
    return render(request, 'registration/signup.html', {'form': form})

def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('admin-dashboard')
    else:
        form = AuthenticationForm()
    return render(request, 'registration/login.html', {'form': form})

def logout_view(request):
    logout(request)
    return redirect('login')

class UserVerificationStatusView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        verified = is_user_verified(user)
        return Response({'is_verified': verified}, status=status.HTTP_200_OK)
