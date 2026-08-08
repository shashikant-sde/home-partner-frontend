import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../home/available_jobs_screen.dart';
import '../home/help_support_screen.dart';

// ─── Data model for a single uploaded document ───────────────────────────────
class _UploadedDoc {
  final String name;   // file-name
  final String path;   // local path
  final String type;   // 'image' | 'pdf' | 'other'
  final int sizeBytes;

  _UploadedDoc({
    required this.name,
    required this.path,
    required this.type,
    required this.sizeBytes,
  });

  String get sizeLabel {
    if (sizeBytes < 1024) return '${sizeBytes} B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// ─── Document slot descriptor ─────────────────────────────────────────────────
class _DocSlot {
  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final bool required;
  _UploadedDoc? uploaded;

  _DocSlot({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    this.required = false,
    this.uploaded,
  });
}

// ─── Widget ───────────────────────────────────────────────────────────────────
class ServiceProviderDetailsScreen extends StatefulWidget {
  final String serviceName;

  const ServiceProviderDetailsScreen({
    super.key,
    required this.serviceName,
  });

  @override
  State<ServiceProviderDetailsScreen> createState() =>
      _ServiceProviderDetailsScreenState();
}

class _ServiceProviderDetailsScreenState
    extends State<ServiceProviderDetailsScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _salonNameController = TextEditingController();
  String _selectedExperience = '1 Year';
  double _serviceRadius = 5.0;

  // Work mode: 'online' = home-visit, 'offline' = at salon
  String _workMode = 'online';

  // Profile photo
  File? _profileImage;

  // Document slots
  late List<_DocSlot> _docSlots;

  final List<String> _experienceOptions = const [
    '1 Year',
    '2 Years',
    '3 Years',
    '5+ Years',
    '10+ Years',
  ];

  // Allowed extensions
  static const _allowedImageExts = ['jpg', 'jpeg', 'png'];
  static const _allowedDocExts = ['pdf', 'jpg', 'jpeg', 'png'];
  static const _maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB

  @override
  void initState() {
    super.initState();
    _docSlots = [
      _DocSlot(
        id: 'aadhaar',
        label: 'Aadhaar Card',
        subtitle: 'JPG, PNG or PDF • Max 5 MB',
        icon: Icons.credit_card_rounded,
        required: true,
      ),
      _DocSlot(
        id: 'pan',
        label: 'PAN Card',
        subtitle: 'JPG, PNG or PDF • Max 5 MB',
        icon: Icons.badge_rounded,
        required: true,
      ),
      _DocSlot(
        id: 'driving_license',
        label: 'Driving License',
        subtitle: 'JPG, PNG or PDF • Max 5 MB (optional)',
        icon: Icons.directions_car_rounded,
        required: false,
      ),
      _DocSlot(
        id: 'passport',
        label: 'Passport',
        subtitle: 'JPG, PNG or PDF • Max 5 MB (optional)',
        icon: Icons.menu_book_rounded,
        required: false,
      ),
      _DocSlot(
        id: 'other',
        label: 'Other Document',
        subtitle: 'Any govt. issued ID • Max 5 MB (optional)',
        icon: Icons.file_present_rounded,
        required: false,
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _salonNameController.dispose();
    super.dispose();
  }

  // ─── Profile photo picker ────────────────────────────────────────────────
  Future<void> _pickProfilePhoto() async {
    final source = await _showImageSourceSheet();
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    final file = File(picked.path);
    final ext = picked.name.split('.').last.toLowerCase();

    if (!_allowedImageExts.contains(ext)) {
      _showError('Profile photo must be JPG or PNG.');
      return;
    }
    final size = await file.length();
    if (size > _maxFileSizeBytes) {
      _showError('Profile photo must be under 5 MB.');
      return;
    }

    setState(() => _profileImage = file);
  }

  Future<ImageSource?> _showImageSourceSheet() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Photo Source',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0EEFF),
                child: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              ),
              title: const Text('Camera',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0EEFF),
                child: Icon(Icons.photo_library_rounded, color: AppColors.primary),
              ),
              title: const Text('Gallery',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ─── Document picker ─────────────────────────────────────────────────────
  Future<void> _pickDocument(_DocSlot slot) async {
    final choice = await _showDocPickerSheet(slot.label);
    if (choice == null) return;

    File? pickedFile;
    String? fileName;
    int? fileSize;
    String fileType = 'other';

    if (choice == 'image') {
      // Pick image (camera or gallery)
      final source = await _showImageSourceSheet();
      if (source == null) return;

      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (picked == null) return;

      final ext = picked.name.split('.').last.toLowerCase();
      if (!_allowedImageExts.contains(ext)) {
        _showError('Only JPG and PNG images are allowed for documents.');
        return;
      }
      pickedFile = File(picked.path);
      fileName = picked.name;
      fileSize = await pickedFile.length();
      fileType = 'image';
    } else {
      // Pick file (PDF or image from file system)
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedDocExts,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;

      final pf = result.files.first;
      if (pf.path == null) return;

      final ext = (pf.extension ?? '').toLowerCase();
      if (!_allowedDocExts.contains(ext)) {
        _showError('Only PDF, JPG, or PNG files are allowed.');
        return;
      }

      pickedFile = File(pf.path!);
      fileName = pf.name;
      fileSize = pf.size;
      fileType = ext == 'pdf' ? 'pdf' : 'image';
    }

    // Size validation
    final size = fileSize ?? await pickedFile.length();
    if (size > _maxFileSizeBytes) {
      _showError('File is too large. Maximum allowed size is 5 MB.');
      return;
    }

    setState(() {
      slot.uploaded = _UploadedDoc(
        name: fileName ?? 'document',
        path: pickedFile!.path,
        type: fileType,
        sizeBytes: size,
      );
    });
  }

  Future<String?> _showDocPickerSheet(String docLabel) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload $docLabel',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'JPG, PNG or PDF • Max 5 MB',
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0EEFF),
                child: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              ),
              title: const Text('Take Photo',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
              subtitle: const Text('Use camera to capture document',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
              onTap: () => Navigator.pop(context, 'image'),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0EEFF),
                child: Icon(Icons.photo_library_rounded, color: AppColors.primary),
              ),
              title: const Text('Choose from Gallery',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
              subtitle: const Text('Pick an image from your photos',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
              onTap: () => Navigator.pop(context, 'image'),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0EEFF),
                child: Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
              ),
              title: const Text('Browse Files (PDF/Image)',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
              subtitle: const Text('Select a PDF or image file from storage',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
              onTap: () => Navigator.pop(context, 'file'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _removeDocument(_DocSlot slot) {
    setState(() => slot.uploaded = null);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Inter')),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─── Validation & submit ─────────────────────────────────────────────────
  void _saveDetails() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return;
    }

    if (_workMode == 'offline' && _salonNameController.text.trim().isEmpty) {
      _showError('Please enter your Salon / Shop name.');
      return;
    }

    final missingRequired = _docSlots
        .where((s) => s.required && s.uploaded == null)
        .map((s) => s.label)
        .toList();

    if (missingRequired.isNotEmpty) {
      _showError('Please upload: ${missingRequired.join(', ')}');
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AvailableJobsScreen()),
      (route) => false,
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Your Service Details',
          style: const TextStyle(
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                  // ── Profile Photo ────────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickProfilePhoto,
                          child: Stack(
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerLow,
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: _profileImage != null
                                    ? Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: AppColors.primaryContainer,
                                        size: 32,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _profileImage != null
                              ? 'Tap to change photo'
                              : 'Profile Photo (Optional)',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        if (_profileImage != null) ...[
                          const SizedBox(height: 4),
                          TextButton.icon(
                            onPressed: () => setState(() => _profileImage = null),
                            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                            label: const Text(
                              'Remove',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.error),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Identity & Experience ────────────────────────────────
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader('Identity & Experience'),
                        const SizedBox(height: 8),
                        const Divider(color: AppColors.surfaceVariant),
                        const SizedBox(height: 16),

                        _label('Full Name'),
                        const SizedBox(height: 8),
                        _inputBox(
                          controller: _nameController,
                          hint: 'e.g. Julian Masters',
                        ),
                        const SizedBox(height: 20),

                        _label('Experience (Years)'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _experienceOptions.map((exp) {
                            final isSelected = _selectedExperience == exp;
                            return InkWell(
                              onTap: () => setState(() => _selectedExperience = exp),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.outlineVariant,
                                  ),
                                ),
                                child: Text(
                                  exp,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        _label('About You (Bio)'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _bioController,
                            maxLines: 4,
                            maxLength: 150,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              color: AppColors.onSurface,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Tell clients about your style and expertise...',
                              hintStyle: TextStyle(color: AppColors.outline),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Work Mode ──────────────────────────────────────
                        const Divider(color: AppColors.surfaceVariant),
                        const SizedBox(height: 16),
                        _label('Work Mode'),
                        const SizedBox(height: 4),
                        Text(
                          'How do you prefer to serve clients?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Toggle row — Online / Offline
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _workMode = 'online';
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 8),
                                  decoration: BoxDecoration(
                                    gradient: _workMode == 'online'
                                        ? AppColors.primaryGradient
                                        : null,
                                    color: _workMode == 'online'
                                        ? null
                                        : AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: _workMode == 'online'
                                          ? Colors.transparent
                                          : AppColors.outlineVariant,
                                    ),
                                    boxShadow: _workMode == 'online'
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.25),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.home_rounded,
                                        size: 22,
                                        color: _workMode == 'online'
                                            ? Colors.white
                                            : AppColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Online',
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: _workMode == 'online'
                                              ? Colors.white
                                              : AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Home Visit',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          color: _workMode == 'online'
                                              ? Colors.white70
                                              : AppColors.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _workMode = 'offline';
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 8),
                                  decoration: BoxDecoration(
                                    gradient: _workMode == 'offline'
                                        ? AppColors.primaryGradient
                                        : null,
                                    color: _workMode == 'offline'
                                        ? null
                                        : AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: _workMode == 'offline'
                                          ? Colors.transparent
                                          : AppColors.outlineVariant,
                                    ),
                                    boxShadow: _workMode == 'offline'
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.25),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.store_rounded,
                                        size: 22,
                                        color: _workMode == 'offline'
                                            ? Colors.white
                                            : AppColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Offline',
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: _workMode == 'offline'
                                              ? Colors.white
                                              : AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'At Salon',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          color: _workMode == 'offline'
                                              ? Colors.white70
                                              : AppColors.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ── Animated Salon Name field ──────────────────────
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          child: _workMode == 'offline'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    // Info banner
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0EEFF),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.25),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.info_outline_rounded,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Your salon name will be visible to clients so they can visit you directly.',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    _label('Salon / Shop Name *'),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainerLow,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.4),
                                          width: 1.5,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.store_rounded,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  _salonNameController,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                color: AppColors.onSurface,
                                              ),
                                              decoration:
                                                  const InputDecoration(
                                                hintText:
                                                    'e.g. Royal Cuts Salon',
                                                hintStyle: TextStyle(
                                                    color: AppColors.outline),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Service Area ─────────────────────────────────────────
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on_rounded,
                                    color: AppColors.primary, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Service Area',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${_serviceRadius.toStringAsFixed(1)} km radius',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.surfaceContainerLow,
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withOpacity(0.12),
                                  border: Border.all(color: AppColors.primary, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: AppColors.onSurfaceVariant, size: 16),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Drag the pin to adjust your base service location.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Verification Documents ───────────────────────────────
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader('Verification Documents'),
                        const SizedBox(height: 4),
                        const Text(
                          'Upload clear scans or photos of your documents. Required documents are marked with *.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Document tiles
                        ..._docSlots.map((slot) => _buildDocSlot(slot)).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Floating Save Button ─────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.marginMobile),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
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
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _saveDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save Details',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
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

  // ─── Document tile widget ────────────────────────────────────────────────
  Widget _buildDocSlot(_DocSlot slot) {
    final uploaded = slot.uploaded;
    final isUploaded = uploaded != null;
    final isImage = isUploaded && uploaded.type == 'image';
    final isPdf = isUploaded && uploaded.type == 'pdf';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUploaded
            ? const Color(0xFFF0FBF4)
            : AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded
              ? const Color(0xFF10B981)
              : AppColors.primary.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: isUploaded ? null : () => _pickDocument(slot),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isUploaded
              ? Row(
                  children: [
                    // Thumbnail or PDF icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: isImage
                            ? Colors.transparent
                            : const Color(0xFFFFEBEB),
                        child: isImage
                            ? Image.file(File(uploaded.path), fit: BoxFit.cover)
                            : const Icon(
                                Icons.picture_as_pdf_rounded,
                                color: Colors.red,
                                size: 32,
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (slot.required)
                                const Text(
                                  '* ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                slot.label,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            uploaded.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF10B981),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${uploaded.sizeLabel} • Uploaded',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_rounded,
                              color: AppColors.primary, size: 20),
                          onPressed: () => _pickDocument(slot),
                          tooltip: 'Change',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: AppColors.error, size: 20),
                          onPressed: () => _removeDocument(slot),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: Icon(slot.icon,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (slot.required)
                                const Text(
                                  '* ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                slot.label,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            slot.subtitle,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(Icons.upload_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(25, 28, 30, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.outline),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
