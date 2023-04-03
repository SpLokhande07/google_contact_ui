import 'package:contacts_app/constants.dart';
import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/pods/auth.dart';
import 'package:contacts_app/pods/contacts.dart';
import 'package:contacts_app/view/add_contact.dart';
import 'package:contacts_app/view/contact_detail.dart';
import 'package:contacts_app/widgets/circular_image.dart';
import 'package:contacts_app/widgets/custom_textfields.dart';
import 'package:contacts_app/widgets/custom_tile.dart';
import 'package:contacts_app/widgets/h_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        ref.read(contactPods.notifier).fetchContact();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var contactPod = ref.watch(contactPods);
    var contactPodNotifier = ref.watch(contactPods.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                backgroundColor: kPrimaryColor,
                title: MyTile(),
              ),
              SliverToBoxAdapter(
                child: SearchBar(),
              ),
              if (contactPod.searchedContacts != null)
                contactPod.searchedContacts!.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: HText(title: "No contact to display"),
                        ),
                      )
                    : SliverAnimatedList(
                        initialItemCount: contactPod.searchedContacts!.length,
                        itemBuilder: (_, i, animation) {
                          return ContactTile(
                            onTap: () {
                              contactPod.selectedContactDetail =
                                  contactPod.searchedContacts![i];

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ContactDetail(
                                          // contactModel:
                                          //     contactPod.searchedContacts![i],
                                          // isNew: false,
                                          )));
                            },
                            type: TileType.contactInfo,
                            contactModel: contactPod.searchedContacts![i],
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (contactPod
                                    .searchedContacts![i].number!.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          "tel:${contactPod.searchedContacts![i].number!}"));
                                    },
                                    child: CircularIcon(
                                      icon: Icons.call,
                                      color: Colors.green,
                                    ),
                                  ),
                                SizedBox(
                                  width: 4.w,
                                ),
                              ],
                            ),
                          );
                        })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddContact(
                          isNew: true,
                        )));
          },
          backgroundColor: kSecondaryColor,
          child: const Icon(Icons.add, color: kFontColor),
        ),
      ),
    );
  }
}

class MyTile extends ConsumerWidget {
  const MyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var authPod = ref.watch(authPods);
    return ContactTile(
      type: TileType.myInfo,
      contactModel: ContactModel.getCurrentUserInfo(),
      widget: GestureDetector(
        onTap: () async {
          await authPod.logout(context);
        },
        child: CircularIcon(
          icon: Icons.logout,
          color: kFontColor,
        ),
      ),
    );
  }
}

class MyContactList extends StatefulHookConsumerWidget {
  const MyContactList({Key? key}) : super(key: key);

  @override
  ConsumerState<MyContactList> createState() => _MyContactListState();
}

class _MyContactListState extends ConsumerState<MyContactList> {
  @override
  Widget build(BuildContext context) {
    var contactPod = ref.read(contactPods);
    return contactPod.searchedContacts != null
        ? SliverAnimatedList(
            initialItemCount: contactPod.searchedContacts!.length,
            itemBuilder: (_, i, animation) {
              return ContactTile(
                type: TileType.contactInfo,
                contactModel: ContactModel.getCurrentUserInfo(),
              );
            })
        : const Center(
            child: CircularProgressIndicator(color: kSecondaryColor),
          );
  }
}
