import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';


class TextFonts {
  static TextStyle logoName = GoogleFonts.bellefair(
  color: Colors.black,
  fontSize: 80,
  );

  static TextStyle logoCaption = GoogleFonts.caveat(
  color: Colours.text,
  fontSize: 40,
  );
  
  static TextStyle titles = GoogleFonts.poppins( 
   color: Colours.text,
   fontSize:  40,
   fontWeight: FontWeight.bold,
  );
   static TextStyle titlesAppBar = GoogleFonts.poppins( 
   color: Colors.white,
   fontSize:  30,
   fontWeight: FontWeight.bold,
  );
    
   static TextStyle normal = GoogleFonts.poppins( 
   color: Colours.text,
   fontSize:  17,
  );


}
