
import 'package:dioexample/user_repository.dart';
import 'package:dioexample/user_res.dart';
import 'package:rxdart/subjects.dart';

class UserBloc {
  final UserRepository _userRepository = UserRepository();

  final BehaviorSubject<UserResponse> _subject = BehaviorSubject<UserResponse>();

  getUser() async {
    UserResponse response = await _userRepository.getUser();
    _subject.sink.add(response);
  }

  disponse(){
    _subject.close();
  }

  BehaviorSubject<UserResponse> get subject => _subject;
  
}

final bloc = UserBloc();