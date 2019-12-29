import 'dart:collection';

import 'package:bloc/bloc/bloc_base.dart';
import 'package:bloc/models/movie_card.dart';
import 'package:rxdart/subjects.dart';

class FavoriteBloc implements BlocBase {
  final Set<MovieCard> _favorites = Set<MovieCard>();

  var _favoriteAddController = BehaviorSubject<MovieCard>();
  Sink<MovieCard> get inAddFavorite => _favoriteAddController.sink;

  var _favoriteRemoveController = BehaviorSubject<MovieCard>();
  Sink<MovieCard> get inRemoveFavorite => _favoriteRemoveController.sink;

  var _favoriteTotalController = BehaviorSubject<int>.seeded(0);
  Sink<int> get _inTotalFavorite => _favoriteTotalController.sink;
  Stream<int> get outTotalFavorie => _favoriteTotalController.stream;

  BehaviorSubject<List<MovieCard>> _favoritesController =
      BehaviorSubject<List<MovieCard>>.seeded([]);
  Sink<List<MovieCard>> get _inFavorites => _favoritesController.sink;
  Stream<List<MovieCard>> get outFavorites => _favoritesController.stream;

  FavoriteBloc() {
    _favoriteAddController.listen((movieCard) {
      _favorites.add(movieCard);
      _notify();
    });

    _favoriteRemoveController.listen((movieCard){
      _favorites.remove(movieCard);
      _notify();
    });
  }

  void _notify() {
    // Send to whomever is interested...
    // The total number of favorites
    _inTotalFavorite.add(_favorites.length);

    // The new list of all favorite movies
    _inFavorites.add(UnmodifiableListView(_favorites));
  }

  @override
  void dispose() {
    _favoriteAddController.close();
    _favoriteRemoveController.close();
    _favoriteTotalController.close();
    _favoritesController.close();
  }
}
