part of location_context;

@visibleForTesting
typedef Location LocationFactory();

@visibleForTesting
void mockLocation(LocationFactory mock) {
  _createLocation = mock;
}

LocationFactory _createLocation = () => Location();

class LocationContext extends InheritedWidget {

  final Position currentLocation;
  final Position lastLocation;
  final String error;

  LocationContext._({
    @required this.currentLocation,
    this.lastLocation,
    this.error,
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  static LocationContext of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(LocationContext);
  }

  static Widget around(Widget child, {Key key}) {
    return _LocationContextWrapper(child: child, key: key);
  }
  
  @override
    bool updateShouldNotify(LocationContext  oldWidget) {
      return currentLocation != oldWidget.currentLocation || 
        lastLocation != oldWidget.lastLocation || 
        error != oldWidget.error;
    }
}

class _LocationContextWrapper extends StatefulWidget {
  final Widget child;

  _LocationContextWrapper({Key key, this.child}) : super(key : key);

  @override
  State<StatefulWidget> createState() => new _LocationContextWrapperState();

}

class _LocationContextWrapperState extends State<_LocationContextWrapper> {

  final Location _location = _createLocation();

  String _error;

  Position _currentLocation;
  Position _lastLocation;

  StreamSubscription<Map<String, double>> _locationChangedSubscription;


@override
  void initState() {
    super.initState();

    _locationChangedSubscription = _location.onLocationChanged()
      .listen((Map<String, double> result) {
        final Position nextLocation = Position._fromMap(result);
        setState(() {
          _error = null;
          _lastLocation = _currentLocation;
          _currentLocation = nextLocation;      
        });
      }
    );

    initLocation();
  }


void initLocation() async {
  try {
    final Map<String, double> result = await _location.getLocation();

    setState(() {
      _error = null;
      _lastLocation = Position._fromMap(result);
      _currentLocation = _lastLocation;
    });
  } on PlatformException catch (ex) {
    setState(() {
      if (ex.code == 'PERMISSION_DENIED') {
        _error = 'Location Permission Denied';
      } else if (ex.code == 'PERMISSION_DENIED_NEVER_ASK') {
         _error ='Location Permission Denied. Please open App Settings and enabled Location Permissions';
      }        
    });
  }
}


@override
  void dispose() {
    _locationChangedSubscription?.cancel();

    super.dispose();
  }


@override
  Widget build(BuildContext context) {
     return LocationContext._(
       lastLocation: _lastLocation,
       currentLocation: _currentLocation,
       error: _error,
       child: widget.child,
     );
  }
}
