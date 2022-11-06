import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

_onMapCreated(GoogleMapController googleMapController){
   _controller.complete(googleMapController);

   _controller.future;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa & Geolocalização"),
      ),
      body: Container(
        child: GoogleMap(
        mapType: MapType.normal, 
        //mapType: MapType.none , 
        //mapType: MapType.satellite , 
        //mapType: MapType.hybrid , 
        initialCameraPosition: CameraPosition(
          target: LatLng(-8.822453, 13.234531),
          zoom: 16
        ),
       onMapCreated: _onMapCreated,
        ),
      ) 
    );
  }
}