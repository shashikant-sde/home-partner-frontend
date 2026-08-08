import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'schedule_screen.dart';
import 'account_screen.dart';
import 'earnings_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
enum JobStatus { pending, accepted, declined }

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
  JobStatus status;

  ServiceRequest({
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
    this.status = JobStatus.pending,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class AvailableJobsScreen extends StatefulWidget {
  const AvailableJobsScreen({super.key});

  @override
  State<AvailableJobsScreen> createState() => _AvailableJobsScreenState();
}

class _AvailableJobsScreenState extends State<AvailableJobsScreen> {
  bool _isOnline = true;
  int _activeNavIndex = 0;

  final List<ServiceRequest> _requests = [
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

  // Track which job IDs are being animated out
  final Set<String> _removingIds = {};

  int get _pendingCount =>
      _requests.where((r) => r.status == JobStatus.pending).length;

  // ── Accept ────────────────────────────────────────────────────────────────
  Future<void> _acceptJob(ServiceRequest job) async {
    final confirmed = await _showConfirmSheet(
      title: 'Accept Job?',
      subtitle:
          'You are about to accept "${job.title}" from ${job.clientName}. This will be added to your schedule.',
      confirmLabel: 'Yes, Accept',
      confirmColor: AppColors.primary,
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF0A7A42),
      iconBg: const Color(0xFFE7F7EF),
    );
    if (!confirmed) return;

    setState(() => job.status = JobStatus.accepted);

    _showResultSnack(
      message: '✅  Job accepted! Added to your schedule.',
      color: const Color(0xFF0A7A42),
    );

    // Animate card out after brief delay so user sees status
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _removingIds.add(job.id));
    await Future.delayed(const Duration(milliseconds: 380));
    if (mounted) {
      setState(() {
        _requests.removeWhere((r) => r.id == job.id);
        _removingIds.remove(job.id);
      });
    }
  }

  // ── Decline ───────────────────────────────────────────────────────────────
  Future<void> _declineJob(ServiceRequest job) async {
    final confirmed = await _showConfirmSheet(
      title: 'Decline Job?',
      subtitle:
          'Are you sure you want to decline "${job.title}" from ${job.clientName}? This action cannot be undone.',
      confirmLabel: 'Yes, Decline',
      confirmColor: Colors.redAccent,
      icon: Icons.cancel_rounded,
      iconColor: Colors.redAccent,
      iconBg: const Color(0xFFFFEBEB),
    );
    if (!confirmed) return;

    setState(() => job.status = JobStatus.declined);

    _showResultSnack(
      message: '❌  Job declined.',
      color: Colors.redAccent,
    );

    // Animate card out
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _removingIds.add(job.id));
    await Future.delayed(const Duration(milliseconds: 380));
    if (mounted) {
      setState(() {
        _requests.removeWhere((r) => r.id == job.id);
        _removingIds.remove(job.id);
      });
    }
  }

  // ── Confirmation bottom sheet ─────────────────────────────────────────────
  Future<bool> _showConfirmSheet({
    required String title,
    required String subtitle,
    required String confirmLabel,
    required Color confirmColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(
                          color: AppColors.outlineVariant, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                    ),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  void _showResultSnack({required String message, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.85),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
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
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.onSurface),
                onPressed: () {},
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

              // ── Online / Offline toggle ──────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isOnline
                      ? const Color(0xFFE7F7EF)
                      : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isOnline
                        ? const Color(0xFF0A7A42).withOpacity(0.25)
                        : AppColors.outlineVariant.withOpacity(0.3),
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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isOnline
                            ? const Color(0xFF0A7A42)
                            : AppColors.outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isOnline
                            ? "You're currently Online"
                            : "You're currently Offline",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _isOnline
                              ? const Color(0xFF0A7A42)
                              : AppColors.onSurface,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isOnline,
                      onChanged: (val) => setState(() => _isOnline = val),
                      activeColor: AppColors.primaryContainer,
                      activeTrackColor: AppColors.primaryFixed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Section header ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      'New Service Requests ($_pendingCount)',
                      key: ValueKey(_pendingCount),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
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

              // ── Job cards ────────────────────────────────────────────────
              if (_requests.isEmpty)
                _buildEmptyState()
              else
                Column(
                  children: _requests.map((job) {
                    final isRemoving = _removingIds.contains(job.id);
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 350),
                      opacity: isRemoving ? 0.0 : 1.0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 350),
                        offset: isRemoving
                            ? const Offset(1.0, 0)
                            : Offset.zero,
                        curve: Curves.easeInCubic,
                        child: _buildJobCard(job),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 12),

              // ── Bento bottom row ─────────────────────────────────────────
              Row(
                children: [
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
                          Icon(Icons.trending_up_rounded,
                              color: Colors.white, size: 36),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Job card ───────────────────────────────────────────────────────────────
  Widget _buildJobCard(ServiceRequest job) {
    final isAccepted = job.status == JobStatus.accepted;
    final isDeclined = job.status == JobStatus.declined;
    final isPending = job.status == JobStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isAccepted
            ? const Color(0xFFF0FBF4)
            : isDeclined
                ? const Color(0xFFFFF0F0)
                : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAccepted
              ? const Color(0xFF10B981).withOpacity(0.4)
              : isDeclined
                  ? Colors.redAccent.withOpacity(0.3)
                  : AppColors.surfaceContainer,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(25, 28, 30, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status ribbon when accepted/declined
          if (!isPending)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: isAccepted
                    ? const Color(0xFF10B981)
                    : Colors.redAccent,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isAccepted
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAccepted ? 'Job Accepted!' : 'Job Declined',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                      child: Icon(job.icon,
                          color: job.iconColor, size: 30),
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
                              const Icon(Icons.star_rounded,
                                  color: AppColors.secondary, size: 16),
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
                const Divider(
                    color: AppColors.surfaceContainerLow, height: 1),
                const SizedBox(height: 16),

                // Metadata
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.near_me_outlined,
                              color: AppColors.outline, size: 20),
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
                          const Icon(Icons.schedule_outlined,
                              color: AppColors.outline, size: 20),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              job.scheduledTime,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Buttons — only shown when pending
                if (isPending) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Decline
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => _declineJob(job),
                            icon: const Icon(Icons.close_rounded,
                                size: 16,
                                color: Colors.redAccent),
                            label: const Text(
                              'Decline',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.redAccent, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Accept
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _acceptJob(job),
                            icon: const Icon(Icons.check_rounded,
                                size: 16, color: Colors.white),
                            label: const Text(
                              'Accept Job',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state when all jobs are handled ──────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_rounded,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 20),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No pending service requests right now.\nNew jobs will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
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
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: _activeNavIndex,
          onTap: (index) {
            setState(() => _activeNavIndex = index);
            if (index == 1) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => const ScheduleScreen()))
                  .then((_) => setState(() => _activeNavIndex = 0));
            } else if (index == 2) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => const EarningsScreen()))
                  .then((_) => setState(() => _activeNavIndex = 0));
            } else if (index == 3) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => const AccountScreen()))
                  .then((_) => setState(() => _activeNavIndex = 0));
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontFamily: 'Inter', fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service_rounded,
                  color: _activeNavIndex == 0
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded,
                  color: _activeNavIndex == 1
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments_outlined,
                  color: _activeNavIndex == 2
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded,
                  color: _activeNavIndex == 3
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
