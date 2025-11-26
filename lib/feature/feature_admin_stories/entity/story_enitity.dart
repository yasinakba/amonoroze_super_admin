/// created_at : "string"
/// creator_id : "string"
/// creator_name : "string"
/// expires_at : "string"
/// id : "string"
/// images : [{"category_id":"string","category_name":"string","duration":0,"id":"string","image_url":"string","link_type":"string","master_product_id":"string","order":0,"product_name":"string"}]
/// is_active : true
/// story_type : "string"
/// title : "string"
/// view_count : 0

class StoryEntity {
  StoryEntity({
      String? createdAt, 
      String? creatorId, 
      String? creatorName, 
      String? expiresAt, 
      String? id, 
      List<Images>? images, 
      bool? isActive, 
      String? storyType, 
      String? title, 
      num? viewCount,}){
    _createdAt = createdAt;
    _creatorId = creatorId;
    _creatorName = creatorName;
    _expiresAt = expiresAt;
    _id = id;
    _images = images;
    _isActive = isActive;
    _storyType = storyType;
    _title = title;
    _viewCount = viewCount;
}

  StoryEntity.fromJson(dynamic json) {
    _createdAt = json['created_at'];
    _creatorId = json['creator_id'];
    _creatorName = json['creator_name'];
    _expiresAt = json['expires_at'];
    _id = json['id'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
    _isActive = json['is_active'];
    _storyType = json['story_type'];
    _title = json['title'];
    _viewCount = json['view_count'];
  }
  String? _createdAt;
  String? _creatorId;
  String? _creatorName;
  String? _expiresAt;
  String? _id;
  List<Images>? _images;
  bool? _isActive;
  String? _storyType;
  String? _title;
  num? _viewCount;
StoryEntity copyWith({  String? createdAt,
  String? creatorId,
  String? creatorName,
  String? expiresAt,
  String? id,
  List<Images>? images,
  bool? isActive,
  String? storyType,
  String? title,
  num? viewCount,
}) => StoryEntity(  createdAt: createdAt ?? _createdAt,
  creatorId: creatorId ?? _creatorId,
  creatorName: creatorName ?? _creatorName,
  expiresAt: expiresAt ?? _expiresAt,
  id: id ?? _id,
  images: images ?? _images,
  isActive: isActive ?? _isActive,
  storyType: storyType ?? _storyType,
  title: title ?? _title,
  viewCount: viewCount ?? _viewCount,
);
  String? get createdAt => _createdAt;
  String? get creatorId => _creatorId;
  String? get creatorName => _creatorName;
  String? get expiresAt => _expiresAt;
  String? get id => _id;
  List<Images>? get images => _images;
  bool? get isActive => _isActive;
  String? get storyType => _storyType;
  String? get title => _title;
  num? get viewCount => _viewCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_at'] = _createdAt;
    map['creator_id'] = _creatorId;
    map['creator_name'] = _creatorName;
    map['expires_at'] = _expiresAt;
    map['id'] = _id;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    map['is_active'] = _isActive;
    map['story_type'] = _storyType;
    map['title'] = _title;
    map['view_count'] = _viewCount;
    return map;
  }

}

/// category_id : "string"
/// category_name : "string"
/// duration : 0
/// id : "string"
/// image_url : "string"
/// link_type : "string"
/// master_product_id : "string"
/// order : 0
/// product_name : "string"

class Images {
  Images({
      String? categoryId, 
      String? categoryName, 
      num? duration, 
      String? id, 
      String? imageUrl, 
      String? linkType, 
      String? masterProductId, 
      num? order, 
      String? productName,}){
    _categoryId = categoryId;
    _categoryName = categoryName;
    _duration = duration;
    _id = id;
    _imageUrl = imageUrl;
    _linkType = linkType;
    _masterProductId = masterProductId;
    _order = order;
    _productName = productName;
}

  Images.fromJson(dynamic json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _duration = json['duration'];
    _id = json['id'];
    _imageUrl = json['image_url'];
    _linkType = json['link_type'];
    _masterProductId = json['master_product_id'];
    _order = json['order'];
    _productName = json['product_name'];
  }
  String? _categoryId;
  String? _categoryName;
  num? _duration;
  String? _id;
  String? _imageUrl;
  String? _linkType;
  String? _masterProductId;
  num? _order;
  String? _productName;
Images copyWith({  String? categoryId,
  String? categoryName,
  num? duration,
  String? id,
  String? imageUrl,
  String? linkType,
  String? masterProductId,
  num? order,
  String? productName,
}) => Images(  categoryId: categoryId ?? _categoryId,
  categoryName: categoryName ?? _categoryName,
  duration: duration ?? _duration,
  id: id ?? _id,
  imageUrl: imageUrl ?? _imageUrl,
  linkType: linkType ?? _linkType,
  masterProductId: masterProductId ?? _masterProductId,
  order: order ?? _order,
  productName: productName ?? _productName,
);
  String? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  num? get duration => _duration;
  String? get id => _id;
  String? get imageUrl => _imageUrl;
  String? get linkType => _linkType;
  String? get masterProductId => _masterProductId;
  num? get order => _order;
  String? get productName => _productName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = _categoryId;
    map['category_name'] = _categoryName;
    map['duration'] = _duration;
    map['id'] = _id;
    map['image_url'] = _imageUrl;
    map['link_type'] = _linkType;
    map['master_product_id'] = _masterProductId;
    map['order'] = _order;
    map['product_name'] = _productName;
    return map;
  }

}