import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSupermarketPage extends StatelessWidget {

  Future<void> addSupermarkets() async {
    try {
      final response = await add_supermarket.addSupermarket();
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          supermarkets = jsonData.map<Supermarket>((item) => Supermarket.fromJson(item)).toList();
        });
      } else {
        print('Failed to add supermarkets. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while add supermarkets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Supermarket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: locationXController,
              decoration: InputDecoration(labelText: 'Location X'),
            ),
            TextField(
              controller: locationYController,
              decoration: InputDecoration(labelText: 'Location Y'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addSupermarkets(),
              child: Text('Add Supermarket'),
            ),
          ],
        ),
      ),
    );
  }
}
