import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/psd_model.dart';
import 'package:mineralflow/models/run2_model.dart';
import 'package:mineralflow/models/run_model.dart';
import 'package:mineralflow/models/sample_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
// --- 1. REMOVE the old app bar import ---
// import 'package:mineralflow/view/components/app_bar2.dart';
// --- 2. ADD the new sidebar import ---
import 'package:mineralflow/view/pages/psd_details.dart';
import 'package:mineralflow/view/pages/run2_details.dart';
import 'package:mineralflow/view/pages/run_details.dart';

class CreateRunPage extends StatefulWidget {
  const CreateRunPage({super.key});

  @override
  State<CreateRunPage> createState() => _CreateRunPageState();
}

class _CreateRunPageState extends State<CreateRunPage> {
  // --- All your existing state management, logic, and dialogs remain unchanged ---
  String? _selectedPersonnel;
  String? _selectedTask;
  List<BatchModel> _allBatches = [];
  List<BatchModel> _availableBatches = [];
  List<SampleModel> _selectedSamplesForRun = [];

  final List<String> _personnelOptions = Data.personnelOptions.toList();
  final List<String> _taskOptions =
      Data.samplePrepOptions.toList() +
      Data.analyticalSectionOptions.toList() +
      ["Particle Size Distribution"];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _allBatches = Data.batchList;
  }

  void _filterBatchesByTask(String? task) {
    if (task == null) {
      setState(() => _availableBatches = []);
      return;
    }
    if (task == "Crushing" || task == "Pulverization") {
      setState(() => _availableBatches = _allBatches);
      return;
    }
    setState(() {
      _availableBatches =
          _allBatches.where((batch) => batch.tasks.contains(task)).toList();
    });
  }

  void _addSamplesToRun(List<SampleModel> samplesToAdd) {
    setState(() {
      for (final sample in samplesToAdd) {
        if (!_selectedSamplesForRun.any(
          (s) => s.sampleCode == sample.sampleCode,
        )) {
          _selectedSamplesForRun.add(sample);
        }
      }
    });
  }

  void _removeSampleFromRun(int sampleId) {
    setState(() {
      _selectedSamplesForRun.removeWhere((s) => s.sampleCode == sampleId);
    });
  }

  void _createRun() {
    if (_selectedPersonnel == null || _selectedTask == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a person and a task.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedSamplesForRun.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one sample to the run.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedTask == "Crushing" || _selectedTask == "Pulverization") {
      Run2Model run = Run2Model(
        taskName: _selectedTask!,
        status: "Pending",
        samples: _selectedSamplesForRun,
        date: DateTime.now(),
        assignedPersonal: _selectedPersonnel!,
      );
      Data.run2List.add(run);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Run2DetailsPage(run: run)),
      );
    } else if (_selectedTask == "Particle Size Distribution") {
      PsdModel run = PsdModel(
        status: "Pending",
        sample: _selectedSamplesForRun[0],
        date: DateTime.now(),
        assignedPersonal: _selectedPersonnel!,
      );
      Data.psdList.add(run);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PsdPage(psdRun: run)),
      );
    } else {
      RunModel run = RunModel(
        taskName: _selectedTask!,
        status: "Pending",
        samples: _selectedSamplesForRun,
        date: DateTime.now(),
        assignedPersonal: _selectedPersonnel!,
      );
      Data.runList.add(run);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnalyticalRunDetailsPage(run: run),
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Run created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _showAddSamplesDialog(BatchModel batch) async {
    final List<SampleModel> filteredSamples =
        batch.samples
            .where(
              (sample) =>
                  sample.taskUpdate.containsKey(_selectedTask) ||
                  _selectedTask == "Crushing" ||
                  _selectedTask == "Pulverization",
            )
            .toList();

    final Map<int, bool> selectedStates = {
      for (var sample in filteredSamples) sample.sampleCode: false,
    };

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                color: Colors.blueGrey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      batch.batchOrder,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          final allVisibleSelected = filteredSamples.every(
                            (s) => selectedStates[s.sampleCode] == true,
                          );
                          for (final sample in filteredSamples) {
                            selectedStates[sample.sampleCode] =
                                !allVisibleSelected;
                          }
                        });
                      },
                      icon: const Icon(Icons.done_all),
                      label: const Text('Add All'),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Sample ID')),
                      DataColumn(label: Text('Weight')),
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Add')),
                    ],
                    rows:
                        filteredSamples.map((sample) {
                          return DataRow(
                            cells: [
                              DataCell(Text(sample.sampleCode.toString())),
                              DataCell(Text(sample.receivingWeight.toString())),
                              DataCell(Text(sample.sampleLocation ?? 'N/A')),
                              DataCell(
                                Checkbox(
                                  value: selectedStates[sample.sampleCode],
                                  onChanged: (bool? value) {
                                    setDialogState(() {
                                      selectedStates[sample.sampleCode] =
                                          value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final samplesToAdd =
                        batch.samples
                            .where((s) => selectedStates[s.sampleCode] == true)
                            .toList();
                    _addSamplesToRun(samplesToAdd);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Selected'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  // --- End of unchanged logic ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      // --- 3. REPLACE the old ReusableAppBar ---
      appBar: AppBar(
        title: const Text("Create New Run"),
        backgroundColor: Colors.blueGrey,
      ),
      // --- 4. ADD the new SideBar to the drawer property ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage: ActivePage.newRun, // Set the active page for highlighting
      ),
      // --- The entire body of your page remains exactly the same ---
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildAvailableBatchesPanel()),
                  const SizedBox(width: 20),
                  Expanded(flex: 3, child: _buildSelectedSamplesPanel()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _createRun,
                icon: const Icon(Icons.add_task),
                label: const Text('Create Run', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- All helper widgets (_buildTopBar, etc.) remain unchanged ---
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          const Text(
            "Assigned Personal:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPersonnel,
              hint: const Text('Select a person...'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items:
                  _personnelOptions
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
              onChanged: (value) => setState(() => _selectedPersonnel = value),
            ),
          ),
          const SizedBox(width: 40),
          const Text(
            "Task:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedTask,
              hint: const Text('Select a task...'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items:
                  _taskOptions
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
              onChanged: (value) {
                setState(() => _selectedTask = value);
                _selectedSamplesForRun.clear();
                _filterBatchesByTask(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableBatchesPanel() {
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
              'Available Batches',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child:
                _availableBatches.isEmpty
                    ? const Center(
                      child: Text('Select a task to see available batches.'),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(top: 4),
                      itemCount: _availableBatches.length,
                      itemBuilder: (context, index) {
                        final batch = _availableBatches[index];
                        return Card(
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.2),
                          color: Colors.blue[50],
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: ListTile(
                            textColor: Colors.blueGrey[800],
                            iconColor: Colors.blueGrey[800],
                            title: Text(
                              batch.batchOrder,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text('${batch.samples.length} Samples'),
                            onTap: () => _showAddSamplesDialog(batch),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSamplesPanel() {
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
              'Samples Added for Run',
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
                        DataColumn(label: Text('Weight')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows:
                          _selectedSamplesForRun.map((sample) {
                            BatchModel? activeBatch;
                            for (var element in _availableBatches) {
                              for (var element2 in element.samples) {
                                if (element2 == sample) {
                                  activeBatch = element;
                                  break;
                                }
                              }
                            }
                            return DataRow(
                              cells: [
                                DataCell(Text(activeBatch!.batchOrder)),
                                DataCell(Text(sample.sampleCode.toString())),
                                DataCell(Text(sample.sampleLocation ?? 'N/A')),
                                DataCell(
                                  Text(sample.receivingWeight.toString()),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _removeSampleFromRun(
                                          sample.sampleCode,
                                        ),
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
}
