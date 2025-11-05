import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfixer/src/presentation/screens/change_password_screen.dart';
import 'package:myfixer/src/services/auth_service.dart';

class ManageAccountScreen extends StatefulWidget {
  final AuthService authService;

  const ManageAccountScreen({super.key, required this.authService});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _profilePicture;
  File? _identityCard;
  File? _criminalRecordCertificate;

  Future<void> _pickImage(
      ImageSource source, Function(File) onImageSelected) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  Future<void> _pickProfilePicture() async {
    _pickImage(ImageSource.gallery, (image) {
      setState(() {
        _profilePicture = image;
      });
    });
  }

  Future<void> _pickIdentityCard() async {
    _pickImage(ImageSource.gallery, (image) {
      setState(() {
        _identityCard = image;
      });
    });
  }

  Future<void> _pickCriminalRecordCertificate() async {
    _pickImage(ImageSource.gallery, (image) {
      setState(() {
        _criminalRecordCertificate = image;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.authService.currentFirstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.authService.currentLastName ?? '');
    _usernameController =
        TextEditingController(text: widget.authService.currentUsername ?? '');
    _emailController =
        TextEditingController(text: widget.authService.currentEmail ?? '');
    _phoneController = TextEditingController(
        text: widget.authService.currentPhoneNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileChanges() async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Guardando cambios...')),
      );

      final bool success = await widget.authService.updateUserProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        phoneNumber: _phoneController.text,
        profilePicture: _profilePicture,
        identityCard: _identityCard,
        criminalRecordCertificate: _criminalRecordCertificate,
      );

      if (!mounted) return;
      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito!')),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error al actualizar el perfil.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Gestionar Cuenta',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: _profilePicture != null
                        ? FileImage(_profilePicture!)
                        : (widget.authService.profilePictureUrl != null
                            ? NetworkImage(
                                widget.authService.profilePictureUrl!)
                            : null) as ImageProvider?,
                    child: _profilePicture == null &&
                            widget.authService.profilePictureUrl == null
                        ? const Icon(Icons.person,
                            color: Colors.white, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.black, size: 20),
                        onPressed: _pickProfilePicture,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Información del Perfil'),
            _buildTextFormField(_firstNameController, 'Nombres',
                readOnly: false),
            const SizedBox(height: 8),
            _buildTextFormField(_lastNameController, 'Apellidos',
                readOnly: false),
            const SizedBox(height: 8),
            _buildTextFormField(_usernameController, 'Username',
                readOnly: false),
            const SizedBox(height: 8),
            _buildTextFormField(_emailController, 'Email',
                readOnly: false, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 8),
            _buildTextFormField(_phoneController, 'Teléfono',
                readOnly: false, keyboardType: TextInputType.phone),
            const SizedBox(height: 24),

            _buildSectionTitle('Documentos'),
            _buildDocumentTile(
              context,
              'Cédula de Identidad',
              widget.authService.identityCardUrl != null
                  ? 'Subido'
                  : (_identityCard != null
                      ? 'Archivo seleccionado'
                      : 'No subido'),
              _pickIdentityCard,
            ),
            if (widget.authService.currentUserType == 'provider')
              _buildDocumentTile(
                context,
                'Certificado de no antecedentes penales',
                widget.authService.criminalRecordCertificateUrl != null
                    ? 'Subido'
                    : (_criminalRecordCertificate != null
                        ? 'Archivo seleccionado'
                        : 'No subido'),
                _pickCriminalRecordCertificate,
              ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveProfileChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Guardar Cambios',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Seguridad'),
            _buildActionTile(context, 'Cambiar Contraseña', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()));
            }),
            const SizedBox(height: 24),

            _buildSectionTitle('Acciones de la Cuenta'),
            _buildActionTile(context, 'Eliminar Cuenta', () {
              _showDeleteConfirmationDialog(context);
            }, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child:
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      {bool readOnly = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(label),
      keyboardType: keyboardType,
      validator: (value) {
        if (!readOnly && (value == null || value.isEmpty)) {
          return 'Por favor, introduce $label';
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Eliminar Cuenta',
              style: TextStyle(color: Colors.white)),
          content: const Text(
              '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
              style: TextStyle(color: Colors.grey)),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Perform delete account action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocumentTile(
      BuildContext context, String title, String status, VoidCallback onTap) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(status,
            style: TextStyle(
                color: status == 'No subido' ? Colors.red : Colors.green)),
        trailing: const Icon(Icons.upload_file, color: Colors.white, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, String title, VoidCallback onTap,
      {Color? color}) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title: Text(title,
            style: TextStyle(color: color ?? Colors.white, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios,
            color: color ?? Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}
