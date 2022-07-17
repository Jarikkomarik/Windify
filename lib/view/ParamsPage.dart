import 'package:flutter/material.dart';
import 'ResultPage.dart';

class ParamsPage extends StatefulWidget {
  const ParamsPage({super.key, required this.long, required this.lat});

  final String long;
  final String lat;

  @override
  State<ParamsPage> createState() => _ParamsPageState(lat: lat, long: long);
}

class _ParamsPageState extends State<ParamsPage> {
  _ParamsPageState({required this.long, required this.lat});

  final formGlobalKey = GlobalKey<FormState>();
  final String long;
  final String lat;

  TextEditingController diameterController = TextEditingController();
  TextEditingController powerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: userForm(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: calculateButton(context),
          resizeToAvoidBottomInset: false,
        )
    );
  }

  Widget userForm() {
    return Stack(children: [
      Container(
        alignment: Alignment(0, -0.80),
        child: Text(
          'Motor Parameters',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 180),
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: diameterController,
                validator: (value) {
                  if (value != null && RegExp("\\b([1-9]|10)\\b").hasMatch(value)) {
                    return null;
                  }
                  return "Enter valid number (1 - 10)";
                },
                keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Diameter',
                  hintText: '3',
                  suffixText: 'Meters'),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: powerController,
                validator: (value) {
                  if (value != null && RegExp("\\b([[5-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-9][0-9][0-9][0-9]0)\\b").hasMatch(value)) {
                    return null;
                  }
                  return "Enter valid number (100 - 10,000)";
                },
                keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Power',
                  hintText: '500',
                  suffixText: 'W'),
              )
            ],
          )
        )
      ),
    ]);
  }

  Widget calculateButton(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0.96),
      child: FloatingActionButton.extended(
        onPressed: () {
          if (formGlobalKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  long: long,
                  lat: lat,
                  diameter: diameterController.value.text,
                  power: powerController.value.text,
                )));
          }
        },
        label: Text(
          'Calculate',
          style: TextStyle(fontSize: 40),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }
}
