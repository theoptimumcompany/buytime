
class CategoryTree {
  String nodeName;
  String nodeId;
  int nodeLevel;
  List<dynamic> categoryNodeList; // Array di mappe che costruisce l'albero delle categorie

  CategoryTree({
    this.nodeName,
    this.nodeId,
    this.nodeLevel,
    this.categoryNodeList,
  });

  CategoryTree.fromState(CategoryTree categoryNode) {
    this.nodeName = categoryNode.nodeName;
    this.nodeId = categoryNode.nodeId;
    this.nodeLevel = categoryNode.nodeLevel;
    this.categoryNodeList = categoryNode.categoryNodeList;
  }

  CategoryTree copyWith(
      {String nodeName,
      String nodeId,
      int nodeLevel,
      List<dynamic> categoryNodeList}) {
    return CategoryTree(
      nodeName: nodeName ?? this.nodeName,
      nodeId: nodeId ?? this.nodeId,
      nodeLevel: nodeLevel ?? this.nodeLevel,
      categoryNodeList: categoryNodeList ?? this.categoryNodeList,
    );
  }

  CategoryTree toEmpty() {
    return CategoryTree(
      nodeName: "",
      nodeId: "",
      nodeLevel: 0,
      categoryNodeList: null,
    );
  }
}
