import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapClass extends StatefulWidget {
   TextEditingController textEditingController;
   TextEditingController cityController;
   TextEditingController stateController;
   TextEditingController pincodeController;

  MapClass(
      {
        this.textEditingController,
        this.cityController,
        this.stateController,
        this.pincodeController,


      });
  @override
  _MapClassState createState() => _MapClassState();
}

class _MapClassState extends State<MapClass> {

  Position position;
  Widget _child;
  double lat,long;
  bool flag = false;
  String shop_id;
  SharedPreferences pref;

  void _getCurrentLocation() async{
    pref= await SharedPreferences.getInstance();
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
       lat = position.latitude;
      long=position.longitude;
      Constant.latitude=lat;
      Constant.longitude=long;

      getAddress();
      print("lat ${lat}");
      print(long);
      _child = _mapWidget();
    });
  }
  String valArea;
  getAddress()async{
    print("rahul lay ${lat}  ${long}");
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {

      valArea=first.subLocality.toString()+ " "+first.subAdminArea.toString()+" "+first.featureName.toString()+" "+first.thoroughfare.toString()+""+first.postalCode.toString();
      widget.textEditingController.text=first.subLocality.toString()+ " "+first.subAdminArea.toString()+" "+first.featureName.toString()+" "+first.thoroughfare.toString()+""+first.postalCode.toString();
     widget.cityController.text=first.subLocality.toString()=="null"?"":first.subLocality.toString();
     widget.stateController.text=first.locality.toString();
     widget.pincodeController.text=first.postalCode.toString();
      print("valArea  ${valArea}");
      pref.setString("address", valArea);
      pref.setString("lat", lat.toString());
      pref.setString("lng", long.toString());
      pref.setString("pin", first.postalCode.toString());
      pref.setString("city", first.locality.toString());
    });

    print('hoooo  ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }
  BitmapDescriptor customIcon;
void cerateicon()async{
  customIcon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
      'images/destination_map_marker.png')
      .then((d) {
    customIcon = d;
  });

}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cerateicon();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Location",style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.tela,
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
            color: AppColors.tela
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[


            Container(
              height: MediaQuery.of(context).size.height/1.5,
              child: _child,
            ),
            Container(
              margin: EdgeInsets.all(10),
              // height: 400,
              child: Text(valArea!=null?valArea:""),
            ),

            flag?circularIndi():Row(),

            SizedBox(height: 20,),


            _getActionButtons(),
          ],
        ),
      ),
    );
  }

  GoogleMapController _controller;

  Widget _mapWidget(){
    return GoogleMap(
      mapType: MapType.normal,
      markers: _createMarker(),
      // onCameraMove: ((position) => _updatePosition(position)),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 16.0,
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
        // _setStyle(controller);
      },
    );
  }
  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
          draggable: true,
          icon: BitmapDescriptor.fromAsset("assets/images/destination_map_marker.png"),
          // icon: customIcon,
          onDragEnd: ((position){
            setState(() {
              lat=position.latitude;
              long=position.longitude;

              print("lat  ${lat}");
              print(long);
              getAddress();


            });


          }),
          markerId: MarkerId('home1234'),
          position: LatLng(position.latitude,position.longitude),
          // icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '${lat}  ${long}')
      )
    ].toSet();
  }

  Widget _getActionButtons() {
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Center(
        child: RaisedButton(
          onPressed: () {
            print(lat);
            print(long);
            Navigator.pop(context);

            // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),);


          },
          color: AppColors.tela,
          padding: EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Text(
            "OK", style:TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),

          ),
        ),
      ),

    );


  }

  Widget circularIndi(){
    return  Align(
      alignment: Alignment.center,
      child: Center(
        child:  CircularProgressIndicator(),
      ),
    );
  }

}
