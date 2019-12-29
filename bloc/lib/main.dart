
import 'package:bloc/bloc/application_bloc.dart';
import 'package:bloc/bloc/bloc_provider.dart';
import 'package:bloc/bloc/favorite_bloc.dart';
import 'package:bloc/pages/home_page.dart';
import 'package:flutter/material.dart';


Future<void> main() async {

  runApp(
    BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider<FavoriteBloc>(
        bloc: FavoriteBloc(),
        child: MyApp(),
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
}

