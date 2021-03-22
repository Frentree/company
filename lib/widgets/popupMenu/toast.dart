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

toastNoItems(BuildContext context) {
  Toast.show("No Items", context, duration: 2, gravity: Toast.BOTTOM);
}

toastAppClose(BuildContext context) {
  Toast.show("'뒤로'버튼 한번 더 누르시면 앱이 종료됩니다.", context, duration: 2, gravity: Toast.BOTTOM);
}