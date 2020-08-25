//사용자 정보 데이터 모델입니다.

/*
컬렉션 이름 : user_info
데이터 내용
  계정 <account>
  비밀번호 <password>
  이름 <name>
  직급 <rank>
 */

class UserInfo {
  String id; //Document ID
  String account;
  String password;
  String name;
  String rank;

  UserInfo({
    this.id,
    this.account,
    this.password,
    this.name,
    this.rank
  });

  UserInfo.fromMap(Map snapshot, String id) :
    id = id ?? '',
    account = snapshot['account'] ?? '',
    password = snapshot['password'] ?? '',
    name = snapshot['name'] ?? '',
    rank = snapshot['rank'] ?? '';

  toJon() {
    return {
      "account": account,
      "password": password,
      "name": name,
      "rank": rank,
    };
  }
}