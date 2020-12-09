import 'package:intl/intl.dart';

class Words{
  String company() => Intl.message("회사",
      name: "company",
      args: [],
      desc: "company message"
  );

  String companyInfomation() => Intl.message("회사 정보",
      name: "companyInfomation",
      args: [],
      desc: "companyInfomation message"
  );

  String userManager() => Intl.message("유저 관리",
      name: "userManager",
      args: [],
      desc: "userManager message"
  );

  String myInfomation() => Intl.message("내 정보",
      name: "myInfomation",
      args: [],
      desc: "myInfomation message"
  );

  String logout() => Intl.message("로그아웃",
      name: "logout",
      args: [],
      desc: "logout message"
  );
}