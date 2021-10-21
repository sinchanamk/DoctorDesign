import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:royalmart/model/Gallerymodel.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/model/slidermodal.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/SubCategry.dart';
import 'package:royalmart/screen/booking.dart';
import 'package:royalmart/screen/detailpage.dart';
import 'package:royalmart/screen/detailpage1.dart';
import 'package:royalmart/screen/doctorpage.dart';
import 'package:royalmart/screen/productlist.dart';
import 'package:royalmart/screen/secondtabview.dart';
import 'package:new_version/new_version.dart';
import 'package:royalmart/screen/secondtabview1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class Demo {
  final String imagepath;
  final String text;
  Demo(
    this.imagepath,
    this.text,
  );
}

class Screen extends StatefulWidget {
  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  static int cartvalue = 0;

  final addController = TextEditingController();

  Position position;
  getAddress1(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdminArea.toString() +
          " " +
          first.featureName.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
      // print('Rahul ${address}');
      // pref.setString("lat", lat.toString());
      // pref.setString("lat", lat.toString());
      // pref.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  bool progressbar = true;
  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position.latitude;
      Constant.longitude = position.longitude;
      print(' lat ${Constant.latitude},${Constant.longitude}');
      getAddress1(Constant.latitude, Constant.longitude);
    });
  }

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
  ];

  final List<String> imgList1 = [
    'https://assets.myntassets.com/h_1440,q_90,w_1080/v1/assets/images/9329399/2019/4/24/8df4ed41-1e43-4a0d-97fe-eb47edbdbacd1556086871124-Libas-Women-Kurtas-6161556086869769-1.jpg',
  ];
  int _current = 0;
  var _start = 0;
  static List<Categary> list = new List<Categary>();
  static List<Categary> list1 = new List<Categary>();
  static List<Categary> service = new List<Categary>();
  static List<Categary> list2 = new List<Categary>();
  static List<Slider1> sliderlist = List<Slider1>();

  static List<Products> topProducts = List();
  static List<Products> topProducts1 = List();
  static List<Products> dilofdayProducts = List();
  List<Gallery> galiryImage = List();
  final List<String> imgL = List();

  List<Products> products1 = List();
  // PackageInfo packageInfo ;
  // AppUpdateInfo _updateInfo;
  String lastversion = "0";
  int valcgeck;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  getPackageInfo() async {
    NewVersion newVersion = NewVersion(context: context);
    final status = await newVersion.getVersionStatus();
    // status.canUpdate; // (true)
    // status.localVersion ;// (1.2.1)
    // status.storeVersion; // (1.2.3)
    // status.appStoreLink;
    newVersion.showAlertIfNecessary();
    // print(status.canUpdate);
    // print(status.localVersion);
    // print(status.storeVersion);
    // print(status.appStoreLink);
  }

  void _showError(dynamic exception) {
//    showLongToast(exception.toString());
//  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
  }

//   @override
//   void initState() {
//   }
  List<Demo> listdemo = [];
  List<Demo> listdemo1 = [];

  List imageList = [
    "assets/images/b.jpg",
    "assets/images/b1.jpg",
    "assets/images/b4.png",
    "assets/images/b5.jpg",
  ];

  @override
  void initState() {
    listdemo.add(Demo("assets/images/1.jpg", "OPD Appointment"));
    listdemo.add(Demo("assets/images/3.jpg", "Planned Surgery"));
    listdemo.add(Demo("assets/images/4.jpg", "Planned Admission"));
    listdemo.add(Demo("assets/images/5.jpg", "Planned Discharge"));
    listdemo.add(Demo("assets/images/2.jpg", "IPD Appointment"));

    
    listdemo1.add(Demo("assets/images/a2.png", "Eye"));
    listdemo1.add(Demo("assets/images/a3.png", "Heart"));
    listdemo1.add(Demo("assets/images/a.png", "Blood"));
listdemo1.add(Demo("assets/images/a4.png", "Dental"));
    super.initState();
//
    _getCurrentLocation();
    super.initState();

    if (Constant.Checkupdate) {
      getPackageInfo();
      Constant.Checkupdate = false;
    }
    DatabaseHelper.getData("8633").then((usersFromServe) {
      setState(() {
        service = usersFromServe;
      });
    });
    // checkForUpdate(context);
    DatabaseHelper.getData("8634").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          list1 = usersFromServe;
          if (list1 != null) {
            if (list1.length % 2 == 0) {
              list.clear();
              list2.clear();
              for (var i = 0; i < list1.length / 2; i++) {
                list.add(list1[i]);
                _start = i;
              }
              for (var m = _start + 1; m < list1.length; m++) {
                list2.add(list1[m]);
              }
            } else {
              list.clear();
              list2.clear();
              for (var i = 0; i < list1.length / 2; i++) {
                list.add(list1[i]);
                _start = i;
              }
              for (var m = _start; m < list1.length; m++) {
                list2.add(list1[m]);
              }
            }
          }
        });
      }
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          sliderlist = usersFromServe1;
        });
      }
    });

    DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          ScreenState.topProducts = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });

    DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          ScreenState.topProducts1 = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          products1 = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
//    search
    DatabaseHelper.getTopProduct1("new", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          ScreenState.dilofdayProducts = usersFromServe;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    showDilogue(context);
    return Container(
        color: AppColors.white,
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            //         // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              //           // The builder function returns a ListTile with a title that
              //           // displays the index of the current item.
              (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   color: AppColors.tela,

                  //                     child: GestureDetector(
                  //                       onTap: () {
                  //                         _getCurrentLocation();
                  //                         // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo()),);
                  //                       },
                  //                       child: Card(
                  //                         color: AppColors.tela,
                  //                         shape: RoundedRectangleBorder(
                  //                           borderRadius: BorderRadius.circular(10.0),
                  //                         ),
                  //                         elevation: 0.0,
                  //                         // child: Container(
                  //                         //   height: 40,
                  //                         //   color: AppColors.white,
                  //                         //   margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  //                         //   padding: EdgeInsets.only(top: 0, bottom: 0),
                  //                         //   child: TextField(
                  //                         //     controller: addController,
                  //                         //     enabled: false,
                  //                         //     style: TextStyle(fontSize: 12),
                  //                         //     obscureText: false,
                  //                         //     decoration: InputDecoration(
                  //                         //         hintText: "Your current location",
                  //                         //         hintStyle: TextStyle(
                  //                         //             fontSize: 14.0, color: Colors.grey),
                  //                         //         prefixIcon: Icon(
                  //                         //           Icons.location_on,
                  //                         //           color: AppColors.black,
                  //                         //         )),
                  //                         //   ),
                  //                         // ),
                  //                       ),
                  //                     ),
                  //                   ),

                  /* Container(
                            color: AppColors.tela,

                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserFilterDemo('0')),
                                );
                              },
                              child: Card(
                                color: AppColors.tela,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 0.0,
                                child: Container(
                                  height: 35,
                                  color: AppColors.white,
                                  margin:
                                  EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                  padding: EdgeInsets.only(top: 5, bottom: 0),
                                  child: TextField(
                                    enabled: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        hintText: "Search a Product,Brand....",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0, color: Colors.grey),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.black,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),*/

                  /*    service!=null? Container(
                            height: 75,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: service.length == null ? 0 : service.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 70,

//                                  color: Colors.cyan[50],

                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5),

                                    child: InkWell(
                                      onTap:(){
                                        var i=service[index].pcatId;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(service[index].pCats, i)),);

                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Screen3(service[index].pcatId,service[index].pCats)),);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 0.0, 5.0, 0.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(25.0)),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(0.0),
                                                    child: service[index]
                                                        .img
                                                        .isEmpty
                                                        ? Image.asset("assets/images/logo.png",fit: BoxFit.fill)
                                                        : Image.network(
                                                        Constant.base_url +
                                                            "manage/uploads/p_category/" +
                                                            service[index].img,
                                                        fit: BoxFit.fill),
                                                  )),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                // SizedBox(height: 10.0),
                                                Text(
                                                  service[index].pCats,
                                                  maxLines:1,


                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12,
                                                      color: AppColors.black),
                                                ),


                                              ],
                                            ),
                                            SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    )

                                );
                              },),
                          ):Row(),
*/
                  Container(
                      color: AppColors.white,
                      height: 190.0, width:500,
                      padding: EdgeInsets.only(top: 10),
                     // width: MediaQuery.of(context).size.width,
                      child: CarouselSlider.builder(
                        itemCount: imageList.length, //sliderlist.length,
                        options: CarouselOptions(
                        
                          aspectRatio: 16/10,
                         // enlargeCenterPage: true,
                          autoPlay: true,
                           autoPlayCurve: Curves.linear,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.99,
                        ),
                        itemBuilder: (ctx, index, realIdx) {
                          return Container(
                            child: GestureDetector(
                              onTap: () {
                                // if (!sliderlist[index].title.isEmpty) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Screen2(
                                //             sliderlist[index].title, "")),
                                //   );
                                // } else if (!sliderlist[index]
                                //     .description
                                //     .isEmpty) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ProductDetails1(
                                //             sliderlist[index].description)),
                                //   );
//

                               // }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 5.0, right: 5),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    //  child:Image.network(Constant.Base_Imageurl + sliderlist[index].img, fit: BoxFit.fill,)
                                    child: Image.asset(
                                      imageList[index],
                                      fit: BoxFit.cover,
                                    ),
                                    // CachedNetworkImage(
                                    //   width: MediaQuery.of(context).size.width-30,
                                    //   fit: BoxFit.fill,
                                    //   imageUrl: Constant.Base_Imageurl + sliderlist[index].img,
                                    //   placeholder: (context, url) =>
                                    //       Center(
                                    //           child:
                                    //           CircularProgressIndicator()),
                                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                                    //
                                    // )
                                  )),
                            ),
                          );
                        },
                      )),

//                           service!=null?service.length>0? Container(
//                             color: AppColors.white,
//                             padding: EdgeInsets.only(bottom: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       top: 8.0, left: 8.0, right: 8.0,bottom: 10),
//                                   child: Text("Properties",
//                                     style: TextStyle(
//                                         color: AppColors.product_title_name,
//                                         fontSize: 18,
//                                         fontFamily: 'Roboto',
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),

//                               ],
//                             ),
//                           ):Container():Container(),
//                           service!=null? Container(
//                             color: AppColors.white,
//                             padding: EdgeInsets.symmetric(vertical: 0.0),
// //                    margin: EdgeInsets.symmetric(vertical: 8.0),
//                             height: 170.0,

//                             child: service!=null?service.length != null ? ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: service.length == null ? 0 : service
//                                   .length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Container(

//                                     margin: EdgeInsets.symmetric(horizontal: 5),
//                                     child: Column(
//                                       children: <Widget>[
//                                         Card(
//                                           // color: AppColors.black,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(10.0),),
//                                           child: Material(
//                                             color: AppColors.white,
//                                             child: InkWell(
//                                               onTap: () {
//                                                 // Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
//                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(service[index].pCats, service[index].pcatId)),);

//                                               },
//                                               child: Container(
//                                                 height: 150.0,
//                                                 width: 150.0,
//                                                 decoration: new BoxDecoration(

//                                                     borderRadius: BorderRadius.circular(10),
//                                                     image: DecorationImage(
//                                                         image:service[index].img.isEmpty? AssetImage("assets/images/logo.png",):NetworkImage(
//                                                             Constant.base_url +
//                                                                 "manage/uploads/p_category/" +
//                                                                 service[index].img),
//                                                         fit: BoxFit.cover
//                                                     )
//                                                 ),
//                                                 child: Container(
// //
//                                                   decoration: BoxDecoration(
//                                                     // color: AppColors.tela1,
//                                                     borderRadius: BorderRadius
//                                                         .circular(10),

//                                                   ),
//                                                   child: Align(
//                                                       alignment: Alignment.bottomCenter,
//                                                       child: Container(
//                                                         alignment:Alignment.center,
//                                                         decoration: BoxDecoration(
//                                                           color: AppColors.tela,
//                                                           borderRadius: BorderRadius.only(
//                                                               bottomRight: Radius.circular(10.0),
//                                                               bottomLeft: Radius.circular(10.0)),
//                                                         ),
//                                                         width: MediaQuery.of(context).size.width,
//                                                         height: 28,
//                                                         child: Text(
//                                                           service[index].pCats,
//                                                           maxLines: 1,
//                                                           style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontWeight: FontWeight
//                                                                   .bold,
//                                                               fontSize: 12),
//                                                         ),
//                                                       )

//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),

//                                       ],
//                                     )

//                                 );
//                               },) : Center(
//                               child: CircularProgressIndicator(
//                                 backgroundColor: AppColors.tela,
//                               ),
//                             ):Container(),

//      ):Row(),000

                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: new BoxDecoration(
//                              color: AppColors.white,

                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 14.0, left: 8.0, right: 8.0),
                          child: Text(Constant.AppName_showon_Homescreen,
                              style: TextStyle(
                                  color: AppColors.App_H_name,
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold)),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       right: 8.0, top: 8, left: 8.0),
                        //   child: FlatButton(
                        //       color: Colors.white,
                        //       child: Text('View All',
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.blue)),
                        //       onPressed: () {
                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(builder: (context) =>
                        //         //       ProductList("new",
                        //         //           Constant.AProduct_type_Name2)),
                        //         // );
                        //       }),
                        // ),
                      ],
                    ),
                  ),

                  Container(
                      color: AppColors.white,
                    //  padding: EdgeInsets.symmetric(vertical: 10.0),
//                    margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 120.0,
                      child:ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: listdemo1
                                  .length, //list2.length == null ? 0 : list2
                              // .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    width: 80,
                                //                                  color: Colors.cyan[50],
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                           // var i = list[index].pcatId;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => UserFilterDemo("0"))
                                                    //  list[index].pcatId,
                                                    //   list[index].pCats,
                                                     // )),
                                            );
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              CircleAvatar(radius: 40,
                                              backgroundColor: Colors.grey[100],
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      image: DecorationImage(
                                                         
                                                          image: AssetImage(
                                                              listdemo1[index].imagepath)
                                                          // image:NetworkImage( Constant.base_url + "manage/uploads/p_category/" + list[index].img,)
                                                          )),
                                                                              
                                                  /* child:
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(35.0)),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(0.0),
                                                          child: list1[index]
                                                              .img
                                                              .isEmpty
                                                              ? Image.asset("assets/images/logo.png",fit: BoxFit.fill)
                                                              : Image.network(  Constant.base_url +"manage/uploads/p_category/" +
                                                                  list[index].img,
                                                              fit: BoxFit.fill),
                                                        )),*/
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: <Widget>[
                                                  // SizedBox(height: 10.0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      listdemo1[index].text,
                                                      //list[index].pCats,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 9,
                                                        color:
                                                            AppColors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                            ],
                                          ),
                                        ),
                                
                                     
                                        // list2.length>0?
                                        // InkWell(
                                        //   onTap:(){
                                        //     var i=list2[index].pcatId;
                                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => Screen3(list2[index].pcatId,list2[index].pCats)),);
                                
                                        //   },
                                        //   child: Padding(
                                        //     padding: EdgeInsets.fromLTRB(
                                        //         5.0, 0.0, 5.0, 0.0),
                                        //     child: Column(
                                        //       children: <Widget>[
                                        //         Container(
                                        //           width: 70,
                                        //           height: 70,
                                        //           decoration: BoxDecoration(
                                        //               borderRadius: BorderRadius.circular(10),
                                        //               image: DecorationImage(
                                        //                   fit: BoxFit.fill,
                                        //                   image:NetworkImage( Constant.base_url + "manage/uploads/p_category/" + list2[index].img,)
                                        //               )
                                        //           ),
                                
                                        //         /*  child:
                                        //           ClipRRect(
                                        //               borderRadius: BorderRadius.all(
                                        //                   Radius.circular(35.0)),
                                        //               child: Padding(
                                        //                 padding: EdgeInsets.all(0.0),
                                        //                 child: list1[index]
                                        //                     .img
                                        //                     .isEmpty
                                        //                     ? Image.asset("assets/images/logo.png",fit: BoxFit.fill)
                                        //                     : Image.network(
                                        //                     Constant.base_url +
                                        //                         "manage/uploads/p_category/" +
                                        //                         list2[index].img,
                                        //                     fit: BoxFit.fill),
                                        //               )),*/
                                        //         ),
                                        //         // Column(
                                        //         //   crossAxisAlignment:
                                        //         //   CrossAxisAlignment.center,
                                        //         //   mainAxisSize: MainAxisSize.min,
                                        //         //   children: <Widget>[
                                        //         //     // SizedBox(height: 10.0),
                                        //         //     Padding(
                                        //         //       padding: const EdgeInsets.all(8.0),
                                        //         //       child: Text(
                                        //         //         list2[index].pCats,
                                        //         //         maxLines: 2,
                                        //         //         textAlign: TextAlign.center,
                                        //         //         overflow: TextOverflow.ellipsis,
                                        //         //         style: TextStyle(
                                        //         //             fontWeight: FontWeight.w700,
                                        //         //             fontSize: 12,
                                        //         //             color: AppColors.black),
                                        //         //       ),
                                        //         //     ),
                                
                                        //         //     // Text(
                                        //         //     //   "${widget.items} Items",
                                        //         //     //   style: TextStyle(
                                        //         //     //     fontWeight: FontWeight.w400,
                                        //         //     //     fontSize: 10,
                                        //         //     //   ),
                                        //         //     // ),
                                        //         //     // SizedBox(height: 5),
                                        //         //   ],
                                        //         // ),
                                        //         SizedBox(width: 5),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                
                                        //     :Row(),
                                      ],
                                    ));
                              },
                            )
                          // : Center(
                          //     child: CircularProgressIndicator(
                          //       backgroundColor: AppColors.tela,
                          //     ),
                            ),

                  topProducts.length > 0
                      ? Container(
                          color: AppColors.white,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  Constant.AProduct_type_Name1,
                                  style: TextStyle(
                                      color: AppColors.product_title_name,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 8.0, left: 8.0),
                                child: RaisedButton(
                                    color: Colors.white,
                                    child: Text('View All',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductList(
                                                "Top",
                                                Constant.AProduct_type_Name1)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        )
                      : Container(),

                  topProducts.length > 0
                      ? Container(
//                            color: AppColors.black,
                          height: 280.0,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.withOpacity(.4),
                                    Colors.teal.withOpacity(.1),
                                  ])),
                          child: topProducts != null
                              ? Container(
//                              color: AppColors.tela,
                                  margin: EdgeInsets.only(
                                      left: 8.0, top: 20, bottom: 20),
                                  height: 230.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts.length == null
                                          ? 0
                                          : topProducts.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: topProducts[index] != 0
                                              ? 130.0
                                              : 230.0,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: <Widget>[
//                                          shape: RoundedRectangleBorder(
//                                            borderRadius: BorderRadius.circular(
//                                                10.0),
//                                          ),

                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                topProducts[
                                                                    index])),
                                                  );
//
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                        height: 130,
//                                            width: 162,

                                                        child: topProducts[
                                                                        index]
                                                                    .img !=
                                                                null
                                                            ? Image.network(
                                                                Constant.Product_Imageurl +
                                                                    topProducts[
                                                                            index]
                                                                        .img,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : Image.asset(
                                                                "assests/images/logo.png")

//                                                 CachedNetworkImage(
//                                                       fit: BoxFit.cover,
//                                                       imageUrl: Constant.Product_Imageurl + topProducts[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                       placeholder: (context, url) =>
//                                                           Center(
//                                                               child:
//                                                               CircularProgressIndicator()),
//                                                       errorWidget:
//                                                           (context, url, error) =>
//                                                       new Icon(Icons.error),
//
//                                                     ),
                                                        ),
                                                  ],
                                                ),
                                              ),

                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 5),
                                                  padding: EdgeInsets.only(
                                                      left: 3, right: 5),
                                                  color: AppColors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        topProducts[index]
                                                            .productName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        '(\u{20B9} ${topProducts[index].buyPrice})',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 12,
                                                            color:
                                                                AppColors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 2.0,
                                                                bottom: 1),
                                                        child: Text(
                                                            '\u{20B9} ${calDiscount(topProducts[index].buyPrice, topProducts[index].discount)}',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: AppColors.tela,
                                  ),
                                ),
                        )
                      : Container(),

                  topProducts1 != null
                      ? topProducts1.length > 0
                          ? Container(
                              color: AppColors.white,
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      'Deals of the day',
                                      style: TextStyle(
                                          color: AppColors.product_title_name,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0, left: 8.0),
                                    child: RaisedButton(
                                        color: Colors.white,
                                        child: Text('View All',
                                            style: TextStyle(
                                                color: Colors.blueGrey)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductList("day",
                                                        "Deals of the day")),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                  topProducts1 != null
                      ? topProducts1.length > 0
                          ? Container(
                              // color: AppColors.black,
                              margin: EdgeInsets.only(
                                  left: 8.0, top: 20, bottom: 20),
                              height: 230.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topProducts1.length == null
                                      ? 0
                                      : topProducts1.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width: topProducts1[index] != 0
                                              ? 170.0
                                              : 230.0,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(right: 10),
                                          child: Card(
                                            child: Column(
                                              children: <Widget>[
//                                          shape: RoundedRectangleBorder(
//                                            borderRadius: BorderRadius.circular(
//                                                10.0),
//                                          ),

                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails(
                                                                  topProducts1[
                                                                      index])),
                                                    );
//
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 130,
//                                            width: 162,

                                                        child: topProducts1[
                                                                        index]
                                                                    .img !=
                                                                null
                                                            ? Image.network(
                                                                Constant.Product_Imageurl +
                                                                    topProducts1[
                                                                            index]
                                                                        .img,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )

                                                            /*  CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: Constant
                                                              .Product_Imageurl +
                                                              topProducts1[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                          placeholder: (context, url) =>
                                                              Center(
                                                                  child:
                                                                  CircularProgressIndicator()),
                                                          errorWidget:
                                                              (context, url, error) =>
                                                          new Icon(Icons.error),

                                                        )*/

                                                            : Image.asset(
                                                                "assets/images/logo.png"),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5,
                                                        right: 5,
                                                        top: 5),
                                                    padding: EdgeInsets.only(
                                                        left: 3, right: 5),
                                                    color: AppColors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          topProducts1[index]
                                                              .productName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                AppColors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          '(\u{20B9} ${topProducts1[index].buyPrice})',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .black,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 2.0,
                                                                  bottom: 1),
                                                          child: Text(
                                                              '\u{20B9} ${calDiscount(topProducts1[index].buyPrice, topProducts1[index].discount)} ${topProducts1[index].unit_type != null ? "/" + topProducts1[index].unit_type : ""}',
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        double.parse(topProducts1[index]
                                                    .discount) >
                                                0
                                            ? showSticker(index, topProducts1)
                                            : Row()
                                      ],
                                    );
                                  }),
                            )
                          : Container()
                      : Container(),

//                           Container(
//                             color: AppColors.tela1,
//                             child: FutureBuilder(
//                                 future: getBanner(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     return ListView.builder(
//                                       itemCount: snapshot.data.length == null
//                                           ? 0
//                                           : snapshot.data.length,

//                                       shrinkWrap: true,
//                                       primary: false,
//                                       scrollDirection: Axis.vertical,
//                                       itemBuilder: (BuildContext context,
//                                           int index) {
//                                         Slider1 item = snapshot.data[index];
//                                         return InkWell(
//                                             onTap: () {
//                                               // print(item.title + "TITLE");
//                                               // print(item.description + "DESCR");
//                                               if (!item.title.isEmpty) {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           Screen2(
//                                                               item.title, "")),
//                                                 );
//                                               }
//                                               else
//                                               if (!item.description.isEmpty) {
//                                                 Navigator.push(context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           ProductDetails1(item
//                                                               .description)),);
// //

//                                               }
//                                             },

//                                             child: Card(
//                                               child: Container(
//                                                 height:190,
//                                                 padding: EdgeInsets.only(
//                                                     top: 6.0,
//                                                     left: 8.0,
//                                                     right: 8.0,
//                                                     bottom: 5),
//                                                 child: Image.network(  Constant.Product_Imageurl5 + item.img,fit: BoxFit.fill,)

//                                                 // CachedNetworkImage(
//                                                 //   fit: BoxFit.fill,
//                                                 //   imageUrl: Constant.Product_Imageurl5 + item.img,
//                                                 //   placeholder: (context, url) =>
//                                                 //       Center(),
//                                                 //   errorWidget:
//                                                 //       (context, url, error) =>
//                                                 //   new Icon(Icons.error),
//                                                 //
//                                                 // ),
//                                               ),
//                                             )
//                                         );
//                                       },

//                                     );
//                                   }
//                                   else {
//                                     return Center();
//                                   }
//                                 }
//                             ),
//                           ),

                  // products1!=null? products1.length>0?  Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.only(bottom: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //             top: 8.0, left: 8.0, right: 8.0),
                  //         child: Text("Featured Products",
                  //           style: TextStyle(
                  //               color: AppColors.product_title_name,
                  //               fontSize: 15,
                  //               fontFamily: 'Roboto',
                  //               fontWeight: FontWeight.bold),),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(
                  //             right: 8.0, top: 8.0, left: 8.0),
                  //         child: RaisedButton(
                  //             color: Colors.white,
                  //             child: Text('View All',
                  //                 style: TextStyle(
                  //                     color: Colors.blueGrey)),
                  //             onPressed: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(builder: (context) =>
                  //                     ProductList("yes",
                  //                         "Featured Products")),
                  //               );
                  //             }),
                  //       )
                  //     ],
                  //   ),
                  // ):Container():Container(),
                  // Container(height: 10,
                  //   color: AppColors.good,),

                  // products1!=null?products1.length>0?Container(
                  //   color:AppColors.good,
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     scrollDirection: Axis.vertical,
                  //     itemCount:products1.length,

                  //     itemBuilder: (BuildContext context, int index) {

                  //       return Stack(
                  //         children: [
                  //           Container(
                  //             margin: EdgeInsets.only(left: 10, right: 10, top: 6,bottom: 6),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.all(Radius.circular(16))),
                  //             child: InkWell(
                  //               onTap: () {
                  //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(products1[index])),);
                  //               },
                  //               child: Container(

                  //                 child: Row(
                  //                   children: <Widget>[
                  //                     Container(
                  //                       margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  //                       width: 110,
                  //                       height: 110,
                  //                       decoration: BoxDecoration(
                  //                           borderRadius: BorderRadius.all(Radius.circular(14)),
                  //                           color: Colors.blue.shade200,
                  //                           image: DecorationImage(
                  //                               fit: BoxFit.cover,

                  //                               image: NetworkImage(products1[index].img!=null?Constant.Product_Imageurl+products1[index].img:"ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg", )

                  //                           )),
                  //                     ),

                  //                     Expanded(
                  //                       child: Container(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: Column(
                  //                           mainAxisSize: MainAxisSize.max,
                  //                           crossAxisAlignment: CrossAxisAlignment.start,
                  //                           children: <Widget>[
                  //                             Container(
                  //                               child:
                  //                               Text(products1[index].productName==null? 'name':products1[index].productName,

                  //                                 overflow: TextOverflow.fade,
                  //                                 style:TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
                  //                                     .copyWith(fontSize: 14),
                  //                               ),

                  //                             ),
                  //                             SizedBox(height: 6),

                  //                             Row(
                  //                               children: <Widget>[
                  //                                 Padding(
                  //                                   padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                  //                                   child: Text('\u{20B9} ${calDiscount(products1[index].buyPrice,products1[index].discount)}  ${products1[index].unit_type!=null?"/"+products1[index].unit_type:""}', style: TextStyle(
                  //                                     color: AppColors.sellp,
                  //                                     fontWeight: FontWeight.w700,
                  //                                   )),
                  //                                 ),
                  //                                 SizedBox(width: 20,),
                  //                                 Expanded(
                  //                                   child: Text('(\u{20B9} ${products1[index].buyPrice})',
                  //                                     overflow:TextOverflow.ellipsis,
                  //                                     maxLines: 2,
                  //                                     style: TextStyle(
                  //                                         fontWeight: FontWeight.w700,
                  //                                         fontStyle: FontStyle.italic,
                  //                                         color: AppColors.mrp,
                  //                                         decoration: TextDecoration.lineThrough
                  //                                     ),
                  //                                   ),
                  //                                 )
                  //                               ],
                  //                             ),

                  /* Container(
                                                        margin: EdgeInsets.only(left: 0.0,right: 10),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: <Widget>[
                                                              SizedBox(width: 0.0,height: 10.0,),

                                                              Column(
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: <Widget>[
                                                                      Container(
                                                                          height: 25,
                                                                          width: 35,
                                                                          child:
                                                                          Material(

                                                                            color: AppColors.teladep,
                                                                            elevation: 0.0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                color: Colors.white,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            clipBehavior: Clip.antiAlias,
                                                                            child:Padding (
                                                                              padding: EdgeInsets.only(bottom: 10),
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    print(products1[index].count);
                                                                                    if(products1[index].count!="1"){
                                                                                      setState(() {
//                                                                                _count++;

                                                                                        String  quantity=products1[index].count;
                                                                                        int totalquantity=int.parse(quantity)-1;
                                                                                        products1[index].count=totalquantity.toString();

                                                                                      });
                                                                                    }



//



                                                                                  },
                                                                                  child:Padding(padding: EdgeInsets.only(top:10.0,),

                                                                                    child:Icon(
                                                                                      Icons.maximize,size: 20,
                                                                                      color: Colors.white,
                                                                                    ),


                                                                                  )
                                                                              ),
                                                                            ),
                                                                          )),

                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
                                                                        child:Center(
                                                                          child:
                                                                          Text(products1[index].count!=null?'${products1[index].count}':'$_count',

                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 19,
                                                                                  fontFamily: 'Roboto',
                                                                                  fontWeight: FontWeight.bold)),

                                                                        ),),

                                                                      Container(
                                                                          margin: EdgeInsets.only(left: 3.0),
                                                                          height: 25,
                                                                          width: 35,
                                                                          child:
                                                                          Material(

                                                                            color: AppColors.teladep,
                                                                            elevation: 0.0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                color: Colors.white,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            clipBehavior: Clip.antiAlias,
                                                                            child: InkWell(
                                                                              onTap: () {
                                                                                if(int.parse(products1[index].count) <= int.parse(products1[index].quantityInStock)){
                                                                                  setState(() {
//                                                                                _count++;

                                                                                    String  quantity=products1[index].count;
                                                                                    int totalquantity=int.parse(quantity)+1;
                                                                                    products1[index].count=totalquantity.toString();

                                                                                  });
                                                                                }
                                                                                else{
                                                                                  showLongToast('Only  ${products1[index].count}  products in stock ');
                                                                                }


                                                                              },


                                                                              child:Icon(
                                                                                Icons.add,size: 20,
                                                                                color: Colors.white,
                                                                              ),


                                                                            ),
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              // SizedBox(width: 10,),

                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: <Widget>[

                                                                  Container(
                                                                      margin: EdgeInsets.only(left: 3.0),
                                                                      height: 40,

                                                                      child:
                                                                      Material(

                                                                        color: AppColors.sellp,
                                                                        elevation: 0.0,
                                                                        shape: RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                            color: Colors.white,
                                                                          ),
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        clipBehavior: Clip.antiAlias,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            if(Constant.isLogin){


                                                                              String  mrp_price=calDiscount(products1[index].buyPrice,products1[index].discount);
                                                                              totalmrp= double.parse(mrp_price);


                                                                              double dicountValue=double.parse(products1[index].buyPrice)-totalmrp;
                                                                              String gst_sgst=calGst(mrp_price,products1[index].sgst);
                                                                              String gst_cgst=calGst(mrp_price,products1[index].cgst);

                                                                              String  adiscount=calDiscount(products1[index].buyPrice,products1[index].msrp!=null?products1[index].msrp:"0");

                                                                              admindiscountprice=(double.parse(products1[index].buyPrice)-double.parse(adiscount));



                                                                              String color="";
                                                                              String size="";
                                                                              _addToproducts(products1[index].productIs,products1[index].productName,products1[index].img,int.parse(mrp_price),int.parse(products1[index].count),color,size,products1[index].productDescription,gst_sgst,gst_cgst,
                                                                                  products1[index].discount,dicountValue.toString(), products1[index].APMC, admindiscountprice.toString(),products1[index].buyPrice,products1[index].shipping,products1[index].quantityInStock);


                                                                              setState(() {
//                                                                              cartvalue++;
                                                                                Constant.carditemCount++;
                                                                                cartItemcount(Constant.carditemCount);

                                                                              });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

                                                                            }
                                                                            else{


                                                                              Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => SignInPage()),);
                                                                            }

//

                                                                          },
                                                                          child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
                                                                              child:Center(

                                                                                child:Icon(Icons.add_shopping_cart,color: Colors.white,),

                                                                              )),),
                                                                      )),









                                                                ],
                                                              ),






                                                            ]
                          //                               ) ,
                          //                             ),*/

                  //                           ],
                  //                         ),

                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),

                  //             ),
                  //           ),
                  //           double.parse(products1[index].discount)>0?  showSticker(index,products1):Row()

                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ):Row():Row(),

                  /* Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 5,left: 8,right: 8,top: 5),
                            padding: EdgeInsets.all( 8) ,


                            decoration: new BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),


//                              color: AppColors.white,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image:  AssetImage("assets/images/banner2.jpeg"),
                              ),


                              // color: Colors.white,
                            ),

                          ),*/
                  dilofdayProducts.length > 0
                      ? Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  Constant.AProduct_type_Name2,
                                  style: TextStyle(
                                      color: AppColors.product_title_name,
                                      fontSize: 17,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 8.0, left: 8.0),
                                child: FlatButton(
                                    color: Colors.white,
                                    child: Text('View All',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>UserFilterDemo("0"),)
                                            //  ProductList(
                                            //     "new",
                                            //     Constant.AProduct_type_Name2)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        )
                      : Container(),

                  // dilofdayProducts.length>0?
                  // Container(
                  //   color: Colors.black12,
                  // child: ListView.builder(
                  //   primary: false,
                  //    physics:ClampingScrollPhysics() ,
                  //    controller: new ScrollController(keepScrollOffset: false),
                  //     shrinkWrap: true,

                  //     // crossAxisCount: 2,
                  //     // childAspectRatio: 0.68,
                  //     padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
                  //     itemBuilder: (BuildContext context, int index) {
                  //children: List.generate(dilofdayProducts.length, (index){

//                                   return Container(
//                                     height: 170,
//                                     child: Card(
//                                       elevation: 2.0,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       child: Column(
//                                         children: <Widget>[
//                                           InkWell(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ProductDetails(
//                                                             dilofdayProducts[index])),
//                                               );
// //
//                                             },
                  dilofdayProducts.length > 0
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          height: 260,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: dilofdayProducts.length == null
                                  ? 0
                                  : dilofdayProducts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    width: 170.0,
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoctorPage(
                                                         )),
                                            );
//
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 180,
                                                width: double.infinity,
                                                //  child:Image.network(Constant.Product_Imageurl + dilofdayProducts[index].img,fit: BoxFit.cover,)
                                                child: Image.asset(
                                                  listdemo[index].imagepath,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

//                                               CachedNetworkImage(
//                                                 fit: BoxFit.cover,
//                                                 imageUrl: Constant.Product_Imageurl + dilofdayProducts[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                 placeholder: (context, url) =>
//                                                     Center(
//                                                         child:
//                                                         CircularProgressIndicator()),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                 new Icon(Icons.error),
//
//                                               ),

                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 5,
                                                      bottom: 5),
                                                  padding: EdgeInsets.only(
                                                      left: 3, right: 5),
                                                  color: AppColors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        listdemo[index].text,
                                                        //dilofdayProducts[index].productName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '(\u{20B9} ${dilofdayProducts[index].buyPrice})',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 12,
                                                                color: AppColors
                                                                    .black,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 2.0,
                                                                    bottom: 1,
                                                                    right: 10),
                                                            child: Text(
                                                                '\u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice, dilofdayProducts[index].discount)}',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )));
                              }))
                      : Container(),

                  /*Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            height: 138.0,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dilofdayProducts.length == null
                                    ? 0
                                    : dilofdayProducts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 130.0,

                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child:
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        dilofdayProducts[index])),
                                          );
//
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 130,

                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: Constant
                                                    .Product_Imageurl +
                                                    dilofdayProducts[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                        CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                new Icon(Icons.error),

                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),


                          ),*/

                  /*  Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 6.0, left: 8.0, right: 8.0, bottom: 10),
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/banner-2.png'),
                            ),
                          ),
                        )*/
                ],
              ),
              // Builds 1000 ListTiles
              childCount: 1,
            ),
          )
        ]));
  }

  /*Showpop(){
    showDialog(
      barrierDismissible: false, // JUST MENTION THIS LINE
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(5.0),
                child:  Container(
                  height: 110.0,
                  width: 320.0,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding:  EdgeInsets.all(5.0),
                          child: Text("New Version is avaliable on Playstore",style: TextStyle(fontSize: 18,color: Colors.black),)
                      ),
//          Padding(
//              padding:  EdgeInsets.all(10.0),
//              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
//          ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (_updateInfo.availableVersionCode-valcgeck)<3? FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel !', style: TextStyle(color: AppColors.black, fontSize: 18.0),)):Row(),

                          FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                // _launchURL();
                              },
                              child: Text('Update ', style: TextStyle(color: AppColors.green, fontSize: 18.0),)),

                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }*/

//  showDilogue(BuildContext context) {
//    Dialog errorDialog = Dialog(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//      //this right here
//      child: Container(
//        height: 160.0,
//        width: 300.0,
//
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Padding(
//                padding: EdgeInsets.all(10.0),
//                child: Text("New Version is avaliable on Playstore",
//                  style: TextStyle(fontSize: 18, color: Colors.black),)
//            ),
////          Padding(
////              padding:  EdgeInsets.all(10.0),
////              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
////          ),
//
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('Cancel !', style: TextStyle(
//                        color: AppColors.black, fontSize: 18.0),)),
//
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      _launchURL();
//                    },
//                    child: Text('Update Now ', style: TextStyle(
//                        color: AppColors.green, fontSize: 18.0),)),
//
//              ],
//            )
//          ],
//        ),
//      ),
//    );
//    showDialog(
//        context: context, builder: (BuildContext context) => errorDialog);
//  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(Constant.val);
    print(returnStr);
    return returnStr;
  }

  _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.sanjarcreation';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
