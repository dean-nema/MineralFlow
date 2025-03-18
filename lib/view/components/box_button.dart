import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/registered_sample.dart';

class BoxButton extends StatelessWidget {
  final String image;
  final String caption;
  BoxButton({
    super.key,
    required this.image,
    required this.caption,
  });

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
          foregroundColor:
              Colors.transparent, // Prevents ripple color interference
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // Match Container's radius
          ),
          elevation: 0, // Disable default shadow (using BoxShadow instead)
        ),
        onPressed: () {
          if (caption == "Add Batch Samples") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CategoryPage()),
            );
          }else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisteredSample()),
            );

          }
        }, // Button action
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Image.asset(image, height: 150, width: 150),
            const SizedBox(height: 20),
            Text(caption, style: TextFonts.normal2),
          ],
        ),
      ),
    );
  }
}
