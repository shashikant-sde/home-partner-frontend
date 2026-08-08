import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'onboarding_carousel_screen.dart';
import '../../../core/utils/translation_manager.dart';

class LanguageOption {
  final String code;
  final String label;
  final String nativeText;

  const LanguageOption({
    required this.code,
    required this.label,
    required this.nativeText,
  });
}


class SplashLanguageScreen extends StatefulWidget {
  const SplashLanguageScreen({super.key});

  @override
  State<SplashLanguageScreen> createState() => _SplashLanguageScreenState();
}

class _SplashLanguageScreenState extends State<SplashLanguageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sheetAnimationController;
  late Animation<Offset> _sheetSlideAnimation;

  String _selectedLanguageCode = 'EN';

  final List<LanguageOption> _languages = const [
    LanguageOption(code: 'EN', label: 'English', nativeText: 'EN'),
    LanguageOption(code: 'HI', label: 'Hindi', nativeText: 'हि'),
    LanguageOption(code: 'MR', label: 'Marathi', nativeText: 'म'),
    LanguageOption(code: 'KN', label: 'Kannada', nativeText: 'ಕ'),
    LanguageOption(code: 'TA', label: 'Tamil', nativeText: 'த'),
    LanguageOption(code: 'TE', label: 'Telugu', nativeText: 'తె'),
    LanguageOption(code: 'BN', label: 'Bengali', nativeText: 'বা'),
  ];

  @override
  void initState() {
    super.initState();
    _sheetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _sheetSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sheetAnimationController,
        curve: const Cubic(0.22, 1.0, 0.36, 1.0),
      ),
    );

    // Slide up bottom sheet after initial delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _sheetAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _sheetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.06),
              ),
            ),
          ),

          // Main Canvas Content (Logo, App Name & Tagline)
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // App Logo Container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_repair_service_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App Name
                  Text(
                    'HomePartner',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Welcome Tagline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to HomePartner ',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const Text(
                        '👋',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Language Select Bottom Sheet
          SlideTransition(
            position: _sheetSlideAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.marginMobile,
                  vertical: AppDimensions.spaceLg,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag Handle Indicator
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title & Subtitle
                      Text(
                        'Select Language',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose your preferred language to continue',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),

                      // Language Cards List (Scrollable)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: _languages.map((lang) {
                              final isSelected = _selectedLanguageCode == lang.code;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedLanguageCode = lang.code;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLowest,
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
                                        // Language Icon / Badge
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? AppColors.primaryContainer.withOpacity(0.15)
                                                : AppColors.surfaceContainerHigh,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            lang.nativeText,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.onSurfaceVariant,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Language Label
                                        Text(
                                          lang.label,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.onSurface,
                                              ),
                                        ),
                                        const Spacer(),

                                        // Radio Selection Indicator
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.outlineVariant,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: isSelected
                                              ? Container(
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.primary,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                AppTranslation.currentLanguage = _selectedLanguageCode;
                              });
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const OnboardingCarouselScreen(),
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
                              'Confirm',
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
