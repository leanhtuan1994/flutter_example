

import 'dart:async';
import 'dart:collection';

import 'package:bloc/api/tmdp_api.dart';
import 'package:bloc/bloc/bloc_base.dart';
import 'package:bloc/models/movie_genre.dart';
import 'package:bloc/models/movie_genres_list.dart';

class ApplicationBloc implements BlocBase {
  
  StreamController<List<MovieGenre>> _syncController = StreamController<List<MovieGenre>>.broadcast();
  Stream<List<MovieGenre>> get outMovieGenres => _syncController.stream;

  StreamController<List<MovieGenre>> _cmdController = StreamController<List<MovieGenre>>.broadcast();
  StreamSink get getMovieGenres => _cmdController.sink;

  @override
  void dispose() {
    _syncController.close();
    _cmdController.close();
  }

  ApplicationBloc(){
    api.movieGenres().then((list) {
      _genresList = list;
    }); 

    _cmdController.stream.listen((_) {
      _syncController.sink.add(UnmodifiableListView<MovieGenre> (_genresList.genres));

    });
  }

  MovieGenresList _genresList;

}