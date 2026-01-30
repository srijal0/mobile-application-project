import 'package:fashion_store_trendora/core/services/upload_service.dart';
import 'package:fashion_store_trendora/core/utils/user_storage.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isEditing = false;
  bool isUploading = false;
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  final String defaultProfileImagePath = 'assets/images/girl.jpg';

  @override
  void initState() {
    super.initState();
    
    fullNameController = TextEditingController(text: widget.fullName);
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
    
    // Load existing profile image if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authViewModelProvider);
      print("==================== DEBUG START ====================");
      print("🔍 Logged in user fullName: ${authState.entity?.fullName}");
      print("🔍 Logged in user username: ${authState.entity?.username}");
      print("🔍 Logged in user email: ${authState.entity?.email}");
      print("🔍 Logged in user ID: ${authState.entity?.authId}");
      print("---");
      print("📦 Widget fullName parameter: ${widget.fullName}");
      print("📦 Widget username parameter: ${widget.username}");
      print("📦 Widget email parameter: ${widget.email}");
      print("==================== DEBUG END ====================");
      
      _loadProfileImage();
    });
  }

  Future<void> _loadProfileImage() async {
    // Get userId from auth state
    final authState = ref.read(authViewModelProvider);
    final userId = authState.entity?.authId ?? "";
    
    if (userId.isEmpty) {
      print("❌ No user logged in");
      return;
    }
    
    print("📸 Loading profile image for userId: $userId");
    
    try {
      final uploadService = ref.read(uploadServiceProvider);
      final imageUrl = await uploadService.getProfileImage(userId);
      if (imageUrl != null && imageUrl.isNotEmpty) {
        setState(() {
          _profileImageUrl = imageUrl;
        });
        print("✅ Profile image loaded: $imageUrl");
      } else {
        print("ℹ️ No profile image found for this user");
      }
    } catch (e) {
      print("❌ Error loading profile image: $e");
    }
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
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.red,
                ),
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
                    setState(() {
                      _profileImage = File(pickedFile.path);
                    });
                    
                    // Upload image immediately
                    await _uploadProfileImage();
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.red,
                ),
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
                    setState(() {
                      _profileImage = File(pickedFile.path);
                    });
                    
                    // Upload image immediately
                    await _uploadProfileImage();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      // Get userId from auth state
      final authState = ref.read(authViewModelProvider);
      final userId = authState.entity?.authId ?? "";
      
      print("📤 Attempting to upload image for userId: $userId");
      
      if (userId.isEmpty) {
        showCenterMessage("User not logged in", color: Colors.red.shade300);
        setState(() {
          isUploading = false;
        });
        return;
      }
      
      final uploadService = ref.read(uploadServiceProvider);
      final result = await uploadService.uploadProfileImage(
        imageFile: _profileImage!,
        userId: userId,
        onProgress: (sent, total) {
          print("Upload progress: ${(sent / total * 100).toStringAsFixed(0)}%");
        },
      );

      print("📥 Upload result: $result");

      if (result['success'] == true) {
        setState(() {
          _profileImageUrl = result['data']['imageUrl'];
          isUploading = false;
        });
        
        showCenterMessage(
          "Profile picture updated successfully!",
          color: Colors.red,
        );
        print("✅ Image uploaded successfully: $_profileImageUrl");
      } else {
        setState(() {
          isUploading = false;
        });
        
        showCenterMessage(
          result['message'] ?? "Failed to upload image",
          color: Colors.red.shade700,
        );
        print("❌ Upload failed: ${result['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      
      showCenterMessage(
        "Failed to upload image: $e",
        color: Colors.red.shade700,
      );
      print("❌ Upload error: $e");
    }
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
              color: color ?? Colors.red,
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
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  bool validateProfile() {
    if (fullNameController.text.trim().isEmpty) {
      showCenterMessage("Full name cannot be empty", color: Colors.red.shade300);
      return false;
    }
    if (usernameController.text.trim().isEmpty) {
      showCenterMessage("Username cannot be empty", color: Colors.red.shade300);
      return false;
    }
    if (usernameController.text.trim().length < 3) {
      showCenterMessage("Username must be at least 3 characters", color: Colors.red.shade300);
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      showCenterMessage("Email cannot be empty", color: Colors.red.shade300);
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(emailController.text.trim())) {
      showCenterMessage("Enter a valid email", color: Colors.red.shade300);
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      showCenterMessage("Password cannot be empty", color: Colors.red.shade300);
      return false;
    }
    if (passwordController.text.trim().length < 8) {
      showCenterMessage("Password must be at least 8 characters", color: Colors.red.shade300);
      return false;
    }
    return true;
  }

  void _saveProfile() {
    if (validateProfile()) {
      UserStorage.register(
        fullName: fullNameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showCenterMessage(
        "Profile updated successfully!",
        color: Colors.red,
      );

      setState(() {
        isEditing = false;
      });
    }
  }

  ImageProvider _getProfileImage() {
    // Priority: Local file > Network URL > Default asset
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      // Construct full URL with your backend base URL
      final fullUrl = "http://10.0.2.2:5000$_profileImageUrl";
      return NetworkImage(fullUrl);
    } else {
      return const AssetImage('assets/images/girl.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE), // Light red background
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: IconThemeData(size: isTablet ? 28 : 24),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 32 : 16),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600 : double.infinity,
            ),
            child: Column(
              children: [
                // Profile Picture with Edit Icon
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: isTablet ? 80 : 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getProfileImage(),
                      ),
                    ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (isEditing && !isUploading)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(isTablet ? 10 : 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: isTablet ? 24 : 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: isTablet ? 40 : 32),

                // Full Name
                TextFormField(
                  controller: fullNameController,
                  enabled: isEditing,
                  style: TextStyle(fontSize: isTablet ? 18 : 14),
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(fontSize: isTablet ? 18 : 14),
                    prefixIcon: Icon(
                      Icons.person,
                      size: isTablet ? 28 : 24,
                      color: Colors.red,
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: isEditing ? Colors.white : Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 20 : 16,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 20 : 16),

                // Username
                TextFormField(
                  controller: usernameController,
                  enabled: isEditing,
                  style: TextStyle(fontSize: isTablet ? 18 : 14),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(fontSize: isTablet ? 18 : 14),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: isTablet ? 28 : 24,
                      color: Colors.red,
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: isEditing ? Colors.white : Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 20 : 16,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 20 : 16),

                // Email
                TextFormField(
                  controller: emailController,
                  enabled: isEditing,
                  style: TextStyle(fontSize: isTablet ? 18 : 14),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: isTablet ? 18 : 14),
                    prefixIcon: Icon(
                      Icons.email,
                      size: isTablet ? 28 : 24,
                      color: Colors.red,
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: isEditing ? Colors.white : Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 20 : 16,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: isTablet ? 20 : 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  enabled: isEditing,
                  obscureText: true,
                  style: TextStyle(fontSize: isTablet ? 18 : 14),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: isTablet ? 18 : 14),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: isTablet ? 28 : 24,
                      color: Colors.red,
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: isEditing ? Colors.white : Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 20 : 16,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),

                // Edit/Save and Cancel Buttons
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
                            showCenterMessage("Changes cancelled", color: Colors.orange.shade300);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 20 : 16,
                            ),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    if (isEditing) SizedBox(width: isTablet ? 16 : 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            _saveProfile();
                          } else {
                            setState(() {
                              isEditing = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 20 : 16,
                          ),
                        ),
                        child: Text(
                          isEditing ? "Save Changes" : "Edit Profile",
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
}