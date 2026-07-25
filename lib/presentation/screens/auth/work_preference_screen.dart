import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'select_city_screen.dart';
import 'set_location_screen.dart';
import '../home/help_support_screen.dart';

class WorkPreferenceOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const WorkPreferenceOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class WorkPreferenceScreen extends StatefulWidget {
  const WorkPreferenceScreen({super.key});

  @override
  State<WorkPreferenceScreen> createState() => _WorkPreferenceScreenState();
}

class _WorkPreferenceScreenState extends State<WorkPreferenceScreen>
    with SingleTickerProviderStateMixin {
  String _selectedWorkType = 'full-time';
  String _selectedCity = 'Bengaluru';
  late AnimationController _sheetController;
  late Animation<Offset> _sheetAnimation;

  final List<String> _cities = const [
    'Bengaluru',
    'Mumbai',
    'Delhi NCR',
    'Pune',
    'Hyderabad',
    'Chennai',
  ];

  final List<WorkPreferenceOption> _options = const [
    WorkPreferenceOption(
      id: 'full-time',
      title: 'Full Time',
      subtitle: '8–10 hours daily commitment',
      icon: Icons.work_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.primaryFixed,
    ),
    WorkPreferenceOption(
      id: 'part-time',
      title: 'Part Time',
      subtitle: '2–3 hours flexible shifts',
      icon: Icons.timer_rounded,
      iconColor: AppColors.secondary,
      iconBgColor: AppColors.secondaryFixed,
    ),
    WorkPreferenceOption(
      id: 'women-partner',
      title: 'Women Partner',
      subtitle: 'Safety priority & custom timings',
      icon: Icons.woman_rounded,
      iconColor: Color(0xFFD81B60),
      iconBgColor: Color(0xFFFFEBF2),
    ),
    WorkPreferenceOption(
      id: 'on-demand',
      title: 'On-Demand Only',
      subtitle: 'Accept gigs whenever available',
      icon: Icons.electric_bolt_rounded,
      iconColor: AppColors.tertiary,
      iconBgColor: AppColors.tertiaryFixed,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sheetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sheetController,
        curve: const Cubic(0.16, 1.0, 0.3, 1.0),
      ),
    );

    // Trigger sliding sheet entrance
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _sheetController.forward();
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _showCityPickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusSheet),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select City',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _cities.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFF1F3F5),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final city = _cities[index];
                    final isSelected = _selectedCity == city;
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedCity = city;
                        });
                        Navigator.of(context).pop();
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      title: Text(
                        city,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Map Area (Simulated Map Graphic Layout)
          Positioned.fill(
            bottom: 300, // Leaves room for the sheet bottom area
            child: Stack(
              children: [
                // Clean Map Backdrop Image
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.5),
                    colorBlendMode: BlendMode.color,
                  ),
                ),
                // Grid/Overlay simulation
                Container(
                  color: AppColors.background.withOpacity(0.4),
                ),
                // City Pin Marker & Label
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _showCityPickerDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCity,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.onSurface,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom Header App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Select City',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Help',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet with earning/work type selection options
          SlideTransition(
            position: _sheetAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusSheet),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 40,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Slide Handle
                    Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                    ),
                    // Inner scrollable content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.marginMobile,
                        ).copyWith(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Hello Partner ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  '👋',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'How do you want to earn on HomePartner?',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                            ),
                            const SizedBox(height: 24),

                            // Work Type Selection list
                            Column(
                              children: _options.map((opt) {
                                final isSelected = _selectedWorkType == opt.id;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedWorkType = opt.id;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(25, 28, 30, 0.04),
                                            blurRadius: 20,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Left Option Icon
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: opt.iconBgColor,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Icon(
                                              opt.icon,
                                              color: opt.iconColor,
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(width: 16),

                                          // Info Column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  opt.title,
                                                  style: const TextStyle(
                                                    fontFamily: 'Manrope',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  opt.subtitle,
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 13,
                                                    color: AppColors.onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Right Chevron Icon
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            color: AppColors.outline,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // Footer Buttons inside sheet
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 56,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const SetLocationScreen(),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusFull,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Skip',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 56,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusFull,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.2),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const SelectCityScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppDimensions.radiusFull,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
