import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/data/sample_row.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/pages/batch_list.dart';

class SampleRegistryPage extends StatefulWidget {
  final BatchModel batch;
  const SampleRegistryPage({super.key, required this.batch});

  @override
  State<SampleRegistryPage> createState() => _SampleRegistryPageState();
}

class _SampleRegistryPageState extends State<SampleRegistryPage> {
  List<SampleRow> _sampleRows = [];
  final List<String> _sampleTypeOptions = Data.sampleTypeOptions;

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All samples validated and ready for submission!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BatchListPage()),
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

  void _addSampleRow() {
    setState(() {
      _sampleRows.add(
        SampleRow(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isFromInitialData: false,
          sampleCodeController: TextEditingController(),
          sampleDescriptionController: TextEditingController(),
          sampleLocationController: TextEditingController(),
          receivingWeightController: TextEditingController(),
        ),
      );
    });
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
    for (var row in _sampleRows) {
      row.sampleCodeController.dispose();
      row.sampleDescriptionController.dispose();
      row.sampleLocationController.dispose();
      row.receivingWeightController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Sample Registry",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
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
                    // Vertical scroll
                    // --- FIX START: Wrap with LayoutBuilder to get container width ---
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          // Horizontal scroll
                          scrollDirection: Axis.horizontal,
                          // Force the DataTable to have a minimum width of the container
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
                                        if (index.isEven) {
                                          return Colors.grey.withOpacity(0.12);
                                        }
                                        return null;
                                      }),
                                      cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(
                                          row.isFromInitialData
                                              ? _buildStaticTextCell(
                                                row.sampleCodeController.text,
                                              )
                                              : SizedBox(
                                                width: 150,
                                                child: _buildTextField(
                                                  row.sampleCodeController,
                                                ),
                                              ),
                                        ),
                                        DataCell(
                                          row.isFromInitialData
                                              ? _buildStaticTextCell(
                                                row
                                                    .sampleDescriptionController
                                                    .text,
                                              )
                                              : SizedBox(
                                                width: 200,
                                                child: _buildTextField(
                                                  row.sampleDescriptionController,
                                                ),
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
                    // --- FIX END ---
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addSampleRow,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text("Add Sample"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
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
