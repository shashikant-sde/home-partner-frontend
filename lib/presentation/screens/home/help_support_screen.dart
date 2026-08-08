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
  final int _activeNavIndex = 3; // Account is active

  // Track expanded state for FAQ items
  final List<bool> _faqExpanded = [false, false, false];

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I change my service area?',
      'answer': 'To update your service area, go to Profile > Service Settings > Working Radius. Note that some area changes may require a re-verification of your local permits.',
    },
    {
      'question': 'When will I receive my weekly earnings?',
      'answer': 'Earnings are processed every Monday and typically appear in your registered bank account by Wednesday, depending on your bank\'s processing times.',
    },
    {
      'question': 'What if a customer cancels last minute?',
      'answer': 'Cancellations made within 24 hours of the scheduled start time are subject to a late cancellation fee which is paid directly to your balance.',
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Hero Section
              const Text(
                'How can we help?',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Search our knowledge base or browse categories below.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search for help topics',
                          hintStyle: TextStyle(color: AppColors.outline),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Browse by Topic
              const Text(
                'BROWSE BY TOPIC',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              // Bento Grid of Categories
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
                children: [
                  _buildTopicCard(
                    icon: Icons.payments_outlined,
                    title: 'Earnings & Payments',
                    subtitle: 'Payouts, taxes, and balance',
                  ),
                  _buildTopicCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Schedule & Bookings',
                    subtitle: 'Managing tasks & availability',
                  ),
                  _buildTopicCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Account & Profile',
                    subtitle: 'Verification and settings',
                  ),
                  _buildTopicCard(
                    icon: Icons.security_rounded,
                    title: 'Safety & Security',
                    subtitle: 'Protocols and reporting',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // FAQs Accordion
              const Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              ...List.generate(_faqs.length, (index) => _buildFaqItem(index)),

              const SizedBox(height: 28),

              // Still need help? Contact Us
              const Text(
                'STILL NEED HELP?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact our team',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Available 24/7 for emergency support and general inquiries.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildContactButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      text: 'Chat with Support',
                    ),
                    const SizedBox(height: 12),
                    _buildContactButton(
                      icon: Icons.call_outlined,
                      text: 'Request a Callback',
                    ),
                    const SizedBox(height: 12),
                    _buildContactButton(
                      icon: Icons.mail_outline_rounded,
                      text: 'Email Us',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Footer info
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Version 2.4.12 • Built for HomePartners',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: AppColors.outlineVariant),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for bottom bar
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

  Widget _buildTopicCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.transparent),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.08),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(25, 28, 30, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              faq['question']!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              color: AppColors.onSurfaceVariant,
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
                    fontSize: 13,
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

  Widget _buildContactButton({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
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
