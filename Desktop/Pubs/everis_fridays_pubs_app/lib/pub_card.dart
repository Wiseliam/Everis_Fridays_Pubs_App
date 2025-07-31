import 'package:everis_fridays_pubs_app/models/pubs.dart';
import 'package:flutter/material.dart';

class PubCard extends StatelessWidget {
  const PubCard(this.pub, {Key? key}) : super(key: key);
  final Pubs pub;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.transparent,
          backgroundImage:
              NetworkImage('http://192.168.1.169:1337${pub.picture.url}'),
        ),
        title: Text(pub.name,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.justify),
        subtitle:
            Text(pub.address, style: Theme.of(context).textTheme.bodyMedium),
        trailing: Text('\$${pub.avgPrice.toString()}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.greenAccent)),
      ),
    );
  }
}
