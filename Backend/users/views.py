from rest_framework.generics import CreateAPIView, RetrieveUpdateAPIView
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User
from .serializers import UserSerializer, LoginSerializer, UserProfileUpdateSerializer

class UserRegistrationView(CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
    authentication_classes = []

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
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user_id': user.id,
                'username': user.username,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'email': user.email,
                'phone_number': user.phone_number,
                'user_type': user.user_type,
                'profile_picture': user.profile_picture.url if user.profile_picture else None,
                'message': 'Inicio de sesión exitoso'
            }, status=status.HTTP_200_OK)
        else:
            # All authentication methods failed
            return Response({'error': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)

class UserProfileView(RetrieveUpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserProfileUpdateSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user
