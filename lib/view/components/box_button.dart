import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class BoxButton extends StatelessWidget {
 final String image;
 final String caption;
 final VoidCallback func;
 BoxButton({super.key,  required this.image, required this.caption, required this.func});

  @override
  Widget build(BuildContext context) {
    return Container( 
        width: 250,
        height: 250,
        decoration: BoxDecoration( 
            color: Colours.bg2,
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
          backgroundColor: Colours.bg2, // Background color
          foregroundColor: Colors.transparent, // Prevents ripple color interference
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // Match Container's radius
          ),
          elevation: 0, // Disable default shadow (using BoxShadow instead)
        ),
        onPressed: func, // Button action
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            Image.asset(
              image,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            Text(
              caption,
              style: TextFonts.normal2,
            ),
          ],
        ),
      ),    );
  }
}
