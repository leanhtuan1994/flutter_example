import 'dart:async';

import 'package:bloc/bloc/bloc_base.dart';
import 'package:bloc/models/movie_card.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteMovieBloc implements BlocBase {
  final BehaviorSubject<bool> _isFavoriteController = BehaviorSubject<bool>();
  Stream<bool> get outIsFavorite => _isFavoriteController.stream;

  final StreamController<List<MovieCard>> _favoritesController =
      StreamController<List<MovieCard>>();
  Sink<List<MovieCard>> get inFavorites => _favoritesController.sink;

  FavoriteMovieBloc(MovieCard movieCard) {
    _favoritesController.stream.map((list) {
      list.any((MovieCard card) => card.id == movieCard.id);
    }).listen((isFavorite) => _isFavoriteController.add(isFavorite));
  }

  @override
  void dispose() {
    _isFavoriteController.close();
    _favoritesController.close(); 
  }
}
