/*
이름 <name>
이메일 <mail>
핸드폰번호 <phone>
회사코드 <companyCode>
<추가예정>
*/

class User {
  String id; //Document ID
  String name;
  String mail;
  String phone;
  String companyCode;

  User({
    this.id,
    this.name,
    this.mail,
    this.phone,
    this.companyCode,
  });

  User.fromMap(Map snapshot, String id) :
        id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        phone = snapshot["phone"] ?? "",
        companyCode = snapshot["companyCode"] ?? "";

  toJson(){
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "companyCode": companyCode,
    };
  }
}