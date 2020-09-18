/*
회사명 <companyName>
회사코드 <companyCode>
<추가예정>
*/

class Company {
  String id; //Document ID
  String companyName;
  String companyCode;

  Company({
    this.id,
    this.companyName,
    this.companyCode,
  });

  Company.fromMap(Map snapshot, String id) :
        id = id ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "";

  toJson(){
    return {
      "companyName": companyName,
      "companyCode": companyCode,
    };
  }
}