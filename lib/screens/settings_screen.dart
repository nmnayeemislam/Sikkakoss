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
          'A fully offline kids learning app with Bangla, English, Arabic, numbers, Surah, quiz, and Hive progress tracking.',
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
              const SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Settings'),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SwitchListTile(
                        value: _darkMode,
                        onChanged: _toggleDarkMode,
                        secondary: const Icon(Icons.dark_mode_rounded),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Use a calmer nighttime theme'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.info_rounded),
                        title: const Text('About App'),
                        subtitle: const Text(AppConstants.appName),
                        onTap: _showAbout,
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
