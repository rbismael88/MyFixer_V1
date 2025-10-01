from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from .models import ClientProfile, ProviderProfile
from .serializers import ClientProfileSerializer, ProviderProfileSerializer

class ClientProfileListCreateView(ListCreateAPIView):
    queryset = ClientProfile.objects.all()
    serializer_class = ClientProfileSerializer

class ClientProfileRetrieveUpdateDestroyView(RetrieveUpdateDestroyAPIView):
    queryset = ClientProfile.objects.all()
    serializer_class = ClientProfileSerializer

class ProviderProfileListCreateView(ListCreateAPIView):
    queryset = ProviderProfile.objects.all()
    serializer_class = ProviderProfileSerializer

class ProviderProfileRetrieveUpdateDestroyView(RetrieveUpdateDestroyAPIView):
    queryset = ProviderProfile.objects.all()
    serializer_class = ProviderProfileSerializer
