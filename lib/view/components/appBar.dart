import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
    backgroundColor: Colours.text,
    title: Text("Mineral Flow", style: TextFonts.titlesAppBar,),
    leading: appBarLeft(),
    shape: const RoundedRectangleBorder(),
      
    );
  }
}


class appBarLeft extends StatelessWidget {
   appBarLeft({super.key});

  @override
  Widget build(BuildContext context) {
   final barWidth = MediaQuery.sizeOf(context).width * 0.4;   
    return Align(
    alignment: Alignment.topRight ,
      child: Container( 
          width: barWidth,
          height: 30,
          decoration: BoxDecoration( 
              color: Colours.bg2,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
          ),
        child: Center(
        child: Row( 
            children: [ 
                 Text("Registered Samples", style: TextFonts.normal,),
                 const SizedBox(width: 8,),
                 Text("Recently Saved", style: TextFonts.normal,),
                 const SizedBox(width: 8,),
                 Text("Last Catorgory Samples",style: TextFonts.normal,),
                 const SizedBox(width: 8,),
                 Container( 
                    width: 40,
                    decoration: BoxDecoration( 
                      border: Border.all( 
                        color: Colours.text,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center( 
                        child: Row(
                        mainAxisSize: MainAxisAlignment.spaceAround,
                        children: [
                        Text("Dean Nemaramba ", style: TextFonts.normal,),
                        Icon(Icons.person),
                        ],),
                    ),
                 )
            ],
        ),),
      ),
    );
  }
}
