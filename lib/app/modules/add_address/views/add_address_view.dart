import 'package:ebuy/app/data/models/req/address_req.model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/add_address_controller.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({Key? key}) : super(key: key);

  @override
  State<AddAddressView> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddAddressView> {
  final TextEditingController addressController = TextEditingController();
  late GoogleMapController mapController;
  String _currentAddress = '';
  bool _isLocationSelected = false;
  // final _controller = Get.find<AddAddressController>();
  final controller = Get.put(AddAddressController());
  late AddressReq address;

  LatLng _currentPosition = const LatLng(
    11.562108,
    104.888535,
  ); // Default position

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
        ),
      );
      return;
    }

    // Get the current position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        print("Current Position: $_currentPosition");
      });

      // Move the map camera to the current location
      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
      _isLocationSelected = true;
      // Fetch address from coordinates
      _getAddressFromLatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location: $e')),
      );
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        " ${place.street}, ${place.subLocality}, ${place.locality}, ${place.country} , ${place.postalCode}";
        addressController.text = _currentAddress;
      });

      print("line 2 address ${place.subLocality}");
      //line 1
      print("line 1 address ${place.street}");
    } catch (e) {
      setState(() {
        _currentAddress = "Failed to get address: $e";
      });
    }
  }

  void confirmAddress() {
    // if(_isLocationSelected){
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const Text('Save Address?'),
    //         content: const Text('Do you want to save this address?'),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //
    //               Navigator.pop(context);
    //               Navigator.pop(context);
    //             },
    //             child: const Text('Yes'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //               Navigator.pop(context);
    //             },
    //             child: const Text('No'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // } else {
    //   Navigator.pop(context);
    // }
  }
  //_updateAddressFromMap
  Future<void> _updateAddressFromMap(LatLng newPosition) async {
    try {
      // Update the current position
      setState(() {
        _currentPosition = newPosition;
      });

      // Fetch address from new coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        newPosition.latitude,
        newPosition.longitude,
      );
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}, ${place.postalCode}";
        addressController.text = _currentAddress;
      });
      //set address
      address = AddressReq(
        line1: place.street ?? "",
        latitude: _currentPosition.latitude,
        longitude: _currentPosition.longitude,
        city: place.locality ?? "Phnom Penh",
        country: place.country ?? "",
        postalCode: 12000,
      );
    } catch (e) {
      //mounted
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get address: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true);
          },
        ),
        title: const Text('Address'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {
              controller.addAddress(address);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Google Map
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onCameraMove: (position) {
                    // Update address as the user moves the map
                    _updateAddressFromMap(position.target);
                  },
                ),
                const Center(
                  child: Icon(Icons.location_pin, size: 40, color: Colors.pink),
                ),
              ],
            ),
          ),

          // Address Input Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    addressController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Illustration and Instructions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/map_illustration.png',
                  // Replace with your image path
                  height: 120,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Enter an address or move the pin to the correct location on the map.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ],
            ),
          ),

          // "Use My Current Location" Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: _getCurrentLocation,
              child: const Text(
                'Use my current location',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
