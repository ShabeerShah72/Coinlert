import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final double height;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.height = 74,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFF181A20),
        border: Border(top: BorderSide(color: Color(0xFF23242C))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navBarIcon(Icons.home, "Home", 0),
          _navBarIcon(Icons.search, "Explore", 1),
          _navBarIcon(Icons.add_alert, "Alert", 2),
          _navBarIcon(Icons.show_chart, "Market", 3),
          _navBarIcon(Icons.account_circle, "My account", 4),
        ],
      ),
    );
  }

  Widget _navBarIcon(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.blueAccent : Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blueAccent : Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}