import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Apis/supermarketApi.dart';
import '../../../model/supermarket.dart';

class SupermarketListPage extends StatefulWidget {
  @override
  _SupermarketListPageState createState() => _SupermarketListPageState();
}

class _SupermarketListPageState extends State<SupermarketListPage> {
  List<Supermarket> supermarkets = [];

  @override
  void initState() {
    super.initState();
    fetchSupermarkets();
  }

  Future<void> fetchSupermarkets() async {
    try {
      final response = await SupermarketApi.getAllSupermarketList();
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          supermarkets = jsonData.map<Supermarket>((item) => Supermarket.fromJson(item)).toList();
        });
      } else {
        print('Failed to fetch supermarkets. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching supermarkets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supermarkets'),
      ),
      body: ListView.builder(
        itemCount: supermarkets.length,
        itemBuilder: (context, index) {
          final supermarket = supermarkets[index];
          return ListTile(
            title: Text(supermarket.name),
            subtitle: Text('ID: ${supermarket.id}'),
            // Add more widgets to display other information
          );
        },
      ),
    );
  }
}
