class EndPoints {
  //BaseUrl
  static const String baseUrl = 'http://192.168.0.70:3030/api';
  // static const String baseUrl = 'http://10.0.2.2:3030/api';

  //로그인
  static const String login = '$baseUrl/auth/login';

  //MBTI
  static String mbtiTest(int page) => '$baseUrl/mbti/test?page=$page';
  static const String mbtiSumit = '$baseUrl/mbti/submit'; //제출
  static const String mbtiDetail = '$baseUrl/mbti/detail';
  static const String mbtiTodo = '$baseUrl/analysis/todo';
}