import 'dart:convert';
import 'package:everis_fridays_pubs_app/models/pubs.dart';
import 'package:flutter/material.dart';
import 'package:everis_fridays_pubs_app/pub_card.dart';
import 'package:http/http.dart';
import 'package:everis_fridays_pubs_app/max_price_page.dart';

void main() => runApp(const EverisFridayApp());

class EverisFridayApp extends StatelessWidget {
  const EverisFridayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 4, 174, 66),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 4, 174, 66),
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF1E1E1E),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(size: 30, color: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Pubs> _listPubs = <Pubs>[];
  late Future<String> futurePubs;
  int? maxPriceFilter;

  @override
  void initState() {
    super.initState();
    loadPubs();
  }

  void loadPubs() {
    setState(() {
      _listPubs.clear();
      if (maxPriceFilter == null) {
        futurePubs = getPubs(_listPubs);
      } else {
        futurePubs = getPubsFiltered(_listPubs, maxPriceFilter!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Everis Fridays Pub'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, size: 30),
            tooltip: 'Filter by max price',
            onPressed: () async {
              final result = await Navigator.push<int?>(
                context,
                MaterialPageRoute(
                    builder: (context) => MaxPricePage(maxPriceFilter)),
              );

              if (result != null) {
                maxPriceFilter = result;
                loadPubs();
              }
            },
          ),
          if (maxPriceFilter != null)
            IconButton(
              icon: const Icon(Icons.clear, size: 30),
              tooltip: 'Remove filter',
              onPressed: () {
                maxPriceFilter = null;
                loadPubs();
              },
            )
        ],
      ),
      body: Center(
        child: _buildPubs(),
      ),
    );
  }

  Widget _buildPubs() {
    return FutureBuilder<String>(
      future: futurePubs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent));
        } else if (!snapshot.hasData) {
          return const Text("Ups there is no data or connection");
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: _listPubs.length,
          itemBuilder: (context, index) {
            return PubCard(_listPubs[index]);
          },
        );
      },
    );
  }
}

Future<String> getPubs(List<Pubs> listPubs) async {
  final response = await get(Uri.parse('http://192.168.1.169:1337/api/pubs'));

  if (response.statusCode == 200) {
    List<dynamic> pubsListRaw = jsonDecode(response.body);
    for (var item in pubsListRaw) {
      listPubs.add(Pubs.fromJson(item));
    }
    return "Success!";
  } else {
    throw Exception('Failed to load data');
  }
}

Future<String> getPubsFiltered(List<Pubs> listPubs, int maxPrice) async {
  final response = await get(Uri.parse(
      'http://192.168.1.169:1337/api/pubs/affordable?maxPrice=$maxPrice'));

  if (response.statusCode == 200) {
    List<dynamic> pubsListRaw = jsonDecode(response.body);
    for (var item in pubsListRaw) {
      listPubs.add(Pubs.fromJson(item));
    }
    return "Success!";
  } else {
    throw Exception('Failed to load data');
  }
}




