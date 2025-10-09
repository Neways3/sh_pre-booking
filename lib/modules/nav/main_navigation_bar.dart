// import 'package:flutter/material.dart';
// import 'package:neways_face_attendance_pro/features/attendance_report/screens/attendance_calendar_view.dart';
// import 'package:neways_face_attendance_pro/features/homepage/presentation/ui/face_auth_screen.dart';
// import 'package:neways_face_attendance_pro/features/profile/presentation/ui/profile_page.dart';

// class MainNavigationBar extends StatefulWidget {
//   const MainNavigationBar({super.key});

//   @override
//   State<MainNavigationBar> createState() => _MainNavigationPageState();
// }

// class _MainNavigationPageState extends State<MainNavigationBar>
//     with TickerProviderStateMixin {
//   int _currentIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   final List<Widget> _screens = [
//     FaceAuthScreen(),
//     AttendanceCalendarView(),
//     ProfilePageScreen()
//   ];

//   final List<NavItem> _navItems = const [
//     NavItem(
//       icon: Icons.task_alt_outlined,
//       activeIcon: Icons.task_alt,
//       label: 'Attendance',
//       color: Color(0xFF6C5CE7),
//     ),
//     NavItem(
//       icon: Icons.calendar_month_outlined,
//       activeIcon: Icons.calendar_month,
//       label: 'Calendar',
//       color: Color(0xFF00B894),
//     ),
//     NavItem(
//       icon: Icons.person_outline,
//       activeIcon: Icons.person,
//       label: 'Profile',
//       color: Color(0xFF0984E3),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onTabTapped(int index) {
//     if (index != _currentIndex) {
//       _animationController.forward().then((_) {
//         _animationController.reverse();
//       });
//     }
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _screens[_currentIndex],
//       // extendBody: true,
//       bottomNavigationBar: SafeArea(
//         // minimum: const EdgeInsets.all(16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24),
//           child: Container(
//             height: 70,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(_navItems.length, (index) {
//                 final item = _navItems[index];
//                 final isSelected = index == _currentIndex;

//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () => _onTabTapped(index),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 8,
//                       ),
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? item.color.withOpacity(0.1)
//                             : Colors.transparent,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           AnimatedBuilder(
//                             animation: _scaleAnimation,
//                             builder: (context, child) {
//                               return Transform.scale(
//                                 scale: isSelected &&
//                                         _animationController.isAnimating
//                                     ? _scaleAnimation.value
//                                     : 1.0,
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 300),
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? item.color
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: isSelected
//                                         ? [
//                                             BoxShadow(
//                                               color: item.color.withOpacity(
//                                                 0.3,
//                                               ),
//                                               blurRadius: 8,
//                                               offset: const Offset(0, 4),
//                                             ),
//                                           ]
//                                         : null,
//                                   ),
//                                   child: Icon(
//                                     isSelected ? item.activeIcon : item.icon,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.grey[600],
//                                     size: 20,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           // const SizedBox(height: 4),
//                           // AnimatedDefaultTextStyle(
//                           //   duration: const Duration(milliseconds: 300),
//                           //   style: TextStyle(
//                           //     fontSize: 11,
//                           //     fontWeight:
//                           //         isSelected
//                           //             ? FontWeight.w600
//                           //             : FontWeight.w500,
//                           //     color: isSelected ? item.color : Colors.grey[600],
//                           //   ),
//                           //   child: Text(item.label),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NavItem {
//   final IconData icon;
//   final IconData activeIcon;
//   final String label;
//   final Color color;

//   const NavItem({
//     required this.icon,
//     required this.activeIcon,
//     required this.label,
//     required this.color,
//   });
// }
