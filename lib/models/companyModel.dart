/*
회사명 <companyName>
회사코드 <companyCode>
회사주소 <companyAddr>
<추가예정>
*/

class Company {
  String id; //Document ID
  String companyName;
  String companyCode;
  String companyAddr;
  List<dynamic> companySearch;

  Company({
    this.id,
    this.companyName,
    this.companyCode,
    this.companyAddr,
    this.companySearch,
  });

  Company.fromMap(Map snapshot, String id)
      : id = id ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        companyAddr = snapshot["companyAddr"] ?? "",
        companySearch = snapshot["companySearch"] ?? [];

  toJson() {
    return {
      "companyName": companyName,
      "companyCode": companyCode,
      "companyAddr": companyAddr,
      "companySearch": companySearch,
    };
  }
}
