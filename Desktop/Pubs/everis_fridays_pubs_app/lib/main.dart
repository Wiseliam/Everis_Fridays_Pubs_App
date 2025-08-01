import 'dart:convert';
import 'package:everis_fridays_pubs_app/models/pubs.dart';
import 'package:everis_fridays_pubs_app/affordable_pubs_screen.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:everis_fridays_pubs_app/pub_card.dart';
import 'package:http/http.dart';
// ignore: unused_import

void main() => runApp(EverisFridayApp());

class EverisFridayApp extends StatefulWidget {
  const EverisFridayApp({Key? key}) : super(key: key);

  @override
  EverisFridayState createState() => EverisFridayState();
}

class EverisFridayState extends State<EverisFridayApp> {
  final List<Pubs> _listPubs = <Pubs>[];
  late Future<String> futurePubs;
  
  @override
  void initState() {
    super.initState();
    futurePubs = getPubs(_listPubs);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Everis Fridays Pub'),
          backgroundColor: Color.fromARGB(255, 92, 4, 169),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildPubs()),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (buttonContext) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.purpleAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      buttonContext,
                      MaterialPageRoute(
                        builder: (context) => AffordablePubsScreen(),
                      ),
                    );
                  },
                  child: const Text('Show Affordable Pubs'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPubs() {
    return FutureBuilder<String>(
      future: futurePubs,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: _listPubs.length,
            itemBuilder: (context, index) {
              final pub = _listPubs[index];
              return ListTile(
                title: Text(pub.name),
                subtitle: Text('Price: €${pub.avgPrice}'),
              );
            },
          );
        }
      },
    );
  }
}

Future<String> getPubs(_listPubs) async {
  final Response response = await get(Uri.parse('http://192.168.1.169:1337/api/pubs'));

  if (response.statusCode == 200) {
    List<dynamic> pubsListRaw = jsonDecode(response.body);
    for (var i = 0; i < pubsListRaw.length; i++) {
        _listPubs.add(Pubs.fromJson(pubsListRaw[i]));
    }

    return "Success!";
  } else {
    throw Exception('Failed to load data');
  }
}