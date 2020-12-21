import 'package:intl/intl.dart';


class Words {
  static final word = Words();
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

/* 알림 - 경비 */
  String exSetBox() => Intl.message("경비 정산함", name: "exSetBox", args: [], desc: "expense settlement box message");
  String appForapproval() => Intl.message("결재 신청함", name: "appForapproval", args: [], desc: "application for approval message");
  String exDate() => Intl.message("지출일자", name: "exDate", args: [], desc: "Expenditure date message");
  String category() => Intl.message("항목", name: "category", args: [], desc: "category message");
  String amount() => Intl.message("금액", name: "amount", args: [], desc: "Amount message");
  String receipt() => Intl.message("영수증", name: "receipt", args: [], desc: "Receipt message");
  String state() => Intl.message("상태", name: "state", args: [], desc: "State message");
  String categoryCon() => Intl.message("항목이 없습니다", name: "categoryCon", args: [], desc: "There is no item message");
  String lunch() => Intl.message("중식비", name: "lunch", args: [], desc: "lunch message");
  String dinner() => Intl.message("석식비", name: "dinner", args: [], desc: "dinner message");
  String save() => Intl.message("저장", name: "save", args: [], desc: "save message");
/* 알림 - 경비 종료 */

/* 로그인 및 회원가입 페이지 */
  String login() => Intl.message("로그인", name: "login", args: [], desc: "Login message");
  String name() => Intl.message("이름", name: "name", args: [], desc: "Name message");
  String password() => Intl.message("비밀번호", name: "password", args: [], desc: "password message");
  String passwordConfirm() => Intl.message("비밀번호 확인", name: "passwordConfirm", args: [], desc: "passwordConfirm message");
  String signIn() => Intl.message("로그인", name: "signIn", args: [], desc: " message");
  String signUp() => Intl.message("회원가입", name: "signUp", args: [], desc: "sign up message");
  String birthDay() => Intl.message("생년월일", name: "birthDay", args: [], desc: "birthDay message");
/* 로그인 및 회원가입 페이지 종료*/

  String transportation() => Intl.message("교통비", name: "transportation", args: [], desc: "Transportation fee message");
  String etc() => Intl.message("기타", name: "etc", args: [], desc: "Etc message");

/* 일정 */
  String pleaseTitle() => Intl.message("제목을 입력하세요", name: "pleaseTitle", args: [], desc: "Please enter a title message");
  String dateTime() => Intl.message("일시", name: "dateTime", args: [], desc: "date and time message");
  String addItem() => Intl.message("추가 항목", name: "addItem", args: [], desc: "Additional Items message");
  String outLocation() => Intl.message("외근 장소", name: "outLocation", args: [], desc: "out-of-office location message");
  String outCon() => Intl.message("외근지를 입력하세요", name: "outCon", args: [], desc: "Please enter your outside office message");

  String participant() => Intl.message("참가자", name: "participant", args: [], desc: "participant message");
  String content() => Intl.message("내용", name: "content", args: [], desc: "content message");
  String contentCon() => Intl.message("내용을 입력하세요", name: "contentCon", args: [], desc: "Please enter the content message");
/* 일정 종료 */

/* 사용자 추가 & 삭제 */
  String requestUser() => Intl.message("사용자 추가 요청", name: "requestUser", args: [], desc: "Request Add User message");
  String count() => Intl.message("건", name: "count", args: [], desc: "count message");
  String noDataApprove() => Intl.message("승인할 데이터가 없습니다", name: "noDataApprove", args: [], desc: "No data to approve. message");
  String deleteUser() => Intl.message("사용자 삭제(퇴사자)", name: "deleteUser", args: [], desc: "Delete User(a retired employee) message");
  String deleteUserCon() => Intl.message("삭제할 사용자 이름을 입력하세요", name: "deleteUserCon", args: [], desc: "Please enter the user name you want to message");
  String forAddUser() => Intl.message("님의 사용자 추가 요청", name: "forAddUser", args: [], desc: "'s Request for Add User message");
  String requestDate() => Intl.message("요청일자", name: "requestDate", args: [], desc: "Request date message");
  String noSearch() => Intl.message("검색 결과 없음", name: "noSearch", args: [], desc: "No search results. message");
  String resignationProcess() => Intl.message("님의 퇴사 처리", name: "resignationProcess", args: [], desc: "'s resignation process message");
  String accept() => Intl.message("승낙", name: "accept", args: [], desc: "Accept message");
  String refusal() => Intl.message("거절", name: "refusal", args: [], desc: "refusal message");
/* 사용자 추가/ 삭제 종료 */

/* 권한 */
  String gradeNameUpdate() => Intl.message("권한명 수정하기", name: "gradeNameUpdate", args: [], desc: "Modify Privilege Name message");
  String deleteGrade() => Intl.message("권한 삭제하기", name: "deleteGrade", args: [], desc: "Delete Permissions message");
  String deleteGradeCon() => Intl.message("권한을 삭제하시겠습니까?", name: "deleteGradeCon", args: [], desc: "Are you sure you want to delete the permissions? message");
  String superAdminCon() => Intl.message("최고 관리자는 1명 이하로 삭제 불가능 합니다.", name: "superAdminCon", args: [], desc: "Super Administrator cannot be deleted with less than 1 person message");
  String permissionDetails() => Intl.message("권한 상세 설명", name: "permissionDetails", args: [], desc: "Privilege Detail Description message");
  String addUser() => Intl.message("사용자 추가하기", name: "addUser", args: [], desc: "Add User message");
  String deleteUserPermission() => Intl.message("사용자 삭제하기", name: "deleteUserPermission", args: [], desc: "Delete User message");
  String addPermission() => Intl.message("권한 추가", name: "addPermission", args: [], desc: "Add Permissions message");
  String updateFail() => Intl.message("아직 구현되지 않은 기능입니다", name: "updateFail", args: [], desc: "Feature not yet implemented. message");
  String updateMessage() => Intl.message("업데이트 예정", name: "updateMessage", args: [], desc: "Update scheduled message");
  String buttonCon() => Intl.message("Cancel 버튼을 클릭하여 종료해주세요", name: "buttonCon", args: [], desc: "Please click the button to exit. message");
/* 권한 종료 */

/* 출근 처리 */
  String beforeWork() => Intl.message("출근전", name: "beforeWork", args: [], desc: "before going to work message");
  String leaveWork() => Intl.message("퇴근", name: "leaveWork", args: [], desc: "leave work message");
  String leaveWorkPro() => Intl.message("퇴근처리", name: "leaveWorkPro", args: [], desc: "leave-of-work processing message");
  String leaveWorkProCon() => Intl.message("퇴근 하시겠습니까?", name: "leaveWorkProCon", args: [], desc: " message");
/* 출근 처리 종료 */

/* 조직도 */
  String organizationChart() => Intl.message("조직도", name: "organizationChart", args: [], desc: "Organization chart message");

  String departmentAdd() => Intl.message("부서 추가하기", name: "departmentAdd", args: [], desc: "departmentAdd message");
  String departmentAddCon() => Intl.message("부서명을 입력해주세요", name: "departmentAddCon", args: [], desc: "departmentAdd message");
  String departmentUpdate() => Intl.message("부서명 수정하기", name: "departmentUpdate", args: [], desc: "To amend the department name message");
  String parentDepartmentCreate() => Intl.message("상위 부서 생성하기", name: "parentDepartmentCreate", args: [], desc: "Create a parent department message");
  String subDepartmentCreate() => Intl.message("하위 부서 생성하기", name: "subDepartmentCreate", args: [], desc: "Create a sub department message");
  String departmentDelete() => Intl.message("부서 삭제하기", name: "departmentDelete", args: [], desc: "departmentDelete message");
  String addMember() => Intl.message("구성원 추가하기", name: "addMember", args: [], desc: "Add Members message");
  String deleteMember() => Intl.message("구성원 삭제하기", name: "deleteMember", args: [], desc: "Delete Members message");
  String deleteTeamCon() => Intl.message("부서를 삭제 하시겠습니까?", name: "deleteTeamCon", args: [], desc: "deleteTeamCon message");

/* 조직도 종료 */
  String team() => Intl.message("팀", name: "team", args: [], desc: "team message");
  String position() => Intl.message("직급", name: "position", args: [], desc: "position message");
  String positionCon() => Intl.message("직급을 입력해주세요", name: "positionCon", args: [], desc: "positionCon message");
  String notSelect() => Intl.message("나중에 선택", name: "notSelect", args: [], desc: "notSelect message");
  String positionManagerment() => Intl.message("직급관리", name: "positionManagerment", args: [], desc: "positionManagerment message");

  String positionAdd() => Intl.message("직급 추가하기", name: "positionAdd", args: [], desc: "departmentAdd message");
  String positionAddCon() => Intl.message("직급명을 입력해주세요", name: "positionAddCon", args: [], desc: "tdepartmentAdd message");
  String positionUpdate() => Intl.message("직급명 수정하기", name: "positionUpdate", args: [], desc: "To amend the department name message");
  String positionDelete() => Intl.message("직급 삭제하기", name: "positionDelete", args: [], desc: "departmentDelete message");
  String deletePositionCon() => Intl.message("직급을 삭제 하시겠습니까?", name: "deletePositionCon", args: [], desc: "deleteTeamCon message");

  String enteredDate() => Intl.message("입사일", name: "enteredDate", args: [], desc: "Entered date message");
  String enteredDateCon() => Intl.message("입사일을 입력해주세요", name: "enteredDateCon", args: [], desc: "Entered date message");
  String dropAccountCon() => Intl.message("계정을 정말로 삭제 하시겠습니까?", name: "dropAccountCon", args: [], desc: "dropAccountCon message");
  String passwordFail() => Intl.message("패스워드가 틀렸습니다.", name: "passwordFail", args: [], desc: "dropAccountCon message");
  String dropAccountFail() => Intl.message("계정 삭제를 실패하였습니다.", name: "dropAccountFail", args: [], desc: "dropAccountCon message");
  String dropAccountGradeFail() => Intl.message("최고 및 앱 관리자이므로 삭제 불가능합니다. ", name: "dropAccountGradeFail", args: [], desc: "dropAccountCon message");
  String dropAccountCompltedDialog() => Intl.message("계정이 삭제되었습니다.", name: "dropAccountCompltedDialog", args: [], desc: "dropAccountCon message");
  String loginPageGo() => Intl.message("로그인 화면으로 이동", name: "loginPageGo", args: [], desc: "loginPageGo message");


  String singUpWaiting() => Intl.message("승인 대기", name: "singUpWaiting", args: [], desc: "singUpWaiting message");
  String singUpWaitingCon() => Intl.message("회원가입 승인 대기 상태입니다.\n승인 완료 후 이용 가능합니다.", name: "singUpWaitingCon", args: [], desc: "singUpWaiting message");
  
  String workState() => Intl.message("근무상태", name: "workState", args: [], desc: "singUpWaiting message");
  String copyScheduleCon() => Intl.message("복사할 일정을 선택하세요", name: "copyScheduleCon", args: [], desc: "copyScheduleCon message");
  String currentWorkStatus() => Intl.message("현재 동료 근무 현황", name: "currentWorkStatus", args: [], desc: "Current status of co-workers message");
  String nowScheduleBring() => Intl.message("더 보기", name: "nowScheduleBring", args: [], desc: "Current status of co-workers message");
}
