import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class AddNewButton extends StatelessWidget {
  final String title;
   var func;
   AddNewButton({super.key, required this.title, required this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 130,
      decoration: BoxDecoration(
        color: Colours.btn,
        borderRadius: BorderRadius.all(Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.btn, // Background color
          foregroundColor:
              Colors.transparent, // Prevents ripple color interference
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // Match Container's radius
          ),
          elevation: 0, // Disable default shadow (using BoxShadow instead)
        ),
        onPressed: func, // Button action
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Image.asset("assets/images/new.png", height: 80, width: 80),
            Text(title, style: TextFonts.buttonText),
          ],
        ),
      ),
    );
  }
}
