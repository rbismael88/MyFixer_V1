
from django.urls import path
from .views import (
    UserRegistrationView, 
    UserLoginView, 
    UserProfileView, 
    DocumentVerificationView, 
    UserVerificationStatusView, 
    admin_dashboard_view,
    verify_user_document_view,
    reject_user_document_view,
    signup_view,
    login_view,
    logout_view
)
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('register/', UserRegistrationView.as_view(), name='user-registration'),
    path('login/', UserLoginView.as_view(), name='user-login'),
    path('profile/', UserProfileView.as_view(), name='user-profile'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('verify-documents/<int:user_id>/', DocumentVerificationView.as_view(), name='document-verification'),
    path('verification-status/', UserVerificationStatusView.as_view(), name='user-verification-status'),
    path('admin-dashboard/', admin_dashboard_view, name='admin-dashboard'),
    path('verify-document/<int:user_id>/<str:document_type>/', verify_user_document_view, name='verify-user-document'),
    path('reject-document/<int:user_id>/<str:document_type>/', reject_user_document_view, name='reject-user-document'),
    path('signup/', signup_view, name='signup'),
    path('login/', login_view, name='login'),
    path('logout/', logout_view, name='logout'),
]
