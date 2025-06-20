import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/sample_model.dart';

/// A read-only page to display the list of samples associated with a specific batch.
class SampleListPage extends StatefulWidget {
  final BatchModel batch;
  const SampleListPage({super.key, required this.batch});

  @override
  State<SampleListPage> createState() => _SampleListPageState();
}

class _SampleListPageState extends State<SampleListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Sample List: ${widget.batch.batchOrder}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            // The Column now only contains the table, wrapped in an Expanded widget.
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                              headingRowColor: MaterialStateProperty.all(
                                Colors.blueGrey[100],
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              // "Actions" column has been removed.
                              columns: const [
                                DataColumn(label: Text('Seq#')),
                                DataColumn(label: Text('Sample Code')),
                                DataColumn(label: Text('Sample Description')),
                                DataColumn(label: Text('Sample Location')),
                                DataColumn(label: Text('Sample Type')),
                                DataColumn(label: Text('Receiving Wt.')),
                                DataColumn(label: Text('PSD')),
                                DataColumn(
                                  label: Text('Receiving Date & Time'),
                                ),
                              ],
                              // Data is now mapped directly from the batch's sample list.
                              rows:
                                  widget.batch.samples.asMap().entries.map((
                                    entry,
                                  ) {
                                    int index = entry.key;
                                    SampleModel sample = entry.value;

                                    return DataRow(
                                      key: ValueKey(sample.sampleCode),
                                      color: MaterialStateProperty.resolveWith<
                                        Color?
                                      >((states) {
                                        if (index.isEven) {
                                          return Colors.grey.withOpacity(0.12);
                                        }
                                        return null;
                                      }),
                                      // All cells now use static Text widgets for display only.
                                      cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(
                                          Text(sample.sampleCode.toString()),
                                        ),
                                        DataCell(Text(widget.batch.client)),
                                        DataCell(
                                          Text(sample.sampleLocation ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(sample.sampleType ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(
                                            sample.receivingWeight
                                                    ?.toString() ??
                                                'N/A',
                                          ),
                                        ),
                                        DataCell(
                                          // A disabled checkbox clearly shows the boolean state.
                                          Checkbox(
                                            value: sample.psd,
                                            onChanged:
                                                null, // `null` makes it non-interactive.
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            DateFormat(
                                              'dd/MM/yy hh:mm a',
                                            ).format(
                                              widget.batch.receivingDate,
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
                ),
                // The bottom buttons have been removed.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
