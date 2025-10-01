from django.contrib import admin
from .models import ClientProfile, ProviderProfile

admin.site.register(ClientProfile)
admin.site.register(ProviderProfile)