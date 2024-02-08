import 'package:flutter/material.dart';
import 'package:the_land_lord_website/services/theme/theme.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

enum ButtonType { elevatePrimary, elevateSecondary, text, icon, iconWithBackground }

// ignore: must_be_immutable
class CustomButtons extends StatelessWidget {
  final ButtonType? buttonType;
  final VoidCallback onPressed;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final double? width;
  final double? height;
  final bool loading;
  final bool disabled;
  final Icon? icon;
  final double? iconSize;
  final Color? iconColor;
  final Color? buttonColor;
  final Size? minimumSize;
  final EdgeInsets? padding;
  final BorderSide? borderSide;

  const CustomButtons.elevatePrimary({
    required this.onPressed,
    Key? key,
    this.title,
    this.titleStyle,
    this.child,
    this.width,
    this.height,
    this.loading = false,
    this.disabled = false,
    this.buttonColor,
    this.padding,
    this.borderSide,
  })  : buttonType = ButtonType.elevatePrimary,
        icon = null,
        iconSize = null,
        iconColor = null,
        minimumSize = null,
        super(key: key);

  const CustomButtons.elevateSecondary({
    required this.onPressed,
    Key? key,
    this.title,
    this.titleStyle,
    this.child,
    this.width,
    this.height,
    this.loading = false,
    this.disabled = false,
    this.padding,
    this.icon,
    this.borderSide,
  })  : buttonType = ButtonType.elevateSecondary,
        iconSize = null,
        iconColor = null,
        buttonColor = null,
        minimumSize = null,
        super(key: key);

  const CustomButtons.text({
    required this.onPressed,
    Key? key,
    this.title,
    this.titleStyle,
    this.child,
    this.disabled = false,
    this.minimumSize,
  })  : assert(title != null || child != null, 'Text button should have a title or a child!'),
        buttonType = ButtonType.text,
        loading = false,
        icon = null,
        borderSide = null,
        width = null,
        height = null,
        iconSize = null,
        iconColor = null,
        buttonColor = null,
        padding = null,
        super(key: key);

  const CustomButtons.icon({
    required this.onPressed,
    this.icon,
    Key? key,
    this.disabled = false,
    this.iconSize,
    this.iconColor,
    this.child,
    this.padding,
  })  : assert(icon != null || child != null, 'Icon button should have an icon or a child'),
        buttonType = ButtonType.icon,
        title = null,
        titleStyle = null,
        width = null,
        height = null,
        borderSide = null,
        loading = false,
        buttonColor = null,
        minimumSize = null,
        super(key: key);

  const CustomButtons.iconWithBackground({
    required this.onPressed,
    Key? key,
    this.disabled = false,
    this.icon,
    this.buttonColor,
    this.padding,
    this.width,
    this.height,
    this.child,
  })  : assert(icon != null || child != null, 'Icon with background button should have an icon or a child'),
        buttonType = ButtonType.iconWithBackground,
        title = null,
        titleStyle = null,
        borderSide = null,
        loading = false,
        iconSize = null,
        iconColor = null,
        minimumSize = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.elevatePrimary:
        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                side: borderSide ?? BorderSide.none,
              ),
            ),
            padding: MaterialStateProperty.all(padding ?? const EdgeInsets.symmetric(horizontal: Paddings.regular)),
            minimumSize: MaterialStateProperty.all(
              Size(
                width ?? 50,
                height ?? 50,
              ),
            ),
            backgroundColor: buttonColor != null
                ? MaterialStateProperty.all(buttonColor)
                : disabled
                    ? MaterialStateProperty.all(Theme.of(context).scaffoldBackgroundColor)
                    : MaterialStateProperty.all(kPrimaryColor),
          ),
          onPressed: disabled || loading
              ? null
              : () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onPressed();
                },
          child: loading
              ? SizedBox(
                  width: (height ?? 50) - 20,
                  height: (height ?? 50) - 20,
                  child: const CircularProgressIndicator(color: Colors.white),
                )
              : child ??
                  Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: titleStyle ?? AppFonts.x16Bold,
                  ),
        );
      case ButtonType.elevateSecondary:
        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                side: borderSide ?? const BorderSide(color: kPrimaryColor),
              ),
            ),
            padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
            minimumSize: MaterialStateProperty.all(
              Size(
                width ?? 50,
                height ?? 50,
              ),
            ),
            backgroundColor: disabled ? MaterialStateProperty.all(Theme.of(context).scaffoldBackgroundColor) : MaterialStateProperty.all(Colors.white),
          ),
          onPressed: disabled || loading
              ? null
              : () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onPressed();
                },
          child: loading
              ? const CircularProgressIndicator(color: kPrimaryColor)
              : icon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Center(
                            child: Text(
                              title ?? '',
                              style: titleStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 17),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: Paddings.regular),
                          child: icon,
                        ),
                      ],
                    )
                  : child ??
                      Text(
                        title ?? '',
                        style: titleStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 17),
                      ),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: disabled
              ? () {}
              : () {
                  onPressed();
                },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            minimumSize: minimumSize != null ? MaterialStateProperty.all(minimumSize) : null,
          ),
          child: child ??
              Text(
                title ?? '',
                style: disabled ? Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: titleStyle?.fontSize ?? 17) : titleStyle ?? AppFonts.x16Regular,
              ),
        );
      case ButtonType.icon:
        return IconButton(
          icon: child ?? icon!,
          disabledColor: kNeutralColor,
          padding: padding ?? const EdgeInsets.all(8.0),
          iconSize: iconSize != null && iconSize! > 0 ? iconSize! : 24.0,
          color: iconColor ?? kSecondaryColor,
          onPressed: disabled
              ? null
              : () {
                  onPressed();
                },
        );
      case ButtonType.iconWithBackground:
        return ElevatedButton(
          onPressed: disabled
              ? () {}
              : () {
                  onPressed();
                },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(RadiusSize.small))),
            minimumSize: Size(width ?? 50, height ?? 50),
            elevation: 0,
            padding: padding ?? const EdgeInsets.all(Paddings.regular),
            backgroundColor: disabled ? Theme.of(context).scaffoldBackgroundColor : buttonColor ?? kPrimaryColor,
          ),
          child: child ?? icon,
        );
      default:
        return Container();
    }
  }
}
