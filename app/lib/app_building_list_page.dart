import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigation_provider.dart';
import 'database_helper.dart';
import 'app_bathroom_detail.dart';

class BuildingList extends StatelessWidget {
  const BuildingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buildings',
            style: TextStyle(color: Colors.white, fontSize: 30)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD9042B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false).setPage(0);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Provider.of<NavigationProvider>(context, listen: false)
                  .setPage(2);
            },
          ),
        ],
        toolbarHeight: 100.00,
      ),
      body: FutureBuilder<List<String>>(
        future: DatabaseHelper.instance
            .getAllBuildingsSorted(), // Use the new sorted method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No buildings available.'));
          } else {
            final buildings = snapshot.data!;
            return ListView.builder(
              itemCount: buildings.length,
              itemBuilder: (context, index) {
                return Card(
                  color:
                      index % 2 == 0 ? Colors.white : const Color(0xFFD9D9D9),
                  child: ListTile(
                    minTileHeight: 75,
                    title: Text(
                      buildings[index],
                      style: const TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BathroomDetails(building: buildings[index]),
                        ),
                      );
                    },
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
