import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:myfixer/src/services/auth_service.dart';

class StatusService {
  WebSocketChannel? _channel;
  final AuthService _authService = AuthService();
  bool _isConnected = false;
  Timer? _reconnectTimer;

  void connect() async {
    if (_isConnected) return;

    final token = await _authService.getToken();
    if (token == null) return;

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8001/ws/status/?token=$token'),
      );
      _isConnected = true;

      _channel?.stream.listen(
        (message) {
          // Handle incoming messages if needed
        },
        onDone: () {
          _isConnected = false;
          _scheduleReconnect();
        },
        onError: (error) {
          _isConnected = false;
          _scheduleReconnect();
        },
      );
    } catch (e) {
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }

  void _scheduleReconnect() {
    if (_isConnected) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect();
    });
  }
}
