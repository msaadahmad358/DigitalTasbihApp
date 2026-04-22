// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:device_preview/device_preview.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';

// void main() =>
//     runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Digital Tasbih',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: const Color(0xFF00B4DB),
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'SF Pro Display',
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Color(0xFF0083B0),
//           elevation: 0,
//           centerTitle: true,
//           titleTextStyle: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF0083B0),
//           ),
//         ),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//       debugShowCheckedModeBanner: false,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
//     _controller.forward();
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         // Add this check
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const TasbihScreen()),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//           ),
//         ),
//         child: Center(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/tasbih_icon.png',
//                     width: 80,
//                     height: 80,
//                     errorBuilder: (error, context, stackTrace) => const Icon(
//                       Icons.touch_app,
//                       size: 50,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Digital Tasbih',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TasbihItem {
//   final String id;
//   final String name;
//   final String arabic;
//   int count;
//   int target;
//   final bool isDefault;

//   TasbihItem({
//     required this.id,
//     required this.name,
//     required this.arabic,
//     this.count = 0,
//     this.target = 33,
//     this.isDefault = false,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'arabic': arabic,
//     'count': count,
//     'target': target,
//     'isDefault': isDefault,
//   };

//   factory TasbihItem.fromJson(Map<String, dynamic> json) => TasbihItem(
//     id: json['id'],
//     name: json['name'],
//     arabic: json['arabic'],
//     count: json['count'] ?? 0,
//     target: json['target'] ?? 33,
//     isDefault: json['isDefault'] ?? false,
//   );
// }

// class TasbihScreen extends StatefulWidget {
//   const TasbihScreen({super.key});

//   @override
//   State<TasbihScreen> createState() => _TasbihScreenState();
// }

// class _TasbihScreenState extends State<TasbihScreen> {
//   List<TasbihItem> _tasbihs = [];
//   int _selectedIndex = 0;
//   Timer? _saveDebounce;

//   // Add this method inside _TasbihScreenState class

//   Widget _buildDrawer() {
//     return Drawer(
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     // Header
//                     Container(
//                       padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
//                       child: Column(
//                         children: [
//                           Image.asset(
//                             'assets/images/tasbih_icon.png',
//                             width: 80,
//                             height: 80,
//                             errorBuilder: (error, context, stackTrace) =>
//                                 const Icon(
//                                   Icons.touch_app,
//                                   size: 50,
//                                   color: Color(0xFF0083B0),
//                                 ),
//                           ),
//                           const SizedBox(height: 20),
//                           const Text(
//                             'Digital Tasbih',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const Divider(
//                       color: Colors.white24,
//                       thickness: 1,
//                       indent: 24,
//                       endIndent: 24,
//                       height: 8,
//                     ),

//                     // Menu Items
//                     const Padding(
//                       padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
//                       child: Text(
//                         'MENU',
//                         style: TextStyle(
//                           color: Colors.white54,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),

//                     ListTile(
//                       leading: const Icon(
//                         Icons.home,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                       title: const Text(
//                         'Home',
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       ),
//                       trailing: const Icon(
//                         Icons.chevron_right,
//                         color: Colors.white38,
//                         size: 20,
//                       ),
//                       onTap: () => Navigator.pop(context),
//                     ),

//                     // About
//                     ExpansionTile(
//                       leading: const Icon(
//                         Icons.info_outline,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                       title: const Text(
//                         'About Us',
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       ),
//                       iconColor: Colors.white,
//                       collapsedIconColor: Colors.white,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha: 0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             children: [
//                               const Text(
//                                 'Digital Tasbih helps you keep track of your daily dhikr with ease. Simple, fast, and beautiful.',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 13,
//                                   height: 1.5,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 24),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   _buildContactIcon(
//                                     Icons.email_outlined,
//                                     Colors.white70,
//                                     'hafizapps@gmail.com',
//                                   ),
//                                   const SizedBox(width: 32),
//                                   _buildContactIcon(
//                                     Icons.language,
//                                     Colors.white70,
//                                     'hafizapps.com',
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 'hafizapps@gmail.com',
//                                 style: TextStyle(
//                                   color: Colors.white.withValues(alpha: 0.5),
//                                   fontSize: 11,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     ListTile(
//                       leading: const Icon(
//                         Icons.share_outlined,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                       title: const Text(
//                         'Share App',
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       ),
//                       trailing: const Icon(
//                         Icons.chevron_right,
//                         color: Colors.white38,
//                         size: 20,
//                       ),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _shareApp();
//                       },
//                     ),

//                     ListTile(
//                       leading: const Icon(
//                         Icons.star_outline,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                       title: const Text(
//                         'Rate Us',
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       ),
//                       trailing: const Icon(
//                         Icons.chevron_right,
//                         color: Colors.white38,
//                         size: 20,
//                       ),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _rateApp();
//                       },
//                     ),

//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),

//               // Version at bottom
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 20,
//                   horizontal: 24,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     top: BorderSide(
//                       color: Colors.white.withValues(alpha: 0.1),
//                       width: 0.5,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '© 2026 Hafiz Apps',
//                       style: TextStyle(
//                         color: Colors.white.withValues(alpha: 0.4),
//                         fontSize: 11,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         'v1.0',
//                         style: TextStyle(
//                           color: Colors.white.withValues(alpha: 0.5),
//                           fontSize: 10,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContactIcon(IconData icon, Color color, String text) {
//     return InkWell(
//       onTap: () {
//         debugPrint('Contact: $text');
//       },
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha: 0.15),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: color, size: 22),
//       ),
//     );
//   }

//   void _shareApp() async {
//     await Share.share(
//       'Check out Digital Tasbih app! Count your daily dhikr easily.\n\nDownload: https://play.google.com/store/apps/details?id=com.hafizapps.tasbeeh',
//     );
//   }

//   void _rateApp() async {
//     final url = Platform.isAndroid
//         ? 'https://play.google.com/store/apps/details?id=com.hafizapps.tasbeeh'
//         : 'https://apps.apple.com/app/idYOUR_APP_ID';

//     try {
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       } else {
//         throw 'Could not launch $url';
//       }
//     } catch (e) {
//       if (mounted) {
//         // Add this check
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Rate us on Play Store / App Store'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   final List<TasbihItem> _defaultTasbihs = [
//     TasbihItem(
//       id: '1',
//       name: 'Subhan Allah',
//       arabic: 'سُبْحَانَ اللَّه',
//       isDefault: true,
//       target: 33,
//     ),
//     TasbihItem(
//       id: '2',
//       name: 'Alhamdulillah',
//       arabic: 'الْحَمْدُ لِلَّه',
//       isDefault: true,
//       target: 33,
//     ),
//     TasbihItem(
//       id: '3',
//       name: 'Allahu Akbar',
//       arabic: 'اللَّهُ أَكْبَر',
//       isDefault: true,
//       target: 34,
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   @override
//   void dispose() {
//     _saveDebounce?.cancel();
//     super.dispose();
//   }

//   void _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString('tasbihs');
//     if (saved != null) {
//       List<dynamic> decoded = jsonDecode(saved);
//       setState(() {
//         _tasbihs = decoded.map((e) => TasbihItem.fromJson(e)).toList();
//       });
//     } else {
//       setState(() {
//         _tasbihs = List.from(_defaultTasbihs);
//       });
//     }
//   }

//   void _saveData() {
//     _saveDebounce?.cancel();
//     _saveDebounce = Timer(const Duration(milliseconds: 500), () async {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(
//         'tasbihs',
//         jsonEncode(_tasbihs.map((e) => e.toJson()).toList()),
//       );
//     });
//   }

//   void _increment() {
//     setState(() {
//       if (_tasbihs[_selectedIndex].count < _tasbihs[_selectedIndex].target) {
//         _tasbihs[_selectedIndex].count++;
//         HapticFeedback.lightImpact();
//       }
//       if (_tasbihs[_selectedIndex].count == _tasbihs[_selectedIndex].target) {
//         _showCompletionDialog();
//       }
//     });
//     _saveData();
//   }

//   void _decrement() {
//     setState(() {
//       if (_tasbihs[_selectedIndex].count > 0) {
//         _tasbihs[_selectedIndex].count--;
//         HapticFeedback.lightImpact();
//       }
//     });
//     _saveData();
//   }

//   void _reset() {
//     showDialog(
//       context: context,
//       builder: (_) => _CustomDialog(
//         title: 'Reset Counter?',
//         content: 'Reset ${_tasbihs[_selectedIndex].name} to 0?',
//         icon: Icons.refresh,
//         confirmText: 'Reset',
//         onConfirm: () {
//           setState(() => _tasbihs[_selectedIndex].count = 0);
//           _saveData();
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Counter reset'),
//               duration: Duration(milliseconds: 800),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showCompletionDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => _CustomDialog(
//         title: 'Completed!',
//         content: '${_tasbihs[_selectedIndex].name} completed ✨',
//         icon: Icons.celebration,
//         confirmText: 'Continue',
//         showCancel: false,
//         onConfirm: () {},
//       ),
//     );
//   }

//   void _setTarget() {
//     final controller = TextEditingController(
//       text: _tasbihs[_selectedIndex].target.toString(),
//     );
//     showDialog(
//       context: context,
//       builder: (_) => _InputDialog(
//         title: 'Set Target',
//         hint: 'Enter target count',
//         controller: controller,
//         onConfirm: () {
//           final val = int.tryParse(controller.text);
//           if (val != null && val > 0) {
//             setState(() {
//               _tasbihs[_selectedIndex].target = val;
//               if (_tasbihs[_selectedIndex].count > val) {
//                 _tasbihs[_selectedIndex].count = val;
//               }
//             });
//             _saveData();
//           }
//         },
//       ),
//     );
//   }

//   void _addCustomTasbih() {
//     final nameCtrl = TextEditingController();
//     final arabicCtrl = TextEditingController();
//     final targetCtrl = TextEditingController(text: '33');

//     showDialog(
//       context: context,
//       builder: (_) => _MultiInputDialog(
//         title: 'New Tasbih',
//         controllers: [nameCtrl, arabicCtrl, targetCtrl],
//         hints: const ['Name', 'Arabic Text', 'Target Count'],
//         onConfirm: () {
//           if (nameCtrl.text.isNotEmpty) {
//             setState(() {
//               _tasbihs.add(
//                 TasbihItem(
//                   id: DateTime.now().millisecondsSinceEpoch.toString(),
//                   name: nameCtrl.text,
//                   arabic: arabicCtrl.text.isEmpty
//                       ? nameCtrl.text
//                       : arabicCtrl.text,
//                   target: int.tryParse(targetCtrl.text) ?? 33,
//                 ),
//               );
//             });
//             _saveData();
//           }
//         },
//       ),
//     );
//   }

//   void _deleteTasbih(int index) {
//     if (_tasbihs[index].isDefault) return;
//     showDialog(
//       context: context,
//       builder: (_) => _CustomDialog(
//         title: 'Delete Tasbih?',
//         content: 'Delete ${_tasbihs[index].name} permanently?',
//         icon: Icons.delete_outline,
//         confirmText: 'Delete',
//         onConfirm: () {
//           setState(() {
//             _tasbihs.removeAt(index);
//             if (_selectedIndex >= _tasbihs.length) {
//               _selectedIndex = _tasbihs.length - 1;
//             }
//           });
//           _saveData();
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final current = _tasbihs.isNotEmpty ? _tasbihs[_selectedIndex] : null;

//     return Scaffold(
//       drawer: _buildDrawer(),
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: const Text(
//           'Digital Tasbih',
//           style: TextStyle(color: Colors.white),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//             ),
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: _setTarget,
//             tooltip: 'Set Target',
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _addCustomTasbih,
//             tooltip: 'Add Tasbih',
//           ),
//         ],
//       ),
//       body: _tasbihs.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           'assets/images/tasbih_icon.png',
//                           width: 80,
//                           height: 80,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(
//                                 Icons.touch_app,
//                                 size: 50,
//                                 color: Color(0xFF0083B0),
//                               ),
//                         ),
//                         const SizedBox(height: 20),
//                         const Text(
//                           'Digital Tasbih',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'No Tasbihs Yet',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Tap + to add your first tasbih',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _addCustomTasbih,
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add Tasbih'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0083B0),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // Counter Card
//                 GestureDetector(
//                   onTap: _increment,
//                   onLongPress: _reset,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 20),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 32,
//                       horizontal: 20,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//                       ),
//                       borderRadius: BorderRadius.circular(28),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF0083B0).withValues(alpha: 0.3),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           current!.arabic,
//                           style: const TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           '${current.count}',
//                           style: const TextStyle(
//                             fontSize: 80,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             height: 1,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '/ ${current.target}',
//                           style: const TextStyle(
//                             fontSize: 20,
//                             color: Colors.white70,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         SizedBox(
//                           width: 200,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: LinearProgressIndicator(
//                               value: current.count / current.target,
//                               backgroundColor: Colors.white.withValues(
//                                 alpha: 0.25,
//                               ),
//                               color: Colors.white,
//                               minHeight: 6,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 onPressed: _decrement,
//                                 icon: const Icon(
//                                   Icons.remove,
//                                   color: Colors.white,
//                                 ),
//                                 iconSize: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 40),
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 onPressed: _reset,
//                                 icon: const Icon(
//                                   Icons.refresh,
//                                   color: Colors.white,
//                                 ),
//                                 iconSize: 28,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Tap card • Long press to reset',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.white.withValues(alpha: 0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Tasbih List Section
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(24),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: 3,
//                                     height: 18,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(2),
//                                       color: const Color(0xFF00B4DB),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     'Tasbih List',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFF00B4DB,
//                                   ).withValues(alpha: 0.1),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   '${_tasbihs.length}',
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF0083B0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.separated(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 4,
//                             ),
//                             itemCount: _tasbihs.length,
//                             separatorBuilder: (ctx, idx) =>
//                                 const SizedBox(height: 8),
//                             itemBuilder: (ctx, idx) =>
//                                 RepaintBoundary(child: _buildListItem(idx)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildListItem(int idx) {
//     final t = _tasbihs[idx];
//     final isSelected = idx == _selectedIndex;
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         gradient: isSelected
//             ? const LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//               )
//             : null,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: isSelected
//             ? [
//                 BoxShadow(
//                   color: const Color(0xFF0083B0).withValues(alpha: 0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ]
//             : null,
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: ListTile(
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 4,
//           ),
//           leading: CircleAvatar(
//             radius: 18,
//             backgroundColor: isSelected ? Colors.white : Colors.grey[300],
//             child: Text(
//               '${t.count}',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? const Color(0xFF0083B0) : Colors.grey[700],
//               ),
//             ),
//           ),
//           title: Text(
//             t.name,
//             style: TextStyle(
//               fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//               color: isSelected ? Colors.white : Colors.grey[800],
//               fontSize: 15,
//             ),
//           ),
//           subtitle: Text(
//             t.arabic,
//             style: TextStyle(
//               fontSize: 12,
//               color: isSelected ? Colors.white70 : Colors.grey[500],
//             ),
//           ),
//           trailing: t.isDefault
//               ? Icon(
//                   Icons.lock_outline,
//                   size: 18,
//                   color: isSelected ? Colors.white70 : Colors.grey[400],
//                 )
//               : IconButton(
//                   icon: Icon(
//                     Icons.delete_outline,
//                     size: 20,
//                     color: isSelected ? Colors.white70 : Colors.redAccent,
//                   ),
//                   onPressed: () => _deleteTasbih(idx),
//                 ),
//           onTap: () => setState(() => _selectedIndex = idx),
//         ),
//       ),
//     );
//   }
// }

// // ==================== CUSTOM DIALOGS WITH APP GRADIENT ====================

// class _CustomDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final IconData icon;
//   final String confirmText;
//   final VoidCallback onConfirm;
//   final bool showCancel;

//   const _CustomDialog({
//     required this.title,
//     required this.content,
//     required this.icon,
//     required this.confirmText,
//     required this.onConfirm,
//     this.showCancel = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//           ),
//           borderRadius: BorderRadius.circular(28),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(icon, size: 48, color: Colors.white),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     content,
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white.withValues(alpha: 0.9),
//                       height: 1.4,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
//               child: Row(
//                 children: [
//                   if (showCancel)
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           side: const BorderSide(
//                             color: Colors.white,
//                             width: 1.5,
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   if (showCancel) const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         onConfirm();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: const Color(0xFF0083B0),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         confirmText,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _InputDialog extends StatelessWidget {
//   final String title;
//   final String hint;
//   final TextEditingController controller;
//   final VoidCallback onConfirm;

//   const _InputDialog({
//     required this.title,
//     required this.hint,
//     required this.controller,
//     required this.onConfirm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//           ),
//           borderRadius: BorderRadius.circular(28),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
//               child: Column(
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: controller,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                     decoration: InputDecoration(
//                       hintText: hint,
//                       hintStyle: TextStyle(
//                         color: Colors.white.withValues(alpha: 0.6),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withValues(alpha: 0.15),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide.none,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: const BorderSide(
//                           color: Colors.white,
//                           width: 1.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.white, width: 1.5),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         onConfirm();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: const Color(0xFF0083B0),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         'Save',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MultiInputDialog extends StatelessWidget {
//   final String title;
//   final List<TextEditingController> controllers;
//   final List<String> hints;
//   final VoidCallback onConfirm;

//   const _MultiInputDialog({
//     required this.title,
//     required this.controllers,
//     required this.hints,
//     required this.onConfirm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
//           ),
//           borderRadius: BorderRadius.circular(28),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
//               child: Column(
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ...List.generate(
//                     controllers.length,
//                     (i) => Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: TextField(
//                         controller: controllers[i],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                         ),
//                         keyboardType: i == 2
//                             ? TextInputType.number
//                             : TextInputType.text,
//                         decoration: InputDecoration(
//                           hintText: hints[i],
//                           hintStyle: TextStyle(
//                             color: Colors.white.withValues(alpha: 0.6),
//                           ),
//                           filled: true,
//                           fillColor: Colors.white.withValues(alpha: 0.15),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: const BorderSide(
//                               color: Colors.white,
//                               width: 1.5,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.white, width: 1.5),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         onConfirm();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: const Color(0xFF0083B0),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         'Add',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

void main() =>
    runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Tasbih',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppConstants.secondaryColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppConstants.secondaryColor,
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
