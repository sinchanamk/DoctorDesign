import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'AppConstant.dart';
import 'Home.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {

  var _visible = true;
  String logincheck ;

  void getLocation() async {
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {

      Constant.latitude=position.latitude;
      Constant.longitude=position.longitude;
    });
    print(position);
  }
  void checkLogin() async {
    SharedPreferences pref= await SharedPreferences.getInstance();

    String pin= pref.getString("pin");
    String cityid= pref.getString("cityid");
    bool  val= pref.getBool("isLogin");

    pref.setString("lat",  Constant.latitude.toString());
    pref.setString("lng",  Constant.longitude.toString());

    print("cityid.length");
    print(val);

    setState(() {
      // cityid==null?Constant.cityid="": Constant.cityid=cityid;
      Constant.pinid=pin;
      val==null? Constant.isLogin=false:Constant.isLogin=val;
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),):
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),):
      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);

    });


    // print(cityname);



  }


  AnimationController animationController;
  Animation<double> animation;
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {


    checkLogin();
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectButton()),);


    /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );*/




  }

  @override
  void initState() {
    super.initState();

    getLocation();




    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
//    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

//              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))


            ],),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/d1.jpg',fit: BoxFit.cover,
                width: animation.value * 550,
                height: animation.value * 550,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
