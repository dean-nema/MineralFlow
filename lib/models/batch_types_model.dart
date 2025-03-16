class BatchTypesModel {
  String _batchName = ""; 
  List<String>? _batchOptions;
  BatchTypesModel(String title, List<String>? options) {
    _batchName = title;
    _batchOptions = options;
  }

  // Getter for batchName
  String get batchName => _batchName;

  // Setter for batchName
  set batchName(String name) {
    _batchName = name;
  }

  void addOption(String newOption) {
    if (_batchOptions == null) {
      _batchOptions = [newOption];
    } else {
      _batchOptions!.add(newOption);
    }
  }
  void deleteOption(String optionToDelete){
      if (_batchOptions == null) { 
            } else {
        for (var option in _batchOptions!) {
             if(option == optionToDelete){
                 _batchOptions!.remove(option);
                 break;
             }
            }            
            }
  }

  // Getter for batchOptions
  List<String>? get batchOptions => _batchOptions;

  // Setter for batchOptions
  set batchOptions(List<String>? options) {
    _batchOptions = options;
  }
}
