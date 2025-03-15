class Batch {
    String _batchName = "";
    List<String>? _batchOptions;
    Batch(String title, List<String>? options){
        _batchName = title;
        _batchOptions = options;
    }
    
  // Getter for batchName
  String get batchName => _batchName;

  // Setter for batchName
  set batchName(String name) {
    _batchName = name;
  }

  // Getter for batchOptions
  List<String>? get batchOptions => _batchOptions;

  // Setter for batchOptions
  set batchOptions(List<String>? options) {
    _batchOptions = options;
  }


     

}
