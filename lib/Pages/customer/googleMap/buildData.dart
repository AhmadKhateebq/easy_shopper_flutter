import 'package:flutter/material.dart';

import '../data_container.dart';
import '../model/product_data.dart';

List<Widget> _buildDoNotContainList() {
  List<Product> doNotContainProducts = doNotContain;
  return [
    const SizedBox(height: 16),
    Text(
      'Do Not Contain:',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 8),
    SingleChildScrollView(
      child: Column(
        children: doNotContainProducts.map((product) {
          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.description),
            tileColor: Colors.red[400],
          );
        }).toList(),
      ),
    ),
  ];
}

List<Widget> _buildDoContainList() {
  List<Product> doContainProducts = doContain;
  return [
    const SizedBox(height: 16),
    Text(
      'Contains:',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 8),
    SingleChildScrollView(
      child: Column(
        children: doContainProducts.map((product) {
          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.description),
            tileColor: Colors.green[400],
          );
        }).toList(),
      ),
    ),
  ];
}
