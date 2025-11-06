import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://127.0.0.1:8001'; // Adjust if your backend URL is different
  Map<String, dynamic>? _currentUser;
  String? _accessToken;

  String? get currentFirstName => _currentUser?['first_name'];
  String? get currentLastName => _currentUser?['last_name'];
  String? get profilePictureUrl => _currentUser?['profile_picture'];
  String? get currentUsername => _currentUser?['username'];
  String? get currentEmail => _currentUser?['email'];
  String? get currentPhoneNumber => _currentUser?['phone_number'];
  String? get identityCardUrl => _currentUser?['identity_card'];
  String? get criminalRecordCertificateUrl =>
      _currentUser?['criminal_record_certificate'];
  String? get currentUserType => _currentUser?['user_type'];
  bool get isVerified => _currentUser?['is_verified'] ?? false;

  Future<String?> getToken() async {
    return _accessToken;
  }

  Future<Map<String, dynamic>> signIn(String identifier, String password) async {
    final url = Uri.parse('$baseUrl/users/login/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'identifier': identifier,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = data['user'];
        _accessToken = data['access'];
        return data;
      } else {
        // Attempt to decode the error message from the backend
        try {
          final error = json.decode(response.body);
          return {'error': error['detail'] ?? 'An unknown error occurred'};
        } catch (e) {
          return {
            'error': 'Failed to log in. Status code: ${response.statusCode}'
          };
        }
      }
    } catch (e) {
      // Handle network errors or other exceptions
      return {'error': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('$baseUrl/users/register/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        try {
          final error = json.decode(response.body);
          return {'error': error.toString()};
        } catch (e) {
          return {
            'error': 'Failed to sign up. Status code: ${response.statusCode}'
          };
        }
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  Future<bool> updateUserType(String userType) async {
    if (_accessToken == null) return false;

    final url = Uri.parse('$baseUrl/users/profile/');
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({'user_type': userType}),
      );

      if (response.statusCode == 200) {
        _currentUser?['user_type'] = userType;
        await fetchUserProfile(); // Refresh user data
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchUserProfile() async {
    if (_accessToken == null) return;

    final url = Uri.parse('$baseUrl/users/profile/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        _currentUser = json.decode(response.body);
      }
    } catch (e) {
      // Handle error, maybe log it
    }
  }

  void signOut() {
    _currentUser = null;
    _accessToken = null;
  }

  Future<bool> updateUserProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String phoneNumber,
    File? profilePicture,
    File? identityCard,
    File? criminalRecordCertificate,
  }) async {
    if (_accessToken == null) return false;

    final url = Uri.parse('$baseUrl/users/profile/');
    try {
      var request = http.MultipartRequest('PATCH', url);
      request.headers['Authorization'] = 'Bearer $_accessToken';

      // Add text fields
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['username'] = username;
      request.fields['phone_number'] = phoneNumber;

      // Add files if they exist
      if (profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_picture', profilePicture.path));
      }
      if (identityCard != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'identity_card', identityCard.path));
      }
      if (criminalRecordCertificate != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'criminal_record_certificate', criminalRecordCertificate.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        // Update the local user object with the new data from the response
        _currentUser?['first_name'] = data['first_name'];
        _currentUser?['last_name'] = data['last_name'];
        _currentUser?['username'] = data['username'];
        _currentUser?['phone_number'] = data['phone_number'];
        _currentUser?['profile_picture'] = data['profile_picture_url'];
        _currentUser?['identity_card'] = data['identity_card_url'];
        _currentUser?['criminal_record_certificate'] =
            data['criminal_record_certificate_url'];
        return true;
      } else {
        // Handle error
        return false;
      }
    } catch (e) {
      // Handle exception
      return false;
    }
  }
}
