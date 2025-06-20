import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/pages/recipient_display.dart';
import 'package:mineralflow/view/pages/sample_list.dart'; // Make sure this path is correct

/// A helper class to manage the status of each individual analysis task.
class TaskStatus {
  final String name;
  int numberOfSamples = 0;
  int pending;
  int complete;
  int inProgress;

  TaskStatus({
    required this.name,
    required this.pending,
    required this.complete,
    required this.inProgress,
    required this.numberOfSamples,
  });
}

class BatchOrderDetailsPage extends StatefulWidget {
  final BatchModel batch;
  const BatchOrderDetailsPage({super.key, required this.batch});

  @override
  State<BatchOrderDetailsPage> createState() => _BatchOrderDetailsPageState();
}

class _BatchOrderDetailsPageState extends State<BatchOrderDetailsPage> {
  // --- STATE VARIABLES ---
  late BatchModel _currentBatch;
  late List<TaskStatus> _taskStatuses;

  // Options for the dropdowns
  final List<String> _batchStatusOptions = Data.statusOptions;
  final List<String> _taskStatusOptions = Data.taskStatusOptions;
  final List<String> _priorityOptions = Data.priorityOptions;
  final List<String> _personnelOptions = Data.personnelOptions;

  @override
  void initState() {
    super.initState();
    _currentBatch = widget.batch;
    _taskStatuses = Data.getBatchStats(widget.batch);
  }

  // --- HELPER FUNCTIONS ---
  String _priorityDoubleToString(double? priority) {
    if (priority == 1.0) return 'Urgent';
    if (priority == 2.0) return 'High';
    return 'Normal';
  }

  double? _priorityStringToDouble(String? priorityString) {
    if (priorityString == 'Urgent') return 1.0;
    if (priorityString == 'High') return 2.0;
    return null; // 'Normal' priority
  }

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Batch Details: ${_currentBatch.batchOrder}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoPanel(),
            const SizedBox(width: 20),
            Expanded(child: _buildTasksTablePanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Text(
              "Batch Information",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Batch Order:", _currentBatch.batchOrder),
                _buildInfoRow("Batch Submitter:", _currentBatch.submitter),
                _buildStatusDropdown(
                  "Status:",
                  _currentBatch.status ?? 'Pending',
                ),
                _buildPersonnelDropdown(
                  "Assigned Personal:",
                  _currentBatch.assignedPersonal,
                ),
                _buildInfoRow(
                  "Batch Location:",
                  _currentBatch.batchLocation ?? "Not Yet",
                ),
                _buildInfoRow(
                  "Receiving Date:",
                  DateFormat(
                    'dd/MM/yyyy hh:mm a',
                  ).format(_currentBatch.receivingDate),
                ),
                _buildInfoRow(
                  "Number of Samples:",
                  _currentBatch.numOfSamples().toString(),
                ),
                _buildPriorityDropdown("Priority:", _currentBatch.priority),
                const Divider(height: 32),
                _buildActionButton(
                  icon: Icons.science_outlined,
                  label: "View Samples",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SampleListPage(batch: widget.batch),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.people_outline,
                  label: "View Recipients",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecipientsPage(batch: widget.batch),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.description_outlined,
                  label: "View Documents",
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  label: "Delete Batch",
                  color: Colors.red,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTablePanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    Colors.blueGrey[100],
                  ),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  columnSpacing: 30,
                  // New column structure
                  columns: const [
                    DataColumn(label: Text('Method Analysis')),
                    DataColumn(label: Text('Number of Samples'), numeric: true),
                    DataColumn(label: Text('Pending'), numeric: true),
                    DataColumn(label: Text('In-Progress'), numeric: true),
                    DataColumn(label: Text('Complete'), numeric: true),
                  ],
                  // New row structure based on the task's single status
                  rows:
                      _taskStatuses.map((task) {
                        final totalSamples = task.numberOfSamples.toString();

                        return DataRow(
                          cells: [
                            DataCell(Text(task.name)),
                            DataCell(Center(child: Text(totalSamples))),
                            DataCell(
                              Center(child: Text(task.pending.toString())),
                            ),
                            DataCell(
                              Center(child: Text(task.inProgress.toString())),
                            ),
                            DataCell(
                              Center(child: Text(task.complete.toString())),
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
    );
  }

  // --- HELPER WIDGETS (Unchanged) ---
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(String label, String currentValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: currentValue,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items:
                  _batchStatusOptions
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _currentBatch.status = newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityDropdown(String label, double? currentValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _priorityDoubleToString(currentValue),
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items:
                  _priorityOptions
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
              onChanged: (String? newValue) {
                setState(
                  () =>
                      _currentBatch.priority = _priorityStringToDouble(
                        newValue,
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonnelDropdown(String label, String? currentValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: currentValue ?? 'Unassigned',
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items:
                  _personnelOptions
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue == 'Unassigned') {
                    _currentBatch.assignedPersonal = null;
                  } else {
                    _currentBatch.assignedPersonal = newValue;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: color == null ? null : Colors.white,
            alignment: Alignment.centerLeft,
            minimumSize: const Size(double.infinity, 50),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
