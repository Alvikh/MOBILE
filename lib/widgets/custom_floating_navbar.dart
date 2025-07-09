import 'package:flutter/material.dart';

class CustomFloatingNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomFloatingNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 10,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.monitor_heart, 0),
            _buildNavItem(Icons.tune, 1),
            _buildNavItem(Icons.person, 2),
            _buildNavItem(Icons.menu_book, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        onItemSelected(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedIndex == index 
              ? Colors.white.withOpacity(0.2) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                icon,
                key: ValueKey<int>(selectedIndex == index ? 1 : 0),
                color: selectedIndex == index 
                    ? const Color(0xFF085085) 
                    : Colors.white.withOpacity(0.9),
                size: selectedIndex == index ? 28 : 26,
              ),
            ),
            const SizedBox(height: 2),
            if (selectedIndex == index)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 5,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF085085),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}