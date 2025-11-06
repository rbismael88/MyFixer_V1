from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    USER_TYPE_CHOICES = (
        ("client", "Client"),
        ("provider", "Provider"),
    )
    user_type = models.CharField(max_length=10, choices=USER_TYPE_CHOICES, default="client")
    phone_number = models.CharField(max_length=20, unique=True, blank=False, null=False) # Unique added back, default removed

    # Override fields from AbstractUser to make them mandatory
    first_name = models.CharField(max_length=150, blank=False) # Default removed
    last_name = models.CharField(max_length=150, blank=False) # Default removed
    email = models.EmailField(blank=False, unique=True) # Default removed

    profile_picture = models.ImageField(upload_to='profile_pics/', blank=True, null=True)
    identity_card = models.ImageField(upload_to='identity_cards/', blank=True, null=True)
    criminal_record_certificate = models.ImageField(upload_to='criminal_records/', blank=True, null=True)
    
    profile_picture_verified = models.BooleanField(default=False)
    identity_card_verified = models.BooleanField(default=False)
    criminal_record_certificate_verified = models.BooleanField(default=False)

    @property
    def is_verified(self):
        if self.user_type == 'client':
            return self.profile_picture_verified and self.identity_card_verified
        elif self.user_type == 'provider':
            return self.profile_picture_verified and self.identity_card_verified and self.criminal_record_certificate_verified
        return False

    def save(self, *args, **kwargs):
        # Check if the instance has been saved before.
        if self.pk:
            try:
                old_instance = User.objects.get(pk=self.pk)
                # Check for identity card change
                if old_instance.identity_card and old_instance.identity_card != self.identity_card:
                    old_instance.identity_card.delete(save=False)
                # Check for criminal record certificate change
                if old_instance.criminal_record_certificate and old_instance.criminal_record_certificate != self.criminal_record_certificate:
                    old_instance.criminal_record_certificate.delete(save=False)
                # Check for profile picture change
                if old_instance.profile_picture and old_instance.profile_picture != self.profile_picture:
                    old_instance.profile_picture.delete(save=False)
            except User.DoesNotExist:
                # This case should ideally not happen if self.pk exists.
                pass
        super().save(*args, **kwargs)