/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

ShopEntity shopEntityFromJson(String str) => ShopEntity.fromJson(json.decode(str));

String shopEntityToJson(ShopEntity data) => json.encode(data.toJson());

class ShopEntity {
    ShopEntity({
        required this.status,
        required this.address,
        required this.createdAt,
        required this.rejectedFields,
        required this.city,
        required this.frontNationalCardImage,
        required this.updatedAt,
        required this.name,
        required this.logo,
        required this.cityId,
        required this.userId,
        required this.video,
        required this.statusDescription,
        required this.referralId,
        required this.nationalCode,
        required this.id,
        required this.backNationalCardImage,
    });

    String status;
    String address;
    DateTime createdAt;
    RejectedFields rejectedFields;
    City city;
    String frontNationalCardImage;
    DateTime updatedAt;
    String name;
    String logo;
    String cityId;
    String userId;
    String video;
    String statusDescription;
    String referralId;
    String nationalCode;
    String id;
    String backNationalCardImage;

    factory ShopEntity.fromJson(Map<dynamic, dynamic> json) => ShopEntity(
        status: json["Status"],
        address: json["Address"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        rejectedFields: RejectedFields.fromJson(json["RejectedFields"]),
        city: City.fromJson(json["City"]),
        frontNationalCardImage: json["FrontNationalCardImage"],
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        name: json["Name"],
        logo: json["Logo"],
        cityId: json["CityId"],
        userId: json["UserId"],
        video: json["Video"],
        statusDescription: json["StatusDescription"],
        referralId: json["ReferralID"],
        nationalCode: json["NationalCode"],
        id: json["ID"],
        backNationalCardImage: json["BackNationalCardImage"],
    );

    Map<dynamic, dynamic> toJson() => {
        "Status": status,
        "Address": address,
        "CreatedAt": createdAt.toIso8601String(),
        "RejectedFields": rejectedFields.toJson(),
        "City": city.toJson(),
        "FrontNationalCardImage": frontNationalCardImage,
        "UpdatedAt": updatedAt.toIso8601String(),
        "Name": name,
        "Logo": logo,
        "CityId": cityId,
        "UserId": userId,
        "Video": video,
        "StatusDescription": statusDescription,
        "ReferralID": referralId,
        "NationalCode": nationalCode,
        "ID": id,
        "BackNationalCardImage": backNationalCardImage,
    };
}

class City {
    City({
        required this.provinceId,
        required this.createdAt,
        required this.id,
        required this.updatedAt,
        required this.name,
    });

    String provinceId;
    DateTime createdAt;
    String id;
    DateTime updatedAt;
    String name;

    factory City.fromJson(Map<dynamic, dynamic> json) => City(
        provinceId: json["ProvinceID"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        id: json["ID"],
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        name: json["Name"],
    );

    Map<dynamic, dynamic> toJson() => {
        "ProvinceID": provinceId,
        "CreatedAt": createdAt.toIso8601String(),
        "ID": id,
        "UpdatedAt": updatedAt.toIso8601String(),
        "Name": name,
    };
}

class RejectedFields {
    RejectedFields({
        required this.additionalProp1,
        required this.additionalProp3,
        required this.additionalProp2,
    });

    String additionalProp1;
    String additionalProp3;
    String additionalProp2;

    factory RejectedFields.fromJson(Map<dynamic, dynamic> json) => RejectedFields(
        additionalProp1: json["additionalProp1"],
        additionalProp3: json["additionalProp3"],
        additionalProp2: json["additionalProp2"],
    );

    Map<dynamic, dynamic> toJson() => {
        "additionalProp1": additionalProp1,
        "additionalProp3": additionalProp3,
        "additionalProp2": additionalProp2,
    };
}
