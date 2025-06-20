import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_types_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/types_button.dart';
import 'package:mineralflow/view/pages/sample_description.dart';

class TypeDetails extends StatefulWidget {
  final BatchTypesModel batch;
  const TypeDetails({super.key, required this.batch});

  @override
  State<TypeDetails> createState() => _TypeDetailsState();
}

class _TypeDetailsState extends State<TypeDetails> {
  TextEditingController controller = TextEditingController();

  bool smallScreen = false;
  @override
  Widget build(BuildContext context) {
    //variables
    String option = "";

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    smallScreen = height < 940 ? true : false;

    //functions

    Future openPopUp() => showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add New ${widget.batch.batchName}"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter Name.."),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        String textStr = controller.text;
                        controller.clear();
                        for (var element in Data.batcheTypes) {
                          if (element.batchName == widget.batch.batchName) {
                            element.batchOptions!.add(textStr);
                          }
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
    );
    void func() {
      print(option);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SampleDescription()),
      );
    }

    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: smallScreen ? 20 : 80.0),
              child: Text(
                "Select ${widget.batch.batchName}",
                style: TextFonts.titles,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: smallScreen ? 10 : 70),
                        SizedBox(
                          width: width * 0.8,
                          height: smallScreen ? height * 0.38 : height * 0.5,
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap:
                                  true, // Ensures it takes only needed space inside SingleChildScrollView
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevents GridView from scrolling separately
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // Adjust for your layout needs
                                    crossAxisSpacing:
                                        10, // Space between columns
                                    mainAxisSpacing: 10, // Space between rows
                                    childAspectRatio:
                                        3, // Adjust aspect ratio as needed
                                  ),
                              itemCount: widget.batch.batchOptions?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      smallScreen
                                          ? EdgeInsets.only(left: 10, right: 10)
                                          : EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                  child: TypesButton(
                                    text: widget.batch.batchOptions![index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: smallScreen ? 250 : 300,
                child: AddNewButton(
                  title: "New ${widget.batch.batchName}",
                  func: openPopUp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
