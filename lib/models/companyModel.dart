/*
회사명 <companyName>
회사코드 <companyCode>
회사주소 <companyAddr>
회사전화번호 <companyPhoneNumber>
사업자번호 <businessNumber>
회사로고<companyLogo>
회사홈페이지<companyLink>
회사출퇴근
<추가예정>
*/

class Company {
  String id; //Document ID
  String companyName;
  String companyCode;
  String companyAddr;
  String companyPhone;
  String companyNo;
  String companyPhoto;
  String companyWeb;
  List<dynamic> companySearch;

  Company({
    this.id,
    this.companyName,
    this.companyCode,
    this.companyAddr,
    this.companyPhone,
    this.companyNo,
    this.companyPhoto,
    this.companyWeb,
    this.companySearch,
  });

  Company.fromMap(Map snapshot, String id)
      : id = id ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        companyAddr = snapshot["companyAddr"] ?? "",
        companyPhone = snapshot["companyPhone"] ?? "",
        companyNo = snapshot["companyNo"] ?? "",
        companyPhoto = snapshot["companyPhoto"] ?? "",
        companyWeb = snapshot["companyWeb"] ?? "",
        companySearch = snapshot["companySearch"] ?? [];
  toJson() {
    return {
      "companyName": companyName,
      "companyCode": companyCode,
      "companyAddr": companyAddr,
      "companyPhone": "",
      "companyNo": "",
      "companyPhoto": "",
      "companyWeb": "",
      "companySearch": companySearch,
    };
  }
}
