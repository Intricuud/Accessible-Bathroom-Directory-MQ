// In app_bathroom_detail.dart

import 'package:app/navigation_provider.dart';
import 'package:app/report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';

class BathroomDetails extends StatelessWidget {
  final String building;

  const BathroomDetails({Key? key, required this.building}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          building,
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD9042B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Set the back button color to white
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.flag, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ReportPage()));
            },
          ),
        ],
        toolbarHeight: 100.00,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getBathroomsByBuilding(building),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bathroom data available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final bathroom = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    minTileHeight: 75,
                    title: Text(
                      'Level: ${bathroom['level']}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    children: [
                      ListTile(title: Text('Door: ${bathroom['manual_auto']}')),
                      ListTile(
                          title: Text('Grab Bar: ${bathroom['grab_bar']}')),
                      ListTile(
                          title: Text(
                              'Drying: ${bathroom['paper_towel_air_dryer']}')),
                      ListTile(title: Text('Shower: ${bathroom['shower']}')),
                      if (bathroom['notes'] != null &&
                          bathroom['notes'].isNotEmpty)
                        ListTile(title: Text('Notes: ${bathroom['notes']}')),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
