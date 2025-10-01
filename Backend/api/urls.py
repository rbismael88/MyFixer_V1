
from django.urls import path
from .views import (
    ClientProfileListCreateView,
    ClientProfileRetrieveUpdateDestroyView,
    ProviderProfileListCreateView,
    ProviderProfileRetrieveUpdateDestroyView,
)

urlpatterns = [
    path('clients/', ClientProfileListCreateView.as_view(), name='client-list-create'),
    path('clients/<int:pk>/', ClientProfileRetrieveUpdateDestroyView.as_view(), name='client-detail'),
    path('providers/', ProviderProfileListCreateView.as_view(), name='provider-list-create'),
    path('providers/<int:pk>/', ProviderProfileRetrieveUpdateDestroyView.as_view(), name='provider-detail'),
]
