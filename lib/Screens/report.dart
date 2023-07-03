import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

import 'ViewReport.dart';

class StoreLocationScreen extends StatefulWidget {
  @override
  _StoreLocationScreenState createState() => _StoreLocationScreenState();
}

class _StoreLocationScreenState extends State<StoreLocationScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();

  var reportVal;

  void storeLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    databaseReference.push().set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'Comments': reportVal,
    });
    // print(position.latitude);
    // print(position.longitude);
    print(reportVal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Drug Abuse'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.symmetric(vertical: 80),
                prefixIcon: const Icon(Icons.email_outlined),
                hintText: 'Delatils',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
              ),
              onChanged: (value) => setState(() {
                reportVal = value;
              }),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: storeLocation,
              child: Text('Report'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ViewLocationsScreen()),
            //     );
            //   },
            //   child: Text('Check'),
            // ),
          ],
        ),
      ),
    );
  }
}
