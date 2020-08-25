import 'package:get_it/get_it.dart';
import 'package:companyplaylist/DataModel/API_model.dart';
import 'package:companyplaylist/DataModel/CRUD_model.dart';
import 'package:companyplaylist/crudmodel/userInfoCRUD.dart';

GetIt locator = GetIt.instance;
GetIt userInfoLocator = GetIt.instance;

void setupLocator() {
  userInfoLocator.registerLazySingleton(() => Api("user_info"));
  userInfoLocator.registerLazySingleton(() => UserInfoCRUD());
  //locator.registerLazySingleton(() => Api("test"));
  //locator.registerLazySingleton(() => Api("test_minji"));
  locator.registerLazySingleton(() => CRUDModel());
  //locator.registerL
}