import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/constants/app_constants.dart';

class TabletSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isExpanded;
  final VoidCallback onToggle;

  const TabletSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final navItems = [
      _SidebarItem(icon: Icons.dashboard_rounded, label: AppConstants.overview),
      _SidebarItem(
        icon: Icons.medical_services_rounded,
        label: AppConstants.products,
      ),
      _SidebarItem(
        icon: Icons.shopping_cart_rounded,
        label: AppConstants.orders,
      ),
      _SidebarItem(icon: Icons.bar_chart_rounded, label: 'Sales'),
      _SidebarItem(icon: Icons.people_rounded, label: AppConstants.customers),
      _SidebarItem(icon: Icons.payment_rounded, label: AppConstants.payments),
      _SidebarItem(
        icon: Icons.help_outline_rounded,
        label: AppConstants.helpSupport,
      ),
      _SidebarItem(icon: Icons.settings_rounded, label: AppConstants.settings),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 280 : 80,
      decoration: BoxDecoration(
        color: AppTheme.sidebarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 26),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.accentColor,
                  radius: 20,
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Pharmly',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = index == selectedIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onItemSelected(index),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppTheme.accentColor.withValues(alpha: 217)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color:
                                  isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.white,
                              size: 24,
                            ),
                            if (isExpanded) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.white,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Upgrade section
          if (isExpanded) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withValues(alpha: 26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppConstants.upgradeProText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.upgradeProDesc,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 179),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Upgrade Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Logout
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => authProvider.logout(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      if (isExpanded) ...[
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            AppConstants.logout,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
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

class _SidebarItem {
  final IconData icon;
  final String label;

  const _SidebarItem({required this.icon, required this.label});
}
