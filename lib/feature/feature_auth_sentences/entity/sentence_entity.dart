/// ID : "d32f3ad1-4335-4f1f-9daa-1a057a70b932"
/// CreatedAt : "2025-07-21T02:11:04.710361Z"
/// UpdatedAt : "2025-07-21T02:11:04.710361Z"
/// Text : "شیراز"

class SentenceEntity {
  SentenceEntity({
      String? id, 
      String? createdAt, 
      String? updatedAt, 
      String? text,}){
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _text = text;
}

  SentenceEntity.fromJson(dynamic json) {
    _id = json['ID'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _text = json['Text'];
  }
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  String? _text;
SentenceEntity copyWith({  String? id,
  String? createdAt,
  String? updatedAt,
  String? text,
}) => SentenceEntity(  id: id ?? _id,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  text: text ?? _text,
);
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['Text'] = _text;
    return map;
  }

}