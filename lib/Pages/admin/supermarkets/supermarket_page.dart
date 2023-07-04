import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graduation_project/Pages/admin/supermarkets/add_supermarket.dart';
import 'package:graduation_project/Pages/admin/supermarkets/superMarketItems.dart';
import 'package:graduation_project/Style/borders.dart';

import '../../../Apis/supermarketApi.dart';
import '../../customer/model/supermarket.dart';

class SupermarketListPage extends StatefulWidget {
  @override
  _SupermarketListPageState createState() => _SupermarketListPageState();
}

class _SupermarketListPageState extends State<SupermarketListPage> {
  List<Supermarket> supermarkets = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchSupermarkets();
  }

  Future<void> fetchSupermarkets() async {
    try {
      final response = await SupermarketApis.getAllSupermarketList();
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          loading = false;
          supermarkets = jsonData
              .map<Supermarket>((item) => Supermarket.fromJson(item))
              .toList();
        });
      } else {
        print(
            'Failed to fetch supermarkets. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching supermarkets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppBorders.appColor,
          onPressed: () async {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return AddSuperMarket();
            })).then((value) {
              fetchSupermarkets();
            });
          },
          label: Icon(Icons.add),
        ),
        body: loading
            ? Align(
                alignment: Alignment.center, child: CircularProgressIndicator())
            : supermarkets.isEmpty
                ? Text("Empty Supermarkets")
                : RefreshIndicator(
                    child: ListView.builder(
                      itemCount: supermarkets.length,
                      itemBuilder: (context, index) {
                        final supermarket = supermarkets[index];
                        return Slidable(
                          endActionPane:
                              ActionPane(motion: ScrollMotion(), children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                SupermarketApis.deleteSuperMarket(
                                        supermarket.id.toString())
                                    .then((res) {
                                  if (res.statusCode == 200 ||
                                      res.statusCode == 204)
                                    fetchSupermarkets();
                                  ;
                                  print(
                                      "delete supermarket response: ${res.body} status : ${res.statusCode}");
                                });
                              },
                            ),
                            Text("Delete")
                          ]),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: AppBorders.containerDecoration(),
                            child: ListTile(
                              leading: Icon(Icons.store),
                              title: Text(supermarket.name),
                              onTap: () {
                                Navigator.push(context,
                                    new MaterialPageRoute(builder: (context) {
                                  return SuperMarketItems(supermarket.name,
                                      supermarket.id.toString());
                                }));
                              },
                              // Add more widgets to display other information
                            ),
                          ),
                        );
                      },
                    ),
                    onRefresh: fetchSupermarkets));
  }
}
