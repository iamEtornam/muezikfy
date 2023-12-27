import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.textController,
    this.validator,
    this.label,
    required this.placeholderText,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.isProfile = false,
    this.suffixIcons,
    this.prefixIcons,
    this.initialText,
    this.onChanged,
    this.maxLines,
    this.labelFontWeight,
    this.onSubmitted,
    this.inputFormatters,
    this.autocorrect = true,
  });

  final TextEditingController? textController;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSubmitted;
  final String? label;
  final String placeholderText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool isProfile;
  final Widget? suffixIcons;
  final Widget? prefixIcons;
  final String? initialText;
  final FontWeight? labelFontWeight;
  final int? maxLines;
  final bool autocorrect;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...{
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 15, fontWeight: labelFontWeight ?? FontWeight.w400),
          ),
          SizedBox(
            height: isProfile ? 7 : 16,
          ),
        },
        TextFormField(
          controller: textController,
          keyboardType: keyboardType,
          initialValue: initialText,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          enabled: enabled,
          maxLines: maxLines,
          autocorrect: autocorrect,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              label: Text(placeholderText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      )),
              alignLabelWithHint: true,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              contentPadding: const EdgeInsets.all(15.0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder:
                  Theme.of(context).inputDecorationTheme.focusedBorder,
              enabledBorder:
                  Theme.of(context).inputDecorationTheme.enabledBorder,
              disabledBorder:
                  Theme.of(context).inputDecorationTheme.disabledBorder,
              errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
              focusedErrorBorder:
                  Theme.of(context).inputDecorationTheme.focusedErrorBorder,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
              errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
              suffixIcon: suffixIcons,
              prefixIcon: prefixIcons),
          cursorColor: Colors.black,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
