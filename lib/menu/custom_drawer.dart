import 'package:flutter/material.dart';
import 'package:scheduled_notifications/screens/home_screen.dart';
import 'package:scheduled_notifications/screens/version_notes_screen.dart';
import 'package:flutter/services.dart';

class CustomDrawer extends StatefulWidget {
  final int selectedIndex;

  const CustomDrawer({required this.selectedIndex, super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 12.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(28.0)),
        child: Drawer(
          elevation: 0,
          backgroundColor: Colors.grey[50],
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.alarm, size: 40.0),
                ),
                accountName: const Text(
                  'Scheduled Notifications',
                  style: TextStyle(fontSize: 22.0),
                ),
                accountEmail: const Text('Version 1.0.0'),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 12.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'NAVIGATION',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    _buildMenuItem(
                      context: context,
                      index: 0,
                      icon: Icons.home,
                      label: 'Home',
                      onTap: () {
                        if (widget.selectedIndex == 0) return;
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const HomeScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      index: 1,
                      icon: Icons.code,
                      label: 'Version Notes',
                      onTap: () {
                        if (widget.selectedIndex == 1) return;
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const VersionNotes(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 32.0),
                    _buildMenuItem(
                      context: context,
                      index: 2,
                      icon: Icons.settings_rounded,
                      label: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    SystemNavigator.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = widget.selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: isSelected
          ? const Color(0xFF4F46E5).withValues(alpha: 0.12)
          : Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[700],
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}