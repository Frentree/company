/*
이름 <name>
이메일 <mail>
핸드폰번호 <phone>
<추가예정>
*/

class User {
  String id; //Document ID
  String name;
  String mail;
  String phone;

  User({
    this.id,
    this.name,
    this.mail,
    this.phone,
  });

  User.fromMap(Map snapshot, String id) :
        id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        phone = snapshot["phone"] ?? "";

  toJson(){
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
    };
  }
}