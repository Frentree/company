import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

toastDelete(BuildContext context) {
  Toast.show("Deleted", context, duration: 2, gravity: Toast.BOTTOM);
}

toastSuccess(BuildContext context) {
  Toast.show("Success", context, duration: 2, gravity: Toast.BOTTOM);
}

toastCreate(BuildContext context) {
  Toast.show("Created", context, duration: 2, gravity: Toast.BOTTOM);
}

toastModified(BuildContext context) {
  Toast.show("Modified", context, duration: 2, gravity: Toast.BOTTOM);
}