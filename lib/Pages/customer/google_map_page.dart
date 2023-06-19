import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

import '../../Style/borders.dart';
import 'data_container.dart';
import 'loadingScreen.dart';
import 'model/product_data.dart';
import 'model/supermarket_data.dart';
import 'dummy_data/supermarket_list.dart';

void main() => runApp(const GoogleMapHomePage());

class GoogleMapHomePage extends StatelessWidget {
  const GoogleMapHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermarkets location',
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
          initialChildSize: 0.341,
          maxChildSize: 0.8,
          minChildSize: 0.1,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(35.0)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    color: ui.Color.fromARGB(255, 39, 36, 36),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                        color: AppBorders.appColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(35.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supermarket.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Location: ${supermarket.locationX}, ${supermarket.locationY}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
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
                            'Contains:',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._buildDoContainList(),
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
                          ..._buildDoNotContainList(),
                        ],
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

  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(31.9753133, 35.1960417);
  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    for (final supermarket in supermarkets) {
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
          _openBottomSheet(supermarket);
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
  void initState() {
    _createCustomIcon().then((BitmapDescriptor value) {
      setState(() {
        myIcon = value;
      });
    });
    super.initState();
  }

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

List<Widget> _buildDoNotContainList() {
  List<Product> doNotContainProducts = doNotContain;
  return [
    // const SizedBox(height: 16),
    // const SizedBox(height: 8),
    SingleChildScrollView(
      child: Column(
        children: doNotContainProducts.map((product) {
          return ListTile(
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(product.description),
            tileColor: Colors.red[400],
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }).toList(),
      ),
    ),
  ];
}

List<Widget> _buildDoContainList() {
  List<Product> doContainProducts = doContain;
  return [
    // const SizedBox(height: 16),
    // const SizedBox(height: 8),
    SingleChildScrollView(
      child: Column(
        children: doContainProducts.map((product) {
          return ListTile(
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(product.description),
            tileColor: Colors.green[400],
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }).toList(),
      ),
    ),
  ];
}
