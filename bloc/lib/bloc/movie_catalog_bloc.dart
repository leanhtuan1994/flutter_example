import 'dart:collection';

import 'package:bloc/api/tmdp_api.dart';
import 'package:bloc/bloc/bloc_base.dart';
import 'package:bloc/models/movie_card.dart';
import 'package:bloc/models/movie_filter.dart';
import 'package:bloc/models/movie_page_result.dart';
import 'package:rxdart/rxdart.dart';

class MovieCatalogBloc implements BlocBase {
  ///
  /// Max number of movies per fetched page
  ///
  final int _moviesPerPage = 20;

  ///
  /// Genre
  ///
  int _genre = 28;

  ///
  /// Release date min
  ///
  int _minReleaseDate = 2000;

  ///
  /// Release date max
  ///
  int _maxReleaseDate = 2005;

  ///
  /// Total number of movies in the catalog
  ///
  int _totalMovies = -1;

  ///
  /// List of all the movie pages that have been fetched from Internet.
  /// We use a [Map] to store them, so that we can identify the pageIndex
  /// more easily.
  ///
  final _fetchPages = <int, MoviePageResult>{};

  ///
  /// List of the pages, currently being fetched from Internet
  ///
  final _pagesBeingFetched = Set<int>();

  ///
  /// We are going to need the list of movies to be displayed
  ///
  PublishSubject<List<MovieCard>> _moviesController =
      PublishSubject<List<MovieCard>>();
  Sink<List<MovieCard>> get _inMoviesList => _moviesController.sink;
  Stream<List<MovieCard>> get outMoviesList => _moviesController.stream;

  PublishSubject<int> _indexController = PublishSubject<int>();
  Sink<int> get inMovieIndex => _indexController.sink;

  BehaviorSubject<int> _totalMoviesController = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<List<int>> _releaseDatesController =
      BehaviorSubject<List<int>>.seeded([2000, 2005]);
  BehaviorSubject<int> _genreController = BehaviorSubject<int>.seeded(28);
  Sink<int> get _inTotalMovies => _totalMoviesController.sink;
  Stream<int> get outTotalMovies => _totalMoviesController.stream;
  Sink<List<int>> get _inReleaseDates => _releaseDatesController.sink;
  Stream<List<int>> get outReleaseDates => _releaseDatesController.stream;
  Sink<int> get _inGenre => _genreController.sink;
  Stream<int> get outGenre => _genreController.stream;

  BehaviorSubject<MovieFilters> _filtersController =
      BehaviorSubject<MovieFilters>.seeded(
          MovieFilters(genre: 28, minReleaseDate: 2000, maxReleaseDate: 2005));
  Sink<MovieFilters> get inFilters => _filtersController.sink;
  Stream<MovieFilters> get outFilters => _filtersController.stream;

  MovieCatalogBloc() {
    _indexController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isEmpty)
        .listen(_handleIndexes);

    outFilters.listen(_handleFilters);
  }

  @override
  void dispose() {
    _moviesController.close();
    _indexController.close();
    _totalMoviesController.close();
    _releaseDatesController.close();
    _genreController.close();
    _filtersController.close();
  }

  void _handleIndexes(List<int> indexes) {
    indexes.forEach((int index) {
      final int pageIndex = 1 + ((index + 1) ~/ _moviesPerPage);

      if (_fetchPages.containsKey(pageIndex)) {
        if (!_pagesBeingFetched.contains(pageIndex)) {
          _pagesBeingFetched.add(pageIndex);

          api
              .pagedList(
                  pageIndex: pageIndex,
                  genre: _genre,
                  minYear: _minReleaseDate,
                  maxYear: _maxReleaseDate)
              .then((MoviePageResult fetchedPage) =>
                  _handleFetchedPage(fetchedPage, pageIndex));
        }
      }
    });
  }

  void _handleFetchedPage(MoviePageResult page, int pageIndex) {

    _fetchPages[pageIndex] = page;
    _pagesBeingFetched.remove(pageIndex);
   
    List<MovieCard> movies = <MovieCard>[];
    List<int> pageIndexes = _fetchPages.keys.toList();
    pageIndexes.sort((a, b) => a.compareTo(b));

    final int minPageIndex = pageIndexes[0];
    final int maxPageIndex = pageIndexes[pageIndexes.length - 1];


    if (minPageIndex == 1){
      for (int i = 1; i <= maxPageIndex; i++){
        if (!_fetchPages.containsKey(i)){
          // As soon as there is a hole, stop
          break;
        }
        // Add the list of fetched movies to the list
        movies.addAll(_fetchPages[i].movies);
      }
    }

    if (_totalMovies == -1){
      _totalMovies = page.totalResults;
      _inTotalMovies.add(_totalMovies);
    }

    // Only notify when there are movies
    if (movies.length > 0){
      _inMoviesList.add(UnmodifiableListView<MovieCard>(movies));
    }
  }

  void _handleFilters(MovieFilters result) {
     // First, let's record the new filter information
    _minReleaseDate = result.minReleaseDate;
    _maxReleaseDate = result.maxReleaseDate;
    _genre = result.genre;

    // Then, we need to reset
    _totalMovies = -1;
    _fetchPages.clear();
    _pagesBeingFetched.clear();

    // Let's notify who needs to know
    _inGenre.add(_genre);
    _inReleaseDates.add(<int>[_minReleaseDate, _maxReleaseDate]);
    _inTotalMovies.add(0);

    // we need to tell about a change so that we pick another list of movies
    _inMoviesList.add(<MovieCard>[]);
  }
}
