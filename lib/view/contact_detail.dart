import 'package:contacts_app/constants.dart';
import 'package:contacts_app/pods/contacts.dart';
import 'package:contacts_app/view/add_contact.dart';
import 'package:contacts_app/widgets/circular_image.dart';
import 'package:contacts_app/widgets/h_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetail extends StatefulHookConsumerWidget {
  ContactDetail({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends ConsumerState<ContactDetail> {
  @override
  Widget build(BuildContext context) {
    var contactPod = ref.read(contactPods);
    var contactPodNotifier = ref.read(contactPods.notifier);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, color: kFontColor)),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddContact(
                              contactModel: contactPod.selectedContactDetail,
                              isNew: false,
                            )));
              },
              child: CircularIcon(
                  icon: Icons.edit_outlined,
                  color: kSecondaryColor.withOpacity(0.6))),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              await contactPodNotifier.deleteContact(
                  context, contactPod.selectedContactDetail!.id!);
            },
            child: CircularIcon(
              icon: Icons.delete,
              color: Colors.red,
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.h,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (contactPod.selectedContactDetail == null ||
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
                    SizedBox(
                      height: 3.h,
                    ),
                    HText(title: contactPod.selectedContactDetail!.name!)
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 25.h,
                  width: 100.w,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: kFontColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HText(
                        title: "Contact Info",
                        color: kFontColor,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (contactPod
                              .selectedContactDetail!.number!.isEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddContact(
                                          contactModel:
                                              contactPod.selectedContactDetail,
                                          isNew: false,
                                        )));
                          } else {
                            launchUrl(Uri.parse(
                                "tel:${contactPod.selectedContactDetail!.number!}"));
                          }
                        },
                        child: contactPod.selectedContactDetail!.number!.isEmpty
                            ? customRow(
                                title: "Add phone number",
                                icon: Icons.call_outlined)
                            : customTile(
                                title:
                                    contactPod.selectedContactDetail!.number!,
                                icon: Icons.call_outlined,
                                type: "Mobile"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (contactPod
                              .selectedContactDetail!.number!.isEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddContact(
                                          contactModel:
                                              contactPod.selectedContactDetail,
                                          isNew: false,
                                        )));
                          }
                        },
                        child: contactPod.selectedContactDetail!.email!.isEmpty
                            ? customRow(
                                title: "Add email", icon: Icons.email_outlined)
                            : customTile(
                                title: contactPod.selectedContactDetail!.email!,
                                icon: Icons.email_outlined,
                                type: "Email"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (contactPod
                          .selectedContactDetail!.birthDate!.isNotEmpty)
                        customTile(
                            title: contactPod.selectedContactDetail!.birthDate!,
                            icon: Icons.date_range_outlined,
                            type: "DOB"),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customRow(
      {bool isRow = true, required String title, required IconData icon}) {
    return isRow
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kSecondaryColor.withOpacity(0.6)),
              const SizedBox(
                width: 10,
              ),
              HText(title: title, color: kSecondaryColor.withOpacity(0.6))
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: kSecondaryColor.withOpacity(0.6)),
              const SizedBox(
                height: 20,
              ),
              HText(title: title, color: kSecondaryColor.withOpacity(0.6))
            ],
          );
  }

  Widget customTile(
      {required String title, required IconData icon, required String type}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kSecondaryColor.withOpacity(0.6)),
        const SizedBox(
          width: 10,
        ),
        HText(title: title, color: kSecondaryColor.withOpacity(0.6)),
      ],
    );
  }
}
