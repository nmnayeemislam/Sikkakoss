import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.onThemeChanged});

  final ValueChanged<bool> onThemeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = ProgressService.isDarkMode();
  }

  Future<void> _toggleDarkMode(bool value) async {
    await ProgressService.setDarkMode(value);
    setState(() {
      _darkMode = value;
    });
    widget.onThemeChanged(value);
  }

  Future<void> _resetProgress() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text(
          'Completed lessons, quiz scores, and stars will be cleared.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (shouldReset != true) {
      return;
    }
    await ProgressService.resetProgress();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress reset successfully.')),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.child_care_rounded, size: 42),
      children: const [
        Text(
          'A fully offline kids learning app with Bangla, English, Arabic, numbers, Surah, quiz, and progress tracking.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFF5DB8FF),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                foregroundColor: Colors.white,
                title: const Text('Settings'),
                leading: IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                sliver: SliverList.list(
                  children: [
                    _SettingsCard(
                      child: SwitchListTile(
                        value: _darkMode,
                        onChanged: _toggleDarkMode,
                        secondary: const Icon(Icons.dark_mode_rounded),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Use a calmer nighttime theme'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsCard(
                      child: ListTile(
                        leading: const Icon(Icons.restart_alt_rounded),
                        title: const Text('Reset Progress'),
                        subtitle: const Text(
                          'Clear lessons, scores, and stars',
                        ),
                        onTap: _resetProgress,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsCard(
                      child: ListTile(
                        leading: const Icon(Icons.info_rounded),
                        title: const Text('About App'),
                        subtitle: Text(AppConstants.appName),
                        onTap: _showAbout,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Happy learning!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF24304F),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Keep exploring new letters, numbers, and Surah every day.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6D7B95),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF2C8),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.child_care_rounded,
                              size: 74,
                              color: Color(0xFF55C04E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: child,
    );
  }
}
