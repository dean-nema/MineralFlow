import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/data/sample_row.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
// import 'package:mineralflow/view/components/app_bar2.dart'; // --- REMOVED: Old app bar import
import 'package:mineralflow/view/pages/batch_list.dart';
import 'package:mineralflow/view/pages/request_page.dart';

class SampleRegistryPage extends StatefulWidget {
  final BatchModel batch;
  const SampleRegistryPage({super.key, required this.batch});

  @override
  State<SampleRegistryPage> createState() => _SampleRegistryPageState();
}

class _SampleRegistryPageState extends State<SampleRegistryPage> {
  List<SampleRow> _sampleRows = [];
  final List<String> _sampleTypeOptions = Data.sampleTypeOptions;

  // --- NEW: Flag to track if the batch was saved successfully ---
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _submitSamples() {
    // Loop through each row to validate
    for (int i = 0; i < _sampleRows.length; i++) {
      final row = _sampleRows[i];
      final rowNumber = i + 1;

      // Check if any of the required fields are empty or not selected
      if (row.sampleCodeController.text.trim().isEmpty ||
          row.sampleDescriptionController.text.trim().isEmpty ||
          row.sampleLocationController.text.trim().isEmpty ||
          row.receivingWeightController.text.trim().isEmpty ||
          row.sampleType == null ||
          row.receivingDateTime == null) {
        // If validation fails, show an error message and stop
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all fields on row $rowNumber'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Exit the function
      }
    }

    // If the loop completes, all rows are valid
    for (var sample in widget.batch.samples) {
      for (var row in _sampleRows) {
        if (row.sampleCodeController.text == sample.sampleCode.toString()) {
          sample.sampleLocation = row.sampleLocationController.text;
          sample.sampleType = row.sampleType;
          sample.receivingWeight = double.tryParse(
            row.receivingWeightController.text,
          );
          sample.psd = row.psd;
        }
      }
    }
    for (var element in widget.batch.samples) {
      print(element.toString());
    }
    for (var sample in widget.batch.samples) {
      if (sample.psd) {
        widget.batch.tasks.add("Particle Size Distribution");
        sample.taskUpdate["Particle Size Distribution"] = "Pending";
      }
    }

    // --- NEW: Set the flag to true since we are saving successfully ---
    _isSaved = true;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All samples validated and batch created!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BatchListPage()),
    );
  }

  /// --- NEW: Function to handle cancellation ---
  void _cancelRegistration() {
    // Simply pop the page. The dispose method will handle the cleanup.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RequestPage()),
    );
  }

  void _loadInitialData() {
    _sampleRows.clear();
    for (var data in widget.batch.samples) {
      _sampleRows.add(
        SampleRow(
          id: data.sampleCode.toString(),
          isFromInitialData: true,
          sampleCodeController: TextEditingController(
            text: data.sampleCode.toString(),
          ),
          sampleDescriptionController: TextEditingController(
            text: widget.batch.client,
          ),
          sampleLocationController: TextEditingController(),
          receivingWeightController: TextEditingController(),
          receivingDateTime: widget.batch.receivingDate,
        ),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context, SampleRow row) async {
    if (row.isFromInitialData) return;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: row.receivingDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          row.receivingDateTime ?? DateTime.now(),
        ),
      );
      if (pickedTime != null) {
        setState(() {
          row.receivingDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _deleteSampleRow(String id) {
    setState(() {
      // Prevent deleting the initial rows that came with the batch
      if (_sampleRows.firstWhere((row) => row.id == id).isFromInitialData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cannot delete samples from the initial request."),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final rowToRemove = _sampleRows.firstWhere((row) => row.id == id);
      rowToRemove.sampleCodeController.dispose();
      rowToRemove.sampleDescriptionController.dispose();
      rowToRemove.sampleLocationController.dispose();
      rowToRemove.receivingWeightController.dispose();
      _sampleRows.removeWhere((row) => row.id == id);
    });
  }

  @override
  void dispose() {
    // First, dispose all the text controllers to prevent memory leaks
    for (var row in _sampleRows) {
      row.sampleCodeController.dispose();
      row.sampleDescriptionController.dispose();
      row.sampleLocationController.dispose();
      row.receivingWeightController.dispose();
    }

    // --- NEW: Automatic batch cleanup logic ---
    // If the page is being disposed and _isSaved is false, it means the user
    // cancelled or navigated back without submitting. We should remove the batch.
    if (!_isSaved) {
      Data.batchList.remove(widget.batch);
      print(
        "Batch ${widget.batch.batchOrder} was not saved and has been discarded.",
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      // --- MODIFIED: Add a standard AppBar to show the drawer menu button ---
      appBar: AppBar(
        title: Text('Register Samples for Batch #${widget.batch.batchOrder}'),
        backgroundColor: Colors.blueGrey, // Matches the SideBar color
      ),
      // --- MODIFIED: Add the new SideBar as the drawer ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage:
            ActivePage.newBatch, // Use the appropriate enum for this page
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: DataTable(
                              columnSpacing: 30,
                              headingRowColor: MaterialStateProperty.all(
                                Colors.blueGrey[100],
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              columns: const [
                                DataColumn(label: Text('Seq#')),
                                DataColumn(label: Text('Sample Code')),
                                DataColumn(label: Text('Sample Description')),
                                DataColumn(label: Text('Sample Location')),
                                DataColumn(label: Text('Sample Type')),
                                DataColumn(label: Text('Receiving Wt.')),
                                DataColumn(label: Text('PSD')),
                                DataColumn(
                                  label: Text('Receiving Date & Time'),
                                ),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows:
                                  _sampleRows.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    SampleRow row = entry.value;

                                    return DataRow(
                                      key: ValueKey(row.id),
                                      color: MaterialStateProperty.resolveWith<
                                        Color?
                                      >((states) {
                                        if (index.isEven)
                                          return Colors.grey.withOpacity(0.12);
                                        return null;
                                      }),
                                      cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(
                                          _buildStaticTextCell(
                                            row.sampleCodeController.text,
                                          ),
                                        ),
                                        DataCell(
                                          _buildStaticTextCell(
                                            row
                                                .sampleDescriptionController
                                                .text,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 150,
                                            child: _buildTextField(
                                              row.sampleLocationController,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          DropdownButton<String>(
                                            value: row.sampleType,
                                            hint: const Text("Select..."),
                                            isExpanded: true,
                                            underline: Container(),
                                            items:
                                                _sampleTypeOptions
                                                    .map(
                                                      (v) => DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: v,
                                                        child: Text(v),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged:
                                                (v) => setState(
                                                  () => row.sampleType = v,
                                                ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 100,
                                            child: _buildTextField(
                                              row.receivingWeightController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Checkbox(
                                            value: row.psd,
                                            onChanged:
                                                (v) => setState(
                                                  () => row.psd = v!,
                                                ),
                                          ),
                                        ),
                                        DataCell(
                                          InkWell(
                                            onTap:
                                                () =>
                                                    row.isFromInitialData
                                                        ? null
                                                        : _selectDateTime(
                                                          context,
                                                          row,
                                                        ),
                                            child: Text(
                                              row.receivingDateTime == null
                                                  ? 'Select...'
                                                  : DateFormat(
                                                    'dd/MM/yy hh:mm a',
                                                  ).format(
                                                    row.receivingDateTime!,
                                                  ),
                                              style: TextStyle(
                                                color:
                                                    row.isFromInitialData
                                                        ? Colors.grey[700]
                                                        : (row.receivingDateTime ==
                                                                null
                                                            ? Colors.blue
                                                            : Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                            tooltip:
                                                "Cannot delete initial samples",
                                            onPressed:
                                                () => _deleteSampleRow(row.id),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align buttons to the right
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            _cancelRegistration, // Calls the new cancel function
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: _submitSamples,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildStaticTextCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[700]),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
