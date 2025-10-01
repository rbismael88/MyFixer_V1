
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/home_screen.dart';
import 'package:myfixer/src/presentation/screens/signin_screen.dart';
import 'package:myfixer/src/presentation/screens/signup_screen.dart';
import 'package:myfixer/src/services/auth_service.dart'; // Import the new auth service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _showSignUp = false;
  bool _isProviderMode = false;

  final AuthService _authService = AuthService();

  void _signIn(String identifier, String password) async {
    bool success = await _authService.signIn(identifier, password);
    setState(() {
      _isLoggedIn = success;
      _isProviderMode = _authService.currentUserType == 'provider'; // Initialize provider mode from auth service
    });
  }

  void _signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    bool success = await _authService.signUp(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    setState(() {
      _isLoggedIn = success;
      _showSignUp = !success; // If signup is successful, hide signup screen
      _isProviderMode = _authService.currentUserType == 'provider'; // Initialize provider mode from auth service
    });
  }

  void _signOut() {
    _authService.signOut(); // Clear stored user data
    setState(() {
      _isLoggedIn = false;
      _isProviderMode = false; // Reset provider mode on logout
    });
  }

  void _goToSignUp() {
    setState(() {
      _showSignUp = true;
    });
  }

  void _goToSignIn() {
    setState(() {
      _showSignUp = false;
    });
  }

  void _toggleProviderMode() async { // Make it async
    final String newType = _isProviderMode ? 'client' : 'provider';
    final bool success = await _authService.updateUserType(newType);
    if (success) {
      setState(() {
        _isProviderMode = !_isProviderMode;
      });
    } else {
      // Handle error, e.g., show a SnackBar
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFixer',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn
          ? HomeScreen(isProviderMode: _isProviderMode, onToggleProviderMode: _toggleProviderMode, onSignOut: _signOut, authService: _authService)
          : _showSignUp
              ? SignUpScreen(onSignUp: _signUp, onGoToSignIn: _goToSignIn)
              : SignInScreen(onSignIn: (identifier, password) => _signIn(identifier, password), onGoToSignUp: _goToSignUp),
    );
  }
}
