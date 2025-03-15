import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class BoxText2Btn extends StatelessWidget {
    final String title;
    final VoidCallback func;
  const BoxText2Btn({super.key, required this.title, required this.func});

  @override
  Widget build(BuildContext context) {
      return Container( 
        width: 250,
        height: 150,
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
          elevation: 0, // Disable default shadow (we use BoxShadow instead)
        ),
        onPressed: func,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextFonts.buttonTitles2,
            ),
          ),
        ),
      ), );
}
}
