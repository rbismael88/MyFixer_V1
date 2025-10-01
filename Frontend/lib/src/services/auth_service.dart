import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl =
      'http://127.0.0.1:8000'; // Adjust this to your backend URL
  static const String registrationPath = '/users/register/';
  static const String loginPath = '/users/login/';

  String? _accessToken;
  String? _currentUserId;
  String? _currentUsername;
  String? _currentFirstName;
  String? _currentLastName;
  String? _currentEmail;
  String? _currentPhoneNumber;
  String? _currentUserType;
  String? _profilePictureUrl;

  // Getters for user data
  String? get currentUserId => _currentUserId;
  String? get currentUsername => _currentUsername;
  String? get currentFirstName => _currentFirstName;
  String? get currentLastName => _currentLastName;
  String? get currentEmail => _currentEmail;
  String? get currentPhoneNumber => _currentPhoneNumber;
  String? get currentUserType => _currentUserType;
  String? get profilePictureUrl => _profilePictureUrl;

  Future<bool> signIn(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$loginPath'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _accessToken = data['access'];
      _currentUserId = data['user_id'].toString();
      _currentUsername = data['username'];
      _currentFirstName = data['first_name'];
      _currentLastName = data['last_name'];
      _currentEmail = data['email'];
      _currentPhoneNumber = data['phone_number'];
      _currentUserType = data['user_type'];
      _profilePictureUrl = data['profile_picture'];

      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$registrationPath'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  void signOut() {
    _accessToken = null;
    _currentUserId = null;
    _currentUsername = null;
    _currentFirstName = null;
    _currentLastName = null;
    _currentEmail = null;
    _currentPhoneNumber = null;
    _currentUserType = null;
    _profilePictureUrl = null;
  }

  Future<bool> updateUserProfile({
    required String firstName,
    required String lastName,
    required String username,
    // required String email, // Email is read-only on backend
    required String phoneNumber,
    String? userType,
  }) async {
    if (_accessToken == null) {
      return false;
    }

    final Map<String, String> body = {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      // 'email': email, // Email is read-only on backend
      'phone_number': phoneNumber,
    };
    if (userType != null) {
      body['user_type'] = userType;
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/users/profile/'), // Use the new profile endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_accessToken', // Include the access token
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Optionally, update the stored user data in AuthService
      _currentFirstName = firstName;
      _currentLastName = lastName;
      _currentUsername = username;
      _currentPhoneNumber = phoneNumber;
      _currentUserType = userType; // Update userType in local state
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUserType(String newUserType) async {
    if (_currentFirstName == null || _currentLastName == null || _currentUsername == null || _currentPhoneNumber == null) {
      return false;
    }
    final success = await updateUserProfile(
      firstName: _currentFirstName!,
      lastName: _currentLastName!,
      username: _currentUsername!,
      phoneNumber: _currentPhoneNumber!,
      userType: newUserType,
    );
    if (success) {
      _currentUserType = newUserType; // Update local state on success
    }
    return success;
  }
}
