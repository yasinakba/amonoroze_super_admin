/// ID : "0eca29e1-7738-4ce8-a0e8-ef7d8a6d52de"
/// CreatedAt : "2025-07-19T12:20:57.292783Z"
/// UpdatedAt : "2025-07-19T12:20:57.292783Z"
/// Name : "اردبیل"
/// Cities : null

class ProvinceEntity {
  ProvinceEntity({
      String? id, 
      String? createdAt, 
      String? updatedAt, 
      String? name, 
      dynamic cities,}){
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _name = name;
    _cities = cities;
}

  ProvinceEntity.fromJson(dynamic json) {
    _id = json['ID'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _name = json['Name'];
    _cities = json['Cities'];
  }
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  String? _name;
  dynamic _cities;
ProvinceEntity copyWith({  String? id,
  String? createdAt,
  String? updatedAt,
  String? name,
  dynamic cities,
}) => ProvinceEntity(  id: id ?? _id,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  name: name ?? _name,
  cities: cities ?? _cities,
);
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get name => _name;
  dynamic get cities => _cities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['Name'] = _name;
    map['Cities'] = _cities;
    return map;
  }

}