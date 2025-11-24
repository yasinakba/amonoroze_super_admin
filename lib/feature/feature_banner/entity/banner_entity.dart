/// ID : "6456379d-11d5-41c1-8b53-1aa95d5c42c0"
/// CreatedAt : "0001-01-01T00:00:00Z"
/// UpdatedAt : "2025-07-28T12:03:04.284902Z"
/// Title : "Theranff"
/// DestinationID : null
/// Image : ""
/// DestinationScreen : null
/// Level : 1

class BannerEntity {
  BannerEntity({
      String? id, 
      String? createdAt, 
      String? updatedAt, 
      String? title, 
      dynamic destinationID, 
      String? image, 
      dynamic destinationScreen, 
      num? level,}){
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _title = title;
    _destinationID = destinationID;
    _image = image;
    _destinationScreen = destinationScreen;
    _level = level;
}

  BannerEntity.fromJson(dynamic json) {
    _id = json['ID'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _title = json['Title'];
    _destinationID = json['DestinationID'];
    _image = json['Image'];
    _destinationScreen = json['DestinationScreen'];
    _level = json['Level'];
  }
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  String? _title;
  dynamic _destinationID;
  String? _image;
  dynamic _destinationScreen;
  num? _level;
BannerEntity copyWith({  String? id,
  String? createdAt,
  String? updatedAt,
  String? title,
  dynamic destinationID,
  String? image,
  dynamic destinationScreen,
  num? level,
}) => BannerEntity(  id: id ?? _id,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  title: title ?? _title,
  destinationID: destinationID ?? _destinationID,
  image: image ?? _image,
  destinationScreen: destinationScreen ?? _destinationScreen,
  level: level ?? _level,
);
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get title => _title;
  dynamic get destinationID => _destinationID;
  String? get image => _image;
  dynamic get destinationScreen => _destinationScreen;
  num? get level => _level;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['Title'] = _title;
    map['DestinationID'] = _destinationID;
    map['Image'] = _image;
    map['DestinationScreen'] = _destinationScreen;
    map['Level'] = _level;
    return map;
  }

}