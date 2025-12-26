import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final String title;
  final VoidCallback onPress;

  const RoundButton({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPress,
        child: Text(title),
      ),
    );
  }
}
