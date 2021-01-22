
class CategoryTree {
  String nodeName;
  String nodeId;
  int nodeLevel;
  int numberOfCategories;
  List<dynamic> categoryNodeList; // Array di mappe che costruisce l'albero delle categorie

  CategoryTree({
    this.nodeName,
    this.nodeId,
    this.nodeLevel,
    this.numberOfCategories,
    this.categoryNodeList,
  });

  CategoryTree.fromState(CategoryTree categoryNode) {
    this.nodeName = categoryNode.nodeName;
    this.nodeId = categoryNode.nodeId;
    this.nodeLevel = categoryNode.nodeLevel;
    this.numberOfCategories = categoryNode.numberOfCategories;
    this.categoryNodeList = categoryNode.categoryNodeList;
  }

  CategoryTree copyWith(
      {String nodeName,
      String nodeId,
      int nodeLevel,
      int numberOfCategories,
      List<dynamic> categoryNodeList}) {
    return CategoryTree(
      nodeName: nodeName ?? this.nodeName,
      nodeId: nodeId ?? this.nodeId,
      nodeLevel: nodeLevel ?? this.nodeLevel,
      numberOfCategories: numberOfCategories ?? this.numberOfCategories,
      categoryNodeList: categoryNodeList ?? this.categoryNodeList,
    );
  }

  CategoryTree.fromJson(Map<String, dynamic> json)
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

  CategoryTree toEmpty() {
    return CategoryTree(
      nodeName: "",
      nodeId: "",
      nodeLevel: 0,
      numberOfCategories: 0,
      categoryNodeList: null,
    );
  }
}
