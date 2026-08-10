import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'complete_profile_screen.dart';
import '../home/help_support_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // 6-digit OTP Controllers & Focus Nodes
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _isOtpExpired = false;
  bool _isLockedOut = false;
  bool _isOtpUsed = false;

  // Security & Attempt Limits
  int _wrongAttempts = 0;
  static const int _maxAttempts = 5;

  // Timers: 5-minute Validity & Resend Cooldown
  int _validitySeconds = 300; // 5 minutes
  int _resendSeconds = 45;    // 45 seconds cooldown
  Timer? _validityTimer;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startValidityTimer();
    _startResendTimer();
  }

  @override
  void dispose() {
    _validityTimer?.cancel();
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startValidityTimer() {
    _validityTimer?.cancel();
    setState(() {
      _validitySeconds = 300;
      _isOtpExpired = false;
    });

    _validityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_validitySeconds > 0) {
        setState(() {
          _validitySeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isOtpExpired = true;
        });
      }
    });
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendSeconds = 45;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatValidityTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  void _resendOtp() {
    if (_resendSeconds > 0) return;

    // Clear fields
    for (var controller in _controllers) {
      controller.clear();
    }

    setState(() {
      _wrongAttempts = 0;
      _isLockedOut = false;
      _isOtpExpired = false;
      _isOtpUsed = false;
    });

    _startValidityTimer();
    _startResendTimer();

    _focusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('A new 6-digit OTP has been sent to ${widget.phoneNumber}'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleInputChange(String value, int index) {
    if (_isOtpExpired || _isLockedOut || _isOtpUsed) return;

    // Handle full paste of OTP (e.g. user pasted 6-digit code or SMS auto-fill)
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 6) {
      final code = digitsOnly.substring(0, 6);
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = code[i];
      }
      _focusNodes[5].unfocus();
      _verifyOtp();
      return;
    }

    if (value.isNotEmpty) {
      // Auto-focus next box
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }

      // Check if all boxes filled -> trigger auto verify
      String fullOtp = _controllers.map((c) => c.text).join();
      if (fullOtp.length == 6) {
        _verifyOtp();
      }
    } else {
      // Auto-focus previous box on backspace/deletion
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _verifyOtp() {
    if (_isOtpUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This OTP has already been verified and expired.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isOtpExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has expired! Please request a new OTP code.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isLockedOut) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum attempts reached. Please tap "Resend OTP" to try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate network validation & security check
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      // Demo condition: '000000' triggers wrong attempt simulation
      bool isSuccess = otp != '000000';

      if (isSuccess) {
        // Mark OTP as used (one-time use only)
        setState(() {
          _isVerifying = false;
          _isOtpUsed = true;
        });
        _validityTimer?.cancel();
        _resendTimer?.cancel();
        TextInput.finishAutofillContext();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verified Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CompleteProfileScreen(),
          ),
        );
      } else {
        // Wrong attempt handling
        setState(() {
          _isVerifying = false;
          _wrongAttempts++;
          if (_wrongAttempts >= _maxAttempts) {
            _isLockedOut = true;
          }
        });

        // Clear fields on wrong attempt
        for (var controller in _controllers) {
          controller.clear();
        }
        if (!_isLockedOut) {
          _focusNodes[0].requestFocus();
        }

        final remaining = _maxAttempts - _wrongAttempts;
        final errorMsg = _isLockedOut
            ? 'Maximum wrong attempts (5/5) reached! Please tap "Resend OTP".'
            : 'Invalid OTP! $remaining attempt(s) remaining.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.marginMobile,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Floating Shield & Badge Illustration
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (_isLockedOut || _isOtpExpired)
                                    ? Colors.red.withOpacity(0.06)
                                    : AppColors.primary.withOpacity(0.06),
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(25, 28, 30, 0.08),
                                    blurRadius: 28,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                (_isLockedOut || _isOtpExpired)
                                    ? Icons.gpp_maybe_rounded
                                    : Icons.verified_user_rounded,
                                color: (_isLockedOut || _isOtpExpired)
                                    ? Colors.redAccent
                                    : AppColors.primary,
                                size: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Typography Header
                    Text(
                      'Verify 6-Digit OTP',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                        children: [
                          const TextSpan(text: 'Enter the 6-digit verification code sent to '),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Validity Timer Banner (5 Minutes Expiry)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isOtpExpired
                            ? Colors.red.shade50
                            : _isLockedOut
                                ? Colors.orange.shade50
                                : AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isOtpExpired
                              ? Colors.red.shade200
                              : _isLockedOut
                                  ? Colors.orange.shade300
                                  : AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isOtpExpired ? Icons.timer_off_rounded : Icons.timer_outlined,
                            size: 18,
                            color: _isOtpExpired ? Colors.red : AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isOtpExpired
                                ? 'OTP Expired! Tap Resend below.'
                                : 'OTP Valid for: ${_formatValidityTime(_validitySeconds)} min',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _isOtpExpired ? Colors.red.shade800 : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // OTP 6-Digit Input Fields with Android & iOS SMS Auto-Fill
                    AutofillGroup(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 46,
                            height: 54,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              enabled: !_isOtpExpired && !_isLockedOut && !_isVerifying && !_isOtpUsed,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: (_isLockedOut || _isOtpExpired)
                                        ? Colors.grey
                                        : AppColors.onSurface,
                                    fontSize: 22,
                                  ),
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                fillColor: (_isLockedOut || _isOtpExpired)
                                    ? Colors.grey.shade200
                                    : const Color(0xFFF1F3F5),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2.2,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              onChanged: (value) => _handleInputChange(value, index),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Wrong Attempts Status / Security Warning
                    if (_wrongAttempts > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _isLockedOut
                              ? '🔒 Verification locked (5/5 failed attempts)'
                              : '⚠️ Wrong attempt ($_wrongAttempts/$_maxAttempts)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _isLockedOut ? Colors.red.shade700 : Colors.orange.shade900,
                          ),
                        ),
                      ),

                    // Resend Action Link & Cooldown Timer (30-60s)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                        ),
                        InkWell(
                          onTap: _resendSeconds == 0 ? _resendOtp : null,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Text(
                              _resendSeconds > 0
                                  ? 'Resend OTP in ${_resendSeconds}s'
                                  : 'Resend OTP',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _resendSeconds > 0
                                    ? Colors.grey.shade500
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Verify Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: (_isOtpExpired || _isLockedOut || _isOtpUsed)
                              ? LinearGradient(
                                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                                )
                              : AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          boxShadow: (_isOtpExpired || _isLockedOut || _isOtpUsed)
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: ElevatedButton(
                          onPressed: (_isVerifying || _isOtpExpired || _isLockedOut || _isOtpUsed)
                              ? null
                              : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            ),
                          ),
                          child: _isVerifying
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  _isOtpUsed
                                      ? 'OTP Verified'
                                      : _isOtpExpired
                                          ? 'OTP Expired'
                                          : _isLockedOut
                                              ? 'Locked Out'
                                              : 'Verify & Proceed',
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Change Registered Number Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Change registered number',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Secure Verification Badge
                    Opacity(
                      opacity: 0.7,
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.security_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Android & iOS SMS Auto-Fill Enabled',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'PROTECTED BY HOMEPARTNER 256-BIT ENCRYPTED OTP GUARD',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
