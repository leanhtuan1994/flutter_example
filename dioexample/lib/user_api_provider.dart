import 'package:dio/dio.dart';
import 'package:dioexample/user_res.dart';

class UserApiProvider {
  final String _endPoint = "https://randomuser.me/api/";
  final Dio _dio = Dio();

  Future<UserResponse> getUser() async {
    try {
      Response response = await _dio.get(_endPoint);
      return UserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Error: $stacktrace');
    }
    
  }

}
