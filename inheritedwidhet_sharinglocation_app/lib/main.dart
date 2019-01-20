import 'package:flutter/material.dart';
import 'location_context.dart';

const MAPS_API_KEY = 'AIzaSyALNDQD8ADi-tkqFLEWLaHaMA6s-bGSCZA';

void main() => runApp(LocationContextExampleApp());

class LocationContextExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocationContext.around(

      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MapViewPage(),
      ),
    );
  }
}

class MapViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final LocationContext loc = LocationContext.of(context);
    final Size size = MediaQuery.of(context).size;

    final List<Widget> children = List();

    // If we had an error fetching our location, display it in red
    if (loc.error != null) {
      children.add(Center(
        child: Text('Error ${loc.error}', style: TextStyle(color: Colors.red)),
      ));
    } else {
      // Otherwise, load a static image of a map centered on the current location. Make sure to add a marker so we know where it is.
      final Position pos = loc.currentLocation;
      if (pos != null) {
        Uri uri = Uri.https('maps.googleapis.com', 'maps/api/staticmap', {
          'center': '${pos.latitude},${pos.longitude}',
          'zoom': '18',
          'size': '${size.width.floor()}x${size.height.floor()}',
          'key': MAPS_API_KEY,
          'markers': 'color:blue|size:small|${pos.latitude},${pos.longitude}',
        });

        children.addAll(<Widget>[
          // Stretch the google map image
          Expanded(
            child: Image.network(uri.toString()),
          ),
          // Add some text to tell us what our actual coordinates are
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Center(child: Text('Latitude: ${pos.latitude}'))),
              Expanded(child: Center(child: Text('Longitude: ${pos.longitude}'))),
            ],
          ),
        ]);
      } else {
        // There was no error, but also no currentLocation
        children.add(Center(child: Text('Location Not Found')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Location Context Example'),
      ),
      body: Column(
        children: children,
      ),
    );
  }
}