class CategoryEntity {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? image;
  Null? parentID;

  CategoryEntity(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.image,
        this.parentID});

  CategoryEntity.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    title = json['Title'];
    image = json['Image'];
    parentID = json['ParentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['Title'] = this.title;
    data['Image'] = this.image;
    data['ParentID'] = this.parentID;
    return data;
  }
}
