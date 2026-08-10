import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'work_preference_screen.dart';
import '../home/help_support_screen.dart';


class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _selectedGender = 'Female';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year.toString();
        _dobController.text = '$day / $month / $year';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'HomePartner',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.marginMobile),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HelpSupportScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Help',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ).copyWith(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Header Section
                  Text(
                    'Complete Your Profile',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tell us a bit more about yourself to get started.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Profile Photo Upload Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Circular dashed box
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerLow,
                                  image: _profileImage != null ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  ) : null,
                                  border: Border.all(
                                    color: AppColors.primaryContainer.withOpacity(0.5),
                                    style: BorderStyle.solid, // Note: Dash borders need custom painter, solid matches look
                                    width: 2,
                                  ),
                                ),
                                child: _profileImage == null ? const Icon(
                                  Icons.camera_alt_rounded,
                                  color: AppColors.primaryContainer,
                                  size: 36,
                                ) : null,
                              ),
                            ),
                            // Mini floating FAB badge (add icon)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.primaryGradient,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'UPLOAD PROFILE PHOTO',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryContainer,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Full Name Field
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Julian Masters',
                        hintStyle: TextStyle(color: AppColors.outline),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date of Birth Field
                  const Text(
                    'Date of Birth',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _selectDate,
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _dobController,
                                keyboardType: TextInputType.datetime,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: AppColors.onSurface,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'DD / MM / YYYY',
                                  hintStyle: TextStyle(color: AppColors.outline),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _selectDate,
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Gender Selection Field
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Male', 'Female', 'Other'].map((gender) {
                      final isSelected = _selectedGender == gender;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGender = gender;
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.primaryGradient : null,
                              color: isSelected ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : AppColors.outlineVariant,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              gender,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 36),

                  // Decorative Bento Trust Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trusted Partner',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Completing your profile increases your trust score by 40% and helps you get jobs faster.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: AppColors.onPrimaryFixedVariant,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Fixed Bottom Action Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.marginMobile),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        String name = _nameController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter your full name')),
                          );
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WorkPreferenceScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                      ),
                      child: const Text(
                        'Save & Continue',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Minimal Math class helper to avoid import issue
class Math {
  static num min(num a, num b) => a < b ? a : b;
}
