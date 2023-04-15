import 'package:contacts_app/constants.dart';
import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/pods/contacts.dart';
import 'package:contacts_app/view/home_screen.dart';
import 'package:contacts_app/widgets/circular_image.dart';
import 'package:contacts_app/widgets/custom_textfields.dart';
import 'package:contacts_app/widgets/h_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';

class AddContact extends StatefulHookConsumerWidget {
  ContactModel? contactModel;
  bool isNew;
  AddContact({Key? key, this.contactModel, this.isNew = false})
      : super(key: key);

  @override
  ConsumerState<AddContact> createState() => _AddContactState();
}

class _AddContactState extends ConsumerState<AddContact> {
  ContactModel contactModel = ContactModel();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contactModel != null) {
      contactModel = widget.contactModel!;
      name.text =
          widget.contactModel!.name == null ? "" : widget.contactModel!.name!;
      email.text =
          widget.contactModel!.email == null ? "" : widget.contactModel!.email!;
      phoneNumber.text = widget.contactModel!.number == null
          ? ""
          : widget.contactModel!.number!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var contactPodNotifier = ref.watch(contactPods.notifier);
    var contactPod = ref.watch(contactPods);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (name.text.isNotEmpty ||
                email.text.isNotEmpty ||
                phoneNumber.text.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      backgroundColor: kPrimaryColor,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        width: 80.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: kPrimaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HText(
                                title: "Your changes have not been saved",
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        contactPodNotifier.reset();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const HomeScreen()),
                                            (route) => false);
                                      },
                                      child: HText(
                                          title: "Discard",
                                          color: kSecondaryColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        contactPod.selectedContactDetail =
                                            contactModel;
                                        bool val = contactPodNotifier
                                            .validateContact();
                                        if (!val) {
                                          showToast(
                                              "Contact must have name or number");
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          await contactPodNotifier
                                              .addUpdateContact(
                                                  context, widget.isNew)
                                              .then((value) =>
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const HomeScreen()),
                                                      (route) => false));
                                        }
                                      },
                                      child: HText(
                                          title: "Save",
                                          fontSize: 12.sp,
                                          color: kSecondaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // titlePadding: EdgeInsets.all(16),
                      // content: HText(
                      //   title: "Your changes have not been saved",
                      // ),
                      // actionsPadding: EdgeInsets.all(16),
                      // actions: [
                      // ],
                    );
                  });
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false);
            }
          },
          child: const Icon(Icons.clear, color: kFontColor),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: HText(title: widget.isNew ? "Create contact" : "Update contact"),
        actions: [
          GestureDetector(
            onTap: () async {
              contactPod.selectedContactDetail = contactModel;
              FocusScope.of(context).unfocus();
              bool val = contactPodNotifier.validateContact();
              if (!val) {
                showToast("Contact must have name or number");
              } else {
                await contactPodNotifier
                    .addUpdateContact(context, widget.isNew)
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false));
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kSecondaryColor.withOpacity(0.7)),
              child: Center(
                  child: HText(
                title: "Save",
                color: kFontColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              )),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 100.w,
          child: Column(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30.h,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          contactPodNotifier.selectImage();
                        },
                        child: (contactPod.selectedContactDetail == null ||
                                contactPod.selectedContactDetail!.img!.isEmpty)
                            ? Container(
                                height: 17.h,
                                width: 17.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kSecondaryColor.withOpacity(0.4)),
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: kFontColor,
                                  size: 30.sp,
                                ))
                            : CircularImage(
                                width: 17.h,
                                height: 17.h,
                                imgUrl: contactPod.selectedContactDetail!.img!,
                                // isNetworkFile: contactPod
                                //     .selectedContactDetail!.img!
                                //     .contains("https://")
                              ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      HText(title: widget.isNew ? "Add photo" : "Update photo")
                    ],
                  ),
                ),
              ),
              CustomTextField(
                controller: name,
                hint: "Name",
                prefixIcon: Icons.person,
                onChanged: (val) {
                  contactModel.name = val;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              CustomTextField(
                controller: phoneNumber,
                hint: "Mobile number",
                prefixIcon: Icons.phone,
                validator: (val) {
                  // RegExp reg = RegExp(r"^([7-9]){10}");
                  // bool isValid = reg.hasMatch(val!);
                  // if (val.length == 10 && isValid) {
                  //   contactModel.number = val;
                  // }
                  if (val!.length == 10) {
                    bool isValid = true;
                    int firstDigit = int.parse(val.toString().split('')[0]);
                    if (firstDigit < 7 && firstDigit > 9) {
                      isValid = false;
                    }
                    if (!isValid) {
                      return "Invalid mobile number";
                    } else {
                      return null;
                    }
                  }
                  return "Invalid mobile number";
                },
                inputType: TextInputType.phone,
                onChanged: (val) {
                  // RegExp reg = RegExp(r"^([7-9]){10}");
                  // if (val.length == 10 ) {
                  //   contactModel.number = val;
                  // }
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              CustomTextField(
                controller: email,
                hint: "Email",
                inputType: TextInputType.emailAddress,
                prefixIcon: Icons.alternate_email,
                onChanged: (val) {
                  contactModel.email = val;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              const DateFormField(),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateFormField extends StatefulHookConsumerWidget {
  const DateFormField({Key? key}) : super(key: key);

  @override
  ConsumerState<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends ConsumerState<DateFormField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          String? date;
          await ref.read(contactPods.notifier).selectDate(context);
        } catch (e) {
          print(e);
        }
      },
      child: CustomTextField(
        controller: ref.read(contactPods.notifier).dob,
        onChanged: (value) {},
        validator: (value) {},
        hint: "Date of birth",
        prefixIcon: Icons.date_range_outlined,
        isEnabled: false,
      ),
    );
  }
}
