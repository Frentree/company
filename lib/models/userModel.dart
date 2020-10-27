/*
이름 <name>
이메일 <mail>
핸드폰번호 <phone>
회사코드 <companyCode>
회사이름 <companyName>
출퇴근 상태 <state>
프로필 이미지 <image>
*/

class User {
  String id; //Document ID
  String name;
  String mail;
  String phone;
  String companyName;
  String companyCode;
  int state;
  String image;

  User({
    this.id,
    this.name,
    this.mail,
    this.phone,
    this.companyName,
    this.companyCode,
    this.state,
    this.image
  });

  User.fromMap(Map snapshot, String id) :
        id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        phone = snapshot["phone"] ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        state = snapshot["state"] ?? 0,
        image = snapshot["image"] ?? "";

  toJson(){
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "companyName": companyName,
      "companyCode": companyCode,
      "state": state,
      "image": image,
    };
  }
}