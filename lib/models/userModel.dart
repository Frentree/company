/*
이름 <name>
이메일 <mail>
핸드폰번호 <phone>
회사코드 <companyCode>
회사이름 <companyName>
*/

class User {
  String id; //Document ID
  String name;
  String mail;
  String phone;
  String companyName;
  String companyCode;
  String profilePhoto;

  User({
    this.id,
    this.name,
    this.mail,
    this.phone,
    this.companyName,
    this.companyCode,
    this.profilePhoto,
  });

  User.fromMap(Map snapshot, String id) :
        id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        phone = snapshot["phone"] ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        profilePhoto = snapshot["profilePhoto"] ?? "";

  toJson(){
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "companyName": companyName,
      "companyCode": companyCode,
      "profilePhoto": profilePhoto,
    };
  }
}