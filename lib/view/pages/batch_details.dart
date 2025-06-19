import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart'; // Make sure this path is correct

/// A helper class to manage the status of each individual analysis task.
class TaskStatus {
  final String name;
  int numberOfSamples = 0;
  String status;

  TaskStatus({
    required this.name,
    required this.status,
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
  final List<String> _batchStatusOptions = [
    'Active',
    'onHold',
    'Finalized',
    'Pending',
    'Cancelled',
  ];
  final List<String> _taskStatusOptions = [
    'Pending',
    'In Progress',
    'Complete',
  ];
  final List<String> _priorityOptions = ['Normal', 'High', 'Urgent'];
  // --- NEW: Demo data for the personnel dropdown ---
  final List<String> _personnelOptions = [
    'Unassigned',
    'John Doe',
    'Jane Smith',
    'Peter Jones',
    'Emily White',
  ];

  @override
  void initState() {
    _currentBatch = widget.batch;
    // Convert the list of task strings into a list of manageable TaskStatus objects
    _taskStatuses = Data.getBatchStats(widget.batch);
  }

  /// Returns a color based on the task status for UI feedback.
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Complete':
        return Colors.green.withOpacity(0.2);
      case 'In Progress':
        return Colors.orange.withOpacity(0.2);
      case 'Pending':
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

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
            // Left Panel: Batch Information and Actions
            _buildInfoPanel(),
            const SizedBox(width: 20),
            // Right Panel: Analysis Tasks Table
            Expanded(child: _buildTasksTablePanel()),
          ],
        ),
      ),
    );
  }

  /// Builds the information and action panel on the left.
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
          // Header
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
          // Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Batch Order:", _currentBatch.batchOrder),
                _buildStatusDropdown(
                  "Status:",
                  _currentBatch.status ?? 'Pending',
                ),
                // --- MODIFIED: Person Assigned is now a dropdown ---
                _buildPersonnelDropdown(
                  "Assigned Personal:",
                  _currentBatch.assignedPersonal,
                ),
                _buildInfoRow("Batch Location:", _currentBatch.batchLocation),
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
                // Action Buttons
                _buildActionButton(
                  icon: Icons.science_outlined,
                  label: "View Samples",
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.people_outline,
                  label: "View Recipients",
                  onPressed: () {},
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

  /// Builds the main analysis tasks table panel.
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
                  columns: const [
                    DataColumn(label: Text('Method Analysis')),
                    DataColumn(label: Text('Number of Samples')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows:
                      _taskStatuses.map((task) {
                        return DataRow(
                          cells: [
                            DataCell(Text(task.name)),
                            DataCell(
                              Center(
                                child: Text(
                                  _currentBatch.numOfSamples().toString(),
                                ),
                              ),
                            ),
                            DataCell(
                              // Dropdown for changing status directly in the table
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(task.status),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(task.status),
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
    );
  }

  // --- HELPER WIDGETS ---

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
                  _batchStatusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentBatch.status = newValue;
                  });
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
                  _priorityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currentBatch.priority = _priorityStringToDouble(newValue);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: Helper to create the personnel dropdown ---
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
              // Handle null by showing 'Unassigned'
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
                  _personnelOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  // If 'Unassigned' is selected, set the model's value to null
                  // Otherwise, set it to the selected name.
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
            minimumSize: const Size(
              double.infinity,
              50,
            ), // Set a minimum height
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ), // Slightly less rounded corners
            ),
          ),
        ),
      ),
    );
  }
}
