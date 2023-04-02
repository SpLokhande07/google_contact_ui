import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CircularImage extends StatelessWidget {
  String imgUrl;
  double? width;
  double? height;
  bool isContactList;
  CircularImage({
    Key? key,
    required this.imgUrl,
    this.height,
    this.width,
    this.isContactList = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 5.h,
      width: width ?? 5.h,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: imgUrl.isNotEmpty && imgUrl.contains("https")
            ? CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.fill,
                errorWidget: (
                  BuildContext context,
                  String url,
                  dynamic error,
                ) =>
                    const Center(
                  child: Icon(
                    Icons.error,
                    color: kFontColor,
                  ),
                ),
                placeholder: (_, val) => const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor)),
              )
            : imgUrl.isNotEmpty
                ? Image.file(File(imgUrl), fit: BoxFit.cover)
                : Container(
                    height: 17.h,
                    width: 17.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor.withOpacity(0.4)),
                    child: Icon(
                      isContactList
                          ? Icons.person_2_outlined
                          : Icons.add_a_photo_outlined,
                      color: kFontColor,
                      size: isContactList ? 15.sp : 30.sp,
                    )),
      ),
    );
  }
}

class CircularIcon extends StatelessWidget {
  IconData icon;
  Color? color;
  double? size;
  CircularIcon({Key? key, required this.icon, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5.h,
      height: 5.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: kHintColor.withOpacity(0.1)),
      child: Icon(
        icon,
        color: color ?? kSecondaryColor,
        size: size ?? 15.sp,
      ),
    );
  }
}
