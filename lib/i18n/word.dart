import 'package:intl/intl.dart';

class Words {
  /* 공통 */
  String input() => Intl.message("입력", name: "input", args: [], desc: "input message");

  String confirm() => Intl.message("확인", name: "confirm", args: [], desc: "confirm message");

  String failed() => Intl.message("실패", name: "failed", args: [], desc: "failed message");

  String select() => Intl.message("선택", name: "select", args: [], desc: "select message");

  String camera() => Intl.message("카메라", name: "camera", args: [], desc: "camera message");

  String gallery() => Intl.message("갤러리", name: "gallery", args: [], desc: "gallery message");

  String update() => Intl.message("수정", name: "update", args: [], desc: "update message");

  String delete() => Intl.message("삭제", name: "delete", args: [], desc: "delete message");

  String ex() => Intl.message("예", name: "ex", args: [], desc: "ex message");

  String Change() => Intl.message("변경", name: "Change", args: [], desc: "Change message");

  String yes() => Intl.message("예", name: "yes", args: [], desc: "yes message");

  String no() => Intl.message("아니오", name: "no", args: [], desc: "no message");

  /* 공통 종료 */

  /* 설정 시작  */
  String companyInfomation() => Intl.message("회사 정보", name: "companyInfomation", args: [], desc: "companyInfomation message");

  String companyName() => Intl.message("회사명", name: "companyName", args: [], desc: "companyName message");

  String businessNumber() => Intl.message("사업자번호", name: "businessNumber", args: [], desc: "businessNumber message");

  String businessNumberCon() => Intl.message("사업자번호를 입력해주세요", name: "businessNumberCon", args: [], desc: "businessNumberCon message");

  String address() => Intl.message("주소", name: "address", args: [], desc: "address message");

  String phone() => Intl.message("전화번호", name: "phone", args: [], desc: "phone message");

  String phoneChangeFiled() => Intl.message("전화번호 변경 실패", name: "phoneChangeFiled", args: [], desc: "phoneChangeFiled message");

  String phoneChangeFiledNoneCon() =>
      Intl.message("전화번호를 아무것도 입력하지 않았습니다", name: "phoneChangeFiledNoneCon", args: [], desc: "phoneChangeFiledNoneCon message");

  String phoneChangeFiledSameCon() =>
      Intl.message("기존 전화번호와 동일합니다", name: "phoneChangeFiledSameCon", args: [], desc: "phoneChangeFiledSameCon message");

  String phoneChangeFiledTyepCon() =>
      Intl.message("유효하지 않은 전화번호 형식입니다", name: "phoneChangeFiledTyepCon", args: [], desc: "phoneChangeFiledTyepCon message");

  String phoneChange() => Intl.message("전화번호 변경", name: "phoneChange", args: [], desc: "phoneChange message");

  String phoneChangeCon() => Intl.message("이 번호로 변경 하시겠습니까?", name: "phoneChangeCon", args: [], desc: "phoneChangeCon message");

  String phoneCon() => Intl.message("전화번호를 입력해주세요", name: "phoneCon", args: [], desc: "phoneCon message");

  String webAddress() => Intl.message("웹사이트", name: "webAddress", args: [], desc: "webAddress message");

  String webAddressCon() => Intl.message("웹사이트를 입력해주세요", name: "webAddressCon", args: [], desc: "webAddressCon message");

  String userManager() => Intl.message("사용자 관리", name: "userManager", args: [], desc: "userManager message");

  String authentication() => Intl.message("인증", name: "authentication", args: [], desc: "authentication message");

  String authenticationSuccessCon() =>
      Intl.message("인증이 완료되었습니다.\n변경될 비밀번호를 입력해주세요", name: "authenticationSuccessCon", args: [], desc: "authenticationSuccessCon message");

  String authenticationFailCon() => Intl.message("인증이 실패 하였습니다", name: "authenticationFailCon", args: [], desc: "authenticationFailCon message");

  String userAddRquestAndDelete() => Intl.message("사용자 추가 요청/삭제", name: "userAddRquestAndDelete", args: [], desc: "userAddRquestAndDelete message");

  String userGradeManager() => Intl.message("사용자 권한 관리", name: "userGradeManager", args: [], desc: "userGradeManager message");

  String myInfomation() => Intl.message("내 정보", name: "myInfomation", args: [], desc: "myInfomation message");

  String myInfomationUpdate() => Intl.message("내 정보 수정", name: "myInfomationUpdate", args: [], desc: "myInfomationUpdate message");

  String currentPassword() => Intl.message("기존 비밀번호", name: "currentPassword", args: [], desc: "currentPassword message");

  String newPassword() => Intl.message("새 비밀번호", name: "newPassword", args: [], desc: "newPassword message");

  String newPasswordConfirm() => Intl.message("새 비밀번호 확인", name: "newPasswordConfirm", args: [], desc: "newPasswordConfirm message");

  String joinDate() => Intl.message("입사일", name: "joinDate", args: [], desc: "joinDate message");

  String email() => Intl.message("이메일", name: "email", args: [], desc: "email message");

  String accountSecession() => Intl.message("계정탈퇴", name: "accountSecession", args: [], desc: "accountSecession message");

  String serviceCenter() => Intl.message("고객센터", name: "serviceCenter", args: [], desc: "serviceCenter message");

  String appVersion() => Intl.message("앱버전", name: "appVersion", args: [], desc: "appVersion message");

  String newVersion() => Intl.message("최신", name: "newVersion", args: [], desc: "newVersion message");

  String logout() => Intl.message("로그아웃", name: "logout", args: [], desc: "logout message");

  /* 설정 종료  */
  /* 스케줄 */
  String my() => Intl.message("나", name: "my", args: [], desc: "my message");

  String workIn() => Intl.message("내근", name: "workIn", args: [], desc: "workIn message");

  String workOut() => Intl.message("외근", name: "workOut", args: [], desc: "workOut message");

  String meeting() => Intl.message("미팅", name: "meeting", args: [], desc: "meeting message");

  String monthly() => Intl.message("월간", name: "monthly", args: [], desc: "monthly message");

  String weekly() => Intl.message("주간", name: "weekly", args: [], desc: "weekly message");

  String daily() => Intl.message("일간", name: "daily", args: [], desc: "daily message");

  String year() => Intl.message("년", name: "year", args: [], desc: "year message");

  String month() => Intl.message("월", name: "month", args: [], desc: "month message");

  String details() => Intl.message("상세", name: "details", args: [], desc: "details message");

  String mySchedule() => Intl.message("나의 일정", name: "mySchedule", args: [], desc: "mySchedule message");

  String colleagueSchedule() => Intl.message("동료 일정", name: "colleagueSchedule", args: [], desc: "colleagueSchedule message");

  String noSchedule() => Intl.message("일정이 없습니다", name: "noSchedule", args: [], desc: "noSchedule message");

  String colleagueTimeSchedule() =>
      Intl.message("이 시각 동료 근무 현황 보기", name: "colleagueTimeSchedule", args: [], desc: "Current Time Colleague Schedule message");
/* 스케줄 종료 */

/* bottom Sheet 타이틀 */
  String addSheduleSelect() => Intl.message("추가할 일정을 선택하세요", name: "addSheduleSelect", args: [], desc: "addSheduleSelect message");

  String workInSchedule() => Intl.message("내근 일정", name: "workInSchedule", args: [], desc: "workInSchedule message");

  String workOutSchedule() => Intl.message("외근 일정", name: "workOutSchedule", args: [], desc: "workOutSchedule message");

  String meetingSchedule() => Intl.message("미팅 일정", name: "meetingSchedule", args: [], desc: "meetingSchedule message");

  String settlement() => Intl.message("경비 정산", name: "settlement", args: [], desc: "settlement message");

  String payroll() => Intl.message("급여 명세", name: "payroll", args: [], desc: "payroll message");

  String notice() => Intl.message("공지사항", name: "notice", args: [], desc: "Notice message");

  String copySchedule() => Intl.message("최근 일정에서 복사", name: "copySchedule", args: [], desc: "Copy from Recent Schedule message");

  String workRequest() => Intl.message("업무 요청", name: "workRequest", args: [], desc: "workRequest message");

  String purchaseItem() => Intl.message("구매 품의", name: "purchaseItem", args: [], desc: "purchaseItem message");
  //String () => Intl.message("", name: "", args: [], desc: " message");
/* bottom Sheet 타이틀 종료 */

/* 알림 */
  String alarm() => Intl.message("알림", name: "alarm", args: [], desc: "alarm message");

  String myApproval() => Intl.message("내 결재함", name: "myApproval", args: [], desc: "My approval message");

  // 내 결재함
  //String () => Intl.message("", name: "", args: [], desc: " message");

  // 공지사항
  String noticeDelete() => Intl.message("공지사항 삭제", name: "noticeDelete", args: [], desc: "noticeDelete message");

  String noticeDeleteCon() => Intl.message("공지사항 내용을 지우시겠습니까?", name: "noticeDeleteCon", args: [], desc: "noticeDeleteCon message");

  String moreDetails() => Intl.message("더보기", name: "moreDetails", args: [], desc: "more details message");

  String comments() => Intl.message("댓글", name: "comments", args: [], desc: "comments message");

  String enterComments() => Intl.message("댓글달기", name: "enterComments", args: [], desc: "Enter Comments message");

  String commentsDeleteCon() => Intl.message("댓글을 정말로 지우시겠습니까?", name: "commentsDeleteCon", args: [], desc: "commentsDeleteCon message");

  String commentsCountHeadCon() => Intl.message("댓글이", name: "commentsCountHeadCon", args: [], desc: "commentsCountHeadCon message");

  String commentsCountTailCon() => Intl.message("개가 있습니다", name: "commentsCountTailCon", args: [], desc: "commentsCountTailCon message");

  String cencel() => Intl.message("취소", name: "cencel", args: [], desc: "cencel message");

  String commentsTo() => Intl.message("님에게 댓글 입력중입니다", name: "commentsTo", args: [], desc: "Entering Comments To message");
  String commnetsUpate() => Intl.message("댓글 수정중입니다", name: "commnetsUpate", args: [], desc: "commnetUpate message");
  String commnetsInput() => Intl.message("댓글을 입력하세요", name: "commnetsInput", args: [], desc: "commnetsInput message");
/* 알림 종료 */

/* 날짜 포맷 */
  String Mon() => Intl.message("월", name: "Mon", args: [], desc: "Mon message");
  String Tue() => Intl.message("화", name: "Tue", args: [], desc: "Tue message");
  String Wed() => Intl.message("수", name: "Wed", args: [], desc: "Wed message");
  String Thu() => Intl.message("목", name: "Thu", args: [], desc: "Thu message");
  String Fri() => Intl.message("금", name: "Fri", args: [], desc: "Fri message");
  String Sat() => Intl.message("토", name: "Sat", args: [], desc: "Sat message");
  String Sun() => Intl.message("일", name: "Sun", args: [], desc: "Sun message");
  String day() => Intl.message("일", name: "day", args: [], desc: "day message");
  String week() => Intl.message("요일", name: "week", args: [], desc: "week message");
  String hour() => Intl.message("시", name: "hour", args: [], desc: "hour message");
  String minute() => Intl.message("분", name: "minute", args: [], desc: "minute message");
  String second() => Intl.message("초", name: "second", args: [], desc: "second message");
/* 날짜 포맷 종료 */

}