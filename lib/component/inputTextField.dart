import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Inputtextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;
  final FocusNode? focus;
  final int? maxLength;
  final double? height;
  final double? width;
  final int? minline;
  final int? maxline;
  final List<TextInputFormatter>? inputFormatters;
  final Alignment? alignment;
  final EdgeInsets? padding;
  const Inputtextfield(
      {super.key,
      required this.controller,
      this.onChanged,
      this.validator,
      this.focus,
      this.maxLength,
      this.height,
      this.width,
      required this.keyboardType,
      this.hintText,
      this.minline,
      this.maxline,
      this.inputFormatters,
      this.alignment,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        focusNode: focus,
        maxLength: maxLength,
        onChanged: onChanged,
        maxLines: maxline,
        minLines: minline,
        validator: validator,
        inputFormatters: [],
        style: const TextStyle(
            color: Color(0xFF09090B),
            fontWeight: FontWeight.w500,
            fontSize: 14),
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFA2A2A2)),
            counterText: '',
            border: InputBorder.none),
      ),
    );
  }
}
