import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/box_text_button.dart';
import 'package:mineralflow/view/components/proceed_btn.dart';
import 'package:mineralflow/view/pages/batch_type.dart';
import 'package:mineralflow/view/pages/type_details.dart';

class PlantDetails extends StatefulWidget {
  PlantDetails({super.key});

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  List<bool> _selections = [false, false];
  TextEditingController location = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    void func() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  TypeDetails(batch: Data.batches[1],)),
      );
    }

    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text("Plant Details", style: TextFonts.titles),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                ToggleButtons(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Container(
                        width: 250,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _selections[0] ? Colours.border : Colours.bg2,
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
                          child: Text(
                            "CHPP",
                            style:
                                _selections[0]
                                    ? TextFonts.buttonTitles3White
                                    : TextFonts.buttonTitles,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Container(
                        width: 250,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _selections[1] ? Colours.border : Colours.bg2,
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
                          child: Text(
                            "CWP",
                            style:
                                _selections[1]
                                    ? TextFonts.buttonTitles3White
                                    : TextFonts.buttonTitles,
                          ),
                        ),
                      ),
                    ),
                  ],
                  isSelected: _selections,

                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selections.length; i++) {
                        _selections[i] = i == index;
                      }
                    });
                  },
                  selectedColor: Colors.transparent,
                  color: Colors.transparent,
                  fillColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  selectedBorderColor: Colors.transparent,
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: width * 0.3,
                  height: 100,
                  child: TextField(
                    controller: location,
                    style: TextStyle(
                      color: Colours.text,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // hintText: hint,
                      // hintStyle: TextStyle(
                      //   color: Colors.blue, //
                      // ),
                      labelText: "Location",
                      labelStyle: TextStyle(
                        color: Colours.text,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => location.clear(),
                        icon: Icon(Icons.clear),
                      ),
                    ),
                    maxLength: 24,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                    flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AddNewButton(title: "Add New Plant", func: () {}),
                          ProceedBtn(func: func),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
