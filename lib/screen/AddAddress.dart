import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:royalmart/Auth/newMap.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/locatization/language_constant.dart';
import 'package:royalmart/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'ShowAddress.dart';
class AddAddress extends StatefulWidget {
  final String valu;
  const AddAddress(this.valu):super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AddAddress> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File> file;
  String status = '';
  String user_id ;

  var _formKeyad=GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey =new GlobalKey<ScaffoldState>();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();

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
    String image= pre.getString("pp");
    String state= pre.getString("state");
    user_id=pre.getString("user_id");
    print(user_id);


    this.setState(() {
      nameController.text= name;
      emailController.text= email;
      stateController.text=state??"";
      pincodeController.text=pin;
      mobileController.text=mobile;
      cityController.text=city;
      address1.text= address;

      print("Constant.image");
      print(Constant.image);
      print(Constant.image.length);


    });
  }



  Position position;

  void _getCurrentLocation() async{
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position.latitude;
      Constant.longitude=position.longitude;


    });
  }

  @override
  void initState() {
    getUserInfo();
    _getCurrentLocation();
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

          title: Text("${getTranslated(context, 'add3')}",style: TextStyle(color: Colors.white),)
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
                          RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            title: Text("${getTranslated(context, 'home')}"),

                            onChanged: (val){
                              print("Radio $val");
                              setSelectRadio(val);
                            },

                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedRadio,
                            title: Text("${getTranslated(context, 'of')} "),

                            onChanged: (val){
                              print("Radio $val");
                              setSelectRadio(val);
                            },

                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedRadio,
                            title: Text("${getTranslated(context, 'o')} "),

                            onChanged: (val){
                              print("Radio $val");
                              setSelectRadio(val);
                            },

                            activeColor: Colors.red,
                          ),

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
                                        '${getTranslated(context, 'name')}',
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

                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 5.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            '${getTranslated(context, 'add5')}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),

                              InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  MapClass(textEditingController: address1,cityController: cityController,stateController: stateController,pincodeController: pincodeController,)),);

                                  },
                                  child: _getEditIcon()),
                            ],
                          ),

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
                                      hintText: '${getTranslated(context, 'add')}',
                                      labelText: 'Enter the address1',
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
/*
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
                                        '${getTranslated(context, 'add6')}',
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
                                      hintText: '${getTranslated(context, 'add')}',
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
                                        '${getTranslated(context, 'email')}',
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
                              )),
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
                                        '${getTranslated(context, 'mob')}',
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
                                        '${getTranslated(context, 'st')}',
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
                                        '${getTranslated(context, 'city')}',
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
                                        '${getTranslated(context, 'pin')}',
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
//                              Expanded(child:
//
//                              DropdownButton(
//                                hint: _dropDownValue1 == null
//                                    ? Text('Select gender')
//                                    : Text(
//                                  _dropDownValue1,
//                                  style: TextStyle(color: Colors.black),
//                                ),
//                                isExpanded: true,
//                                iconSize: 30.0,
//                                style: TextStyle(color: Colors.black,),
//                                items: [
//                                  'Male',
//                                  'Femail',
//                                ].map(
//                                      (val) {
//                                    return DropdownMenuItem<String>(
//                                      value: val,
//                                      child: Text(val),
//                                    );
//                                  },
//                                ).toList(),
//                                onChanged: (val) {
//                                  setState(
//                                        () {
//                                      _dropDownValue1 = val;
//                                    },
//                                  );
//                                },
//                              ),
//
//                              )
                            ]),
                          ),





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
                      child: new Text("${getTranslated(context, 'sav')}"),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () {

                        setState(() {
                          if(_formKeyad.currentState.validate() ){
                            if(pincodeController.text.length==6){

                              _AddAddress();

                            }
                            else{
                              showLongToast("Enter the valide pin");
                            }



//                              setInfo();


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




  Future _AddAddress() async {
// print(Constant.Shop_id);
// print(Constant.API_KEY);
// print(Constant.user_id);
// print(nameController.text);
// print(mobileController.text);
// print(emailController.text);
// print(address1.text);
// print(address2.text);
// print(cityController.text);
// print(stateController.text);
// print(pincodeController.text);
// print(labelController.text);
    var map = new Map<String, dynamic>();
    map['shop_id']=Constant.Shop_id;
    map['X-Api-Key']=Constant.API_KEY;
    map['user_id']=Constant.user_id;
    map['full_name']=nameController.text;
    map['mobile']=mobileController.text;
    map['email']=emailController.text;
    map['address1']=address1.text;
    map['address2']=address2.text!=null?address2.text:"";
    map['city']=cityController.text;
    map['state']=stateController.text;
    map['pincode']=pincodeController.text;
    map['label']=labelController.text;
    map['lat']=pre.getString("lat")!=null?pre.getString("lat"):Constant.latitude.toString();
    map['lng']=pre.getString("lng")!=null?pre.getString("lng"):Constant.longitude.toString();
   String link = Constant.base_url + "manage/api/user_address/add";

   final response = await http.post(link,body:map );
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(user.message);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),);
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));


    } else
      throw Exception("Unable to get Employee list");
  }

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
  Widget _getEditIcon() {
    return

      Container(
        margin: EdgeInsets.only(top: 23),
        child: new CircleAvatar(
          backgroundColor: AppColors.tela,
          radius: 18.0,
          child: new Icon(
            Icons.location_on,
            color: Colors.white,
            size: 20.0,
          ),
        ),

      );
  }



}
