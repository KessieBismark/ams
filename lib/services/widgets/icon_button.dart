import 'package:flutter/material.dart';

class MIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  const MIconButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: icon);
  }
}
