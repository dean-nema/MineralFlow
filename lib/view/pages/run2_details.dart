import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/run2_model.dart';
import 'package:mineralflow/models/sample_model.dart';
import 'package:mineralflow/view/pages/run_list.dart';

class Run2DetailsPage extends StatefulWidget {
  final Run2Model run;
  const Run2DetailsPage({super.key, required this.run});

  @override
  State<Run2DetailsPage> createState() => _Run2DetailsPageState();
}

class _Run2DetailsPageState extends State<Run2DetailsPage> {
  late Run2Model _currentRun;
  late List<SampleModel> _currentSamples;

  @override
  void initState() {
    super.initState();
    _currentRun = widget.run;
    _currentSamples = List.from(widget.run.samples);
  }

  // --- LOGIC FUNCTIONS ---

  void _saveChanges() {
    setState(() {
      widget.run.status = _currentRun.status;
      widget.run.samples = _currentSamples;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AllRunsPage()),
    );
  }

  void _removeSample(int sampleCode) {
    setState(() {
      _currentSamples.removeWhere((sample) => sample.sampleCode == sampleCode);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sample $sampleCode removed from run. Press "Save" to confirm.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// --- MODIFIED to also handle the parent Batch status ---
  void _setStatus(String newStatus) {
    setState(() {
      _currentRun.status = newStatus;
    });

    for (var element in _currentRun.samples) {
      element.taskUpdate[_currentRun.taskName] = newStatus;
    }

    // --- NEW LOGIC: Update the parent Batch status ---
    // If we are starting or completing this run, ensure the parent batch is not pending.
    if ((newStatus == 'In-Progress' || newStatus == 'Complete') &&
        _currentRun.samples.isNotEmpty) {
      // Find the batch that these samples belong to by searching the global list.
      final batchToUpdate = Data.batchList.firstWhere(
        (b) => b.samples.contains(_currentRun.samples.first),
      );

      // f we found the batch and it's pending, update it to In-Progress.
      if (batchToUpdate != null && batchToUpdate.status == 'Pending') {
        batchToUpdate.status = 'In-Progress';
        print(
          'Parent Batch ${batchToUpdate.batchOrder} status updated to In-Progress.',
        );
      }
    }
    // --- END OF NEW LOGIC ---

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Run status updated to "$newStatus". Press "Save" to confirm changes.',
        ),
        backgroundColor: Colors.blue,
      ),
    );
    // Note: We no longer automatically navigate away after setting status,
    // allowing the user to make more changes before saving.
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
                  Data.run2List.removeWhere(
                    (run) => run.runID == _currentRun.runID,
                  );
                  print('Deleting run ${_currentRun.runID}');
                  Navigator.of(context).pop();
                  // Pop twice to go back to the list page
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
        leading: BackButton(
          onPressed: () {
            // Ensure changes are saved when navigating back
            _saveChanges();
          },
        ),
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
              'Samples in Run',
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
                      columns: const [
                        DataColumn(label: Text('Batch Order')),
                        DataColumn(label: Text('Sample ID')),
                        DataColumn(label: Text('Sample Location')),
                        DataColumn(label: Text('Receiving Weight (g)')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows:
                          _currentSamples.map((sample) {
                            // Find the batch for the current sample
                            BatchModel? activeBatch = Data.batchList.firstWhere(
                              (element) => element.samples.contains(sample),
                            );
                            return DataRow(
                              cells: [
                                // Display batch order or 'N/A' if not found
                                DataCell(
                                  Text(activeBatch?.batchOrder ?? 'N/A'),
                                ),
                                DataCell(Text(sample.sampleCode.toString())),
                                DataCell(Text(sample.sampleLocation ?? 'N/A')),
                                DataCell(
                                  Text(
                                    sample.receivingWeight?.toString() ?? 'N/A',
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _removeSample(sample.sampleCode),
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
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SAVE BUTTON
        ElevatedButton.icon(
          onPressed: _saveChanges,
          icon: const Icon(Icons.save_alt_outlined),
          label: const Text('Save and Exit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(width: 20),
        // IN-PROGRESS BUTTON
        ElevatedButton.icon(
          onPressed: () => _setStatus('In-Progress'),
          icon: const Icon(Icons.hourglass_top_rounded),
          label: const Text('Set In-Progress'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(width: 20),
        // COMPLETE BUTTON
        ElevatedButton.icon(
          onPressed: () => _setStatus('Complete'),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Set Complete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(width: 20),
        // DELETE BUTTON
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
