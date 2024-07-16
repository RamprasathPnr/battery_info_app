
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatterInfoWidget extends StatefulWidget {
  const BatterInfoWidget({super.key});

  @override
  _BatterInfoState createState() => _BatterInfoState();
}

class _BatterInfoState extends State<BatterInfoWidget> {
  static const platform = MethodChannel('battery');

  String batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryInformation() async {
    String battery;
    try {
      final int result = await platform.invokeMethod('getBatteryInformation');
      battery = 'Battery Information at $result%';
    } on PlatformException catch (e) {
      battery = "Failed to get battery Information: '${e.message}'.";
    }

    setState(() {
      batteryLevel = battery;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBatteryInformation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Information'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                batteryLevel,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: _getBatteryInformation,
                child: const Text('Battery Information'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}