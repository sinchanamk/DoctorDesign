import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:royalmart/BottomNavigation/categories.dart';
import 'package:royalmart/BottomNavigation/profile.dart';
import 'package:royalmart/BottomNavigation/screenpage.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/BottomNavigation/new_cat.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/profile.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/locatization/language.dart';
import 'package:royalmart/locatization/language_constant.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'drawer.dart';
import 'my_app_bar.dart';

class MyApp1 extends StatefulWidget {
  @override
  MyApp1State createState() => MyApp1State();
}

class MyApp1State extends State<MyApp1> {
  static int countval = 0;
  SharedPreferences pref;

  // final translator =GoogleTranslator();
  void gatinfoCount() async {
    pref = await SharedPreferences.getInstance();

    int Count = pref.getInt("itemCount");
    bool ligin = pref.getBool("isLogin");
    String userid = pref.getString("user_id");
    String image = pref.getString("pp");
    String lval = pref.getString("language");
    setState(() {
      lngval = lval != null ? lval : "en";
      Constant.image = image;
      print(image);
      print("Constant.image=image");
      Constant.user_id = userid;
      if (ligin != null) {
        Constant.isLogin = ligin;
      } else {
        Constant.isLogin = false;
      }
      if (Count == null) {
        Constant.carditemCount = 0;
      } else {
        Constant.carditemCount = Count;
        countval = Count;
      }
//      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  Position position;
  getAddress(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      // valArea=first.subLocality+ " "+first.subAdminArea.toString()+" "+first.featureName.toString()+" "+first.thoroughfare.toString()+""+first.postalCode.toString();
      var address = first.subLocality.toString() +
          " " +
          first.subAdminArea.toString() +
          " " +
          first.featureName.toString() +
          " " +
          first.thoroughfare.toString();
      print('Rahul ${address}');
      pref.setString("lat", lat.toString());
      pref.setString("lat", lat.toString());
      pref.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position.latitude;
      Constant.longitude = position.longitude;
      print(' lat ${Constant.latitude},${Constant.longitude}');
      getAddress(Constant.latitude, Constant.longitude);
    });
  }

  void _changelanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  int count = 0;
  @override
  void initState() {
    _getCurrentLocation();
//    getData();
    // TODO: implement initState
    super.initState();
    // translator = GoogleTranslator();
    gatinfoCount();
  }
             //     class Demo {
//   final String imagepath;
//   final String text;
//   Demo(
//     this.imagepath,
//     this.text,
//   );
// }
//  List<Demo> listdemo = [];
 
//  List imageList = [
//     "assets/images/b.jpg",
//     "assets/images/b1.jpg",
//     "assets/images/b4.png",
//     "assets/images/b5.jpg",
//   ];

//   @override
//   void initState() {
//        listdemo.add(Demo("assets/images/1.jpg", "OPD Appointment"));
//     listdemo.add(Demo("assets/images/3.jpg", "Planned Surgery"));
//     listdemo.add(Demo("assets/images/4.jpg", "Planned Admission"));
//     listdemo.add(Demo("assets/images/5.jpg", "Planned Discharge"));
//     listdemo.add(Demo("assets/images/2.jpg", "IPD Appointment"));
//     super.initState();
// //  

  String lngval;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Screen _screen = Screen();
  // final Cgategorywise _categories = Cgategorywise();
  final My_Cat _categories = My_Cat();
  final WishList _cartitem = WishList();
  final ProfilePage _profilePage = ProfilePage();

  int _current = 0;
  int _selectedIndex = 0;
  Widget _showPage = new Screen();
  Widget _PageChooser(int page) {
    switch (page) {
      case 0:
        _onItemTapped(0);
        return _screen;
        break;
      case 1:
        _onItemTapped(1);
        return _categories;
        break;
      case 2:
        _onItemTapped(2);
        // return _cartitem;
        return _profilePage;
        break;
      // case 3:
      //   _onItemTapped(3);
      //   return _profilePage;
      //   break;
      default:
        return Container(
          child: Center(
            child: Text('No Page is found'),
          ),
        );
    }
  }

  String appname;
  String hm, cat, cart, hlp;
  static String cathome;
  bool check = false;
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select City'),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: FutureBuilder(
                  future: getPcity(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length == null
                              ? 0
                              : snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: snapshot.data[index] != 0 ? 130.0 : 230.0,
                              color: Colors.white,
//                                margin: EdgeInsets.only(right: 10),

                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    check = true;
                                    pref.setString(
                                        'city', snapshot.data[index].places);
                                    pref.setString(
                                        'cityid', snapshot.data[index].loc_id);
                                    Constant.cityid =
                                        snapshot.data[index].loc_id;
                                    Constant.citname =
                                        snapshot.data[index].places;
                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp1()),
                                    );
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Text(
                                            snapshot.data[index].places,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Divider(
                                    //
                                    //   color: AppColors.black,
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: check ? Colors.green : Colors.grey),
                ),
                onPressed: () {
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select city");
                },
              )
            ],
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // drawer is open then first close it
        if (_scaffoldKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else {
          showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                    title: Text('Warning'),
                    content: Text('Do you really want to exit'),
                    actions: [
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () => {
                          exit(0),
                        },
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: () => Navigator.pop(c, false),
                      ),
                    ],
                  ));
        }
        // we can now close the app.
        return true;
      },
      child: Scaffold(
        // key: _scaffoldKey,

        // drawer: Drawer(
        //   child: AppDrawer(),
        // ),
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.only(top: 10, bottom: 0),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  margin: EdgeInsets.only(top: 10, bottom: 15),
                  child: Material(
                    color: Colors.grey[100],
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey[100],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserFilterDemo('0')),
                          );
                        },
                        child: SizedBox(height: 50,width: 500,
                          child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: TextField(
                              
                              enabled: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                  hintText: "Search Product",
                                  hintStyle: TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
            automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: AppColors.tela,
//                backgroundColor: Colors.blue,
         

          // actions: <Widget>[

          //   InkWell(
          //     onTap: (){
          //       Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => WishList()),);
          //     },
          //     child: Stack(
          //       children: <Widget>[
          //         Padding(
          //           padding: EdgeInsets.only(top: 20,right: 30),
          //           child: Icon(Icons.add_shopping_cart,color: Colors.blue,size: 22,),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Padding(
          //             padding: EdgeInsets.only(left: 15,bottom: 28,top: 0),
          //             child: Container(

          //               padding: const EdgeInsets.all(5.0),
          //               decoration: new BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 color: AppColors.telamoredeep,
          //               ),
          //               child: Text('${Constant.carditemCount}',
          //                   style: TextStyle(color: Colors.white, fontSize: 15.0)),
          //             ),
          //           ),

          //         ),
          //         // ScreenState.showCircle(),
          //       ],
          //     ),
          //   ),

          // ],
          /* bottom: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: Container(

          margin: EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: InkWell(
//            onTap: () {
//              showSearch(context: context, delegate: DataSerch(SplashScreenState.filteredUsers));
//
//              print('ontap method');
//            },
            child: Material(

              color: AppColors.teladep,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.tela,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(

                child:Padding(padding: EdgeInsets.only(top:5.0),
              child:
              TextField(
                  onTap:(){
//                    showSearch(context: context, delegate: DataSerch(SplashScreenState.filteredUsers));


                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserFilterDemo()),
                    );
                  },
    style: TextStyle(
    color: Colors.green[900]),
                decoration: InputDecoration(

                  hintText: 'Search Your Product',
                  hintStyle: TextStyle(color: AppColors.tela),

                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),)),
            ),
          ),
        ),

      ),*/
        ),
//              MyAppBar(
//                scaffoldKey: _scaffoldKey,
//              ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: [
        //     BottomNavigationBarItem(
        //       icon:
        //           // Image.asset("assets/images/home.png", height: 28,width: 28,fit:BoxFit.fill),

        //           Icon(
        //         Icons.home,
        //         color: _selectedIndex == 0 ? AppColors.tela : AppColors.green,
        //         size: 25,
        //       ),
        //       title: Text(
        //         '${getTranslated(context, 'home')}',
        //         style: TextStyle(fontSize: 12),
        //       ),
        //     ),]),
            // BottomNavigationBarItem(
            //   icon: Image.asset("assets/images/cat.jpeg",
            //       height: 28, width: 28, fit: BoxFit.fill),
            //   title: Text('${getTranslated(context, 'cat')}',
            //       style: TextStyle(fontSize: 12)),
            // ),
            /*  BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart,color: _selectedIndex == 2 ? AppColors.tela : AppColors.green,size: 25,),
              title: Text(' ${getTranslated(context, 'mcart')}',style: TextStyle(fontSize: 12)),
            ),
*/
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.person,
        //         color: _selectedIndex == 2 ? AppColors.tela : AppColors.green,
        //         size: 25,
        //       ),
        //       title: Text('${getTranslated(context, 'ac')}',
        //           style: TextStyle(fontSize: 12)),
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: AppColors.onselectedBottomicon,
        //   backgroundColor: Colors.white,
        //   type: BottomNavigationBarType.fixed,
        //   onTap: (int index) {
        //   debugPrint("Current Index is $index");
        //     setState(() {
        //       _showPage = _PageChooser(index);
        //     });
        //   },
        // ),

        body: Container(
            color: AppColors.tela,
//    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
            child: _showPage),
      ),
    );
  }
}
