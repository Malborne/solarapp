import 'package:flutter/material.dart';
class TappedContainer extends StatefulWidget {
  final Widget? child;
  final double? width;
  final void Function(TapDownDetails)? onTapDown;

  const TappedContainer({super.key, this.child, this.width,required this.onTapDown});

  @override
  State<TappedContainer> createState() => _TappedContainerState();
}

class _TappedContainerState extends State<TappedContainer> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTapDown: widget.onTapDown,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              // side: const BorderSide(color: Colors.red),
            ),
            constraints:  BoxConstraints.tightFor(
              width: widget.width,
              height: 40,
            ),
            child:  Center(child: widget.child,)),
          )
      );

  }
}
