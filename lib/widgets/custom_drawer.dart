import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onRate;

  const CustomDrawer({super.key, required this.onShare, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildListView(context)),
              _buildVersionFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(),
        const Divider(color: Colors.white24, indent: 24, endIndent: 24),
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            'MENU',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ),
        _buildMenuItem(Icons.home, 'Home', () => Navigator.pop(context)),
        _buildAboutSection(),
        _buildMenuItem(Icons.share_outlined, 'Share App', () {
          Navigator.pop(context);
          onShare();
        }),
        _buildMenuItem(Icons.star_outline, 'Rate Us', () {
          Navigator.pop(context);
          onRate();
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        children: [
          Image.asset(
            'assets/images/tasbih_icon.png',
            width: 80,
            height: 80,
            errorBuilder: (error, context, stackTrace) =>
                const Icon(Icons.touch_app, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Digital Tasbih',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white38,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildAboutSection() {
    return ExpansionTile(
      leading: const Icon(Icons.info_outline, color: Colors.white, size: 22),
      title: const Text(
        'About Us',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      iconColor: Colors.white,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                'Digital Tasbih helps you keep track of your daily dhikr with ease.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContactIcon(
                    Icons.email_outlined,
                    'hafizapps@gmail.com',
                  ),
                  const SizedBox(width: 32),
                  _buildContactIcon(Icons.language, 'hafizapps.com'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactIcon(IconData icon, String text) {
    return InkWell(
      onTap: () => debugPrint('Contact: $text'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(38),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }

  Widget _buildVersionFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withAlpha(25))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2026 Hafiz Apps',
            style: TextStyle(color: Colors.white.withAlpha(102)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'v1.0',
              style: TextStyle(color: Colors.white.withAlpha(128)),
            ),
          ),
        ],
      ),
    );
  }
}
