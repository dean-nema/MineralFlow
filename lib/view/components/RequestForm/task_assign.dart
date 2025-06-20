import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';

class TaskAssign extends StatelessWidget {
  TaskAssign({super.key});
  final List<String> samplePrepOptions = ['Crushing', 'Pulverization'];

  final List<String> analyticalSectionOptions = Data.analyticalSectionOptions;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width * 0.7,
      height: 300,
      // The fixed height was removed to allow the card to size itself based on its content.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Text(
                  // 2. "Sample Information" text is bold
                  "Task Assignment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sample Prep Department',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...samplePrepOptions.map(
                          (option) => CheckboxListTile(
                            title: Text(option),
                            value: true,
                            onChanged: null, // disables the checkbox
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _AnalyticalCheckboxList(
                      options: analyticalSectionOptions,
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

class _AnalyticalCheckboxList extends StatefulWidget {
  final List<String> options;

  const _AnalyticalCheckboxList({required this.options});

  @override
  State<_AnalyticalCheckboxList> createState() =>
      _AnalyticalCheckboxListState();
}

class _AnalyticalCheckboxListState extends State<_AnalyticalCheckboxList> {
  late List<bool> isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = List.filled(widget.options.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytical Section Department',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...List.generate(widget.options.length, (index) {
          return CheckboxListTile(
            title: Text(widget.options[index]),
            value: isChecked[index],
            onChanged: (value) {
              setState(() {
                isChecked[index] = value!;
                Data.manipulateTasks(index, isChecked, widget.options, value);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }
}
