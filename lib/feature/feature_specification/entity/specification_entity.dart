/// category_id : "string"
/// created_at : "string"
/// description : "string"
/// guide_video : "string"
/// id : "string"
/// is_required : true
/// options : [{"id":"string","order":0,"value":"string"}]
/// order : 0
/// title : "string"
/// type : "input_single"
/// updated_at : "string"

class SpecificationEntity {
  SpecificationEntity({
      String? categoryId, 
      String? createdAt, 
      String? description, 
      String? guideVideo, 
      String? id, 
      bool? isRequired, 
      List<Options>? options, 
      num? order, 
      String? title, 
      String? type, 
      String? updatedAt,}){
    _categoryId = categoryId;
    _createdAt = createdAt;
    _description = description;
    _guideVideo = guideVideo;
    _id = id;
    _isRequired = isRequired;
    _options = options;
    _order = order;
    _title = title;
    _type = type;
    _updatedAt = updatedAt;
}

  SpecificationEntity.fromJson(dynamic json) {
    _categoryId = json['category_id'];
    _createdAt = json['created_at'];
    _description = json['description'];
    _guideVideo = json['guide_video'];
    _id = json['id'];
    _isRequired = json['is_required'];
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
    _order = json['order'];
    _title = json['title'];
    _type = json['type'];
    _updatedAt = json['updated_at'];
  }
  String? _categoryId;
  String? _createdAt;
  String? _description;
  String? _guideVideo;
  String? _id;
  bool? _isRequired;
  List<Options>? _options;
  num? _order;
  String? _title;
  String? _type;
  String? _updatedAt;
SpecificationEntity copyWith({  String? categoryId,
  String? createdAt,
  String? description,
  String? guideVideo,
  String? id,
  bool? isRequired,
  List<Options>? options,
  num? order,
  String? title,
  String? type,
  String? updatedAt,
}) => SpecificationEntity(  categoryId: categoryId ?? _categoryId,
  createdAt: createdAt ?? _createdAt,
  description: description ?? _description,
  guideVideo: guideVideo ?? _guideVideo,
  id: id ?? _id,
  isRequired: isRequired ?? _isRequired,
  options: options ?? _options,
  order: order ?? _order,
  title: title ?? _title,
  type: type ?? _type,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get categoryId => _categoryId;
  String? get createdAt => _createdAt;
  String? get description => _description;
  String? get guideVideo => _guideVideo;
  String? get id => _id;
  bool? get isRequired => _isRequired;
  List<Options>? get options => _options;
  num? get order => _order;
  String? get title => _title;
  String? get type => _type;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = _categoryId;
    map['created_at'] = _createdAt;
    map['description'] = _description;
    map['guide_video'] = _guideVideo;
    map['id'] = _id;
    map['is_required'] = _isRequired;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    map['order'] = _order;
    map['title'] = _title;
    map['type'] = _type;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// id : "string"
/// order : 0
/// value : "string"

class Options {
  Options({
      String? id, 
      num? order, 
      String? value,}){
    _id = id;
    _order = order;
    _value = value;
}

  Options.fromJson(dynamic json) {
    _id = json['id'];
    _order = json['order'];
    _value = json['value'];
  }
  String? _id;
  num? _order;
  String? _value;
Options copyWith({  String? id,
  num? order,
  String? value,
}) => Options(  id: id ?? _id,
  order: order ?? _order,
  value: value ?? _value,
);
  String? get id => _id;
  num? get order => _order;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order'] = _order;
    map['value'] = _value;
    return map;
  }

}