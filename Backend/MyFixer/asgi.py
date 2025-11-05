"""
ASGI config for MyFixer project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/asgi/
"""

import os
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from users.token_auth_middleware import TokenAuthMiddleware
import users.routing

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'MyFixer.settings')

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket": TokenAuthMiddleware(
        URLRouter(
            users.routing.websocket_urlpatterns
        )
    ),
})
