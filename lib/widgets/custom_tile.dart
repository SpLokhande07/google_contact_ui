import 'package:contacts_app/constants.dart';
import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/widgets/circular_image.dart';
import 'package:contacts_app/widgets/h_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum TileType { myInfo, contactInfo }

class ContactTile extends StatelessWidget {
  TileType? type;
  ContactModel contactModel;
  GestureTapCallback? onTap;
  Widget? widget;
  ContactTile(
      {Key? key,
      type = TileType.contactInfo,
      required this.contactModel,
      this.onTap,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 7.5.h,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: onTap, child: UserTile(contactModel: contactModel)),
          if (type == TileType.contactInfo)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularIcon(
                  icon: Icons.call,
                )
              ],
            ),
          if (widget != null) widget!
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  ContactModel contactModel;
  UserTile({Key? key, required this.contactModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 62.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularImage(imgUrl: contactModel.img!, isContactList: true),
          SizedBox(width: 5.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HText(title: "${contactModel.name}"),
              if (contactModel.number!.isNotEmpty ||
                  contactModel.email!.isNotEmpty)
                HText(
                  title: "${contactModel.number ?? contactModel.email} ",
                  fontSize: 10.sp,
                  color: kHintColor,
                )
            ],
          )
        ],
      ),
    );
  }
}
