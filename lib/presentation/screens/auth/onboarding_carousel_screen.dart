import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'phone_login_screen.dart';


class OnboardingSlide {
  final String titlePrefix;
  final String highlightedTitle;
  final String description;
  final String imageUrl;

  const OnboardingSlide({
    required this.titlePrefix,
    required this.highlightedTitle,
    required this.description,
    required this.imageUrl,
  });
}

class OnboardingCarouselScreen extends StatefulWidget {
  const OnboardingCarouselScreen({super.key});

  @override
  State<OnboardingCarouselScreen> createState() => _OnboardingCarouselScreenState();
}

class _OnboardingCarouselScreenState extends State<OnboardingCarouselScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoRotateTimer;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      titlePrefix: 'Work & Earn — \n',
      highlightedTitle: 'Up to ₹30,000/month',
      description: 'Join over 5,000+ professionals providing top-rated home services in your city.',
      imageUrl: 'assets/images/barber_1.jpg',
    ),
    OnboardingSlide(
      titlePrefix: 'Flexible Hours — \n',
      highlightedTitle: 'Be Your Own Boss',
      description: 'Choose your own schedule, accept jobs near you, and grow your daily income.',
      imageUrl: 'assets/images/barber_2.jpg',
    ),
    OnboardingSlide(
      titlePrefix: 'Instant Payouts — \n',
      highlightedTitle: 'Direct to Bank Account',
      description: 'Get guaranteed hassle-free weekly payouts and performance bonus rewards.',
      imageUrl: 'assets/images/barber_3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoRotation();
  }

  void _startAutoRotation() {
    _autoRotateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextIndex = (_currentIndex + 1) % _slides.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Auto-Rotating Background Image Carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  slide.imageUrl.startsWith('assets/')
                      ? Image.asset(
                          slide.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          slide.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: const Color(0xFF1E162B));
                          },
                        ),
                  // Dark-to-transparent gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.4, 1.0],
                        colors: [
                          Colors.black26,
                          Color.fromRGBO(25, 28, 30, 0.45),
                          Color.fromRGBO(25, 28, 30, 0.98),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Branding Badge Top-Left
          Positioned(
            top: 54,
            left: AppDimensions.marginMobile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'HomePartner',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // Content Area (Bottom Section)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.marginMobile,
                ).copyWith(bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Headline Section
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        key: ValueKey<int>(_currentIndex),
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 28,
                                    height: 1.25,
                                    fontWeight: FontWeight.bold,
                                  ),
                              children: [
                                TextSpan(text: _slides[_currentIndex].titlePrefix),
                                TextSpan(
                                  text: _slides[_currentIndex].highlightedTitle,
                                  style: const TextStyle(
                                    color: AppColors.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _slides[_currentIndex].description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.outlineVariant.withOpacity(0.9),
                                  fontSize: 15,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (index) {
                        final isSelected = _currentIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 32 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.onPrimaryContainer
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),

                    // Start Working Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PhoneLoginScreen(),
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Working',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Secondary CTA Card ("Looking for help? Book a Service →")
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Small Thumbnail
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=200&auto=format&fit=crop',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Text Info
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Looking for help?',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Book a Service →',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow Icon
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.onPrimaryContainer,
                            size: 24,
                          ),
                        ],
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
