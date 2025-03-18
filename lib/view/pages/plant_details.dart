import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/plant_details_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/pages/batch_type.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/special_smaple.dart';
import 'package:mineralflow/view/pages/type_details.dart';

class PlantDetails extends StatefulWidget {
  const PlantDetails({super.key});

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  final List<bool> _selections = [false, false];
  TextEditingController location = TextEditingController();
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Plant option not selected or Location not entered'),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).hideCurrentSnackBar(); // Dismiss the snackbar
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    void func() {
      String locationStr = location.text;
      var model = Data.getBatchByID();
      if (_selections[0] == false && _selections[1] == false ||
          locationStr.isEmpty) {
        showSnackBar(context);
      } else {
        if (model != null) {
          if (_selections[0]) {
            model.plant = PlantDetailsModel("CHPP", locationStr, null);
          } else {
            model.plant = PlantDetailsModel("CWP", locationStr, null);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      Data.selectedBatchType!.batchName == "Special Sample" ||
                              Data.getBatchByID()!.category!.categoryName ==
                                  "GEOLOGY SAMPLE"
                          ? SpecialSmaple()
                          : TypeDetails(batch: Data.selectedBatchType!),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage()),
          );
        }
      }
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

                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 180,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colours.btn,
                              borderRadius: BorderRadius.all(
                                Radius.circular(22),
                              ),
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
                                backgroundColor:
                                    Colours.btn, // Background color
                                foregroundColor:
                                    Colors
                                        .transparent, // Prevents ripple color interference
                                padding:
                                    EdgeInsets.zero, // Remove default padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    22,
                                  ), // Match Container's radius
                                ),
                                elevation:
                                    0, // Disable default shadow (using BoxShadow instead)
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BatchType(),
                                  ),
                                );
                              }, // Button action
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Text("Back", style: TextFonts.buttonText),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 200, // Rectangular width
                            height: 100, // Rectangular height
                            child: ElevatedButton(
                              onPressed: func,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colours.border, // Green background
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                padding:
                                    EdgeInsets.zero, // Remove default padding
                                elevation: 0, // No shadow
                                side:
                                    BorderSide.none, // Explicitly remove border
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center, // Center the content
                                children: const [
                                  Text(
                                    "Proceed",
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .white, // White text for contrast
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ), // Space between text and arrow
                                  Icon(
                                    Icons.arrow_forward, // Next arrow
                                    color:
                                        Colors
                                            .white, // White arrow for contrast
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [],
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
