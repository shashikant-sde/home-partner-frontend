import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'schedule_screen.dart';
import 'earnings_screen.dart';
import 'account_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  final int _activeNavIndex = 3;

  // Track expanded state for FAQ items
  final List<bool> _faqExpanded = [true, false, false];

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I verify my service provider profile?',
      'answer':
          'To complete your verification, navigate to Profile Settings > Identity Verification. You will need to upload a valid government-issued ID and a recent profile photo. Verification usually takes 24-48 business hours.',
    },
    {
      'question': 'When will I receive my earnings?',
      'answer':
          'Earnings are typically processed every Tuesday for all completed and approved services from the previous week (Monday-Sunday). Depending on your bank, funds may take 1-3 business days to appear in your account.',
    },
    {
      'question': 'What happens if a client cancels a request?',
      'answer':
          'If a client cancels within 24 hours of the scheduled service, a cancellation fee may apply. This fee is automatically credited to your account. For more details, view our Cancellation Policy in the Terms of Service.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.85),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Search Hero Section
              const Text(
                'How can we help?',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find answers to common questions or browse topics below.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search for help topics',
                          hintStyle: TextStyle(
                            color: AppColors.outline,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bento Grid of Categories (4 Items matching UI)
              _buildCategoryCard(
                icon: Icons.person_outline,
                iconBgColor: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                title: 'Account & Profile',
                description: 'Manage login details, verification, and settings.',
              ),
              const SizedBox(height: 12),
              _buildCategoryCard(
                icon: Icons.payments_outlined,
                iconBgColor: AppColors.secondaryFixed,
                iconColor: AppColors.secondary,
                title: 'Earnings & Payments',
                description: 'Payout cycles, bank info, and service fees.',
              ),
              const SizedBox(height: 12),
              _buildCategoryCard(
                icon: Icons.assignment_outlined,
                iconBgColor: AppColors.tertiaryFixed,
                iconColor: AppColors.tertiary,
                title: 'Services & Requests',
                description: 'Booking management and client interactions.',
              ),
              const SizedBox(height: 12),
              _buildCategoryCard(
                icon: Icons.settings_suggest_outlined,
                iconBgColor: AppColors.surfaceContainerHigh,
                iconColor: AppColors.onSurfaceVariant,
                title: 'App & Technical Issues',
                description: 'App bugs, navigation, and device support.',
              ),
              const SizedBox(height: 32),

              // FAQs Accordion
              const Center(
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ...List.generate(_faqs.length, (index) => _buildFaqItem(index)),

              const SizedBox(height: 32),

              // Still Need Help? Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Still need help?',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our dedicated support team is available 24/7 to assist you with any questions or concerns.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: AppColors.onPrimaryContainer.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Chat Button (White Filled)
                    _buildWhiteContactButton(
                      icon: Icons.forum_outlined,
                      text: 'Chat with Support',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    // Email Us (Outlined)
                    _buildOutlinedContactButton(
                      icon: Icons.mail_outline,
                      text: 'Email Us',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    // Call Support (Outlined)
                    _buildOutlinedContactButton(
                      icon: Icons.call_outlined,
                      text: 'Call Support',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Image & Footer Asset Section
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.outlineVariant),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCGd27eyT2-09AKoIQV7EWxN3sHPxZx6JbpCu-p3j3hKg4IL5QESoFQm6mapmEmd6VI3hvWZw8RpXfh9fpBeqvOHN8NN0dqAqpTZ0vO0_SiwlgXDn3Bm1z61Tbg8T6OaRqQQDSxXJZZEyxA8mBEiQw1rWcsQmGfejZEs3FB2iCUIYYnETTiV4qlXhISyETJNHI7hDsF5c1mOOGqd6zEHWujAMxZ84hUlx_kYYJn-HCpG3X0nkRjuzsBVGp39UXWtscIpDfY3qyu9b96',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surfaceContainerHigh,
                        child: const Center(
                          child: Icon(Icons.workspace_premium, color: AppColors.primary, size: 48),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'HomePartner Platform v2.4.0',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(25, 28, 30, 0.04),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: _activeNavIndex,
            onTap: (index) {
              if (index == 0) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (index == 1) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                );
              } else if (index == 2) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const EarningsScreen()),
                );
              } else if (index == 3) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AccountScreen()),
                );
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.onSurfaceVariant,
            selectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.home_outlined, color: _activeNavIndex == 0 ? AppColors.primary : AppColors.onSurfaceVariant),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.calendar_today_rounded, color: _activeNavIndex == 1 ? AppColors.primary : AppColors.onSurfaceVariant),
                ),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.payments_outlined, color: _activeNavIndex == 2 ? AppColors.primary : AppColors.onSurfaceVariant),
                ),
                label: 'Earnings',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.person, color: _activeNavIndex == 3 ? AppColors.primary : AppColors.onSurfaceVariant),
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index) {
    final faq = _faqs[index];
    final isExpanded = _faqExpanded[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            title: Text(
              faq['question']!,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.outline,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                _faqExpanded[index] = expanded;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
                child: Text(
                  faq['answer']!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteContactButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedContactButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
