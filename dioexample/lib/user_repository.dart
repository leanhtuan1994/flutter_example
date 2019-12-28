import 'package:dioexample/user_api_provider.dart';
import 'package:dioexample/user_res.dart';

class UserRepository {
  UserApiProvider _apiProvider = UserApiProvider();
  Future<UserResponse> getUser() {
    return _apiProvider.getUser();
  }
}
