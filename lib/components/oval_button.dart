import 'package:flutter/material.dart';
class OvalButton extends StatefulWidget {
  final String text;
   final void Function()? onPressed;
   const OvalButton({super.key,
    required this.text,
    required this.onPressed,

  });
  @override
  State<OvalButton> createState() => _OvalButtonState();
}

class _OvalButtonState extends State<OvalButton> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: widget.onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        // side: const BorderSide(color: Colors.red),
      ),
      // elevation: 6,
      fillColor: Colors.white12,
      focusColor: Colors.black,
      constraints: const BoxConstraints.tightFor(
        width: 70,
        height: 40,
      ),
      child: Text(widget.text),
    );
  }
}