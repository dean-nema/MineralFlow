import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/sample_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
import 'package:mineralflow/view/pages/recipient_display.dart';
import 'package:mineralflow/view/pages/sample_list.dart';

class BatchDetailsPage extends StatefulWidget {
  final BatchModel batch;
  const BatchDetailsPage({super.key, required this.batch});

  @override
  State<BatchDetailsPage> createState() => _BatchDetailsPageState();
}

class _BatchDetailsPageState extends State<BatchDetailsPage> {
  // --- STATE VARIABLES ---
  late BatchModel _currentBatch;

  // Options for the dropdowns
  final List<String> _batchStatusOptions = Data.statusOptions;
  final List<String> _priorityOptions = Data.priorityOptions;
  final List<String> _personnelOptions = Data.personnelOptions;

  @override
  void initState() {
    super.initState();
    _currentBatch = widget.batch;
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
        title: const Text('Batch Details'),
        backgroundColor: Colors.blueGrey, // Matches the SideBar color
      ),
      // --- MODIFIED: Add the new SideBar as the drawer ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage: ActivePage.batches,
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
    // This widget remains unchanged as its logic is still valid.
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

  /// --- REDESIGNED: This method now builds the dynamic results table ---
  Widget _buildTasksTablePanel() {
    // Dynamically create columns: static ones first, then one for each task.
    final List<DataColumn> tableColumns = [
      const DataColumn(label: Text('Sample Code')),
      const DataColumn(label: Text('Sample Location')),
      ..._currentBatch.tasks.map(
        (taskName) => DataColumn(label: Text(taskName)),
      ),
    ];

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
                  columns: tableColumns,
                  // Generate a row for each sample in the batch.
                  rows:
                      _currentBatch.samples.map((sample) {
                        return DataRow(
                          cells: [
                            // The static cells for sample details.
                            DataCell(Text(sample.sampleCode.toString())),
                            DataCell(Text(sample.sampleLocation ?? 'N/A')),
                            // The dynamic cells, one for each task.
                            ..._currentBatch.tasks.map((taskName) {
                              return _buildResultCell(sample, taskName);
                            }),
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

  /// This is the core logic for determining what to display in each task cell.
  DataCell _buildResultCell(SampleModel sample, String taskName) {
    // Check if the task has a status update for this sample.
    if (sample.taskUpdate.containsKey(taskName)) {
      final status = sample.taskUpdate[taskName]!;
      // If the status is Complete or Finalized, show the data.
      if (status == 'Complete' || status == 'Finalized') {
        // --- MODIFICATION START ---
        // Define the tasks that should just show "Complete" instead of a value.
        const tasksToShowComplete = [
          'Pulverization',
          'Crushing',
          'Particle Size Distribution',
          'Calorific Value',
        ];

        // Check if the current task is one of them.
        if (tasksToShowComplete.contains(taskName)) {
          return const DataCell(
            Center(
              child: Text(
                'Complete', // Display "Complete" as requested.
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        }
        // --- MODIFICATION END ---

        // For all other tasks, show the numerical result.
        final resultValue = sample.taskData[taskName];
        return DataCell(
          Center(
            child: Text(
              resultValue?.toStringAsFixed(4) ??
                  'ERROR', // Show formatted data or an error
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        );
      } else {
        // Otherwise, show the current status as a styled badge.
        return DataCell(
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusBadgeColor(status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              ),
            ),
          ),
        );
      }
    } else {
      // If the task doesn't exist in the update map, display N/A.
      return const DataCell(Center(child: Text('N/A')));
    }
  }

  /// Helper function to provide colors for status badges in the table.
  Color _getStatusBadgeColor(String status) {
    switch (status) {
      case 'In-Progress':
        return Colors.amber.withOpacity(0.3);
      case 'Pending':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
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
