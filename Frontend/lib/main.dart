import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/home_screen.dart';
import 'package:myfixer/src/presentation/screens/signin_screen.dart';
import 'package:myfixer/src/presentation/screens/signup_screen.dart';
import 'package:myfixer/src/services/auth_service.dart';
import 'package:myfixer/src/services/websocket_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFixer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();
  WebSocketService? _webSocketService;
  bool _isAuthenticated = false;
  bool _showSignUp = false;
  bool _isProviderMode = false;

  @override
  void initState() {
    super.initState();
    _initializeWebSocketService();
  }

  void _initializeWebSocketService() {
    _webSocketService = WebSocketService(_authService, _handleUserUpdate);
  }

  void _handleUserUpdate() {
    _authService.fetchUserProfile().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _connectWebSocket() {
    _webSocketService?.connect();
  }

  void _toggleView() {
    setState(() {
      _showSignUp = !_showSignUp;
    });
  }

  void _signOut() {
    _webSocketService?.disconnect();
    _authService.signOut();
    setState(() {
      _isAuthenticated = false;
    });
  }

  Future<void> _toggleProviderMode() async {
    final newUserType = _isProviderMode ? 'client' : 'provider';
    final success = await _authService.updateUserType(newUserType);

    if (mounted) {
      if (success) {
        setState(() {
          _isProviderMode = !_isProviderMode;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al cambiar de modo. Inténtalo de nuevo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return HomeScreen(
        isProviderMode: _isProviderMode,
        onToggleProviderMode: _toggleProviderMode,
        onSignOut: _signOut,
        authService: _authService,
      );
    }

    if (_showSignUp) {
      return SignUpScreen(
        onSignUp: (
            {required String firstName,
            required String lastName,
            required String username,
            required String email,
            required String password,
            required String phoneNumber}) async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final result = await _authService.signUp(
            firstName: firstName,
            lastName: lastName,
            username: username,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
          );
          if (mounted) {
            if (result.containsKey('error')) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                    content: Text('Error de registro: ${result['error']}')),
              );
            } else {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                    content:
                        Text('Registro exitoso! Por favor, inicie sesión.')),
              );
              _toggleView();
            }
          }
        },
        onGoToSignIn: _toggleView,
      );
    } else {
      return SignInScreen(
        onSignIn: (identifier, password) async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final result = await _authService.signIn(identifier, password);
          if (!mounted) return;
          if (result.containsKey('error')) {
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text(result['error'])),
            );
          } else {
            setState(() {
              _isAuthenticated = true;
            });
            _connectWebSocket();
          }
        },
        onGoToSignUp: _toggleView,
      );
    }
  }
}