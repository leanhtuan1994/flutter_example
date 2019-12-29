import 'package:bloc/bloc/bloc_provider.dart';
import 'package:bloc/bloc/movie_catalog_bloc.dart';
import 'package:bloc/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

import 'list_one_page.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Movies List'),
              onPressed: () {
                _openPage(context);
              },
            ),
            FavoriteButton(
              child: Text('Favorite Movies'),
              bgColor: Colors.transparent,
            ),
            RaisedButton(
              child: Text('One Page'),
              onPressed: () {
                _openOnePage(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _openOnePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListOnePage(),
      );
    }));
  }

  void _openPage(BuildContext context) {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListPage(),
      );
    }));
  }

}
