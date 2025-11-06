from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    profile_picture = serializers.SerializerMethodField()
    identity_card = serializers.SerializerMethodField()
    criminal_record_certificate = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'first_name', 'last_name', 'email', 'phone_number', 'user_type', 'profile_picture', 'identity_card', 'criminal_record_certificate', 'password', 'is_verified']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def get_profile_picture(self, obj):
        request = self.context.get('request')
        if obj.profile_picture and hasattr(obj.profile_picture, 'url'):
            if request:
                return request.build_absolute_uri(obj.profile_picture.url)
            return obj.profile_picture.url
        return None

    def get_identity_card(self, obj):
        request = self.context.get('request')
        if obj.identity_card and hasattr(obj.identity_card, 'url'):
            if request:
                return request.build_absolute_uri(obj.identity_card.url)
            return obj.identity_card.url
        return None

    def get_criminal_record_certificate(self, obj):
        request = self.context.get('request')
        if obj.criminal_record_certificate and hasattr(obj.criminal_record_certificate, 'url'):
            if request:
                return request.build_absolute_uri(obj.criminal_record_certificate.url)
            return obj.criminal_record_certificate.url
        return None

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user

class LoginSerializer(serializers.Serializer):
    identifier = serializers.CharField()
    password = serializers.CharField(write_only=True)

class UserProfileSerializer(serializers.ModelSerializer):
    profile_picture = serializers.SerializerMethodField()
    identity_card = serializers.SerializerMethodField()
    criminal_record_certificate = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id', 'username', 'first_name', 'last_name', 'email', 'phone_number', 
            'user_type', 'profile_picture', 'identity_card', 'criminal_record_certificate', 
            'is_verified', 'profile_picture_verified', 'identity_card_verified', 
            'criminal_record_certificate_verified'
        ]

    def get_profile_picture(self, obj):
        request = self.context.get('request')
        if obj.profile_picture and hasattr(obj.profile_picture, 'url'):
            return request.build_absolute_uri(obj.profile_picture.url) if request else obj.profile_picture.url
        return None

    def get_identity_card(self, obj):
        request = self.context.get('request')
        if obj.identity_card and hasattr(obj.identity_card, 'url'):
            return request.build_absolute_uri(obj.identity_card.url) if request else obj.identity_card.url
        return None

    def get_criminal_record_certificate(self, obj):
        request = self.context.get('request')
        if obj.criminal_record_certificate and hasattr(obj.criminal_record_certificate, 'url'):
            return request.build_absolute_uri(obj.criminal_record_certificate.url) if request else obj.criminal_record_certificate.url
        return None

class UserProfileUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'first_name', 'last_name', 'username', 'phone_number', 
            'user_type', 'profile_picture', 'identity_card', 'criminal_record_certificate'
        ]
        extra_kwargs = {
            'profile_picture': {'required': False},
            'identity_card': {'required': False},
            'criminal_record_certificate': {'required': False},
        }