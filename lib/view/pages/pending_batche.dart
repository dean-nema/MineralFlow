import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
// --- 1. REMOVE the old app bar import ---
// import 'package:mineralflow/view/components/app_bar2.dart';
// --- 2. ADD the new sidebar import ---
import 'package:mineralflow/view/pages/batch_details.dart';
import 'package:mineralflow/view/pages/request_page.dart';

class PendingBatchesPage extends StatefulWidget {
  const PendingBatchesPage({super.key});

  @override
  State<PendingBatchesPage> createState() => _PendingBatchesPageState();
}

class _PendingBatchesPageState extends State<PendingBatchesPage> {
  // --- All your existing state variables and logic remain unchanged ---
  late List<BatchModel> _allPendingBatches;
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
    _loadPendingBatches();
  }

  @override
  void dispose() {
    _clientCodeFilterController.dispose();
    _personAssignedFilterController.dispose();
    _dateFilterController.dispose();
    super.dispose();
  }

  void _loadPendingBatches() {
    _allPendingBatches =
        Data.batchList.where((batch) => batch.status == 'Pending').toList();
    _filteredBatches = List.from(_allPendingBatches);
  }

  void _applyFilters() {
    setState(() {
      _filteredBatches =
          _allPendingBatches.where((batch) {
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
      _filteredBatches = List.from(_allPendingBatches);
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
  // --- End of unchanged logic ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // --- 3. REPLACE the old ReusableAppBar ---
      appBar: AppBar(
        title: const Text("Pending Batches"),
        backgroundColor: Colors.blueGrey,
      ),
      // --- 4. ADD the new SideBar to the drawer property ---
      drawer: SideBar(
        userName: Data.currentUser,
        activePage:
            ActivePage.batches, // This page is part of the "Batches" group
      ),
      // --- The entire body of your page remains exactly the same ---
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

  // --- All helper widgets (_buildFiltersPanel, etc.) remain unchanged ---
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
                        MaterialPageRoute(
                          builder: (context) => const RequestPage(),
                        ),
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
              'Pending Batches',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
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
                                    MaterialStateProperty.resolveWith<Color?>(
                                      (states) =>
                                          index.isEven
                                              ? Colors.grey.withOpacity(0.12)
                                              : null,
                                    ),
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
                                  DataCell(
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          batch.status!,
                                          style: const TextStyle(
                                            color: Colors.blue,
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
