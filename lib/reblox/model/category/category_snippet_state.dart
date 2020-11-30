class CategorySnippet {
  String nodeName;
  String nodeId;
  int nodeLevel;
  int numberOfCategories;

  //List<String> manager;
  List<dynamic> categoryNodeList; // Array di mappe

  CategorySnippet({
    this.nodeName,
    this.nodeId,
    this.nodeLevel,
    this.numberOfCategories,
    this.categoryNodeList,
  });

  CategorySnippet.fromState(CategorySnippet categoryNode) {
    this.nodeName = categoryNode.nodeName;
    this.nodeId = categoryNode.nodeId;
    this.nodeLevel = categoryNode.nodeLevel;
    this.numberOfCategories = categoryNode.numberOfCategories;
    this.categoryNodeList = categoryNode.categoryNodeList;
  }

  CategorySnippet copyWith(
      {String nodeName,
      String nodeId,
      int nodeLevel,
      int numberOfCategories,
      List<dynamic> categoryNodeList}) {
    return CategorySnippet(
      nodeName: nodeName ?? this.nodeName,
      nodeId: nodeId ?? this.nodeId,
      nodeLevel: nodeLevel ?? this.nodeLevel,
      numberOfCategories: numberOfCategories ?? this.numberOfCategories,
      categoryNodeList: categoryNodeList ?? this.categoryNodeList,
    );
  }

  CategorySnippet.fromJson(Map<String, dynamic> json)
      : nodeName = json['nodeName'],
        nodeId = json['nodeId'],
        nodeLevel = json['nodeLevel'],
        numberOfCategories = json['numberOfCategories'],
        categoryNodeList = json['categoryNodeList'];

  Map<String, dynamic> toJson() => {
        'nodeName': nodeName,
        'nodeId': nodeId,
        'nodeLevel': nodeLevel,
        'numberOfCategories': numberOfCategories,
        'categoryNodeList': categoryNodeList,
      };

  CategorySnippet toEmpty() {
    return CategorySnippet(
        nodeName: "",
        nodeId: "",
        nodeLevel: 0,
        numberOfCategories: 0,
        categoryNodeList: null);
  }
}
