import 'dart:async';

import 'package:bloc/api/tmdp_api.dart';
import 'package:bloc/bloc/bloc_provider.dart';
import 'package:bloc/bloc/favorite_bloc.dart';
import 'package:bloc/bloc/favorite_movie_bloc.dart';
import 'package:bloc/models/movie_card.dart';
import 'package:flutter/material.dart';

class MovieDetailsWidget extends StatefulWidget {
  MovieDetailsWidget({
    Key key,
    this.movieCard,
    this.boxFit: BoxFit.cover,
    @required this.favoritesStream,
  }) : super(key: key);

  final MovieCard movieCard;
  final BoxFit boxFit;
  final Stream<List<MovieCard>> favoritesStream;

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  FavoriteMovieBloc _bloc;
  StreamSubscription _subscription;

  @override
  void initState() {
    _createBloc();
    super.initState();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  @override
  void didUpdateWidget(MovieDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  child: Image.network(
                      api.imageBaseUrl + widget.movieCard.posterPath,
                      fit: widget.boxFit),
                  tag: 'movie_${widget.movieCard.id}',
                ),
                StreamBuilder<bool>(
                  stream: _bloc.outIsFavorite,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: InkWell(
                        onTap: () {
                          if (snapshot.data) {
                            bloc.inRemoveFavorite.add(widget.movieCard);
                          } else {
                            bloc.inAddFavorite.add(widget.movieCard);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(50.0)),
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            snapshot.data
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: snapshot.data ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6.0),
                Text('Vote average: ${widget.movieCard.voteAverage}',
                    style: TextStyle(
                      fontSize: 12.0,
                    )),
                SizedBox(height: 4.0),
                Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
                  child: Text(widget.movieCard.overview),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _createBloc() {
    _bloc = FavoriteMovieBloc(widget.movieCard);
    _subscription = widget.favoritesStream.listen(_bloc.inFavorites.add);
  }

  _disposeBloc() {
    _subscription.cancel();
    _bloc.dispose();
  }
}
