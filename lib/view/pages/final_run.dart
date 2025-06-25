import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/run_model.dart';
import 'package:mineralflow/models/run2_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
import 'package:mineralflow/view/pages/run2_details.dart';
import 'package:mineralflow/view/pages/run_details.dart';

/// A wrapper class to unify RunModel and Run2Model for display purposes in the UI.
class DisplayRun {
  final String runID;
  final String status;
  final String age;
  final String assignedPersonal;
  final DateTime date;
  final dynamic originalRun;

  DisplayRun({
    required this.runID,
    required this.status,
    required this.age,
    required this.assignedPersonal,
    required this.date,
    required this.originalRun,
  });
}

class FinalizedRunsPage extends StatefulWidget {
  const FinalizedRunsPage({super.key});

  @override
  State<FinalizedRunsPage> createState() => _FinalizedRunsPageState();
}

class _FinalizedRunsPageState extends State<FinalizedRunsPage> {
  // Master list that holds all FINALIZED runs without any filters.
  List<DisplayRun> _allFinalizedRuns = [];
  // The list that will be displayed in the UI after filters are applied.
  List<DisplayRun> _filteredRuns = [];

  // --- State variables for the filters ---
  String? _selectedPersonnel;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _personnelOptions = [];

  @override
  void initState() {
    super.initState();
    _loadFinalizedRuns();
  }

  /// --- MODIFIED: Loads only runs with 'Finalized' status ---
  void _loadFinalizedRuns() {
    List<DisplayRun> combinedList = [];
    Set<String> personnel = {'All'};

    // Process all runs from the first list (RunModel)
    for (var run in Data.runList) {
      if (run.status == 'Finalized') {
        combinedList.add(
          DisplayRun(
            runID: run.runID,
            status: run.status,
            age: run.getAge(),
            assignedPersonal: run.assignedPersonal,
            date: run.date,
            originalRun: run,
          ),
        );
        personnel.add(run.assignedPersonal);
      }
    }

    // Process all runs from the second list (Run2Model)
    for (var run in Data.run2List) {
      if (run.status == 'Finalized') {
        combinedList.add(
          DisplayRun(
            runID: run.runID,
            status: run.status,
            age: run.getAge(),
            assignedPersonal: run.assignedPersonal,
            date: run.date,
            originalRun: run,
          ),
        );
        personnel.add(run.assignedPersonal);
      }
    }

    setState(() {
      _allFinalizedRuns = combinedList;
      _personnelOptions.clear();
      _personnelOptions.addAll(personnel.toList()..sort());
      _applyFilters();
    });
  }

  /// Applies the current filter state to the master list of FINALIZED runs.
  void _applyFilters() {
    List<DisplayRun> tempFilteredList = List.from(_allFinalizedRuns);

    if (_selectedPersonnel != null && _selectedPersonnel != 'All') {
      tempFilteredList =
          tempFilteredList
              .where((run) => run.assignedPersonal == _selectedPersonnel)
              .toList();
    }

    if (_startDate != null) {
      tempFilteredList =
          tempFilteredList
              .where((run) => !run.date.isBefore(_startDate!))
              .toList();
    }

    if (_endDate != null) {
      DateTime inclusiveEndDate = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        23,
        59,
        59,
      );
      tempFilteredList =
          tempFilteredList
              .where((run) => !run.date.isAfter(inclusiveEndDate))
              .toList();
    }

    tempFilteredList.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _filteredRuns = tempFilteredList;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedPersonnel = null;
      _startDate = null;
      _endDate = null;
      _applyFilters();
    });
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _applyFilters();
      });
    }
  }

  void _navigateToDetails(dynamic originalRun) {
    Widget detailsPage;
    if (originalRun is RunModel) {
      detailsPage = AnalyticalRunDetailsPage(run: originalRun);
    } else if (originalRun is Run2Model) {
      detailsPage = Run2DetailsPage(run: originalRun);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unknown run type.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailsPage),
    ).then((_) => _loadFinalizedRuns()); // Refresh data when returning
  }

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text("Finalized Runs"),
        backgroundColor: Colors.blueGrey,
      ),
      // --- 4. ADD the new SideBar to the drawer property ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage: ActivePage.runs, // This is part of the "Runs" section
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterPanel(),
            const SizedBox(width: 24),
            Expanded(child: _buildRunsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),

          const Text(
            'Assigned To',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPersonnel,
            hint: const Text('Select Personnel'),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items:
                _personnelOptions.map((person) {
                  return DropdownMenuItem(value: person, child: Text(person));
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPersonnel = value;
                _applyFilters();
              });
            },
          ),
          const SizedBox(height: 20),

          const Text(
            'Date Range',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => _selectDate(context, isStartDate: true),
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              _startDate == null
                  ? 'Start Date'
                  : DateFormat('dd/MM/yyyy').format(_startDate!),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => _selectDate(context, isStartDate: false),
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              _endDate == null
                  ? 'End Date'
                  : DateFormat('dd/MM/yyyy').format(_endDate!),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --- MODIFIED: Builds the styled data table for FINALIZED runs ---
  Widget _buildRunsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Text(
              'Finalized Run Overview', // --- Title updated ---
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      columnSpacing: 30,
                      headingRowHeight: 60,
                      headingRowColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      columns: const [
                        DataColumn(label: Center(child: Text('Run ID'))),
                        DataColumn(label: Center(child: Text('Status'))),
                        DataColumn(
                          label: Center(child: Text('Assigned Personal')),
                        ),
                        DataColumn(label: Center(child: Text('Aging'))),
                        DataColumn(label: Center(child: Text('View'))),
                      ],
                      rows:
                          _filteredRuns.asMap().entries.map((entry) {
                            int index = entry.key;
                            DisplayRun run = entry.value;
                            final rowColor =
                                index.isEven
                                    ? Colors.white
                                    : Colors.lightBlue[50]!.withOpacity(0.4);

                            return DataRow(
                              color: MaterialStateProperty.all(rowColor),
                              cells: [
                                DataCell(Text(run.runID)),
                                DataCell(
                                  // Display a styled badge for the status
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        run.status,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(run.assignedPersonal)),
                                DataCell(Text(run.age)),
                                DataCell(
                                  Center(
                                    child: ElevatedButton(
                                      onPressed:
                                          () => _navigateToDetails(
                                            run.originalRun,
                                          ),
                                      child: const Text('View'),
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
