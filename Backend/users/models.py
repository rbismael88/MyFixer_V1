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