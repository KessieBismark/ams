import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  final dynamic tag;
  final bool? trans;
  final Widget child;

  const HeroWidget({super.key,this.trans = true, required this.tag, required this.child});

  @override
  Widget build(BuildContext context) => Hero(
    transitionOnUserGestures: trans!,
    
        tag: tag,
        child: Material(type: MaterialType.transparency, child: child),
      );
}
