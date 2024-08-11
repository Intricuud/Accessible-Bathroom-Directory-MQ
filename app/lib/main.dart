import 'package:app/app_bathroom_detail.dart';
import 'package:app/app_building_list_page.dart';
import 'package:app/app_title_page.dart';
import 'package:app/map_page.dart';
import 'package:app/navigation_provider.dart';
import 'package:app/report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Update database with latest data from JSON
  await DatabaseHelper.instance.updateBathroomsFromJson();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          switch (navigationProvider.currentPage) {
            case 1:
              return const BuildingList();
            case 2:
              return const MapPage(); // Assuming you have a MapPage
            case 3:
              return BathroomDetails(
                  building: navigationProvider.selectedBuilding);
            case 4:
              return const ReportPage();
            default:
              return const TitlePage();
          }
        },
      ),
    );
  }
}
