
import 'package:flutter/material.dart';

import '../constants/color.dart';

class MInkWell extends StatelessWidget {
  final Widget widget;
  final Color? hoverColor;
  final Color? focusColor;
  final VoidCallback? onTap;
  const MInkWell({
    super.key,
    required this.widget,
    this.hoverColor,
    this.onTap,
    required this.focusColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: hoverColor,
        focusColor: focusColor,
        onTap: onTap,
        child: widget);
  }
}

class MInKWellHover extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
//  final Function? hover;
  final Color? hoverColor;

  const MInKWellHover({
    super.key,
    required this.onTap,
    //   this.hover,
    this.hoverColor,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: hoverColor ?? secondary,
      child: child,
    );
  }
}
