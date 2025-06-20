import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/pages/batch_details.dart';
import 'package:mineralflow/view/pages/create_run.dart';
import 'package:mineralflow/view/pages/request_page.dart';

class BatchListPage extends StatefulWidget {
  const BatchListPage({super.key});

  @override
  State<BatchListPage> createState() => _BatchListPageState();
}

class _BatchListPageState extends State<BatchListPage> {
  // --- STATE VARIABLES ---
  late List<BatchModel> _allBatches;
  late List<BatchModel> _filteredBatches;

  final TextEditingController _clientCodeFilterController =
      TextEditingController();
  final TextEditingController _personAssignedFilterController =
      TextEditingController();
  final TextEditingController _dateFilterController = TextEditingController();

  String? _statusFilter;
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  final List<String> _statusOptions = Data.statusOptions;

  @override
  void initState() {
    super.initState();
    _allBatches = Data.batchList;
    _filteredBatches = List.from(_allBatches);
  }

  @override
  void dispose() {
    _clientCodeFilterController.dispose();
    _personAssignedFilterController.dispose();
    _dateFilterController.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---
  void _applyFilters() {
    setState(() {
      _filteredBatches =
          _allBatches.where((batch) {
            final clientCodeMatch =
                _clientCodeFilterController.text.isEmpty ||
                batch.getClientCode().toLowerCase().contains(
                  _clientCodeFilterController.text.toLowerCase(),
                );

            final statusMatch =
                _statusFilter == null || batch.status == _statusFilter;

            final personMatch =
                _personAssignedFilterController.text.isEmpty ||
                (batch.assignedPersonal == null
                    ? false
                    : batch.assignedPersonal!.toLowerCase().contains(
                      _personAssignedFilterController.text.toLowerCase(),
                    ));

            final dateMatch =
                (_startDateFilter == null && _endDateFilter == null) ||
                (batch.receivingDate.isAfter(
                      _startDateFilter!.subtract(const Duration(days: 1)),
                    ) &&
                    batch.receivingDate.isBefore(
                      _endDateFilter!.add(const Duration(days: 1)),
                    ));

            return clientCodeMatch && statusMatch && personMatch && dateMatch;
          }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _clientCodeFilterController.clear();
      _personAssignedFilterController.clear();
      _dateFilterController.clear();
      _statusFilter = null;
      _startDateFilter = null;
      _endDateFilter = null;
      _filteredBatches = List.from(_allBatches);
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
        title: const Text(
          "Batch List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
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
                _buildFilterDropdown(),
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

  /// --- MODIFIED: This method now correctly positions the button ---
  Widget _buildDataTablePanel() {
    return Column(
      children: [
        // This Expanded widget is the key. It makes the table container
        // take up all available vertical space.
        Expanded(
          child: Container(
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
                                color: MaterialStateProperty.resolveWith<Color?>((states) {
                                  return index.isEven ? Colors.grey.withOpacity(0.12) : null;
                                }),
                                cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text(batch.getClientCode())),
                                  DataCell(Text(batch.batchOrder)),
                                  DataCell(Text(batch.project)),
                                  DataCell(Text(DateFormat('dd/MM/yyyy').format(batch.receivingDate))),
                                  DataCell(Text(age.toString())),
                                  DataCell(Text(batch.assignedPersonal ?? "Unassigned")),
                                  DataCell(Center(child: Text(batch.samples.length.toString()))),
                                  DataCell(
                                    DropdownButton<String>(
                                      value: batch.status,
                                      underline: Container(),
                                      items: _statusOptions.map((String value) {
                                        return DropdownMenuItem<String>(value: value, child: Text(value));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            final originalBatch = _allBatches.firstWhere((b) => b.batchOrder == batch.batchOrder);
                                            originalBatch.status = newValue;
                                            batch.status = newValue;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton(
                                      child: const Text('View Batch'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => BatchOrderDetailsPage(batch: batch)),
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
        ),
        // This SizedBox provides spacing between the table and the button.
        const SizedBox(height: 20),
        // This button is now pushed to the bottom.
        SizedBox(
          width: 200,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateRunPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colours.border,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              padding: EdgeInsets.zero,
              elevation: 0,
              side: BorderSide.none,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Proceed",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildFilterDropdown() {
    return DropdownButtonFormField<String>(
      value: _statusFilter,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      hint: const Text('Any Status'),
      items:
          _statusOptions.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _statusFilter = newValue;
        });
      },
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
