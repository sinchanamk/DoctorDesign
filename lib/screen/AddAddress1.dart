import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/screen/checkout.dart';
import 'package:royalmart/screen/checkout1.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'ShowAddress.dart';
class AddAddress1 extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AddAddress1> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File> file;
  String status = '';
  String base64Image,imagevalue;
  File _image,imageshow1;
  String errMessage = 'Error Uploading Image';
  String user_id ;
  String url = "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  var _formKeyad=GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey =new GlobalKey<ScaffoldState>();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();
  String valArea;
  getAddress()async{
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      valArea=first.subLocality+ " "+first.subAdminArea.toString()+" "+first.featureName.toString()+" "+first.thoroughfare.toString();
      pre.setString("address", valArea);
      // pre.setString("lat", lat.toString());
      // pre.setString("lng", long.toString());
      // pre.setString("pin", first.postalCode.toString());
      // pre.setString("city", first.subLocality.toString());
    });
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }

  Widget _child;
  Position position;
  double lat,long;
  GoogleMapController _controller;

  void _getCurrentLocation() async{
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      lat=position.latitude;
      long=position.longitude;
      Constant.latitude=lat;
      Constant.longitude=long;;
      print( Constant.latitude.toString());
      print( Constant.longitude.toString());
      _child = _mapWidget();
    });
  }

  Widget _mapWidget(){
    return GoogleMap(
      mapType: MapType.normal,
      markers: _createMarker(),
      zoomGesturesEnabled: true,

      // tiltGesturesEnabled: false,
//      onCameraMove: ((position) => _updatePosition(position)),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 16.0,
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
        // _controller.setMapStyle('[{"featureType": "all","stylers": [{ "color": "#C0C0C0" }]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{ "color": "#CCFFFF" }]},{"featureType": "landscape","elementType": "labels","stylers": [{ "visibility": "off" }]}]');

        // _setStyle(controller);
      },
    );
  }

  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
          draggable: true,
          onDragEnd: ((position){
            setState(() {
              lat=position.latitude;
              long=position.longitude;
              Constant.latitude=lat;
              Constant.longitude=long;;
              print( Constant.latitude.toString());
              print( Constant.longitude.toString());
              getAddress();
            });

            print(lat);
            print(long);

          }),
          markerId: MarkerId('home'),
          position: LatLng(position.latitude,position.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '${lat}  ${long}')
      )
    ].toSet();
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  String _dropDownValue1;
  Future<File> profileImg;

  int selectedRadio=1;

  setSelectRadio(int val){
    setState(() {
      selectedRadio=val;
      if(3==selectedRadio){
        setState(() {
          _status  =true;

        });

      }
      else if(2==selectedRadio){
        setState(() {
          _status  =false;
          labelController.text="Office";

        });
      }
      else{
        setState(() {
          _status  =false;
          labelController.text="Home";


        });

      }

    });
  }

  SharedPreferences pre;

  Future<void> getUserInfo() async {
     pre = await SharedPreferences.getInstance();
    String name= pre.getString("name");
    String email= pre.getString("email");
    String mobile= pre.getString("mobile");
    String pin= pre.getString("pin");
    String city= pre.getString("city");
    String address= pre.getString("address");
    print(address);
    String image= pre.getString("pp");
    user_id=pre.getString("user_id");
    print(user_id);


    this.setState(() {
      nameController.text= name;
      emailController.text= email;
      stateController.text='';
      pincodeController.text=pin;
      mobileController.text=mobile;
      cityController.text=city;
      address1.text= address;

      print("Constant.image");
      print(Constant.image);
      print(Constant.image.length);


    });
  }
  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    // var geolocator = Geolocator();

    _getCurrentLocation();

  }





  @override
  void initState() {
    getUserInfo();
    getLocation();
    super.initState();
    if(selectedRadio==1) {
      setState(() {
        labelController.text="Home";

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          elevation: 0.0,
          backgroundColor: AppColors.tela,

          title: Text("Add Address",style: TextStyle(color: Colors.white),)
      ),
      key: profilescaffoldkey,
      body:Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[

                new Container(
                  color: Color(0xffFFFFFF),
                  child: Form(
                    key: _formKeyad,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                         /* RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            title: Text("Home"),

                            onChanged: (val){
                              print("Radio $val");
                              setSelectRadio(val);
                            },

                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedRadio,
                            title: Text("Office "),

                            onChanged: (val){
                              print("Radio $val");
                              setSelectRadio(val);
                            },

                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedRadio,
                            title: Text("Others "),

                            onChanged: (val){
                              print("Radio $val");
                              setSelectRadio(val);
                            },

                            activeColor: Colors.red,
                          ),
*/
                          _status?getLabel():Row(),




                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[



                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child:  TextFormField(
                                      controller:nameController,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the name";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),


                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(

                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType.text, // Use mobile input type for emails.
                                    controller: address1,
                                    validator: (String value){
                                      print("Length${value.length}");
                                      if(value.isEmpty && value.length>10){
                                        return " Please enter the  address";
                                      }
                                    },


                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Edit the address',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),
                                    )

                                )
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left:30.0,top: 20.0,right: 30),
                              child: InkWell(
                                onTap: (){

                                  showCalander();
                                  // _showSelectionDialog(context);
                                },
                                child: Container(
                                  // width: MediaQuery.of(context).size.width/1.5,
                                    padding: const EdgeInsets.only(left:30.0,top: 0.0,right: 30),
                                    margin: const EdgeInsets.only(left:0.0,top: 0.0,right: 0),


                                  child:  Center(child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        child: Text(
                                          textval.length>20?textval.substring(0,20)+"..": textval,

                                          overflow:TextOverflow.fade,
                                          // maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 12,color:AppColors.black,

                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child:Icon(Icons.expand_more, color: Colors.black,size: 30,)
                                      )

                                    ],
                                  )  ),

                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)
                                  ),
                                ),
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left:30.0,top: 20.0,right: 30),

                              child: InkWell(
                                onTap: (){

                                  _displayDialog(context);
                                  // _showSelectionDialog(context);
                                },
                                child: Container(

                                  padding: const EdgeInsets.only(left:30.0,top: 0.0,right: 30),
                                  margin: const EdgeInsets.only(left:0.0,top: 0.0,right: 0),
                                  // width: MediaQuery.of(context).size.width/1.5,

                                  child:  Center(child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        child: Text(
                                          textval1.length>20?textval1.substring(0,20)+"..": textval1,

                                          overflow:TextOverflow.fade,
                                          // maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 12,color:AppColors.black,

                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child:Icon(Icons.expand_more, color: Colors.black,size: 30,)
                                      )

                                    ],
                                  )  ),

                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)
                                  ),
                                ),
                              )
                          ),

                          /*Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Address2',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(

                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType.text, // Use mobile input type for emails.
                                    controller: address2,
                                    validator: (String value){
                                      print("Length${value.length}");
                                      if(value.isEmpty && value.length>10){
                                        return " Please enter the  address";
                                      }
                                    },


                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address2',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),
                                    )

                                )
                            ),
                          ),*/

                         /* Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child:  TextFormField(
                                      controller:emailController,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the email id";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),

                                    ),
                                  ),
                                ],
                              )),*/
                          /*Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      controller:mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the mobile No";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),*/
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'State',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child:  TextFormField(
                                        controller:mobileController,

                                        keyboardType: TextInputType.number,
                                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,
                                          new LengthLimitingTextInputFormatter(10),],

                                        validator: (String value){
                                          if(value.isEmpty&&value==10){
                                            return " Please enter the mobile No";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile No"),

                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child:  TextFormField(
                                      controller:stateController,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the state";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter State"),

                                    ),
                                    flex: 2,
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'City',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Pin Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Container(
                            height: 70,

                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(15),
                            ),

                            margin: EdgeInsets.only(left: 20,right: 20),
                            padding: EdgeInsets.all(0.0),
                            child:  Row(children : <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child:  TextFormField(
                                      controller:cityController,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the city";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter City"),

                                    ),
                                  ),  ),
                              ),
                              SizedBox(width: 30,),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child:  TextFormField(
                                      controller:pincodeController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6)],

                                      validator: (String value){
                                        if(value.isEmpty&& value.length==6){
                                          return " Please enter the pin code";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Pin Code"),

                                    ),
                                  ),  ),
                              ),

                            ]),
                          ),

                         /* Container(
                            height: 400,
                            child: _child,
                          ),


*/
                          // open map inside a container





                          _getActionButtons() ,
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),);
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }


  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child:  Center(
                    child: RaisedButton(
                      child: new Text("Next"),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () {

                        setState(() {


                          if(textval!="Select Date"&& textval1!="Select Time") {
                            if (_formKeyad.currentState.validate()) {
                              if (pincodeController.text.length == 6) {
                                user_id = pre.getString("user_id");
                                pre.setString("name", nameController.text);
                                pre.setString("email",
                                    emailController.text != null
                                        ? emailController.text
                                        : "");
                                pre.setString("mobile", mobileController.text);
                                pre.setString("pin", pincodeController.text);
                                pre.setString("city", cityController.text);
                                pre.setString("address", address1.text);
                                pre.setString("time", textval1);
                                pre.setString("date", textval);
                                pre.setString("state", stateController.text);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => CheckOutPage1()),);
                                // _AddAddress();

                              }
                              else {
                                showLongToast("Enter the valide pin");
                              }


//                              setInfo();
                            }
                          }
                          else{
                            showLongToast("Please select date and time");
                          }


//                        _status = true;
//                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                    ),
                  )),
            ),
            flex: 2,
          ),

        ],
      ),
    );
  }
  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: AppColors.pink,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

//






/*  Future setInfo() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", address1.text);
    pref.setString("sex", _dropDownValue1);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    Constant.email=emailController.text;
    Constant.name=nameController.text;

    if(Constant.isLogin){
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => CheckOutPage()));


    }
    else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInPage()),);
    }

  }*/



/*
  Future _AddAddress() async {
    print(Constant.Shop_id);
    print(Constant.API_KEY);
    print(Constant.user_id);
    print(nameController.text);
    print(mobileController.text);
    print(emailController.text);
    print(address1.text);
    print(address2.text);
    print(cityController.text);
    print(stateController.text);
    print(pincodeController.text);
    print(labelController.text);
    var map = new Map<String, dynamic>();
    map['shop_id']=Constant.Shop_id;
    map['X-Api-Key']=Constant.API_KEY;
    map['user_id']=Constant.user_id;
    map['full_name']=nameController.text;
    map['mobile']=mobileController.text;
    map['email']=emailController.text;
    map['address1']=address1.text;
    map['address2']=address2.text;
    map['city']=cityController.text;
    map['state']=stateController.text;
    map['pincode']=pincodeController.text;
    map['label']=labelController.text;
    map['lat']=lat.toString();
    map['lng']=long.toString();
    String link = Constant.base_url + "manage/api/user_address/add";
    print(link);
    final response = await http.post(link,body:map );
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(user.message);
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),);
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));


    } else
      throw Exception("Unable to get Employee list");
  }*/

  Widget   getLabel(){


    return Padding(
      padding: EdgeInsets.only(
          left: 25.0, right: 25.0, top: 2.0),
      child: TextFormField(
        controller:labelController,
        validator: (String value){
          if(value.isEmpty){
            return " Please enter the label";
          }
        },
        decoration: const InputDecoration(
            hintText: "Enter Label"),
      ) ,
    );
  }
  String textval="Select Date";
  String textval1="Select Time";


  _displayDialog(BuildContext context) async {
    String formattedDate1 = DateFormat('dd/MM/yyyy ').format(DateTime.now());
    var now = DateTime.now();
    print(DateFormat('HH').format(now));
    dynamic currentTime = await DateFormat('HH').format(now);
    // dynamic currentTime = await DateFormat.jm().format(DateTime.now());
    String compair= currentTime.toString().substring(0,2).replaceAll(":", "").trim();
    print(compair);
    print(formattedDate1);
    print(compair);
    List<String>time;


    if(formattedDate1==textval) {

      // switch (int.parse(compair)) {
      //   case 9:
      //     time = ["12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 10:
      //     time = ["12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 11:
      //     time = ["11am to 12am", "12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 12:
      //     time = ["12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //     case 1:
      //     time = ["12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 2:
      //     time = [ "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 3:
      //     time = [ "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 4:
      //     time = [ "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 5:
      //     time = [ "4pm to 6pm", "6pm to 8pm"];
      //     break;
      //   case 6:
      //     time = ["6pm to 8pm"];
      //     break;
      //   case 7:
      //     time = ["6pm to 8pm"];
      //     break;
      //   case 8:
      //     time = ["No time is avaliable"];
      //     break;
      // }
      if (int.parse(compair)< 8) {
        time = ["8am to 10am","10am to 12am", "12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      }

      else if (int.parse(compair)>8 && int.parse(compair) < 10) {
        time = ["10am to 12am", "12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      }
      else if (int.parse(compair)>9 && int.parse(compair) < 12) {

        time = ["12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      }
      else if (int.parse(compair) > 11 && int.parse(compair) < 14) {

        time = [ "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];
      }
      else if (int.parse(compair) >13 && int.parse(compair) < 16) {
        time = [ "4pm to 6pm", "6pm to 8pm"];
      }
      else if (int.parse(compair) > 15 && int.parse(compair) < 18) {
        time = ["6pm to 8pm"];
      }
      else
        time = ["No slot avaliable today"];
    }

    else{

      time = ["8am to 10am","10am to 12am","12am to 2pm", "2pm to 4pm", "4pm to 6pm", "6pm to 8pm"];

    }




    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable:true,
            title: Text('Select Time'),
            content: Container(
              width: double.maxFinite,
              height: time.length*50.0,
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: time.length == null
                      ? 0
                      : time.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      Container(
                        width: time[index]!=0?130.0:230.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 10),

                        child: InkWell(
                          onTap: () {
                            setState(() {
                              textval1=time[index];Navigator.pop(context);


                            });

                          },
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),
                                    child: Text(
                                      time[index],
                                      overflow:TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,color:AppColors.black,

                                      ),
                                    ),
                                  ),

                                  // RaisedButton(
                                  //   onPressed: () {
                                  //   },
                                  //   color: Colors.amberAccent,
                                  //   padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.all(Radius.circular(10))),
                                  //   child: Text(
                                  //     "Select",
                                  //
                                  //   ),
                                  // ),
                                ],
                              ),
                              Divider(

                                color: AppColors.black,
                              ),





                            ],
                          ),
                        ),







                      )
                    ;
                  }),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 30))))) {
      return true;
    }
    return false;
  }
  DateTime selectedDate;

  showCalander(){

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      selectableDayPredicate: _decideWhichDayToEnable,
    ).then((date){
      setState(() {

        selectedDate=date;
        String formattedDate = DateFormat('dd/MM/yyyy ').format(selectedDate!=null?selectedDate:DateTime.now());
        textval=formattedDate;

        print(formattedDate);
      });
    });
  }

}
