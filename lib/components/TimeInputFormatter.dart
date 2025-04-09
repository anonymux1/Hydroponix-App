import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (oldValue.text.contains(":") &&
        !newValue.text.contains(":") &&
        newValue.text.length == 2) {
      return newValue;
    }
    String value = newValue.text;
    if (newValue.text.length == 1) {
      value = int.parse(newValue.text).clamp(0, 5).toString();
    } else if (newValue.text.length == 2) {
      value =
      '${int.parse(newValue.text).clamp(0, 59).toString().padLeft(2, '0')}:';
    } else if (newValue.text.length == 3) {
      value =
      '${int.parse(newValue.text.substring(0, 2)).clamp(0, 59).toString().padLeft(2, '0')}:${int.parse(newValue.text.substring(2)).clamp(0, 5)}';
    } else if (newValue.text.length == 4) {
      value =
      '${newValue.text.substring(0, 2).toString().padLeft(2, '0')}:${int.parse(newValue.text.substring(2)).clamp(0, 59).toString().padLeft(2, '0')}';
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}