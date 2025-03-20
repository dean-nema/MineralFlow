import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/models/batch_selected_type_model.dart';
import 'package:mineralflow/models/sample_description_model.dart';
import 'package:mineralflow/strings/strings.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/special_description_box.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/registered_sample.dart';

class SpecialSmaple extends StatefulWidget {
  SpecialSmaple({super.key});

  @override
  State<SpecialSmaple> createState() => _SpecialSmapleState();
}

class _SpecialSmapleState extends State<SpecialSmaple> {
  //variables
  SpecialDescriptionClass sample1 = SpecialDescriptionClass();

  bool smallScreen = false;
  bool isGeo = Data.getBatchByID()!.category!.categoryName == Strings.geologySample;

  //functions
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Please fill Mass and Description fields before proceeding'),
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
    final height = MediaQuery.sizeOf(context).height;
    smallScreen = height < 900 ? true : false;
    bool ready2Proceed = true;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all( smallScreen? 8: 18.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isGeo
                      ? "Geology Sample Description"
                      : "Special Sample Description",
                  style: smallScreen? TextFonts.titles2: TextFonts.titles,
                ),
              ),
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: width,
                  height: height * 0.4,
                  child: Center(
                    child: SpecialDescriptionBox(
                      title: "Sample  Description",
                      specialObj: sample1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200, // Rectangular width
                    height: 100, // Rectangular height
                    child: ElevatedButton(
                      onPressed: () {
                        if (sample1.mass == null || sample1.description == null) {
                          setState(() {
                            showSnackBar(context);
                          });
                        } else {
                          BatchSamplesModel? model = Data.getBatchByID();
                          if (model != null) {
                            if (isGeo) {
                              model.type = BatchSelectedTypeModel(
                                Strings.geologySample,
                                Strings.geologySample,
                              );
                            }
                            SampleDescriptionModel specialSample =
                                isGeo
                                    ? SampleDescriptionModel(
                                      Strings.geologySample,
                                      sample1.description!,
                                      sample1.mass!,
                                      sample1.details,
                                    )
                                    : SampleDescriptionModel(
                                      "Special Sample",
                                      sample1.description!,
                                      sample1.mass!,
                                      sample1.details,
                                    );
                  
                            model.addSample(specialSample);
                            model.isComplete = true;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisteredSample(),
                              ),
                              (Route<dynamic> route) =>
                                  false, // This removes all previous routes
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(),
                              ),
                              (Route<dynamic> route) =>
                                  false, // This removes all previous routes
                            );
                          }
                        }
                      },
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
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center the content
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialDescriptionClass {
  String? description;
  double? mass;
  String? details;
}
