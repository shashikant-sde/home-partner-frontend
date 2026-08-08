import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'schedule_screen.dart';
import 'earnings_screen.dart';
import 'account_screen.dart';

// ─────────────────────────────────────────────
// Data model for a bank account
// ─────────────────────────────────────────────
class _BankAccount {
  String bankName;
  String accountType;
  String accountHolder;
  String accountNumber;
  bool obscure;

  _BankAccount({
    required this.bankName,
    required this.accountType,
    required this.accountHolder,
    required this.accountNumber,
    this.obscure = true,
  });

  String get maskedNumber {
    if (accountNumber.length <= 4) return accountNumber;
    final last4 = accountNumber.substring(accountNumber.length - 4);
    return '•••• •••• $last4';
  }
}

// ─────────────────────────────────────────────
// Main screen
// ─────────────────────────────────────────────
class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen>
    with SingleTickerProviderStateMixin {
  final int _activeNavIndex = 3;
  String _selectedPayout = 'weekly';

  final List<_BankAccount> _accounts = [
    _BankAccount(
      bankName: 'Chase Bank',
      accountType: 'Personal Savings',
      accountHolder: 'Alex Rivera',
      accountNumber: '123456784567',
    ),
  ];

  // ── Animation controller for the add-form card ──
  late AnimationController _addCardController;
  late Animation<double> _addCardAnimation;

  bool _showAddForm = false;

  // ── Add-form controllers ──
  final _addBankNameCtrl = TextEditingController();
  final _addAccountTypeCtrl = TextEditingController();
  final _addHolderCtrl = TextEditingController();
  final _addNumberCtrl = TextEditingController();
  final _addFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _addCardAnimation = CurvedAnimation(
      parent: _addCardController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _addCardController.dispose();
    _addBankNameCtrl.dispose();
    _addAccountTypeCtrl.dispose();
    _addHolderCtrl.dispose();
    _addNumberCtrl.dispose();
    super.dispose();
  }

  // ─── Toggle add-form ─────────────────────────
  void _toggleAddForm() {
    setState(() {
      _showAddForm = !_showAddForm;
      if (_showAddForm) {
        _addCardController.forward();
      } else {
        _addCardController.reverse();
        _clearAddForm();
      }
    });
  }

  void _clearAddForm() {
    _addBankNameCtrl.clear();
    _addAccountTypeCtrl.clear();
    _addHolderCtrl.clear();
    _addNumberCtrl.clear();
  }

  // ─── Save new account ─────────────────────────
  void _saveNewAccount() {
    if (_addFormKey.currentState!.validate()) {
      setState(() {
        _accounts.add(_BankAccount(
          bankName: _addBankNameCtrl.text.trim(),
          accountType: _addAccountTypeCtrl.text.trim(),
          accountHolder: _addHolderCtrl.text.trim(),
          accountNumber: _addNumberCtrl.text.trim(),
        ));
        _showAddForm = false;
        _addCardController.reverse();
        _clearAddForm();
      });
      _showSnackBar('Bank account added successfully!', isSuccess: true);
    }
  }

  // ─── Open edit bottom sheet ───────────────────
  void _openEditSheet(int index) {
    final account = _accounts[index];
    final bankNameCtrl = TextEditingController(text: account.bankName);
    final typeCtrl = TextEditingController(text: account.accountType);
    final holderCtrl = TextEditingController(text: account.accountHolder);
    final numberCtrl = TextEditingController(text: account.accountNumber);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.edit_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Edit Bank Account',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSheetField(
                  controller: bankNameCtrl,
                  label: 'Bank Name',
                  icon: Icons.account_balance_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildSheetField(
                  controller: typeCtrl,
                  label: 'Account Type',
                  icon: Icons.category_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildSheetField(
                  controller: holderCtrl,
                  label: 'Account Holder',
                  icon: Icons.person_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildSheetField(
                  controller: numberCtrl,
                  label: 'Account Number',
                  icon: Icons.pin_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 8) return 'Enter at least 8 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                account.bankName = bankNameCtrl.text.trim();
                                account.accountType = typeCtrl.text.trim();
                                account.accountHolder = holderCtrl.text.trim();
                                account.accountNumber = numberCtrl.text.trim();
                              });
                              Navigator.of(ctx).pop();
                              _showSnackBar('Account updated!',
                                  isSuccess: true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontFamily: 'Manrope',
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
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────
  Widget _buildSheetField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppColors.outlineVariant.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor:
            isSuccess ? const Color(0xFF0A7A42) : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Bank Details',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Primary Account header ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Primary Account',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F7EF),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFF0A7A42), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A7A42),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Existing bank account cards ─────────────
              ..._accounts.asMap().entries.map((entry) {
                final i = entry.key;
                final account = entry.value;
                return _BankAccountCard(
                  account: account,
                  onEdit: () => _openEditSheet(i),
                  onToggleObscure: () =>
                      setState(() => account.obscure = !account.obscure),
                );
              }),

              const SizedBox(height: 32),

              // ── Payout Preferences ──────────────────────
              const Text(
                'Payout Preferences',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              _buildPayoutOption(
                id: 'weekly',
                icon: Icons.calendar_month_rounded,
                title: 'Weekly',
                description:
                    'Processed every Monday. No additional fees.',
                isSelected: _selectedPayout == 'weekly',
                onTap: () => setState(() => _selectedPayout = 'weekly'),
              ),
              const SizedBox(height: 16),

              _buildPayoutOption(
                id: 'instant',
                icon: Icons.bolt_rounded,
                title: 'Instant',
                description:
                    'Available within minutes. 1.5% processing fee.',
                badge: 'FEE APPLIES',
                isSelected: _selectedPayout == 'instant',
                onTap: () => setState(() => _selectedPayout = 'instant'),
              ),
              const SizedBox(height: 32),

              // ── Add New Bank Account button ──────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _showAddForm
                        ? const LinearGradient(
                            colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                          )
                        : AppColors.primaryGradient,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _toggleAddForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _showAddForm
                          ? const Row(
                              key: ValueKey('cancel'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close_rounded,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              key: ValueKey('add'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline_rounded,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Add New Bank Account',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              // ── Animated Add-form card ──────────────────
              SizeTransition(
                sizeFactor: _addCardAnimation,
                axisAlignment: -1,
                child: _AddAccountForm(
                  formKey: _addFormKey,
                  bankNameCtrl: _addBankNameCtrl,
                  accountTypeCtrl: _addAccountTypeCtrl,
                  holderCtrl: _addHolderCtrl,
                  numberCtrl: _addNumberCtrl,
                  onSave: _saveNewAccount,
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Your payment data is encrypted and handled by Stripe.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  Widget _buildPayoutOption({
    required String id,
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withOpacity(0.02)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppColors.primaryContainer, size: 28),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.outline,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onTertiaryFixedVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
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
                MaterialPageRoute(builder: (_) => const ScheduleScreen()),
              );
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const EarningsScreen()),
              );
            } else if (index == 3) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AccountScreen()),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontFamily: 'Inter', fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  color: _activeNavIndex == 0
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              label: 'Home',
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
              icon: Icon(Icons.person,
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

// ─────────────────────────────────────────────
// Extracted bank account card widget
// ─────────────────────────────────────────────
class _BankAccountCard extends StatelessWidget {
  final _BankAccount account;
  final VoidCallback onEdit;
  final VoidCallback onToggleObscure;

  const _BankAccountCard({
    required this.account,
    required this.onEdit,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.3),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank name + Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: AppColors.primaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        account.accountType,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Edit button
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Account holder + Account number
          Row(
            children: [
              // Account Holder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCOUNT HOLDER',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      account.accountHolder,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              // Account Number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCOUNT NUMBER',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            account.obscure
                                ? account.maskedNumber
                                : account.accountNumber,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: AppColors.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Eye toggle
                        GestureDetector(
                          onTap: onToggleObscure,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              account.obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              key: ValueKey(account.obscure),
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Add account inline form (animated via SizeTransition)
// ─────────────────────────────────────────────
class _AddAccountForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController bankNameCtrl;
  final TextEditingController accountTypeCtrl;
  final TextEditingController holderCtrl;
  final TextEditingController numberCtrl;
  final VoidCallback onSave;

  const _AddAccountForm({
    required this.formKey,
    required this.bankNameCtrl,
    required this.accountTypeCtrl,
    required this.holderCtrl,
    required this.numberCtrl,
    required this.onSave,
  });

  @override
  State<_AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<_AddAccountForm> {
  bool _obscureNumber = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'New Bank Account',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bank Name
            _buildField(
              controller: widget.bankNameCtrl,
              label: 'Bank Name',
              icon: Icons.account_balance_rounded,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),

            // Account Type
            _buildField(
              controller: widget.accountTypeCtrl,
              label: 'Account Type (e.g. Savings)',
              icon: Icons.category_rounded,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),

            // Account Holder
            _buildField(
              controller: widget.holderCtrl,
              label: 'Account Holder Name',
              icon: Icons.person_rounded,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),

            // Account Number with eye toggle
            TextFormField(
              controller: widget.numberCtrl,
              keyboardType: TextInputType.number,
              obscureText: _obscureNumber,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length < 8) return 'Minimum 8 digits';
                return null;
              },
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                labelText: 'Account Number',
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
                prefixIcon: const Icon(Icons.pin_rounded,
                    color: AppColors.primary, size: 20),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscureNumber = !_obscureNumber),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _obscureNumber
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      key: ValueKey(_obscureNumber),
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: AppColors.outlineVariant, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: AppColors.outlineVariant.withOpacity(0.5),
                      width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: AppColors.primary, width: 1.8),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Colors.redAccent, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Colors.redAccent, width: 1.8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.onSave,
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
                      Icon(Icons.check_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Save Account',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppColors.outlineVariant.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
      ),
    );
  }
}
