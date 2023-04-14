import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/constants.dart';
import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/widgets/loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

var contactPods =
    StateNotifierProvider<ContactPod, MyContacts>((ref) => ContactPod(ref));

class ContactPod extends StateNotifier<MyContacts> {
  Ref ref;
  ContactPod(this.ref) : super(MyContacts());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ContactModel _contactModel = ContactModel();
  TextEditingController dob = TextEditingController();
  Loader loader = Loader();
  final GlobalKey<SliverAnimatedListState> searchContactKey =
      GlobalKey<SliverAnimatedListState>();
  String getImagePath(String id) {
    try {
      String myContactImagePath =
          "$colContact/${FirebaseAuth.instance.currentUser!.uid}/$id/profile.jpg";
      String myImagePath =
          "$colContact/${FirebaseAuth.instance.currentUser!.uid}/profile.jpg";

      if (FirebaseAuth.instance.currentUser!.uid == id) {
        return myImagePath;
      } else {
        return myContactImagePath;
      }
    } catch (e) {
      return "";
    }
  }

  bool validateContact() {
    bool val = true;

    ContactModel model = state.selectedContactDetail!;
    if (model.number!.isEmpty && model.name!.isEmpty) {
      val = false;
    }
    return val;
  }

  selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context, //context of current state
        initialDate: DateTime(DateTime.now().year - 5),
        firstDate: DateTime(DateTime.now().year -
            100), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
      dob.text = formattedDate;
      _contactModel = state.selectedContactDetail!;
      _contactModel.birthDate = formattedDate;
      state = state.copyWith(
          date: formattedDate, selectedContactDetail: _contactModel);
    } else {
      // return "";
    }
  }

  selectImage() async {
    _contactModel = state.selectedContactDetail!;
    // var status = await Permission.storage.status;
    // if (status.isDenied) {
    //   await Permission.storage.request();
    // }
    PlatformFile? file;
    final image = await FilePicker.platform.pickFiles();
    if (image != null) {
      file = image.files.first;
      _contactModel.img = file.path;
      state = state.copyWith(selectedContactDetail: _contactModel);
    }
  }

  Future<String?> uploadImage(context, String id) async {
    try {
      String path = state.selectedContactDetail!.id ==
              FirebaseAuth.instance.currentUser!.uid
          ? "$colContact/${FirebaseAuth.instance.currentUser!.uid}/profile.jpg"
          : "$colContact/${FirebaseAuth.instance.currentUser!.uid}/${id}/profile.jpg";
      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String filePath = '${appDocDir.absolute}/${state.imagePath}';
      var storage = firebaseStorage.ref().child(path);
      File file = File(state.selectedContactDetail!.img!);
      var uploadTask = storage.putFile(file);

      var data = await uploadTask.whenComplete(() {});
      final downloadUrl = await data.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      loader.hideLoader();
      showToast("Unable to update image");
    }
  }

  reset() {
    dob.clear();
    state = state.copyWith(
      date: "",
      selectedContactDetail: ContactModel(
          name: "", email: "", birthDate: "", id: "", img: "", number: ""),
    );
  }

  resetData() {
    dob.clear();
    state = state.copyWith(
      date: "",
      contacts: [],
      searchedContacts: [],
      selectedContactDetail: ContactModel(
          name: "", email: "", birthDate: "", id: "", img: "", number: ""),
    );
  }

  ///API Calls
  Future fetchContact() async {
    List<ContactModel> contactList = [];
    try {
      contactList = await firestore
          .collection(colContact)
          .where("createdBy",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
          .orderBy("name")
          .get()
          .then((querySnapshot) async {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          ContactModel model = ContactModel();
          contactList.add(model.fromJson(
              querySnapshot.docs[i].data(), querySnapshot.docs[i].id));
        }
        return contactList;
      });
      state =
          state.copyWith(contacts: contactList, searchedContacts: contactList);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  searchContact(String val) {
    List<ContactModel> contactList = [];
    state = state.copyWith(searchedContacts: []);
    List<ContactModel> list = state.contacts!;
    if (val.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].name!.contains(val) ||
            list[i].email!.contains(val) ||
            list[i].number!.contains(val)) {
          // searchContactKey.currentState!.insertItem(i);
          contactList.add(list[i]);
        }
      }
    } else {
      contactList = state.contacts!;
    }

    state = state.copyWith(searchedContacts: contactList);
  }

  Future addUpdateContact(BuildContext context) async {
    try {
      String id = "";
      List<ContactModel> list = state.contacts!;
      ContactModel contactModel = state.selectedContactDetail!;
      loader.showLoader(context, "Uploading Image");

      // state = state.copyWith(selectedContactDetail: contactModel);
      if (contactModel.id!.isNotEmpty) {
        id = contactModel.id!;
      } else {
        id = firestore.collection(colContact).doc().id;
      }
      if (contactModel.img!.isNotEmpty &&
          (!contactModel.img!.contains("http"))) {
        contactModel.img = await uploadImage(context, id);
      }
      contactModel.birthDate = dob.text;

      contactModel.id = id;
      loader.updateLoader();
      await firestore
          .collection(colContact)
          .doc(id)
          .set(contactModel.toJson(contactModel))
          .then((value) {
        if (contactModel.img!.isNotEmpty &&
            (!contactModel.img!.contains("http"))) {
          list.add(contactModel);
        }
        state = state.copyWith(
          contacts: list,
        );
        searchContact("");
        loader.hideLoader();
        showToast("Contact saved");
      });
    } catch (e) {
      loader.hideLoader();
    }
  }

  deleteContact(context, String id) async {
    List<ContactModel> contactList = state.contacts!;
    try {
      ContactModel model =
          state.contacts!.firstWhere((element) => element.id == id);
      loader.showLoader(context);
      // String path = getImagePath(id);
      if (model.img!.isNotEmpty) {
        await firebaseStorage.ref(model.img!).delete().catchError((_, __) {
          showToast(
            "Something went wrong",
          );
        });
      }
      await firestore.collection(colContact).doc(id).delete().then((value) {
        int i = contactList.indexWhere((element) => element.id == id);
        contactList.removeAt(i);
        state = state.copyWith(
            contacts: contactList, searchedContacts: contactList);
        loader.hideLoader();
        showToast(
          "Contact deleted",
        );
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      loader.hideLoader();
      print("Failed with error '${e.code}': ${e.message}");
    } catch (e) {
      loader.hideLoader();
    }
  }
}
