class SampleModel {
  int sampleCode;
  String? sampleLocation;
  String? sampleType;
  double? receivingWeight;
  Map<String, String> taskUpdate = Map();
  Map<String, double> taskData = Map();
  bool psd = false;

  SampleModel({
    required this.sampleCode,
    this.sampleLocation,
    this.sampleType,
    this.receivingWeight,
  });
  @override
  String toString() {
    return 'SampleModel('
        'sampleCode: $sampleCode, '
        'sampleLocation: $sampleLocation, '
        'sampleType: $sampleType, '
        'receivingWeight: $receivingWeight, '
        'psd: $psd'
        ')';
  }
}
