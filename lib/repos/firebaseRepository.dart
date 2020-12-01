import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/repos/firebaseMethod.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<void> saveExpense(ExpenseModel expenseModel) =>
      _firebaseMethods.saveExpense(expenseModel);

  Future<String> getImageUrl(String email) =>
      _firebaseMethods.getImageUrl(email);
}