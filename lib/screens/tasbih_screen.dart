import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/tasbih_item.dart';
import '../services/storage_service.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/counter_card.dart';
import '../widgets/tasbih_list_item.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/input_dialog.dart';
import '../widgets/multi_input_dialog.dart';
import '../utils/helpers.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  List<TasbihItem> _tasbihs = [];
  int _selectedIndex = 0;
  Timer? _saveDebounce;

  final List<TasbihItem> _defaultTasbihs = [
    TasbihItem(
      id: '1',
      name: 'Subhan Allah',
      arabic: 'سُبْحَانَ اللَّه',
      isDefault: true,
      target: 33,
    ),
    TasbihItem(
      id: '2',
      name: 'Alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّه',
      isDefault: true,
      target: 33,
    ),
    TasbihItem(
      id: '3',
      name: 'Allahu Akbar',
      arabic: 'اللَّهُ أَكْبَر',
      isDefault: true,
      target: 34,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    super.dispose();
  }

  void _loadData() async {
    _tasbihs = await StorageService.loadTasbihs(_defaultTasbihs);
    if (mounted) setState(() {});
  }

  void _saveData() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(
      const Duration(milliseconds: 500),
      () => StorageService.saveTasbihs(_tasbihs),
    );
  }

  void _increment() {
    setState(() {
      if (_tasbihs[_selectedIndex].count < _tasbihs[_selectedIndex].target) {
        _tasbihs[_selectedIndex].count++;
        HapticFeedback.lightImpact();
      }
      if (_tasbihs[_selectedIndex].count == _tasbihs[_selectedIndex].target) {
        _showCompletionDialog();
      }
    });
    _saveData();
  }

  void _decrement() {
    setState(() {
      if (_tasbihs[_selectedIndex].count > 0) {
        _tasbihs[_selectedIndex].count--;
        HapticFeedback.lightImpact();
      }
    });
    _saveData();
  }

  void _reset() {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Reset Counter?',
        content: 'Reset ${_tasbihs[_selectedIndex].name} to 0?',
        icon: Icons.refresh,
        confirmText: 'Reset',
        onConfirm: () {
          setState(() => _tasbihs[_selectedIndex].count = 0);
          _saveData();
          Helpers.showSnackBar(context, 'Counter reset');
        },
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Completed!',
        content: '${_tasbihs[_selectedIndex].name} completed ✨',
        icon: Icons.celebration,
        confirmText: 'Continue',
        showCancel: false,
        onConfirm: () {},
      ),
    );
  }

  void _setTarget() {
    final controller = TextEditingController(
      text: _tasbihs[_selectedIndex].target.toString(),
    );
    showDialog(
      context: context,
      builder: (_) => InputDialog(
        title: 'Set Target',
        hint: 'Enter target count',
        controller: controller,
        onConfirm: () {
          final val = int.tryParse(controller.text);
          if (val != null && val > 0) {
            setState(() {
              _tasbihs[_selectedIndex].target = val;
              if (_tasbihs[_selectedIndex].count > val) {
                _tasbihs[_selectedIndex].count = val;
              }
            });
            _saveData();
          }
        },
      ),
    );
  }

  void _addCustomTasbih() {
    final nameCtrl = TextEditingController();
    final arabicCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder: (_) => MultiInputDialog(
        title: 'New Tasbih',
        controllers: [nameCtrl, arabicCtrl, targetCtrl],
        hints: const ['Name', 'Arabic Text', 'Target Count'],
        onConfirm: () {
          if (nameCtrl.text.isNotEmpty) {
            setState(() {
              _tasbihs.add(
                TasbihItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text,
                  arabic: arabicCtrl.text.isEmpty
                      ? nameCtrl.text
                      : arabicCtrl.text,
                  target: int.tryParse(targetCtrl.text) ?? 33,
                ),
              );
            });
            _saveData();
          }
        },
      ),
    );
  }

  void _deleteTasbih(int index) {
    if (_tasbihs[index].isDefault) return;
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Delete Tasbih?',
        content: 'Delete ${_tasbihs[index].name} permanently?',
        icon: Icons.delete_outline,
        confirmText: 'Delete',
        onConfirm: () {
          setState(() {
            _tasbihs.removeAt(index);
            if (_selectedIndex >= _tasbihs.length) {
              _selectedIndex = _tasbihs.length - 1;
            }
          });
          _saveData();
        },
      ),
    );
  }

  void _shareApp() async {
    await Share.share(
      'Check out Digital Tasbih app! Count your daily dhikr easily.\n\nDownload: https://play.google.com/store/apps/details?id=com.hafizapps.tasbeeh',
    );
  }

  void _rateApp() async {
    final url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.hafizapps.tasbeeh'
        : 'https://apps.apple.com/app/idYOUR_APP_ID';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Rate us on Play Store / App Store',
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _tasbihs.isNotEmpty ? _tasbihs[_selectedIndex] : null;

    return Scaffold(
      drawer: CustomDrawer(onShare: _shareApp, onRate: _rateApp),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Digital Tasbih',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _setTarget,
            tooltip: 'Set Target',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCustomTasbih,
            tooltip: 'Add Tasbih',
          ),
        ],
      ),
      body: _tasbihs.isEmpty ? _buildEmptyState() : _buildMainContent(current!),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/tasbih_icon.png',
            width: 80,
            height: 80,
            errorBuilder: (error, context, stackTrace) =>
                const Icon(Icons.touch_app, size: 50, color: Color(0xFF0083B0)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Tasbihs Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first tasbih',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addCustomTasbih,
            icon: const Icon(Icons.add),
            label: const Text('Add Tasbih'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0083B0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(TasbihItem current) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CounterCard(
          arabic: current.arabic,
          count: current.count,
          target: current.target,
          onTap: _increment,
          onDecrement: _decrement,
          onReset: _reset,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: const Color(0xFF00B4DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tasbih List',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4DB).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_tasbihs.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0083B0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: _tasbihs.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 8),
                    itemBuilder: (ctx, idx) => RepaintBoundary(
                      child: TasbihListItem(
                        item: _tasbihs[idx],
                        count: _tasbihs[idx].count,
                        isSelected: idx == _selectedIndex,
                        onTap: () => setState(() => _selectedIndex = idx),
                        onDelete: () => _deleteTasbih(idx),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
