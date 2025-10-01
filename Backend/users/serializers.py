
from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'first_name', 'last_name', 'email', 'phone_number', 'user_type', 'profile_picture', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user

class LoginSerializer(serializers.Serializer):
    identifier = serializers.CharField()
    password = serializers.CharField(write_only=True)

class UserProfileUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'username', 'email', 'phone_number', 'profile_picture', 'user_type']
        read_only_fields = ['email'] # Email should probably not be changeable via this endpoint

    def update(self, instance, validated_data):
        # Ensure username is unique if changed
        if 'username' in validated_data and validated_data['username'] != instance.username:
            if User.objects.filter(username=validated_data['username']).exists():
                raise serializers.ValidationError({'username': 'Este nombre de usuario ya está en uso.'})
        
        # Ensure phone_number is unique if changed
        if 'phone_number' in validated_data and validated_data['phone_number'] != instance.phone_number:
            if User.objects.filter(phone_number=validated_data['phone_number']).exists():
                raise serializers.ValidationError({'phone_number': 'Este número de teléfono ya está en uso.'})

        return super().update(instance, validated_data)
