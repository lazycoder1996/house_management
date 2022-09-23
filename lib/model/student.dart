import 'dart:convert';

import 'house.dart';

class StudentModel {
  final int id;
  final String name;
  final String programme;
  final HouseModel house;
  final String parentName;
  final String residence;
  final String contact;
  final String? picture;
  final DateTime dob;
  final String status;
  final int year;

  StudentModel({
    required this.id,
    required this.name,
    required this.programme,
    required this.house,
    required this.parentName,
    required this.residence,
    required this.contact,
    this.picture,
    required this.dob,
    required this.status,
    required this.year,
  });

  // StudentModel(
  //     {required this.id,
  //     required this.name,
  //     required this.programme,
  //     required this.house,
  //     required this.parentName,
  //     required this.residence,
  //     required this.contact,
  //     this.picture,
  //     required this.dob,
  //     required this.status});

  StudentModel copyWith({
    required int id,
    required String name,
    required String programme,
    required HouseModel house,
    required String parentName,
    required String residence,
    required String contact,
    String? picture,
    required DateTime dob,
    required String status,
    required int year,
  }) {
    return StudentModel(
      id: id,
      name: name,
      programme: programme,
      house: house,
      parentName: parentName,
      residence: residence,
      contact: contact,
      picture: picture,
      dob: dob,
      status: status,
      year: year,
    );
  }

  StudentModel merge(StudentModel model) {
    return StudentModel(
      id: model.id,
      name: model.name,
      programme: model.programme,
      house: model.house,
      parentName: model.parentName,
      residence: model.residence,
      contact: model.contact,
      picture: model.picture,
      dob: model.dob,
      status: model.status,
      year: model.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'std_id': id,
      'name': name,
      'programme': programme,
      'house': house.toMap(),
      'parent_name': parentName,
      'residence': residence,
      'contact': contact,
      'picture': picture,
      'DOB': dob,
      'status': status,
      'year': year,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
        id: map['std_id'],
        name: map['name'],
        programme: map['programme'],
        house: HouseModel.fromMap(map['house']),
        parentName: map['parent_name'],
        residence: map['residence'],
        contact: map['contact'],
        picture: map['picture'],
        dob: map['DOB'],
        status: map['status'],
        year: map['year'] ?? 1);
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StudentModel(id: $id, name: $name, programme: $programme, house: $house, parentName: $parentName, residence: $residence, contact: $contact, picture: $picture, dob: $dob, status: $status)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StudentModel &&
        o.id == id &&
        o.name == name &&
        o.programme == programme &&
        o.house == house &&
        o.parentName == parentName &&
        o.residence == residence &&
        o.contact == contact &&
        o.picture == picture &&
        o.dob == dob &&
        o.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        programme.hashCode ^
        house.hashCode ^
        parentName.hashCode ^
        residence.hashCode ^
        contact.hashCode ^
        picture.hashCode ^
        dob.hashCode ^
        status.hashCode;
  }
}
