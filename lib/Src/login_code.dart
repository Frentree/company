import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:companyplaylist/crudmodel/userInfoCRUD.dart';
import 'package:companyplaylist/datamodel2/userInfoModel.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/DataModel/API_model.dart';
import 'package:companyplaylist/locator.dart';

class LoginCheck{
  Future<bool> loginCheck(String email, String password) async{
    bool _loginCheckValue = false;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Api api = Api("user");

    print(Firestore.instance.collection("user").getDocuments());
    await api.getDataCollection().then((doc){
      for(int i = 0; i < doc.documents.length; i++) {
        if(doc.documents.elementAt(i).data["id"] == email){
          if(doc.documents.elementAt(i).data["password"] == password){
            _loginCheckValue = true;
            pref.setString("loginUserName", doc.documents.elementAt(i).data["name"]);
            break;
          }
          else{
            _loginCheckValue = false;
            break;
          }
        }
      }
    });

    return _loginCheckValue;


//    await Firestore.instance.collection("user").getDocuments().then((doc){
//      for(int i = 0; i < doc.documents.length; i++){
//        if(doc.documents.elementAt(i).data["id"] == email){
//          if(doc.documents.elementAt(i).data["password"] == password){
//            _loginCheckValue = true;
//            pref.setString("loginUserName", doc.documents.elementAt(i).data["name"]);
//            pref.setString("loginUserImageURL", doc.documents.elementAt(i).data["imageURL"]);
//            break;
//          }
//          else{
//            _loginCheckValue = false;
//            break;
//          }
//        }
//      }
//    });
//    return _loginCheckValue;
//  }
}}