import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'ParamsPage.dart';

class MapPage extends StatefulWidget {

  MapPage(this._devicePosition);
  Position _devicePosition;

  @override
  State<MapPage> createState() => MapSampleState(_devicePosition);
}

class MapSampleState extends State<MapPage> {

  MapSampleState(this._devicePosition);

  Completer<GoogleMapController> _controller = Completer();
  Position _devicePosition;
  CameraPosition _cameraPosition = CameraPosition(target:LatLng(0,0));
  final googleApikey = "your api key";
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  String location = "Search Location";


  @override
  Widget build(BuildContext context) => getMap(_devicePosition.latitude, _devicePosition.longitude);

  Widget getMap(double latitude, double longitude) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children:
        [
        GoogleMap(
        mapType: MapType.normal,
        onCameraMove: (CameraPosition position) {
          _cameraPosition = position;
        },
        initialCameraPosition: CameraPosition(target: LatLng(latitude, longitude), zoom: 14),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          controller.setMapStyle(
              await rootBundle.loadString("assets/mapStyle.json"));
        },
      ),
        Positioned( //search input bar
          top: 66,
          child: InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'cz')],
                    );//google_map_webservice package

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  }); //form google_maps_webservice package

                  final plist = GoogleMapsPlaces(apiKey: googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  //move map camera to selected place with animation
                  _doAction(LatLng(lat, lang));
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(50, 18, 40, 40),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 70,
                      child: ListTile(
                        title: Text(location, style: TextStyle(fontSize: 18)),
                        trailing: Icon(Icons.search),
                        dense: true,
                      )
                  ),
                ),
              )
          )
      ),
      InkWell(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => MapPage(_devicePosition)
              ),
            );
          },
          borderRadius: BorderRadius.circular(0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 98, 10, 0),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 26,
              color: Colors.black,
            ),
          )
      ),
      Center(
          child: Align(
            alignment: Alignment(0.00, -0.031),
            child: Icon(
              Icons.location_pin,
              size: 50,
              color: Colors.black, // add custom icons also
            ),
          )
      )
          ]
      ),
      floatingActionButton: getLocationButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  FloatingActionButton getLocationButton() {
    return FloatingActionButton.extended(

      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ParamsPage(
                long: _cameraPosition.target.longitude.toString(),
                lat: _cameraPosition.target.latitude.toString()
            )
          ),
        );
      },


      label: Text('SET MY LOCATION'),
      icon: Icon(Icons.location_pin),
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    );
  }


  Future<void> _doAction(LatLng newlatlang) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: newlatlang, zoom: 16.5)));
  }

}
