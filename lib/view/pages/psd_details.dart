import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/psd_model.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/components/app_bar2.dart';
import 'package:mineralflow/view/pages/run_list.dart';

// Helper class for row state
class SieveRow {
  final String id;
  final TextEditingController sieveController;
  final TextEditingController massController;
  SieveRow({
    required this.id,
    required this.sieveController,
    required this.massController,
  });
}

class PsdPage extends StatefulWidget {
  final PsdModel psdRun;
  const PsdPage({super.key, required this.psdRun});
  @override
  State<PsdPage> createState() => _PsdPageState();
}

class _PsdPageState extends State<PsdPage> {
  late PsdModel _currentPsdRun;
  final List<SieveRow> _sieveRows = [];
  double _totalMassRetained = 0.0;
  double _sampleLoss = 0.0;
  double _percentLoss = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPsdRun = widget.psdRun;
    _loadSieveData();
    _recalculateTotals();
  }

  @override
  void dispose() {
    for (var row in _sieveRows) {
      row.sieveController.removeListener(_recalculateTotals);
      row.massController.removeListener(_recalculateTotals);
      row.sieveController.dispose();
      row.massController.dispose();
    }
    super.dispose();
  }

  void _loadSieveData() {
    final sortedSieveEntries =
        _currentPsdRun.data.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key));
    for (var entry in sortedSieveEntries) {
      final sieveSize = entry.key;
      final existingMass = entry.value;
      final sieveController = TextEditingController(text: sieveSize.toString());
      final massController = TextEditingController(
        text: existingMass > 0.0 ? existingMass.toStringAsFixed(2) : '',
      );
      massController.addListener(_recalculateTotals);
      _sieveRows.add(
        SieveRow(
          id: UniqueKey().toString(),
          sieveController: sieveController,
          massController: massController,
        ),
      );
    }
  }

  // --- MODIFIED: This function now handles the real-time update of taskData ---
  void _recalculateTotals() {
    // 1. Calculate totals as before
    double totalMass = 0.0;
    for (var row in _sieveRows) {
      final mass = double.tryParse(row.massController.text) ?? 0.0;
      totalMass += mass;
    }
    final initialMass = _currentPsdRun.sample.receivingWeight ?? 0.0;
    final sampleLoss = initialMass - totalMass;
    final percentLoss =
        initialMass > 0 ? (sampleLoss / initialMass) * 100 : 0.0;

    // 2. Check if the form is complete
    bool isComplete = true;
    for (var row in _sieveRows) {
      if (row.sieveController.text.isEmpty ||
          row.massController.text.isEmpty ||
          double.tryParse(row.sieveController.text) == null ||
          double.tryParse(row.massController.text) == null) {
        isComplete = false;
        break; // No need to check further
      }
    }

    // 3. Update the sample's taskData based on completeness
    if (isComplete) {
      // If complete, set the sample loss value
      _currentPsdRun.sample.taskData['Particle Size Distribution'] = sampleLoss;
    } else {
      // If not complete, ensure any old value is removed
      _currentPsdRun.sample.taskData.remove('Particle Size Distribution');
    }

    // 4. Update the UI state
    if (mounted) {
      setState(() {
        _totalMassRetained = totalMass;
        _sampleLoss = sampleLoss;
        _percentLoss = percentLoss;
      });
    }
  }

  // --- MODIFIED: This function is now simpler ---
  void _saveChanges() {
    final Map<String, dynamic> validation = _validateForm();
    if (!validation['isValid']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation['message']),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update the run data and status
    _currentPsdRun.data = validation['newData'];
    _currentPsdRun.status = 'Complete';
    for (var batch in Data.batchList) {
      for (var sample in batch.samples) {
        if (sample == _currentPsdRun.sample) {
          batch.status = "In-Progress";
        }
      }
    }
    _currentPsdRun.sample.taskUpdate["Particle Size Distribution"] = "Complete";
    _currentPsdRun.sample.taskData["Particle Size Distribution"] = _sampleLoss;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AllRunsPage()),
    );
  }

  // --- NEW: Helper function for validation to avoid code duplication ---
  Map<String, dynamic> _validateForm() {
    final Map<double, double> newData = {};
    for (int i = 0; i < _sieveRows.length; i++) {
      final row = _sieveRows[i];
      final sieveSize = double.tryParse(row.sieveController.text);
      final mass = double.tryParse(row.massController.text);

      if (sieveSize == null ||
          mass == null ||
          row.sieveController.text.isEmpty ||
          row.massController.text.isEmpty) {
        return {
          'isValid': false,
          'message':
              'Please fill all fields with valid numbers for row ${i + 1}.',
          'newData': {},
        };
      }
      if (newData.containsKey(sieveSize)) {
        return {
          'isValid': false,
          'message':
              'Duplicate sieve size "$sieveSize" found. Please use unique sieve sizes.',
          'newData': {},
        };
      }
      newData[sieveSize] = mass;
    }
    return {'isValid': true, 'message': 'Success', 'newData': newData};
  }

  void _addNewSieveRow() {
    setState(() {
      final newSieveController = TextEditingController();
      final newMassController = TextEditingController();
      newMassController.addListener(_recalculateTotals);
      _sieveRows.add(
        SieveRow(
          id: UniqueKey().toString(),
          sieveController: newSieveController,
          massController: newMassController,
        ),
      );
      _recalculateTotals(); // Recalculate to ensure form is now "incomplete"
    });
  }

  void _deleteSieveRow(String id) {
    setState(() {
      final rowToRemove = _sieveRows.firstWhere((row) => row.id == id);
      rowToRemove.sieveController.dispose();
      rowToRemove.massController.dispose();
      _sieveRows.removeWhere((row) => row.id == id);
      _recalculateTotals(); // Recalculate after removing
    });
  }

  // --- UI WIDGET BUILDER METHODS (Unchanged) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("PSD Run for Sample #${_currentPsdRun.sample.sampleCode}"),
        backgroundColor: Colors.blueGrey,
        elevation: 1,
      ),
      drawer: SideBar(userName: Data.currentUser, activePage: ActivePage.runs),
      body: SingleChildScrollView(
        child: Padding(
          // Adjusted padding for better responsiveness on different screen sizes
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800 ? 150 : 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 24),
              _buildSieveTable(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _addNewSieveRow,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Sieve'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueGrey[700],
                    side: BorderSide(color: Colors.blueGrey.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan[600]!, Colors.blueGrey[800]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final initialMass = _currentPsdRun.sample.receivingWeight ?? 0.0;
    return Card(
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Initial Mass:',
              '${initialMass.toStringAsFixed(2)} g',
            ),
            _buildSummaryRow(
              'Total Mass Retained:',
              '${_totalMassRetained.toStringAsFixed(2)} g',
            ),
            _buildSummaryRow(
              'Sample Loss:',
              '${_sampleLoss.toStringAsFixed(2)} g',
            ),
            _buildSummaryRow(
              'Percent Loss:',
              '${_percentLoss.toStringAsFixed(2)} %',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSieveTable() {
    return Card(
      elevation: 2.0,
      color: Colors.blueGrey[100]?.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeaderRow(),
          ..._sieveRows.map((sieveRow) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: Row(
                    key: ValueKey(sieveRow.id),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildTextField(sieveRow.sieveController),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: _buildTextField(sieveRow.massController),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteSieveRow(sieveRow.id),
                          splashRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_sieveRows.last.id != sieveRow.id)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.blueGrey[800]?.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              'Sieve Size (μm)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              'Mass Retained (g)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              'Action',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        isDense: true,
      ),
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.blueGrey[900],
      ),
    );
  }
}
