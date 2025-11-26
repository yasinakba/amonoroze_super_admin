/// ID : "87b94169-ea94-4f4c-9a71-628e93f9bc7b"
/// CreatedAt : "2025-07-19T12:20:57.292783Z"
/// UpdatedAt : "2025-07-19T12:20:57.292783Z"
/// Name : "اصلاندوز"
/// ProvinceID : "0eca29e1-7738-4ce8-a0e8-ef7d8a6d52de"

class CityEntity {
  CityEntity({
      String? id, 
      String? createdAt, 
      String? updatedAt, 
      String? name, 
      String? provinceID,}){
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _name = name;
    _provinceID = provinceID;
}

  CityEntity.fromJson(dynamic json) {
    _id = json['ID'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _name = json['Name'];
    _provinceID = json['ProvinceID'];
  }
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  String? _name;
  String? _provinceID;
CityEntity copyWith({  String? id,
  String? createdAt,
  String? updatedAt,
  String? name,
  String? provinceID,
}) => CityEntity(  id: id ?? _id,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  name: name ?? _name,
  provinceID: provinceID ?? _provinceID,
);
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get name => _name;
  String? get provinceID => _provinceID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['Name'] = _name;
    map['ProvinceID'] = _provinceID;
    return map;
  }

}