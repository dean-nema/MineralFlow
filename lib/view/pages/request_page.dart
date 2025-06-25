import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/data/sample_row.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/recepients_model.dart';
import 'package:mineralflow/models/sample_model.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/RequestForm/report_distr.dart';
import 'package:mineralflow/view/components/RequestForm/sample_info.dart';
import 'package:mineralflow/view/components/RequestForm/task_assign.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
// --- 1. REMOVE the old app bar import ---
// import 'package:mineralflow/view/components/app_bar2.dart';
// --- 2. ADD the new sidebar import ---
import 'package:mineralflow/view/pages/sample_registry.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // --- All your existing variables and functions remain unchanged ---
  PlatformFile? document;
  final TextEditingController amount = TextEditingController();
  final TextEditingController submitter = TextEditingController();
  final TextEditingController projectName = TextEditingController();

  String? _selectedClassification;
  final List<String> _classifications = Data.classifications;
  PlatformFile? _selectedFile;
  late Map<String, bool> _selectedReportOptions;
  final List<String> _reportOptions = Data.reportOptions;

  @override
  void initState() {
    super.initState();
    _selectedReportOptions = {for (var option in _reportOptions) option: false};
  }

  bool areAllFieldsFilled() {
    return amount.text.isNotEmpty &&
        submitter.text.isNotEmpty &&
        Data.type != null &&
        projectName.text.isNotEmpty;
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _handleOptionChange(String option, bool value) {
    setState(() {
      _selectedReportOptions[option] = value;
    });
  }
  // --- End of unchanged logic ---

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool smallScreen = width < 1866 ? true : false;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],

      // --- 3. REPLACE the old ReusableAppBar ---
      appBar: AppBar(
        title: const Text("New Batch Request"),
        backgroundColor: Colors.blueGrey, // Match sidebar theme
      ),

      // --- 4. ADD the new SideBar to the drawer property ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage: ActivePage.newBatch, // This is the active page
      ),

      // --- The entire body of your page remains exactly the same ---
      body: SingleChildScrollView(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Mineral Flow", style: TextFonts.titles),
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
                  classification: _selectedClassification,
                ),
                Padding(padding: EdgeInsets.all(50.0), child: TaskAssign()),
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
                              batchLocation: Data.batchLocations[0],
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
