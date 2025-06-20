import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/data/sample_row.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/recepients_model.dart';
import 'package:mineralflow/models/sample_model.dart';
import 'package:mineralflow/view/components/RequestForm/report_distr.dart';
import 'package:mineralflow/view/components/RequestForm/sample_info.dart';
import 'package:mineralflow/view/components/RequestForm/task_assign.dart';
import 'package:mineralflow/view/pages/sample_registry.dart';

class RequestPage extends StatefulWidget {
  RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  //variables
  PlatformFile? document;
  final TextEditingController amount = TextEditingController();
  final TextEditingController submitter = TextEditingController();
  final TextEditingController projectName = TextEditingController();
  // final TextEditingController batchLocation = TextEditingController();

  String? _selectedClassification;

  final List<String> _classifications = Data.classifications;

  PlatformFile? _selectedFile;
  //Functions
  bool areAllFieldsFilled() {
    return amount.text.isNotEmpty &&
        submitter.text.isNotEmpty &&
        Data.type != null &&
        projectName.text.isNotEmpty;
    //  && batchLocation.text.isNotEmpty;
  }

  // 3. Logic to open the file picker and handle the result
  void _pickFile() async {
    // Opens the file picker dialog
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // Restrict to only the allowed file types
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    // If the user picked a file (result is not null)
    if (result != null) {
      // Update the state to hold the file's information
      setState(() {
        _selectedFile = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  // The state (the map of selected options) lives here in the parent.
  late Map<String, bool> _selectedReportOptions;

  // The list of options is needed to initialize the map.
  final List<String> _reportOptions = Data.reportOptions;

  @override
  void initState() {
    super.initState();
    // Initialize the state.
    _selectedReportOptions = {for (var option in _reportOptions) option: false};
  }

  // This function will be passed to the child widget.
  // It's the only place where setState is called.
  void _handleOptionChange(String option, bool value) {
    setState(() {
      _selectedReportOptions[option] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width < 1866 ? true : false;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Center(
          // Wrapped in a SingleChildScrollView to prevent overflow on smaller screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. "Mineral Flow" text is thicker and larger
                Text(
                  "Mineral Flow",
                  style: TextStyle(
                    fontWeight: FontWeight.w900, // Use w900 for extra thickness
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Sample Request & Analysis Form",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),

                SampleInfo(
                  document: document,
                  amount: amount,
                  submitter: submitter,
                  projectName: projectName,
                  // batchLocation: batchLocation,
                  classification: _selectedClassification,
                ),

                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: TaskAssign(),
                ),

                ReportDistr(),

                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 25),
                  child: Center(
                    child: SizedBox(
                      height: 60,
                      width: 300,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (areAllFieldsFilled()) {
                            String sampNum = amount.text;
                            int num = int.parse(sampNum);
                            List<SampleModel> samples = Data.generateSamples(
                              num,
                            );
                            int tempBatchId = Data.randomNumGenerator(5);
                            String batchOrder = "MCM$tempBatchId";
                            DateTime date = Data.date;
                            List<String> tasks =
                                Data.analyticsTasks.toList() +
                                Data.samplePrepOptions.toList();
                            List<RecepientsModel> recepients =
                                Data.convertRecepients();
                            //create batch
                            for (var sample in samples) {
                              for (var task in tasks) {
                                sample.taskUpdate[task] = "Pending";
                              }
                            }
                            BatchModel batch = BatchModel(
                              submitter: submitter.text,
                              client: Data.type!,
                              document: document,
                              tasks: tasks,
                              recepients: recepients,
                              project: projectName.text,
                              batchLocation: Data.firstStage,
                              batchOrder: batchOrder,
                              samples: samples,
                              status: "Pending",
                              receivingDate: date,
                            );
                            Data.batchList.add(batch);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        SampleRegistryPage(batch: batch),
                              ),
                            );
                            Data.analyticsTasks.clear();
                            Data.currentRecipients.clear();
                          }
                        },
                        label: const Text(
                          "Proceed",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
