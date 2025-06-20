import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart'; // Make sure this path is correct
import 'package:mineralflow/models/run_model.dart';
import 'package:mineralflow/models/run_data_model.dart';
import 'package:mineralflow/view/pages/run_list.dart';

class AnalyticalRunDetailsPage extends StatefulWidget {
  final RunModel run;
  const AnalyticalRunDetailsPage({super.key, required this.run});

  @override
  State<AnalyticalRunDetailsPage> createState() =>
      _AnalyticalRunDetailsPageState();
}

class _AnalyticalRunDetailsPageState extends State<AnalyticalRunDetailsPage> {
  late RunModel _currentRun;
  late List<RunDataModel> _currentRunData;

  @override
  void initState() {
    super.initState();
    _currentRun = widget.run;
    _initializeRunData();
  }

  /// Ensures every sample has a RunDataModel, creating one if it doesn't exist.
  void _initializeRunData() {
    _currentRunData = List.from(widget.run.data);
    for (var sample in widget.run.samples) {
      if (!_currentRunData.any(
        (d) => d.sample.sampleCode == sample.sampleCode,
      )) {
        _currentRunData.add(
          RunDataModel(
            sample: sample,
            furnace: [null, null],
            dishWeight: [null, null],
            sampleWeight: [null, null],
            ashContent: [null, null],
          ),
        );
      }
    }
  }

  // --- LOGIC FUNCTIONS ---

  /// --- MODIFIED: Includes validation and status update logic ---
  void _saveChanges() {
    bool isAnyFieldFilled = false;
    // Check if any of the data fields have been filled
    for (final data in _currentRunData) {
      if ((data.furnace?.any((f) => f != null && f.isNotEmpty) ?? false) ||
          (data.dishWeight?.any((d) => d != null) ?? false) ||
          (data.sampleWeight?.any((s) => s != null) ?? false) ||
          (data.ashContent?.any((a) => a != null) ?? false)) {
        isAnyFieldFilled = true;
        break; // Found at least one filled field, no need to check further
      }
    }

    // Update the original 'run' object passed to the widget with the current local state
    setState(() {
      // If data has been entered, automatically update the status to In-Progress
      if (isAnyFieldFilled && _currentRun.status == 'Pending') {
        _currentRun.status = 'In-Progress';
      }
      widget.run.status = _currentRun.status;
      widget.run.data = _currentRunData;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAnyFieldFilled
              ? 'Changes saved and status updated to In-Progress!'
              : 'Changes saved!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AllRunsPage()),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Run?'),
            content: Text(
              'Are you sure you want to permanently delete run ${_currentRun.runID}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // TODO: Add logic here to delete from your global data source
                  print('Deleting run ${_currentRun.runID}');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Run Details: ${_currentRun.runID}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildHeaderInfo(),
            const SizedBox(height: 24),
            Expanded(child: _buildSamplesTable()),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoBlock("Run Type", _currentRun.taskName),
              _buildInfoBlock("Run ID", _currentRun.runID),
              _buildInfoBlock("Status", _currentRun.status, highlight: true),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          Row(
            children: [
              const Text(
                "Assigned To: ",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                _currentRun.assignedPersonal,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSamplesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Analytical Run Data Entry',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Sample Code')),
                        DataColumn(label: Text('Furnace No.')),
                        DataColumn(label: Text('Dish Weight (g)')),
                        DataColumn(label: Text('Sample Weight (g)')),
                        DataColumn(label: Text('Dish+Sample (g)')),
                        DataColumn(label: Text('Ash Content (%)')),
                        DataColumn(label: Text('Result')),
                      ],
                      rows: _buildTableRows(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildTableRows() {
    List<DataRow> rows = [];
    for (var runData in _currentRunData) {
      rows.add(_buildDataEntryRow(runData, 0)); // Sample-A
      rows.add(_buildDataEntryRow(runData, 1)); // Sample-B
      rows.add(_buildDifferenceRow(runData));
    }
    return rows;
  }

  DataRow _buildDataEntryRow(RunDataModel runData, int index) {
    String suffix = index == 0 ? 'A' : 'B';
    double? dishWeight = runData.dishWeight?[index];
    double? sampleWeight = runData.sampleWeight?[index];
    double dishPlusSample = (dishWeight ?? 0) + (sampleWeight ?? 0);

    return DataRow(
      cells: [
        DataCell(Text('${runData.sample.sampleCode}-$suffix')),
        DataCell(
          _buildTextField(
            initialValue: runData.furnace?[index],
            onChanged: (val) => setState(() => runData.furnace?[index] = val),
          ),
        ),
        DataCell(
          _buildTextField(
            isNumeric: true,
            initialValue: dishWeight?.toString(),
            onChanged:
                (val) => setState(
                  () => runData.dishWeight?[index] = double.tryParse(val),
                ),
          ),
        ),
        DataCell(
          _buildTextField(
            isNumeric: true,
            initialValue: sampleWeight?.toString(),
            onChanged:
                (val) => setState(
                  () => runData.sampleWeight?[index] = double.tryParse(val),
                ),
          ),
        ),
        DataCell(
          Text(dishPlusSample > 0 ? dishPlusSample.toStringAsFixed(4) : ''),
        ),
        DataCell(
          _buildTextField(
            isNumeric: true,
            initialValue: runData.ashContent?[index]?.toString(),
            onChanged:
                (val) => setState(
                  () => runData.ashContent?[index] = double.tryParse(val),
                ),
          ),
        ),
        // --- MODIFIED: Show result cell for Row A, empty for Row B ---
        index == 0
            ? _buildResultCell(runData)
            : const DataCell(SizedBox.shrink()), // Effectively merges the cell
      ],
    );
  }

  /// --- NEW HELPER: Creates the styled PASS/FAIL cell ---
  DataCell _buildResultCell(RunDataModel runData) {
    bool canCalculate =
        runData.ashContent?[0] != null && runData.ashContent?[1] != null;
    bool result =
        canCalculate ? runData.getResult(_currentRun.taskName) : false;

    return DataCell(
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                canCalculate
                    ? (result
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2))
                    : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            canCalculate ? (result ? 'PASS' : 'FAIL') : 'N/A',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  canCalculate
                      ? (result ? Colors.green[800] : Colors.red[800])
                      : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDifferenceRow(RunDataModel runData) {
    bool canCalculate =
        runData.ashContent?[0] != null && runData.ashContent?[1] != null;
    double difference =
        canCalculate
            ? (runData.ashContent![0]! - runData.ashContent![1]!).abs()
            : 0.0;

    return DataRow(
      color: MaterialStateProperty.all(Colors.blueGrey[50]),
      cells: [
        const DataCell(Text('', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('')),
        DataCell(
          Center(
            child: Text(
              '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const DataCell(Text('')), // Result cell is now part of the A/B rows
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _saveChanges,
          icon: const Icon(Icons.save_alt_outlined),
          label: const Text('Save Changes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton.icon(
          onPressed: _showDeleteConfirmation,
          icon: const Icon(Icons.delete_forever_outlined),
          label: const Text('Delete Run'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    String? initialValue,
    bool isNumeric = false,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        initialValue: initialValue ?? '',
        keyboardType:
            isNumeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
        onChanged: onChanged,
        decoration: const InputDecoration(
          isDense: true,
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(String label, String value, {bool highlight = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: highlight ? Colors.blue[700] : Colors.black,
          ),
        ),
      ],
    );
  }
}
