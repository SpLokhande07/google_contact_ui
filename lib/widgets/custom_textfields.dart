import 'package:contacts_app/constants.dart';
import 'package:contacts_app/pods/contacts.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';

class SearchBar extends StatefulHookConsumerWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100.w,
        height: 10.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              decoration: BoxDecoration(
                  color: kFontColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(4),
              child: TextField(
                cursorColor: kHintColor,
                style: const TextStyle(color: kFontColor),
                onChanged: (val) {
                  ref.read(contactPods.notifier).searchContact(val);
                },
                decoration: InputDecoration(
                    // labelStyle: TextStyle(color: kFontColor),
                    fillColor: kSecondaryColor,
                    border: InputBorder.none,
                    prefixIcon:
                        Icon(Icons.search, color: kHintColor, size: 20.sp),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: kHintColor, fontSize: 12.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  IconData? prefixIcon;
  String? hint;
  bool? isEnabled;
  FormFieldValidator<String?>? validator;
  ValueChanged<String>? onChanged;
  TextInputType? inputType;
  CustomTextField(
      {Key? key,
      required this.controller,
      this.prefixIcon,
      this.hint,
      this.isEnabled = true,
      this.validator,
      this.inputType,
      this.onChanged})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.prefixIcon, color: kHintColor),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: kFontColor)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: widget.controller,
                    enabled: widget.isEnabled,
                    keyboardType: widget.inputType ?? TextInputType.text,
                    cursorColor: kHintColor,
                    validator: widget.validator,
                    style: const TextStyle(color: kFontColor),
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                        // labelStyle: TextStyle(color: kFontColor),
                        fillColor: kSecondaryColor,
                        border: InputBorder.none,
                        // prefixIcon: Icon(Icons.search, color: kHintColor, size: 20.sp),
                        hintText: widget.hint ?? "",
                        hintStyle:
                            TextStyle(color: kHintColor, fontSize: 12.sp)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
