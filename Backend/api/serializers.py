
from rest_framework import serializers
from .models import ClientProfile, ProviderProfile
from users.serializers import UserSerializer

class ClientProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = ClientProfile
        fields = ['user', 'latitude', 'longitude']

class ProviderProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = ProviderProfile
        fields = ['user', 'latitude', 'longitude']
