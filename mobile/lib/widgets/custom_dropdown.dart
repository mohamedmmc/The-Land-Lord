import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import '../utils/theme/theme.dart';

// ignore: must_be_immutable
class CustomDropDownMenu<T> extends StatefulWidget {
  T? currentItem;
  final String hintText;
  final List<T> items;
  final Function(T?) onSelectItem;
  final String? Function(T?)? validator;
  final double? width;
  final FocusNode? focusNode;
  final bool isOptional;
  final bool withTranslation;
  final double? topPadding;
  final double? textFontSize;
  final double? menuMaxHeight;
  final String Function(T)? valueFrom;

  CustomDropDownMenu({
    required this.hintText, required this.items, required this.onSelectItem, Key? key,
    this.currentItem,
    this.validator,
    this.isOptional = false,
    this.withTranslation = true,
    this.width,
    this.focusNode,
    this.topPadding,
    this.textFontSize,
    this.valueFrom,
    this.menuMaxHeight,
  }) : super(key: key);

  @override
  CustomDropDownMenuState createState() => CustomDropDownMenuState<T>();
}

class CustomDropDownMenuState<T> extends State<CustomDropDownMenu<T>> {
  @override
  Widget build(BuildContext context) => Stack(
      children: <Widget>[
        if (widget.isOptional) const OptionalHint(),
        Container(
          margin: EdgeInsets.only(top: widget.topPadding ?? 20),
          width: widget.width ?? MediaQuery.of(context).size.width,
          child: Stack(children: <Widget>[
            DropdownButtonFormField<T>(
              focusNode: widget.focusNode,
              value: widget.currentItem,
              menuMaxHeight: widget.menuMaxHeight,
              isExpanded: true,
              hint: Center(
                child: Text(
                  widget.hintText,
                  style: AppFonts.x14Regular.copyWith(color: kNeutralColor.withAlpha(150)),
                ),
              ),
              validator: widget.validator,
              onChanged: (value) {
                widget.onSelectItem.call(value);
                setState(() {
                  widget.currentItem = value;
                });
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(right: 15, left: 15, top: 0, bottom: 10),
                border: InputBorder.none,
              ),
              items: widget.items.map<DropdownMenuItem<T>>((value) => DropdownMenuItem<T>(
                  value: value,
                  child: Center(
                    child: Text(
                      widget.withTranslation && T is String ? (value as String).tr : widget.valueFrom?.call(value) ?? value.toString(),
                      style: TextStyle(fontSize: widget.textFontSize),
                    ),
                  ),
                ),).toList(),
            ),
          ],),
        ),
      ],
    );
}

class OptionalHint extends StatelessWidget {
  const OptionalHint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
      top: 10,
      right: 0,
      child: Text(
        'optional_field'.tr,
        style: const TextStyle(fontSize: 8),
      ),
    );
}
