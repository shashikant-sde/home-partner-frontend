import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'splash_language_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  // Fade-in animation for the whole content
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Scale "pop" animation for the logo icon
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Fade-out animation before transition
  late AnimationController _exitController;
  late Animation<double> _exitAnimation;

  @override
  void initState() {
    super.initState();

    // ── Fade-in ──────────────────────────────────────────────────────────────
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // ── Logo pop-scale ────────────────────────────────────────────────────────
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // ── Fade-out (exit) ───────────────────────────────────────────────────────
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _exitAnimation = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeIn,
    );

    // Start entrance animations
    _fadeController.forward();
    _scaleController.forward();

    // Navigate to language screen after delay
    Future.delayed(const Duration(milliseconds: 2500), _navigateToLanguage);
  }

  Future<void> _navigateToLanguage() async {
    if (!mounted) return;
    // Fade out before push
    await _exitController.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const SplashLanguageScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: FadeTransition(
        opacity: ReverseAnimation(_exitAnimation),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Column(
              children: [
                // ── Top spacer ───────────────────────────────────────────────
                const Spacer(),

                // ── Centre: logo + app name + spinner ────────────────────────
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo icon with animated scale + gradient background
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.28),
                              blurRadius: 32,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_repair_service_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // App name
                    Text(
                      'HomePartner',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 40),

                    // Loading spinner
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        backgroundColor: AppColors.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Bottom spacer ────────────────────────────────────────────
                const Spacer(),

                // ── Version footer ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    'V2.4.0',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
