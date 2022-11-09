import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
final Completer<GoogleMapController> _controller = Completer();
CameraPosition _cameraPosition = const CameraPosition(
          target: LatLng(-8.85866, 13.2234017),
          zoom: 20
    );
final Set<Marker> _marcadore = {};
Set<Polygon> _polygnos = {};
Set<Polyline> _polyline = {};

_onMapCreated(GoogleMapController googleMapController){
   _controller.complete(googleMapController);
}

//metodo para movimentar a camera com o seu angulo, rotacao e zom
_movimentarCamera() async {
 GoogleMapController googleMapController = await _controller.future;
 googleMapController.animateCamera(
    CameraUpdate.newCameraPosition(
      _cameraPosition
    )
  );
}

//Metodo que irá carregar os marcadores no Set<Marker>
// e este irá carregar no marker: para o Mapa, e também carrega os polygons Set<Polygn>
_carregarMarcadores(){

  /*
  Set<Marker> marcadoreLocal = {};

 Marker marcadorShopping = Marker(
    markerId: MarkerId(
      "Marcador-Shopping"),
    position: LatLng(-8.856835, 13.217624),
    icon: BitmapDescriptor.defaultMarkerWithHue( BitmapDescriptor.hueYellow),
    infoWindow: InfoWindow(
      title: "Shopping Rocha Pinto"
    ),
    onTap: (){
      print("Shopping Rocha Pinto");
    }
  );

  Marker marcadorHotel = Marker(
    markerId: MarkerId(
      "Marcador-Hotel"),
      position: LatLng(-8.862459, 13.217214),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(
        title: "Hotel Rocha Pinto"
      ),
      onTap: (){
        print("Hotel Rocha Pinto");
      }
    );


  marcadoreLocal.add(marcadorShopping);
  marcadoreLocal.add(marcadorHotel);

setState(() {
  _marcadore = marcadoreLocal;

});
*/

/*
//Criando Poligonos
Set<Polygon> listaPolygns = {};

Polygon polygon1 = Polygon(
  polygonId: PolygonId(
    "Polygono1"
  ),
  fillColor: Colors.amber,
  strokeColor: Colors.redAccent,
  strokeWidth: 5,
  points: [
    LatLng(-8.856835, 13.217624),
    LatLng(-8.857101, 13.217487),
    LatLng(-8.856788, 13.217296)
  ],
  consumeTapEvents: true,
  onTap: (){
    print("Click no Polygon1");
  },
  zIndex: 1
  );

  Polygon polygon2 = Polygon(
  polygonId: PolygonId(
    "Polygono2"
  ),
  fillColor: Colors.green,
  strokeColor: Colors.blueAccent,
  strokeWidth: 5,
  points: [
    LatLng(-8.857054, 13.217356),
    LatLng(-8.856727, 13.217299),
    LatLng(-8.857034, 13.217703)
  ],
  consumeTapEvents: true,
  onTap: (){
    print("Click no Polygon2");
  },
  zIndex: 0
  );

  listaPolygns.add(polygon1);
  listaPolygns.add(polygon2);

  setState(() {
   _polygnos = listaPolygns;
  });

  */

 //Criando Polyliness
  Set<Polyline> listaPolyline = {};

  Polyline polyline1 = Polyline(
      polylineId:PolylineId(
        "Polyline1"
      ),
      color: Colors.green,
      width: 9,
      points: [
        LatLng(-8.893244, 13.185357),
        LatLng(-8.892308, 13.185464),
        LatLng(-8.891895, 13.183986),
        LatLng(-8.889115, 13.184608),
        LatLng(-8.888964, 13.184233),
        LatLng(-8.888407, 13.184383)
      ],
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      jointType: JointType.mitered,
      consumeTapEvents: true,
      onTap: (){
        print("Click Polyline 1");
      }
    );

    listaPolyline.add(polyline1);
    
    setState(() {
      _polyline = listaPolyline;
    });
 
}

//metodo para carregar a posicao atual de quem usa o App, e tambem tem as permições
Future _recuperarLocalizacaoAtual() async {
LocationPermission permission = await Geolocator.checkPermission();

  if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
       if(permission == LocationPermission.denied){
         return Future.error('Location permissions are denied');
    }
  }
 
  if(permission == LocationPermission.deniedForever){
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  }
  
  else{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high );
       //print("LocalizaÇão atual: " + position.toString());

       Marker marcadorHotel = Marker(
        markerId: MarkerId(
          "Usuario"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: "Meu local"
        ),
        onTap: (){
          print("Local Usuario");
        }
    );
   
       setState(() {
        _marcadore.add(marcadorHotel);
          _cameraPosition = CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 20
           );
         _movimentarCamera();
       });
  }

}

//Metodo que irá monitorar a localização do usuario, com um Listener
    _adicionarListenerLocalizacao() async {
      LocationPermission permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied){
          permission = await Geolocator.requestPermission();
          if(permission == LocationPermission.denied){
            return Future.error('Location permissions are denied');
        }
      }
    
      if(permission == LocationPermission.deniedForever){
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
      }

       else{
          LocationSettings locationSettings = LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 8,
              timeLimit: Duration(seconds: 3),
            );

          Geolocator.getPositionStream(locationSettings: locationSettings)
             .listen((Position position) {

          Marker marcadorHotel = Marker(
              markerId: MarkerId(
                "Marcador-Usuário"),
                position: LatLng(position.latitude, position.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                infoWindow: InfoWindow(
                  title: "Meu Local"
                ),
                onTap: (){
                  print("Local Usuário");
                }
          );

               setState(() {
                  _cameraPosition = CameraPosition(
                         target: LatLng(position.latitude, position.longitude),
                         zoom: 20
                   );
                   _marcadore.add(marcadorHotel);
                   _movimentarCamera();
               });
                
              });
          
      }

    }

@override
void initState() {
  super.initState();
//_carregarMarcadores();
_adicionarListenerLocalizacao();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa & Geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _movimentarCamera(),
        child: Icon(Icons.done_all),
        ),
      body: Container(
        child: GoogleMap(
        //mapType: MapType.normal, 
        //mapType: MapType.none , 
        //mapType: MapType.satellite , 
        mapType: MapType.hybrid , 
        initialCameraPosition: _cameraPosition,
        onMapCreated: _onMapCreated,
        markers: _marcadore,
        //polygons: _polygnos,
        //polylines: _polyline,
        myLocationEnabled: true,
        ),
      ) 
    );
  }
}