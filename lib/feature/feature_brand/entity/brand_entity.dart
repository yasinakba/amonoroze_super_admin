/// description : "string"
/// id : "string"
/// logo : "string"
/// name : "string"

class BrandEntity {
  BrandEntity({
      String? description, 
      String? id, 
      String? logo, 
      String? name,}){
    _description = description;
    _id = id;
    _logo = logo;
    _name = name;
}

  BrandEntity.fromJson(dynamic json) {
    _description = json['description'];
    _id = json['id'];
    _logo = json['logo'];
    _name = json['name'];
  }
  String? _description;
  String? _id;
  String? _logo;
  String? _name;
BrandEntity copyWith({  String? description,
  String? id,
  String? logo,
  String? name,
}) => BrandEntity(  description: description ?? _description,
  id: id ?? _id,
  logo: logo ?? _logo,
  name: name ?? _name,
);
  String? get description => _description;
  String? get id => _id;
  String? get logo => _logo;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['id'] = _id;
    map['logo'] = _logo;
    map['name'] = _name;
    return map;
  }

}