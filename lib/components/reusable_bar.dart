import 'package:flutter/material.dart';

class ReusableBar extends StatelessWidget {
  final Color color;
  final Widget child;
  const ReusableBar({super.key, required this.color, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
