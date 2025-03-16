class BatchCategory {
    String _categoryName = "";

    BatchCategory(String name){
        _categoryName = name;
    }

    String get categoryName => _categoryName;

    set categoryName(String newName ){
        _categoryName = newName;
    }
  
}
