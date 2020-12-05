import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      List<String> chars = newValue.text.replaceAll(' ', '').split('');
      String newString = '';

      for (int i = 0; i < chars.length; i++) {
        if (i % 3 == 0 && i != 0) newString += '';
        newString += chars[i];
      }

      var returnString = NumberFormat("###,###", "en_US");
      int temp = int.parse(newString);
      newString = returnString.format(temp);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

CustomTextInputFormatterReverse(String inputCost) {
  int _returnCost;

  var temp = inputCost.replaceAll(",","");
  debugPrint("a value of temp is " + temp);
  _returnCost = int.parse(temp);

  return _returnCost;
}