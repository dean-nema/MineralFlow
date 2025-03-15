import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class TypesButton extends StatelessWidget {
    final String text;
    final VoidCallback func;
  const TypesButton({super.key, required this.text, required this.func});

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container( 
          width: 340,
          height: 90,
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
            foregroundColor: Colors.transparent, 
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22), 
            ),
            elevation: 0,
          ),
          onPressed: func,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextFonts.buttonTitles2,
              ),
            ),
          ),
        ), ),
      );
  }
}
