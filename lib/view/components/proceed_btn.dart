import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';

class ProceedBtn extends StatelessWidget {
 final VoidCallback func;
  const ProceedBtn({super.key, required this.func});

  @override
  Widget build(BuildContext context) {
return SizedBox(
      width: 200, // Rectangular width
      height: 100, // Rectangular height
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.border, // Green background
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          padding: EdgeInsets.zero, // Remove default padding
          elevation: 0, // No shadow
          side: BorderSide.none, // Explicitly remove border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: const [
            Text(
              "Proceed",
              style: TextStyle(
                color: Colors.white, // White text for contrast
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8), // Space between text and arrow
            Icon(
              Icons.arrow_forward, // Next arrow
              color: Colors.white, // White arrow for contrast
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
