from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    profile_picture = serializers.SerializerMethodField()
    identity_card = serializers.SerializerMethodField()
    criminal_record_certificate = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'first_name', 'last_name', 'email', 'phone_number', 'user_type', 'profile_picture', 'identity_card', 'criminal_record_certificate', 'password']
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

class UserProfileUpdateSerializer(serializers.ModelSerializer):
    profile_picture_url = serializers.SerializerMethodField()
    identity_card_url = serializers.SerializerMethodField()
    criminal_record_certificate_url = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'first_name', 'last_name', 'username', 'email', 'phone_number', 
            'user_type', 'profile_picture', 'identity_card', 'criminal_record_certificate',
            'profile_picture_url', 'identity_card_url', 'criminal_record_certificate_url'
        ]
        read_only_fields = ['email', 'profile_picture_url', 'identity_card_url', 'criminal_record_certificate_url']
        extra_kwargs = {
            'profile_picture': {'write_only': True, 'required': False},
            'identity_card': {'write_only': True, 'required': False},
            'criminal_record_certificate': {'write_only': True, 'required': False},
        }

    def get_profile_picture_url(self, obj):
        request = self.context.get('request')
        if obj.profile_picture and hasattr(obj.profile_picture, 'url'):
            return request.build_absolute_uri(obj.profile_picture.url)
        return None

    def get_identity_card_url(self, obj):
        request = self.context.get('request')
        if obj.identity_card and hasattr(obj.identity_card, 'url'):
            return request.build_absolute_uri(obj.identity_card.url)
        return None

    def get_criminal_record_certificate_url(self, obj):
        request = self.context.get('request')
        if obj.criminal_record_certificate and hasattr(obj.criminal_record_certificate, 'url'):
            return request.build_absolute_uri(obj.criminal_record_certificate.url)
        return None

    def update(self, instance, validated_data):
        # Manually update the file fields if they are present in the validated data
        instance.profile_picture = validated_data.get('profile_picture', instance.profile_picture)
        instance.identity_card = validated_data.get('identity_card', instance.identity_card)
        instance.criminal_record_certificate = validated_data.get('criminal_record_certificate', instance.criminal_record_certificate)

        # Ensure username is unique if changed
        if 'username' in validated_data and validated_data['username'] != instance.username:
            if User.objects.filter(username=validated_data['username']).exists():
                raise serializers.ValidationError({'username': 'Este nombre de usuario ya está en uso.'})
        
        # Ensure phone_number is unique if changed
        if 'phone_number' in validated_data and validated_data['phone_number'] != instance.phone_number:
            if User.objects.filter(phone_number=validated_data['phone_number']).exists():
                raise serializers.ValidationError({'phone_number': 'Este número de teléfono ya está en uso.'})

        return super().update(instance, validated_data)