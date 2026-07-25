import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'schedule_screen.dart';
import 'account_screen.dart';
import 'earnings_screen.dart';

class ServiceRequest {
  final String id;
  final String title;
  final String clientName;
  final double rating;
  final double estEarning;
  final String distance;
  final String scheduledTime;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ServiceRequest({
    required this.id,
    required this.title,
    required this.clientName,
    required this.rating,
    required this.estEarning,
    required this.distance,
    required this.scheduledTime,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class AvailableJobsScreen extends StatefulWidget {
  const AvailableJobsScreen({super.key});

  @override
  State<AvailableJobsScreen> createState() => _AvailableJobsScreenState();
}

class _AvailableJobsScreenState extends State<AvailableJobsScreen> {
  bool _isOnline = true;
  int _activeNavIndex = 0;

  final List<ServiceRequest> _requests = const [
    ServiceRequest(
      id: 'req1',
      title: 'Classic Haircut & Beard Trim',
      clientName: 'Alex J.',
      rating: 4.8,
      estEarning: 35.00,
      distance: '2.4 km away',
      scheduledTime: 'Today, 02:30 PM',
      icon: Icons.content_cut_rounded,
      iconColor: AppColors.secondary,
      iconBgColor: AppColors.secondaryFixed,
    ),
    ServiceRequest(
      id: 'req2',
      title: 'Deep House Cleaning',
      clientName: 'Sarah W.',
      rating: 4.9,
      estEarning: 120.00,
      distance: '5.1 km away',
      scheduledTime: 'Tomorrow, 09:00 AM',
      icon: Icons.home_repair_service_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.primaryFixed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.85),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
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
        centerTitle: false,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
                onPressed: () {
                  // Notifications action
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.marginMobile,
          ).copyWith(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Status Toggle (Online/Offline Switch Container)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
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
                    // Dynamic Status Dot Indicator
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isOnline ? AppColors.secondary : AppColors.outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isOnline ? "You're currently Online" : "You're currently Offline",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    // Switch
                    Switch(
                      value: _isOnline,
                      onChanged: (val) {
                        setState(() {
                          _isOnline = val;
                        });
                      },
                      activeColor: AppColors.primaryContainer,
                      activeTrackColor: AppColors.primaryFixed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header Title (New Service Requests (2) + Recent badge)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Service Requests (2)',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'Recent',
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
              const SizedBox(height: 16),

              // Service Requests List
              Column(
                children: _requests.map((job) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceContainer),
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
                        // Card Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: job.iconBgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                job.icon,
                                color: job.iconColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title,
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        job.clientName,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.star_rounded,
                                        color: AppColors.secondary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        job.rating.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${job.estEarning.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const Text(
                                    'Est. Earning',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      color: AppColors.outline,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.surfaceContainerLow, height: 1),
                        const SizedBox(height: 16),

                        // Job Metadata details
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.near_me_outlined, color: AppColors.outline, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    job.distance,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule_outlined, color: AppColors.outline, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    job.scheduledTime,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Decline / Accept buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Decline logic
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.secondary, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                                    ),
                                  ),
                                  child: const Text(
                                    'Decline',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Accept job action logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                                    ),
                                  ),
                                  child: const Text(
                                    'Accept Job',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Map/Distance Placeholder Section (Bento Style)
              Row(
                children: [
                  // Next appointment bento map card
                  Expanded(
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=400&auto=format&fit=crop',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NEXT APPOINTMENT',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Westview Heights',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Peak demand info bento card
                  Expanded(
                    child: Container(
                      height: 180,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Peak Demand',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'High demand for cleaning services in your area. Earn up to 1.5x more today.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.white70,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
              setState(() {
                _activeNavIndex = index;
              });
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                ).then((_) {
                  setState(() {
                    _activeNavIndex = 0; // Reset index when returning
                  });
                });
              } else if (index == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EarningsScreen()),
                ).then((_) {
                  setState(() {
                    _activeNavIndex = 0; // Reset index when returning
                  });
                });
              } else if (index == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AccountScreen()),
                ).then((_) {
                  setState(() {
                    _activeNavIndex = 0; // Reset index when returning
                  });
                });
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
                  child: Icon(Icons.home_repair_service_rounded, color: _activeNavIndex == 0 ? AppColors.primary : AppColors.onSurfaceVariant),
                ),
                label: 'Jobs',
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
                  child: Icon(Icons.person_outline_rounded, color: _activeNavIndex == 3 ? AppColors.primary : AppColors.onSurfaceVariant),
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
