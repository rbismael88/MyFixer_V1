import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.layers import get_channel_layer
from .serializers import UserSerializer

CONNECTED_USERS_KEY = "connected_users"

class NotificationConsumer(AsyncWebsocketConsumer):
    group_name = 'admin_notifications'

    async def connect(self):
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()
        await self.send_connected_users_count()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data):
        pass

    async def send_notification(self, event):
        await self.send(text_data=json.dumps({
            'type': 'doc_notification',
            'message': event['message']
        }))

    async def user_count_update(self, event):
        await self.send(text_data=json.dumps({
            'type': 'user_count',
            'count': event['count']
        }))

    async def user_update(self, event):
        await self.send(text_data=json.dumps({
            'type': 'user_update',
            'user': event['user']
        }))

    async def get_connected_users_count(self):
        connection = self.channel_layer.connection(0)
        return await connection.scard(CONNECTED_USERS_KEY)

    async def send_connected_users_count(self):
        count = await self.get_connected_users_count()
        await self.channel_layer.group_send(
            self.group_name,
            {
                'type': 'user_count_update',
                'count': count
            }
        )

class StatusConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.user = self.scope["user"]
        if self.user.is_authenticated:
            await self.accept()
            await self.add_user_to_connected()
            await self.broadcast_user_count()
        else:
            await self.close()

    async def disconnect(self, close_code):
        if self.user.is_authenticated:
            await self.remove_user_from_connected()
            await self.broadcast_user_count()

    async def add_user_to_connected(self):
        connection = self.channel_layer.connection(0)
        await connection.sadd(CONNECTED_USERS_KEY, self.user.id)

    async def remove_user_from_connected(self):
        connection = self.channel_layer.connection(0)
        await connection.srem(CONNECTED_USERS_KEY, self.user.id)

    async def get_connected_users_count(self):
        connection = self.channel_layer.connection(0)
        return await connection.scard(CONNECTED_USERS_KEY)

    async def broadcast_user_count(self):
        count = await self.get_connected_users_count()
        channel_layer = get_channel_layer()
        await channel_layer.group_send(
            NotificationConsumer.group_name,
            {
                'type': 'user_count_update',
                'count': count
            }
        )

async def send_admin_notification(message):
    channel_layer = get_channel_layer()
    await channel_layer.group_send(
        NotificationConsumer.group_name,
        {
            'type': 'send_notification',
            'message': message
        }
    )

async def send_user_update(user):
    channel_layer = get_channel_layer()
    user_serializer = UserSerializer(user)
    await channel_layer.group_send(
        NotificationConsumer.group_name,
        {
            'type': 'user_update',
            'user': user_serializer.data
        }
    )