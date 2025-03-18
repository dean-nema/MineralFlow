class BatchSelectedTypeModel{
  String _batchName = ""; 
  String? _batchOption;
  BatchSelectedTypeModel(String title,  String? option) {
    _batchName = title;
    _batchOption = option;
  }

  // Getter for batchName
  String get batchName => _batchName;

  // Setter for batchName
  set batchName(String name) {
    _batchName = name;
  }
  
  String get batchOption => _batchOption!;
  // Setter for batchOptions
  set batchOption(String option) {
    _batchOption = option;
  }
}
