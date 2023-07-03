import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewLocationsScreen extends StatefulWidget {
  @override
  _ViewLocationsScreenState createState() => _ViewLocationsScreenState();
}

class _ViewLocationsScreenState extends State<ViewLocationsScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Map<dynamic, dynamic>> locations = [];

  @override
  void initState() {
    super.initState();
    databaseReference.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value
          as Map<dynamic, dynamic>; // cast the value to the expected type
      values.forEach((key, value) {
        setState(() {
          locations.add(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Locations Reports'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Report $index:\n'
                'Latitude: ${locations[index]['latitude']}\n Longitude: ${locations[index]['longitude']}\n Comments: ${locations[index]['Comments']}\n\n'),
          );
        },
      ),
    );
  }
}
