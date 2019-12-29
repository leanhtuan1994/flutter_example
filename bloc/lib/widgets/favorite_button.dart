import 'package:bloc/bloc/bloc_provider.dart';
import 'package:bloc/bloc/favorite_bloc.dart';
import 'package:bloc/pages/favorites_page.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  FavoriteButton({Key key, @required this.child, @required this.bgColor}) : super(key: key);

  final Widget child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);

    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return FavoritesPage();
        }));
      },
      color: bgColor,
      elevation: 0.0,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          child,
          Positioned(
            top: -12,
            right: -6,
            child: Material(
              type: MaterialType.circle,
              elevation: 2.0,
              color: Colors.red,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: StreamBuilder<int>(
                    stream: bloc.outTotalFavorie,
                    initialData: 0,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
