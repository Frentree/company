//Repos
import 'package:companyplaylist/repos/login/validationMethod.dart';

class LoginRepository{
  Validation _validation = Validation();

  bool isFormValidation (bool validationFunction) => _validation.isFormValidation(validationFunction);
  String validationRegExpCheckMessage(String field, String value) => _validation.validationRegExpCheckMessage(field, value);
  String duplicateCheckMessage(String originalValue, String checkValue) => _validation.duplicateCheckMessage(originalValue, checkValue);
}


