import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
import 'package:mineralflow/view/pages/batch_details.dart';
import 'package:mineralflow/view/pages/request_page.dart';

class InProgressBatchesPage extends StatefulWidget {
  const InProgressBatchesPage({super.key});

  @override
  State<InProgressBatchesPage> createState() => _InProgressBatchesPageState();
}

class _InProgressBatchesPageState extends State<InProgressBatchesPage> {
  // --- STATE VARIABLES ---
  late List<BatchModel> _allInProgressBatches;
  late List<BatchModel> _filteredBatches;

  final TextEditingController _clientCodeFilterController =
      TextEditingController();
  final TextEditingController _personAssignedFilterController =
      TextEditingController();
  final TextEditingController _dateFilterController = TextEditingController();

  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  @override
  void initState() {
    super.initState();
    _loadInProgressBatches();
  }

  @override
  void dispose() {
    _clientCodeFilterController.dispose();
    _personAssignedFilterController.dispose();
    _dateFilterController.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

  /// --- MODIFIED: Loads only 'In-Progress' batches from the source ---
  void _loadInProgressBatches() {
    // The master list is pre-filtered to only include In-Progress batches.
    _allInProgressBatches =
        Data.batchList.where((batch) => batch.status == 'In-Progress').toList();
    _filteredBatches = List.from(_allInProgressBatches);
  }

  /// --- MODIFIED: Simplified filter logic without status check ---
  void _applyFilters() {
    setState(() {
      _filteredBatches =
          _allInProgressBatches.where((batch) {
            final clientCodeMatch =
                _clientCodeFilterController.text.isEmpty ||
                batch.getClientCode().toLowerCase().contains(
                  _clientCodeFilterController.text.toLowerCase(),
                );

            final personMatch =
                _personAssignedFilterController.text.isEmpty ||
                (batch.assignedPersonal ?? '').toLowerCase().contains(
                  _personAssignedFilterController.text.toLowerCase(),
                );

            final dateMatch =
                (_startDateFilter == null || _endDateFilter == null) ||
                (batch.receivingDate.isAfter(
                      _startDateFilter!.subtract(const Duration(days: 1)),
                    ) &&
                    batch.receivingDate.isBefore(
                      _endDateFilter!.add(const Duration(days: 1)),
                    ));

            return clientCodeMatch && personMatch && dateMatch;
          }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _clientCodeFilterController.clear();
      _personAssignedFilterController.clear();
      _dateFilterController.clear();
      _startDateFilter = null;
      _endDateFilter = null;
      _filteredBatches = List.from(_allInProgressBatches);
    });
  }

  Future<void> _selectFilterDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          _startDateFilter != null && _endDateFilter != null
              ? DateTimeRange(start: _startDateFilter!, end: _endDateFilter!)
              : null,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _startDateFilter = picked.start;
        _endDateFilter = picked.end;
        final format = DateFormat('dd/MM/yyyy');
        _dateFilterController.text =
            '${format.format(picked.start)} - ${format.format(picked.end)}';
      });
    }
  }

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("In-Progress Batch"),
        backgroundColor: Colors.blueGrey,
      ),
      // --- 4. ADD the new SideBar to the drawer property ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage: ActivePage.runs, // This is part of the "Runs" section
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFiltersPanel(),
            const SizedBox(width: 20),
            Expanded(child: _buildDataTablePanel()),
          ],
        ),
      ),
    );
  }

  /// --- MODIFIED: Filter panel without the status dropdown ---
  Widget _buildFiltersPanel() {
    return Container(
      width: 300,
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              "Filters",
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
              children: [
                _buildFilterTextField(
                  _clientCodeFilterController,
                  'Client Code',
                ),
                const SizedBox(height: 16),
                _buildFilterDatePicker(),
                const SizedBox(height: 16),
                _buildFilterTextField(
                  _personAssignedFilterController,
                  'Person Assigned',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _applyFilters,
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RequestPage()),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add New Batch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTablePanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // Header for the table
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Text(
              'In-Progress Batches', // --- MODIFIED: Title ---
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Table content
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
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
                          DataColumn(label: Text('Seq#')),
                          DataColumn(label: Text('Client Code')),
                          DataColumn(label: Text('Batch Code')),
                          DataColumn(label: Text('Project')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Age')),
                          DataColumn(label: Text('Person Assigned')),
                          DataColumn(label: Text('# of Samples')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Batch Info')),
                        ],
                        rows:
                            _filteredBatches.asMap().entries.map((entry) {
                              final index = entry.key;
                              final batch = entry.value;
                              final age = batch.getAge();

                              return DataRow(
                                color:
                                    MaterialStateProperty.resolveWith<Color?>((
                                      states,
                                    ) {
                                      return index.isEven
                                          ? Colors.grey.withOpacity(0.12)
                                          : null;
                                    }),
                                cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text(batch.getClientCode())),
                                  DataCell(Text(batch.batchOrder)),
                                  DataCell(Text(batch.project)),
                                  DataCell(
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(batch.receivingDate),
                                    ),
                                  ),
                                  DataCell(Text(age.toString())),
                                  DataCell(
                                    Text(
                                      batch.assignedPersonal ?? "Unassigned",
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        batch.samples.length.toString(),
                                      ),
                                    ),
                                  ),
                                  // --- MODIFIED: Status is now a styled "In-Progress" badge ---
                                  DataCell(
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          batch.status!,
                                          style: TextStyle(
                                            color: Colors.orange[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton(
                                      child: const Text('View Batch'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BatchDetailsPage(
                                                  batch: batch,
                                                ),
                                          ),
                                        );
                                      },
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
        ],
      ),
    );
  }

  // --- HELPER WIDGETS FOR FILTERS ---
  Widget _buildFilterTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _buildFilterDatePicker() {
    return TextField(
      controller: _dateFilterController,
      decoration: const InputDecoration(
        labelText: 'Date Range',
        border: OutlineInputBorder(),
        isDense: true,
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectFilterDateRange(context),
    );
  }
}
