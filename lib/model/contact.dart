import 'package:firebase_auth/firebase_auth.dart';

class MyContacts {
  List<ContactModel>? contacts;
  List<ContactModel>? searchedContacts;
  ContactModel? selectedContactDetail;
  String? date = "";
  MyContacts({
    this.contacts,
    this.searchedContacts,
    this.selectedContactDetail,
    this.date = "",
  });

  MyContacts copyWith(
      {List<ContactModel>? contacts,
      List<ContactModel>? searchedContacts,
      ContactModel? selectedContactDetail,
      String? date}) {
    return MyContacts(
      contacts: contacts ?? this.contacts,
      searchedContacts: searchedContacts ?? this.searchedContacts,
      date: date ?? this.date,
      selectedContactDetail:
          selectedContactDetail ?? this.selectedContactDetail,
    );
  }
}

class ContactModel {
  String? id;
  String? name;
  String? img;
  String? number;
  String? email;
  String? birthDate;
  String? createdBy;

  ContactModel(
      {this.birthDate = "",
      this.email = "",
      this.id = "",
      this.name = "",
      this.img = "",
      this.createdBy = "",
      this.number = ""});

  factory ContactModel.getCurrentUserInfo() {
    return ContactModel(
      id: FirebaseAuth.instance.currentUser!.uid,
      number: FirebaseAuth.instance.currentUser!.phoneNumber ?? "",
      img: FirebaseAuth.instance.currentUser!.photoURL ?? "",
      name: FirebaseAuth.instance.currentUser!.displayName ?? "",
      email: FirebaseAuth.instance.currentUser!.email ?? "",
      createdBy: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  fromJson(Map<String, dynamic> json, [String? id]) {
    return ContactModel(
      id: json["id"] ?? id,
      number: json["number"] ?? "",
      img: json['img'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? '',
      birthDate: json['birthdate'] ?? "",
      createdBy: json['createdBy'] ?? "",
    );
  }

  toJson(ContactModel model) {
    return {
      "name": model.name,
      "email": model.email,
      "birthDate": model.birthDate,
      "img": model.img,
      "number": model.number,
      "createdBy": FirebaseAuth.instance.currentUser!.uid
    };
  }

  copyWith(
      {String? name,
      String? img,
      String? number,
      String? email,
      String? birthDate}) {
    return ContactModel(
        birthDate: birthDate ?? this.birthDate,
        email: email ?? this.email,
        name: name ?? this.name,
        img: this.img,
        number: this.number);
  }
}
