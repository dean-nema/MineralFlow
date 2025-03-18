import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/models/sample_description_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/description_box.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/registered_sample.dart';

class SampleDescription extends StatefulWidget {
  SampleDescription({super.key});

  @override
  State<SampleDescription> createState() => _SampleDescriptionState();
}

class _SampleDescriptionState extends State<SampleDescription> {

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Please fill all fields before proceeding'),
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
  bool ready2Proceed = true;

    DescriptionBoxClass feedObj = DescriptionBoxClass(null, null);
    DescriptionBoxClass productObj = DescriptionBoxClass(null, null);
    DescriptionBoxClass discardObj = DescriptionBoxClass(null, null);
    DescriptionBoxClass middlingObj = DescriptionBoxClass(null, null);

    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("Sample Description", style: TextFonts.titles),
            ),
            Container(
              width: width,
              height: height * 0.74,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              DescriptionBox(
                                title: "Feed",
                                boxDetails: feedObj,
                              ),
                              DescriptionBox(
                                title: "Discard",
                                boxDetails: discardObj,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              DescriptionBox(
                                title: "Product",
                                boxDetails: productObj,
                              ),
                              DescriptionBox(
                                title: "Middling",
                                boxDetails: middlingObj,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 200, // Rectangular width
                        height: 100, // Rectangular height
                        child: ElevatedButton(
                          onPressed: () {
                            if (feedObj.mass == null ||
                                middlingObj.mass == null ||
                                discardObj.mass == null ||
                                productObj.mass == null) {
                              ready2Proceed = false;
                              showSnackBar(context);
                            }
                            if (ready2Proceed) {
                              BatchSamplesModel? model = Data.getBatchByID();
                              if (model != null) {
                                for (var i = 0; i < 4; i++) {
                                  switch (i) {
                                    case 0:
                                      SampleDescriptionModel feedSample =
                                          SampleDescriptionModel(
                                            "Feed",
                                            feedObj.description!,
                                            feedObj.mass!,
                                            null,
                                          );
                                      model.addSample(feedSample);
                                      break;
                                    case 1:
                                      SampleDescriptionModel productSample =
                                          SampleDescriptionModel(
                                            "Product",
                                            productObj.description!,
                                            productObj.mass!,
                                            null,
                                          );
                                      model.addSample(productSample);

                                      break;
                                    case 2:
                                      SampleDescriptionModel discardSample =
                                          SampleDescriptionModel(
                                            "Discard",
                                            discardObj.description!,
                                            discardObj.mass!,
                                            null,
                                          );
                                      model.addSample(discardSample);

                                      break;
                                    case 3:
                                      SampleDescriptionModel middlingSample =
                                          SampleDescriptionModel(
                                            "Middling",
                                            middlingObj.description!,
                                            middlingObj.mass!,
                                            null,
                                          );
                                      model.addSample(middlingSample);

                                      break;
                                    default:
                                  } 
                                }
                                model.isComplete = true;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisteredSample(),
                                  ),
                                  (Route<dynamic> route) =>
                                      false, // This removes all previous routes
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryPage(),
                                  ),
                                );
                              }
                            }else{
                                setState(() {
                                                                  
                                                                });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colours.border, // Green background
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
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
                                  color:
                                      Colors.white, // White text for contrast
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ), // Space between text and arrow
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
          ],
        ),
      ),
    );
  }
}

class DescriptionBoxClass {
  String? description;
  double? mass;
  DescriptionBoxClass(this.mass, this.description);
}
