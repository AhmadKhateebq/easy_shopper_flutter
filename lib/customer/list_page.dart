import 'package:flutter/material.dart';
import 'package:graduation_project/customer/google_map_page.dart';

import 'dummy_data/product_list.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dummyProducts.length,
              itemBuilder: (context, index) {
                final product = dummyProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.brand),
                  onTap: () {
                    // Handle product item tap
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoogleMapPage()));
            },
            child: Text('Show Map'),
          ),
        ],
      ),
    );
  }
}
