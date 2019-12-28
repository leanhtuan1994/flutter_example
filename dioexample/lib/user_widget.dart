import 'package:dioexample/user_res.dart';
import 'package:flutter/material.dart';
import 'user_bloc.dart';

class UserWidget extends StatefulWidget {
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  void initState() {
    bloc.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<UserResponse>(
            stream: bloc.subject.stream,
            builder: (context, AsyncSnapshot<UserResponse> snapshot) {
              if (snapshot.hasData) {
                return _buildUserWidget(snapshot.data);
              } else {
                return _buildLoadingWidget();
              }
            }));
  }

  _buildUserWidget(UserResponse userResponse) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("User widget"),
      ],
    ));
  }

  _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('Loading API...'), CircularProgressIndicator()],
      ),
    );
  }

  @override
  void dispose() {
    bloc.disponse();
    super.dispose();
  }
}
