import 'package:flutter/material.dart';
import 'package:mineralflow/models/batch_types_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/types_button.dart';
import 'package:mineralflow/view/pages/sample_description.dart';

class TypeDetails extends StatelessWidget {
  final BatchTypesModel batch;
 const TypeDetails({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    String option = "";
    void func(){
        print(option);
        Navigator.push(context, 
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
              child: Text("Select ${batch.batchName}", style: TextFonts.titles),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                SizedBox(
                  width: width * 0.6,
                  height: height * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          batch.batchOptions?.map((option) {

                            return Column(
                              children: [
                                TypesButton(text: option, func: func),
                              ],
                            );
                          }).toList() ??
                          [], // Handle null case safely
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                AddNewButton(title: "Add New ${batch.batchName}", func: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
