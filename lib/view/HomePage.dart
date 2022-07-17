import 'package:flutter/material.dart';
import 'Map.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Position? _position;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _determinePosition(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          _position = Position(longitude: 14.423777, latitude: 50.084344, timestamp: DateTime.now(), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
          return getScaffold(context);
        }else if (snapshot.hasData) {
          _position = snapshot.data as Position;
          return getScaffold(context);
        }
        else {
          return Center(
            child: CircularProgressIndicator(
            color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Scaffold getScaffold(BuildContext context) {
    return Scaffold(
      body: welcomeText(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startButton(context),
    );
  }

  Widget welcomeText() {
    return Center(
      child: Container(
        alignment: Alignment(0, -0.45),
        child: const Text(
          'Welcome to '
          '\nWindify !',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      )
    );
  }

  Widget startButton(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0.96),
      child: FloatingActionButton.extended(

        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => MapPage(_position!)),
          );
        },

        label: Text(
          '  Start  ',
          style: TextStyle(fontSize: 40),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

}
