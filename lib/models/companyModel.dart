/*
회사명 <companyName>
회사코드 <companyCode>
회사주소 <companyAddr>
회사전화번호 <companyPhoneNumber>
사업자번호 <businessNumber>
회사로고<companyLogo>
회사홈페이지<companyLink>
<추가예정>
*/

class Company {
  String id; //Document ID
  String companyName;
  String companyCode;
  String companyAddr;
  String companyPhoneNumber;
  String businessNumber;
  String companyLogo;
  String companyLink;
  List<dynamic> companySearch;

  Company({
    this.id,
    this.companyName,
    this.companyCode,
    this.companyAddr,
    this.companyPhoneNumber,
    this.businessNumber,
    this.companyLogo,
    this.companyLink,
    this.companySearch,
  });

  Company.fromMap(Map snapshot, String id)
      : id = id ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        companyAddr = snapshot["companyAddr"] ?? "",
        companyPhoneNumber = snapshot["companyPhoneNumber"] ?? "",
        businessNumber = snapshot["businessNumber"] ?? "",
        companyLogo = snapshot["companyLogo"] ?? "",
        companyLink = snapshot["companyLink"] ?? "",
        companySearch = snapshot["companySearch"] ?? [];

  toJson() {
    return {
      "companyName": companyName,
      "companyCode": companyCode,
      "companyAddr": companyAddr,
      "companyPhoneNumber": companyPhoneNumber,
      "businessNumber": businessNumber,
      "companyLogo": companyLogo,
      "companyLink": companyLink,
      "companySearch": companySearch,
    };
  }
}
