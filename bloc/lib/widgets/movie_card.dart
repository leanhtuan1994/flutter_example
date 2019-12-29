import 'dart:async';

import 'package:bloc/api/tmdp_api.dart';
import 'package:bloc/bloc/bloc_provider.dart';
import 'package:bloc/bloc/favorite_bloc.dart';
import 'package:bloc/bloc/favorite_movie_bloc.dart';
import 'package:bloc/models/movie_card.dart';
import 'package:flutter/material.dart';

class MovieCardWidget extends StatefulWidget {
  @override
  _MovieCardWidgetState createState() => _MovieCardWidgetState();

  MovieCardWidget(
      {Key key,
      @required this.movieCard,
      @required this.favoritesStream,
      @required this.onPressed,
      @required this.noHero})
      : super(key: key);

  final MovieCard movieCard;
  final VoidCallback onPressed;
  final Stream<List<MovieCard>> favoritesStream;
  final bool noHero;
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  FavoriteMovieBloc _bloc;

  StreamSubscription _subscription;

  _createBloc() {
    _bloc = FavoriteMovieBloc(widget.movieCard);
    _subscription = widget.favoritesStream.listen(_bloc.inFavorites.add);
  }

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
  void didUpdateWidget(MovieCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  _disposeBloc() {
    _bloc.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);

    List<Widget> children = <Widget>[
      ClipRect(
        clipper: _SquareClipper(),
        child: widget.noHero
            ? Image.network(
                api.imageBaseUrl + widget.movieCard.posterPath,
                fit: BoxFit.cover,
              )
            : Hero(
                tag: 'movie_${widget.movieCard.id}',
                child: Image.network(
                  api.imageBaseUrl + widget.movieCard.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        decoration: _buildGradientBackground(),
        child: _buildTextualInfo(widget.movieCard),
      )
    ];

    children.add(
      StreamBuilder<bool> (
        stream: _bloc.outIsFavorite,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.data == true) {
            return Positioned(
              top: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(50.0)
                
                ),
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onTap: (){
                    bloc.inRemoveFavorite.add(widget.movieCard);
                  },
                ),
              ),
            );
          }
          return Container();
        },
      )
    );

    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: children,
        ),
      ),
    );
  }

    BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(MovieCard movieCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          movieCard.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          movieCard.voteAverage.toString(),
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SquareClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
