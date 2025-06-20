import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/run_model.dart';
import 'package:mineralflow/models/run2_model.dart';
import 'package:mineralflow/view/pages/run2_details.dart';
import 'package:mineralflow/view/pages/run_details.dart'; // Import for Run2Model details

/// A wrapper class to unify RunModel and Run2Model for display purposes in the UI.
class DisplayRun {
  final String runID;
  final String status;
  final String age;
  final String assignedPersonal; // --- NEW: Added this property ---
  final DateTime date;
  final dynamic originalRun;

  DisplayRun({
    required this.runID,
    required this.status,
    required this.age,
    required this.assignedPersonal, // --- NEW: Added to constructor ---
    required this.date,
    required this.originalRun,
  });
}

class AllRunsPage extends StatefulWidget {
  const AllRunsPage({super.key});

  @override
  State<AllRunsPage> createState() => _AllRunsPageState();
}

class _AllRunsPageState extends State<AllRunsPage> {
  // The state now holds a clean, unified list of DisplayRun objects.
  List<DisplayRun> _displayRuns = [];

  @override
  void initState() {
    super.initState();
    _loadAndCombineRuns();
  }

  /// Loads runs from both data sources, converts them to DisplayRun objects,
  /// and combines them into a single, sorted list for the UI.
  void _loadAndCombineRuns() {
    List<DisplayRun> combinedList = [];

    // Process all runs from the first list (RunModel)
    for (var run in Data.runList) {
      combinedList.add(
        DisplayRun(
          runID: run.runID,
          status: run.status,
          age: run.getAge(),
          assignedPersonal: run.assignedPersonal, // --- NEW: Get the value ---
          date: run.date,
          originalRun: run,
        ),
      );
    }

    // Process all runs from the second list (Run2Model)
    for (var run in Data.run2List) {
      combinedList.add(
        DisplayRun(
          runID: run.runID,
          status: run.status,
          age: run.getAge(),
          assignedPersonal: run.assignedPersonal, // --- NEW: Get the value ---
          date: run.date,
          originalRun: run,
        ),
      );
    }

    // Sort the combined list by date, with the newest runs appearing first.
    combinedList.sort((a, b) => b.date.compareTo(a.date));

    // Update the state to rebuild the UI with the unified list.
    setState(() {
      _displayRuns = combinedList;
    });
  }

  /// Navigates to the correct details page based on the run's original type.
  void _navigateToDetails(dynamic originalRun) {
    if (originalRun is RunModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalyticalRunDetailsPage(run: originalRun),
        ),
      ).then((_) => _loadAndCombineRuns()); // Refresh data when returning
    } else if (originalRun is Run2Model) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Run2DetailsPage(run: originalRun),
        ),
      ).then((_) => _loadAndCombineRuns()); // Refresh data when returning
    } else {
      // Fallback in case of an unexpected type
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unknown run type.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "All Runs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              // Header for the table container
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
                  'Run Overview',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // The table itself, now much cleaner
              Expanded(
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
                          // --- NEW: Added "Assigned Personal" column ---
                          columns: const [
                            DataColumn(label: Text('Run ID')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Assigned Personal')),
                            DataColumn(label: Text('Aging')),
                            DataColumn(label: Text('View')),
                          ],
                          // The UI logic is now simple, mapping over the unified list.
                          rows:
                              _displayRuns.map((run) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(run.runID)),
                                    DataCell(Text(run.status)),
                                    // --- NEW: Added cell to display the person ---
                                    DataCell(Text(run.assignedPersonal)),
                                    DataCell(Text(run.age)),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed:
                                            () => _navigateToDetails(
                                              run.originalRun,
                                            ),
                                        child: const Text('View'),
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
        ),
      ),
    );
  }
}
