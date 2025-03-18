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

  @override
  Widget build(BuildContext context) {
    String option = "";
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

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
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
                        const SizedBox(height: 70),
                        SizedBox(
                          width: width * 0.6,
                          height: height * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  widget.batch.batchOptions?.map((option) {
                                    return Column(
                                      children: [TypesButton(text: option)],
                                    );
                                  }).toList() ??
                                  [], // Handle null case safely
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: AddNewButton(
                        title: "Add New ${widget.batch.batchName}",
                        func: openPopUp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
