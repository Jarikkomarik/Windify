import 'package:flutter/material.dart';
import 'package:windify/model/ResultProcessor.dart';
import 'package:windify/model/CalculationResult.dart';
import 'package:windify/InvalidLocationException.dart';
class ResultPage extends StatefulWidget {
  const ResultPage({super.key,
    required this.long,
    required this.lat,
    required this.power,
    required this.diameter});

  final String long;
  final String lat;
  final String power;
  final String diameter;

  @override
  State<ResultPage> createState() =>
      _ResultPageState(long: long, lat: lat, power: power, diameter: diameter);
}

class _ResultPageState extends State<ResultPage> {
  _ResultPageState({required this.long,
    required this.lat,
    required this.power,
    required this.diameter});

  final String long;
  final String lat;
  final String power;
  final String diameter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ResultProcessor().getCalculation(long, lat,
          diameter, power),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Stack(
            children: [
              getCalculation(snapshot, "No data 😔"),
              getPopUp(snapshot.error as Exception)
            ],
          );
        }
        else if (snapshot.hasData) {
          return getCalculation(snapshot, "");
        }
        else {
          return Stack(
            children: [
              getCalculation(snapshot, "Getting results..."),
              Center(
                child: CircularProgressIndicator(
                color: Colors.white,
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget getCalculation(AsyncSnapshot snapshot, String placeHolder) {
    return Scaffold(
      body: Stack(children: [
        Container(
          alignment: Alignment(0, -0.70),
          child: Text(
            'Calculation Results',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment(0, -0.20),
          child: Text(
            snapshot.data == null ? placeHolder : (snapshot
                .data as CalculationResult).awgWindSpeed + " m/s",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          alignment: Alignment(0, -0.30),
          child: Text(
              "Average wind speed",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left
          ),
        ),
        Container(
          alignment: Alignment(0, 0.05),
          child: Text(
              snapshot.data == null ? placeHolder : (snapshot
                  .data as CalculationResult).yearlyKwh + " Kwh",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.right
          ),
        ),
        Container(
          alignment: Alignment(0, -0.05),
          child: Text(
              "Energy production",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left
          ),
        ),
        Container(
          alignment: Alignment(0, 0.30),
          child: Text(
              snapshot.data == null ? placeHolder : (snapshot
                  .data as CalculationResult).awgYearlyIncome + " Kč",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.right
          ),
        ),
        Container(
          alignment: Alignment(0, 0.20),
          child: Text(
              "Yearly income",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left
          ),
        ),
      ]),
    );
  }

  Widget getPopUp(Exception exception) {
    String errorType;
    String errorMessage;
    if (exception is InvalidLocationException) {
      errorType = "Calculation error";
      errorMessage = "Please select location within\nCzech Republic border";
    } else {
      errorType = "Network error";
      errorMessage = "Connect to network \nor try again later";
    }
    return AlertDialog(
      title: Text(errorType),
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          child: const Text('back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
