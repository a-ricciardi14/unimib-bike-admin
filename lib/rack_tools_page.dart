//TODO: Impostare nuova LocationDescription() --> Aggiungere chiamata BackEnd per modificare effettvamente il parametro.
//TODO: _showDialog() per modifica parametri --> Modificare funzione così che sia universale per ogni parametro che voglio modificare.
//TODO: Card Position Rack --> Aggiungere onTap() la funzione _showDialog() per la modifica del parametro.
//TODO: Card Available Stands --> Aggiungere onTap() la funzione _showDialog() per la modifica del parametro.
//TODO: Card Available Bikes --> Modificare per renderlo un ExpansionTile così da mostrare la lista di biciclette associata alla Rastrelliera.
//TODO: Card Delete Rack --> Aggiungere chiamata BackEnd per cancellare effettivamente la rastrelliera.

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:geolocator/geolocator.dart';

class RackToolsPage extends StatefulWidget {
  final User user;
  final Rack rack;

  RackToolsPage({Key key, @required this.user, @required this.rack}) : super(key: key);

  @override
  _RackToolsPageState createState() => _RackToolsPageState();
}

class _RackToolsPageState extends State<RackToolsPage> {
  User get _user => widget.user;
  Rack get _rack => widget.rack;

  TextEditingController _locationController = new TextEditingController();

  GoogleMapController mapController;
  Future<Position> currentLocation;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //funzione uguale a quella presente in map
  Future<Position> fetchLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Set<Marker> initMarker(BuildContext context, Rack rack){
    Set<Marker> set = Set<Marker>();
    Marker marker;

    marker = Marker(
      markerId: MarkerId(_rack.id.toString()),
      position: LatLng(_rack.latitude, _rack.longitude),
      draggable: false,
      infoWindow: InfoWindow(
        title: _rack.locationDescription,
        snippet: _rack.addressLocality,
      ),
    );
    set.add(marker);
    return set;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Rack ' +
            _rack.id.toString() +
            ' Manage Page'
        ),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      backgroundColor: Colors.grey[300],

      body: Container(
        child: RefreshIndicator(
          child: ListView(
            children: <Widget>[

              //Rack Name Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    AlertDialog(
                      title: Text("Modifica parametro: "),
                      content: new TextField(
                        controller: _locationController,
                      ),
                      actions: <Widget>[
                        MaterialButton(
                          elevation: 5.0,
                          textColor: Colors.red[600],
                          child: Text("Submit"),
                          onPressed: (){
                            setState(() {
                              _rack.locationDescription = putLocalDesc(_locationController.text, _rack.id.toString());
                            });
                          },
                        )
                      ],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.home),
                        SizedBox(width: 40.0),
                        Text(_rack.locationDescription),
                      ],
                    ),
                  ),
                ),
              ),

              //Rack Position Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(width: 40.0),
                      Text(
                          _rack.streetAddress +
                              ' (' +
                              _rack.addressLocality +
                              ')',
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),

              //Rack Capacity Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.apps),
                        SizedBox(width: 40.0),
                        Text('Stand Disponibili:' + _rack.availableStands.toString(),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),

              //Rack Bike_Available Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.directions_bike),
                        SizedBox(width: 40.0),
                        Text('Biciclette Disponibili: ' + _rack.availableBikes.toString(),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),

              //Delete Rack Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.red[600],
                child: InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Cancella Rastrelliera',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              //Google Maps Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Container(
                      width: 300.0,
                      height: 250.0,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_rack.latitude, _rack.longitude),
                            zoom: 16.0
                        ),
                        onMapCreated: (controller){
                          mapController = controller;
                        },
                        myLocationEnabled: false,
                        markers: initMarker(context, _rack),
                      )
                  ),
                ),
              ),
            ],
          ),

          onRefresh: () {
            return _onRefresh();
          },
        ),
      ),
      drawer: MyDrawer(user: _user),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      currentLocation = fetchLocation();
    });
  }
}
