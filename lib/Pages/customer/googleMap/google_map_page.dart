import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:graduation_project/Pages/customer/model/supermarket.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Apis/supermarketApi.dart';
import '../../../Style/borders.dart';
import '../data_container.dart';
import 'buildData.dart';
import '../loadingScreens/loadingScreen.dart';
import '../model/product_data.dart';
import '../model/supermarket_data.dart';

List<Product> _listOfProducts = [];
late int? _listId;

class GoogleMapHomePage extends StatelessWidget {
  const GoogleMapHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermarkets location',
      debugShowCheckedModeBanner: false,
      theme: AppBorders.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/map': (context) => const GoogleMapPage(),
      },
    );
  }
}

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  double _radius = 0.5;
  bool loading = true;
  LatLng userLatLong = LatLng(31.9753133, 35.1960417);
  @override
  void initState() {
    super.initState();
    _createCustomIcon().then((BitmapDescriptor value) {
      setState(() {
        myIcon = value;
      });
    });
    _getUserLocation();
    _fetchRadius();
    initializeItems().then((List<Product> value) {
      _listOfProducts = value;
      fetchSupermarkets(
        _radius,
        _listOfProducts,
        userLatLong.latitude,
        userLatLong.longitude,
      );
    });
  }

  Future<void> _fetchRadius() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _radius = prefs.getDouble('radius') ?? 0.5;
  }

  Future<List<Product>> initializeItems() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // _setPrefsForTesting(preferences);
    _listId = preferences.getInt('listId')!;
    print(preferences.getInt('listId'));
    if (_listId != null) {
      return getListItems(_listId);
    } else {
      return [];
    }
  }

  // _setPrefsForTesting(SharedPreferences preferences) {
  //   preferences.setInt('listId', 14);
  //   preferences.setString('userToken', "1477");
  // }

  // ignore: unused_field
  bool _isBottomSheetOpen = false;
  void _openBottomSheet(Supermarket_data supermarket) {
    setState(() {
      _isBottomSheetOpen = true;
    });

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.085,
          maxChildSize: 0.8,
          minChildSize: 0.05,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22.0)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius:
                  //     const BorderRadius.vertical(top: Radius.circular(50.0)),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      // Sticky header
                      backgroundColor: AppBorders.appColor,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      // expandedHeight: 40,
                      flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.symmetric(vertical: 5),
                          centerTitle: true,
                          title: Column(
                            children: [
                              // SizedBox(
                              //   height: 12,
                              // ),
                              Container(
                                height: 5.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                supermarket.supermarket.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                          //stop
                          ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Text(
                              'Contain Percentage: ${supermarket.containPercentage}%',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Original Items Size: ${supermarket.originalItemsSize}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Containing Size: ${supermarket.containingSize}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                              color: Colors.black,
                              height: 1,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Total Price: ${supermarket.total} NIS',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                              color: Colors.black,
                              height: 1,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Do Not Contain:',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...buildDoNotContainList(supermarket.dontContains),
                            const SizedBox(height: 12),
                            const Divider(
                              color: Colors.black,
                              height: 1,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Contain:',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...buildDoContainList(supermarket.contains),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        _isBottomSheetOpen = false;
      });
    });
  }

  Future<void> fetchSupermarkets(
      double radius, List<Product> products, double x, double y) async {
    print("entered");
    try {
      final response = await SupermarketApis.getSupermarketsWithListOfItems(
          radius, products, x, y);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(json);
        print(jsonData);
        setState(() {
          loading = false;
          supermarketsList = jsonData
              .map<Supermarket_data>(
                  (item) => Supermarket_data.parseSupermarketData(item))
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

  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(31.9753133, 35.1960417);
  List<Supermarket_data> supermarketsList = [];
  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    for (final supermarketData in supermarketsList) {
      Supermarket supermarket = supermarketData.supermarket;
      final LatLng position =
          LatLng(supermarket.locationX, supermarket.locationY);

      final marker = Marker(
        markerId: MarkerId(supermarket.name),
        position: position,
        infoWindow: InfoWindow(
          title: supermarket.name,
        ),
        icon: myIcon, // Set default marker icon
        onTap: () {
          _openBottomSheet(supermarketData);
          ;
        },
      );

      markers.add(marker);
    }

    return markers;
  }

  Future<void> _getUserLocation() async {
    final permissionStatus = await Permission.locationWhenInUse.request();

    if (permissionStatus.isGranted) {
      try {
        final geolocator.Position position =
            await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high,
        );

        print(
            'User Location - Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        LatLng _userLatLong = LatLng(position.latitude, position.longitude);
        userLatLong = _userLatLong;
      } catch (e) {
        print('Failed to get location: $e');
      }
    } else if (permissionStatus.isDenied) {
      print('Location permission is denied by the user.');
      // Display an error message or prompt the user to grant location permissions
    } else if (permissionStatus.isPermanentlyDenied) {
      print(
          'Location permission is permanently denied. Redirect the user to app settings.');
      // Display an error message or redirect the user to app settings
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> _createCustomIcon() async {
    final Uint8List markerIconBytes =
        await _getBytesFromAsset('lib/Assets/icons/supermarket_icon.png', 100);

    return BitmapDescriptor.fromBytes(markerIconBytes);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  BitmapDescriptor myIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialPosition, zoom: 14),
        onMapCreated: (controller) {
          _mapController = controller;
          _getUserLocation(); // Get user location when map is created
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _createMarkers(),
      ),
    );
  }
}
