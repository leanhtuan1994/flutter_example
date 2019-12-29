import 'package:bloc/bloc/bloc_provider.dart';
import 'package:bloc/bloc/favorite_bloc.dart';
import 'package:bloc/bloc/movie_catalog_bloc.dart';
import 'package:bloc/models/movie_card.dart';
import 'package:bloc/widgets/favorite_button.dart';
import 'package:bloc/widgets/filters_summary.dart';
import 'package:bloc/widgets/movie_card.dart';
import 'package:bloc/widgets/movie_details_container.dart';
import 'package:flutter/material.dart';

class ListOnePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MovieDetailsContainerState> _movieDetailsKey =
      new GlobalKey<MovieDetailsContainerState>();

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context);
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('List One Page'),
        actions: <Widget>[
          FavoriteButton(
            child: const Icon(Icons.favorite),
            bgColor: Colors.blue,
          ),
          // Icon to open the filters
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FiltersSummary(),
          Container(
            height: 150.0,
            child: StreamBuilder<List<MovieCard>>(
              stream: movieBloc.outMoviesList,
              builder: (BuildContext context, AsyncSnapshot<List<MovieCard>> snapshot) {
                if(snapshot.hasData == false) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index ) {
                    return _buildMovieCard(movieBloc, index, snapshot.data,
                          favoriteBloc.outFavorites);
                  },
                  itemCount: (snapshot.data == null ? 0 : snapshot.data.length) + 5,
                );
              },
            ),
          )
        ],
      ),
    );
  }

    Widget _buildMovieCard(MovieCatalogBloc movieBloc, int index,
      List<MovieCard> movieCards, Stream<List<MovieCard>> favoritesStream) {
    movieBloc.inMovieIndex.add(index);

    // Get the MovieCard data
    final MovieCard movieCard =
        (movieCards != null && movieCards.length > index)
            ? movieCards[index]
            : null;

    // If the movie card is not yet available, display a progress indicator
    if (movieCard == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Otherwise, display the movie card
    return SizedBox(
      width: 150.0,
      child: MovieCardWidget(
        key: Key('movie_${movieCard.id}'),
        movieCard: movieCard,
        favoritesStream: favoritesStream,
        noHero: true,
        onPressed: () {
          _movieDetailsKey.currentState.movieCard = movieCard;
        },
      ),
    );
  }
}
