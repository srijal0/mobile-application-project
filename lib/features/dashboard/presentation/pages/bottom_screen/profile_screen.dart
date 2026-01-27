import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String fullName;
  final String username;
  final String email;
  final String password;

  const ProfileScreen({
    super.key,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isEditing = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  static const Color primaryColor = Colors.red;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullName);
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!isEditing) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: primaryColor),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 512,
                    maxHeight: 512,
                    imageQuality: 75,
                  );
                  if (pickedFile != null) {
                    setState(() => _profileImage = File(pickedFile.path));
                    showCenterMessage("Profile picture updated");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: primaryColor),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 512,
                    maxHeight: 512,
                    imageQuality: 75,
                  );
                  if (pickedFile != null) {
                    setState(() => _profileImage = File(pickedFile.path));
                    showCenterMessage("Profile picture updated");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showCenterMessage(String message, {Color? color}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), overlayEntry.remove);
  }

  bool validateProfile() {
    if (fullNameController.text.trim().isEmpty) {
      showCenterMessage("Full name cannot be empty", color: Colors.red.shade700);
      return false;
    }
    if (usernameController.text.trim().length < 3) {
      showCenterMessage("Username must be at least 3 characters", color: Colors.red.shade700);
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
        .hasMatch(emailController.text.trim())) {
      showCenterMessage("Enter a valid email", color: Colors.red.shade700);
      return false;
    }
    if (passwordController.text.trim().length < 8) {
      showCenterMessage("Password must be at least 8 characters", color: Colors.red.shade700);
      return false;
    }
    return true;
  }

  void _saveProfile() {
    if (validateProfile()) {
      showCenterMessage("Profile updated successfully!", color: primaryColor);

      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 32 : 16),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: isTablet ? 80 : 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage(
                                'assets/images/profile_placeholder.png',
                              ) as ImageProvider,
                      ),
                    ),
                    if (isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),

                _buildField(fullNameController, "Full Name", Icons.person, isEditing, isTablet),
                _buildField(usernameController, "Username", Icons.person_outline, isEditing, isTablet),
                _buildField(emailController, "Email", Icons.email, isEditing, isTablet,
                    type: TextInputType.emailAddress),
                _buildField(passwordController, "Password", Icons.lock, isEditing, isTablet,
                    obscure: true),

                const SizedBox(height: 24),

                Row(
                  children: [
                    if (isEditing)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              fullNameController.text = widget.fullName;
                              usernameController.text = widget.username;
                              emailController.text = widget.email;
                              passwordController.text = widget.password;
                              _profileImage = null;
                              isEditing = false;
                            });
                            showCenterMessage("Changes cancelled", color: primaryColor);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor, width: 2),
                          ),
                          child: const Text("Cancel", style: TextStyle(color: primaryColor)),
                        ),
                      ),
                    if (isEditing) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => isEditing ? _saveProfile() : setState(() => isEditing = true),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(244, 67, 54, 1)),
                        child: Text(isEditing ? "Save Changes" : "Edit Profile"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool enabled,
    bool isTablet, {
    bool obscure = false,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
      ),
    );
  }
}
