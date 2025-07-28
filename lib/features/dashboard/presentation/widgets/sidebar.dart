import 'package:flutter/material.dart';
import '../../../../common/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _SidebarItem(icon: Icons.dashboard, label: AppConstants.overview),
      _SidebarItem(icon: Icons.medical_services, label: AppConstants.products),
      _SidebarItem(icon: Icons.shopping_cart, label: AppConstants.orders),
      _SidebarItem(icon: Icons.bar_chart, label: 'Sales'),
      _SidebarItem(icon: Icons.people, label: AppConstants.customers),
      _SidebarItem(icon: Icons.payment, label: AppConstants.payments),
      _SidebarItem(icon: Icons.help_outline, label: AppConstants.helpSupport),
      _SidebarItem(icon: Icons.settings, label: AppConstants.settings),
    ];

    return Container(
      width: AppConstants.sidebarWidth,
      color: AppTheme.sidebarColor,
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // You can replace with your SVG/logo asset
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
              const SizedBox(width: 12),
              Text(
                'Pharmly',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Navigation
          Expanded(
            child: ListView.separated(
              itemCount: navItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final selected = index == selectedIndex;
                return Container(
                  decoration:
                      selected
                          ? BoxDecoration(
                            color: AppTheme.accentColor.withValues(
                              alpha: 217,
                            ), // 0.85 * 255 = ~217
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentColor.withValues(
                                  alpha: 77,
                                ), // 0.3 * 255 = ~77
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          )
                          : null,
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: selected ? AppTheme.primaryColor : Colors.white,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: selected ? AppTheme.primaryColor : Colors.white,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        fontSize: selected ? 17 : 15,
                      ),
                    ),
                    selected: selected,
                    selectedTileColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () => onItemSelected(index),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                );
              },
            ),
          ),
          // Upgrade Pro
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withValues(
                alpha: 26,
              ), // 0.1 * 255 = ~26
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.upgradeProText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.upgradeProDesc,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryColor,
                    minimumSize: const Size.fromHeight(32),
                  ),
                  onPressed: () {},
                  child: const Text('Upgrade Now'),
                ),
              ],
            ),
          ),
          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: Text(
              AppConstants.logout,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          const SizedBox(height: 16),
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
