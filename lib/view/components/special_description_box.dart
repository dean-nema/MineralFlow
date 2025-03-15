import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class SpecialDescriptionBox extends StatelessWidget {
  final String title;
   SpecialDescriptionBox({super.key, required this.title});



   TextEditingController descriptionController = TextEditingController();
   TextEditingController massController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 730,
      height: 415,
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
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center, // Centers everything
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(title, style: TextFonts.buttonTitles),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns children properly
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description", style: TextFonts.buttonTitles4),
                      SizedBox(
                        width: 292,
                        height: 66,
                        child: TextField(
                        controller: descriptionController,
                          style: TextStyle(
                            color: Colours.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),

                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          maxLength: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Mass (g)", style: TextFonts.buttonTitles4),
                      SizedBox(
                        width: 292,
                        height: 66,
                        child: TextField(
                          controller: massController,
                          style: TextStyle(
                            color: Colours.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),

                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          maxLength: 30,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Sample Details", style: TextFonts.buttonTitles4),
                      SizedBox(
                        width: 292, // Ensure consistent width
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Sample Description...",
                                hintStyle: TextStyle(color: Colours.text),
                              ),
                              expands: true,
                              maxLines: null,
                              minLines: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
