

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/dbhelper/wishlistdart.dart';
import 'package:royalmart/model/Gallerymodel.dart';
import 'package:royalmart/model/GroupProducts.dart';
import 'package:royalmart/model/Varient.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/screen/Zoomimage.dart';
import 'package:royalmart/screen/detailpage1.dart';
import 'package:royalmart/screen/secondtabview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart';


class ProductDetails extends StatefulWidget {
  final Products plist;
  const ProductDetails(this.plist) : super();

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {


  List <PVariant> pvarlist= List();

  String name="";
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable:true,
            title: Text('Select Variant'),
            content: Container(

              width: double.maxFinite,
              height: pvarlist.length*50.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: pvarlist.length == null
                      ? 0
                      : pvarlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      Container(
                        width: pvarlist[index]!=0?130.0:230.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 10),

                        child: InkWell(
                          onTap: () {
                            setState(() {
                              total= int.parse(pvarlist[index].price);
                              String  mrp_price=calDiscount(pvarlist[index].price,pvarlist[index].discount);
                              totalmrp= double.parse(mrp_price);
                              textval=pvarlist[index].variant;
                              name=pvarlist[index].variant;
                              Navigator.pop(context);

                            });

                          },
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                child: Text(
                                  pvarlist[index].variant,
                                  overflow:TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 15,color:AppColors.black,

                                  ),
                                ),
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



  int _current=0;
  bool flag= true;
  int wishid;
  bool wishflag= true;
  String url="";
  String textval="Select varient";
  // List<Products> products1 = List();
  List<Products> topProducts1 = List();


  final List<String> imgList1 = new List<String>();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  final List<String> _currencies=['ram','mohan'];
  int _count =1;
  String _dropDownValue;
  String _dropDownValue2;
  String _dropDownValue1,groupname="";
  int total;
  int actualprice=200;
  double mrp,totalmrp;
  double sgst1,cgst1 ,dicountValue,admindiscountprice;

  List<Gallery> galiryImage1 = List();
  List<GroupProducts> group = List();
  List<Products> productdetails = List();
  List<String>size;
  List<String>color;
  List<String>catid= List<String>();
  ProductsCart products;
  WishlistsCart nproducts;
  final DbProductManager dbmanager = new DbProductManager();
  final DbProductManager1 dbmanager1 = new DbProductManager1();

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;



  void gatinfoCount() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    Constant.isLogin= false;
    int Count=pref.getInt("itemCount");
    bool ligin=pref.getBool("isLogin");
    setState(() {
      if( ligin!=null) {
        Constant.isLogin = ligin;

      }
      if(Count==null){
        Constant.carditemCount=0;
      }else {
        Constant.carditemCount = Count;
      }
      print(Constant.carditemCount.toString()+"itemCount");
    });



  }

  static List<WishlistsCart> prodctlist1;
  // final DbProductManager1 dbmanager12 = new DbProductManager1();



  @override
  void initState() {
    super.initState();
    name=widget.plist.productName;
    gatinfoCount();
    print(' product id ${widget.plist.productIs}');


    getPvarient(widget.plist.productIs).then((usersFromServe) {
      setState(() {
        pvarlist = usersFromServe;
      });

    });



    dbmanager1.getProductList().then((usersFromServe) {
      setState(() {
        prodctlist1 = usersFromServe;
        for(var i=0;i<prodctlist1.length;i++){
          if(prodctlist1[i].pid==widget.plist.productIs){
            wishid=prodctlist1[i].id;
            wishflag=false;
          }

        }

      });

    });


    catid =widget.plist.productLine.split(',');
    size=widget.plist.productScale.split(',');
    color=widget.plist.productColor.split(',');

    DatabaseHelper.getImage(widget.plist.productIs).then((usersFromServe){
      setState(() {
        galiryImage1=usersFromServe;
        imgList1.clear();
        for(var i=0;i<galiryImage1.length;i++){
          imgList1.add(galiryImage1[i].img);
        }

      });
    });

    GroupPro(widget.plist.productIs).then((usersFromServe){
      if(this.mounted){
        setState(() {
          group=usersFromServe;
          print(group!=null);
          if(group!=null) {
            groupname = group[0].name;
          }
          print(group.toString()+"group info");
        });
      }

    });
    catby_productData(catid.length>0?catid[0]:"0","0").then((usersFromServe){
      setState(() {
        topProducts1=usersFromServe;
      });
    });

    setState(() {

      actualprice=int.parse(widget.plist.buyPrice);
      total=actualprice;
      url=widget.plist.img;
      String  mrp_price=calDiscount(widget.plist.buyPrice,widget.plist.discount);
      totalmrp= double.parse(mrp_price);


      dicountValue=double.parse(widget.plist.buyPrice)-totalmrp;
      String gst_sgst=calGst(totalmrp.toString(),widget.plist.sgst);
      String gst_cgst=calGst(totalmrp.toString(),widget.plist.cgst);

      sgst1 =double.parse(gst_sgst);
      cgst1 =double.parse(gst_cgst);
    });
  }
  bool showdis= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.tela1,
      appBar: AppBar(

        elevation: 0.0,
        backgroundColor: AppColors.tela,

        title: Text("Product Details",style: TextStyle(color: AppColors.white),),
        actions: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishList()),
              );
            },
            child: Stack(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(right: 40,top: 17),
                  child: Icon(Icons.add_shopping_cart,color: Colors.white,size: 30,),
                ),
//                showCircle(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15,bottom: 18),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.telamoredeep,
                      ),
                      child: Text('${Constant.carditemCount}',
                          style: TextStyle(color: Colors.white, fontSize: 15.0)),
                    ),
                  ),

                )

              ],
            ),
          ),


        ],
      ),



      body:Container(
        // color: AppColors.tela1,
        color: AppColors.white,

        child:SafeArea(

            top: false,
            left: false,
            right: false,
            child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    // Use a delegate to build items as they're scrolled on screen.
                    delegate: SliverChildBuilderDelegate(
                      // The builder function returns a ListTile with a title that
                      // displays the index of the current item.
                          (context, index) => Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                       SizedBox(height:10),
                          imgList1!=null?imgList1.length>0? Container(
                            // height: MediaQuery.of(context).size.height/2.6,
                              child:CarouselSlider.builder(
                                  itemCount: imgList1.length,
                                  options: CarouselOptions(
                                    aspectRatio: 1.5,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                  ),
                                  itemBuilder: (ctx, index, realIdx) {
                                    return InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ZoomImage(imgList1)),
                                        );
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: AppColors.tela1,


                                          borderRadius: BorderRadius.circular(20),),
                                        width: MediaQuery.of(context).size.width,


                                        child:Container(

                                            margin: EdgeInsets.all(5.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                              child:
                                              Image.network(
                                                Constant.Product_Imageurl2+imgList1[index],
                                                  fit: BoxFit.fill,
                                              ),
                                             /* CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl:Constant.Product_Imageurl2+imgList1[index],
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                        CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                new Icon(Icons.error),

                                              ),*/



                                            )
                                        ),





                                      ),
                                    );


                                  })
                          ):Row():Row(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: map<Widget>(imgList1, (index, url) {
                              return Container(
                                width: 25.0,
                                height: 0.0,

                                child: Divider(
                                  height: 20,
                                  color: _current == index ? Colors.pinkAccent : AppColors.darkGray,

                                  thickness: 2.0,
//                                  endIndent: 30.0,
                                ),

                                margin: EdgeInsets.symmetric(horizontal: 4.0,vertical: 7.0),
//                                decoration: BoxDecoration(
//                                  shape: BoxShape.rectangle,
//                                  color: _current == index ? Colors.orange : Colors.grey,
//                                ),
                              );
                            }),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 10),
                            child: Text(name,
                                style: TextStyle(
                                  color: Colors.black,fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 20,top: 10,right: 50),
                            child:  Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                  child: Text('\u{20B9} $total', style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough
                                  )),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                  child: Text( '\u{20B9} ${(totalmrp*_count).toStringAsFixed(Constant.val) }',
//                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
                                      style: TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),

                              ],
                            ),
                          ),

                          Container(

                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(15),
                            ),

                            margin: EdgeInsets.only(left: 10,right: 20),
                            padding: EdgeInsets.all(10),
                            child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children : <Widget>[
                                  widget.plist.productColor.length<2?Container(height: 5,):  Container(

                                  ) ,

                                  widget.plist.productColor.length<2?Container():
                                  Container(
                                    width: 120,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child:
                                      DropdownButton(

                                        elevation: 0,
                                        hint: _dropDownValue == null
                                            ? Text('Select color')
                                            : Text(
                                          _dropDownValue,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        isExpanded: true,
                                        iconSize: 30.0,
                                        style: TextStyle(color: Colors.blue),
                                        items:color.map(
                                              (val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(val),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (val) {
                                          setState(
                                                () {
                                              _dropDownValue = val;
                                            },
                                          );
                                        },
                                      ),),
                                  ),
                                  SizedBox(width: 30,),
                                  Expanded(child:

                                  widget.plist.productScale.length<2?Container():Container(
                                    width: 120,
                                    child: DropdownButton(
                                      hint: _dropDownValue1 == null
                                          ? Text('Select Size')
                                          : Text(
                                        _dropDownValue1,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      isExpanded: true,
                                      iconSize: 30.0,
                                      style: TextStyle(color: Colors.blue),
                                      items: size.map(
                                            (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(val),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        setState(
                                              () {
                                            _dropDownValue1 = val;
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  )
                                ]),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 0.0,right: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(width: 0.0,height: 0.0,),

                                 /* Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                              height: 33,
                                              width: 40,
                                              child:
                                              Material(

                                                color: AppColors.teladep,
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(2),
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                    onTap: () {

                                                      if(_count!=1) {
                                                        setState(() {
                                                          _count--;
//                                                        totalmrp=mrp * _count;
                                                        });
                                                      }



                                                    },
                                                    child:Padding(padding: EdgeInsets.only(top:10.0,),

                                                      child:Icon(
                                                        Icons.maximize,size: 30,
                                                        color: Colors.white,
                                                      ),


                                                    )
                                                ),
                                              )),

                                          Padding(
                                            padding:
                                            EdgeInsets.only(top: 0.0, left: 10.0, right: 8.0),
                                            child:Center(
                                              child:
                                              Text('$_count',

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 19,
                                                      fontFamily: 'Roboto',
                                                      fontWeight: FontWeight.bold)),

                                            ),),

                                          Container(
                                              margin: EdgeInsets.only(left: 3.0),
                                              height: 33,
                                              width: 44,
                                              child:
                                              Material(

                                                color: AppColors.teladep,
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(2),
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    if(_count<=int.parse(widget.plist.quantityInStock)){
                                                      setState(() {
                                                        _count++;
//                                                     totalmrp=mrp * _count;
                                                      });

                                                    }else{
                                                      Scaffold.of(context)
                                                          .showSnackBar(SnackBar(content: Text( " Products  is not avaliable "), duration: Duration(seconds: 1)));

                                                    }
                                                  },


                                                  child:Icon(
                                                    Icons.add,size: 30,
                                                    color: Colors.white,
                                                  ),


                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
*/

                                  Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(width: 5),

                                          wishflag?InkWell(
                                            onTap: () {
                                              if(Constant.isLogin){
                                                _addToproducts1(context);
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            " Products  is added to wishlist "),
                                                        duration: Duration(
                                                            seconds: 1)));
                                                setState(() {

                                                  Constant.wishlist++;
                                                  _countList(Constant.wishlist);

//                                                  print( Constant.totalAmount);
                                                  wishflag=false;
                                                });

                                              }

                                              else{


                                                Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => SignInPage()),);
                                              }



                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 3.0),
                                              height: 33,
                                              width: 45,
                                              child:Icon(
                                                  Icons.favorite_border,size: 30,
                                                  color: AppColors.pink
                                              ),),
                                          ):
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                dbmanager1.deleteProducts(wishid);
                                                wishflag=true;

                                              });

                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 3.0),
                                              height: 33,
                                              width: 45,
                                              child:Icon(
                                                  Icons.favorite,size: 30,
                                                  color: AppColors.pink
                                              ),),
                                          ),
                                          SizedBox(width: 20,),
                                          Container(
                                              margin: EdgeInsets.only(left: 3.0),
                                              height: 35,

                                              child:
                                              Material(

                                                color: AppColors.pink,
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    /*  if(Constant.isLogin){


                                                      if(widget.plist.productColor.length>2&&widget.plist.productScale.length>2){

                                                        if(_dropDownValue!=null&&_dropDownValue1!=null) {

                                                          addTocardval();
                                                          Constant.carditemCount++;
                                                          cartItemcount(Constant.carditemCount);


                                                        }else{
                                                          showLongToast("Please select coor and size");
                                                        }


                                                      }



                                                      else if(widget.plist.productColor.length>2){
                                                        if(_dropDownValue!=null){


                                                          addTocardval();
                                                          Constant.carditemCount++;
                                                          cartItemcount(Constant.carditemCount);

                                                        }
                                                        else{
                                                          showLongToast("Please select color");
                                                        }


                                                      }

                                                      else if(widget.plist.productScale.length>2){

                                                        if(_dropDownValue1!=null){


                                                          addTocardval();
                                                          Constant.carditemCount++;
                                                          cartItemcount(Constant.carditemCount);
                                                        }
                                                        else{
                                                          showLongToast("Please select size");
                                                        }

                                                      }

                                                      else{


                                                        addTocardval();
                                                        Constant.carditemCount++;
                                                        cartItemcount(Constant.carditemCount);
                                                      }









                                                    }
                                                    else{


                                                      Navigator.push(context,
                                                        MaterialPageRoute(builder: (context) => SignInPage()),);
                                                    }*/
                                                    launchphone(widget.plist.vendorName);


                                                  },
                                                  child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
                                                      child:Center(

                                                        child:
                                                        Text("Call now",style: TextStyle(color: AppColors.white),

                                                        ),)),),
                                              )),







                                        ],
                                      )
                                    ],
                                  ),






                                ]
                            ) ,
                          ),

                          pvarlist.length>0? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget> [
                              Padding(
                                padding: const EdgeInsets.only(left:16.0,top: 18.0),
                                child: new Text(
                                  ' Variant:',
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Padding(
                                  padding: const EdgeInsets.only(left:16.0,top: 8.0),
                                  child: InkWell(
                                    onTap: (){

                                      _displayDialog(context);
                                      // _showSelectionDialog(context);
                                    },
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width/1.5,
                                      padding: const EdgeInsets.only(left:10.0,top: 0.0,right:10.0,),
                                      margin: const EdgeInsets.only(top: 5.0,),


                                      child:  Center(child:Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            child: Text(
                                              textval.length>20?textval.substring(0,20)+"..": textval,

                                              overflow:TextOverflow.fade,
                                              // maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 15,color:AppColors.black,

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


                              /*Container(
                                 color: AppColors.black,
                                   margin:EdgeInsets.only(left: 10,top: 10,right: 10) ,
                                   height: 45,
                                   child: Padding(
                                     padding: EdgeInsets.only(left: 0,top: 0,right: 0),
                                     child: TextField(
                                         minLines: 1,
                                         maxLines: 3,
                                         decoration: InputDecoration(
                                           prefixIcon: Icon(Icons.expand_more),
                                             hintText: "Select varient",
                                             border: OutlineInputBorder()
                                         )),))*/

                            ],
                          ):Row(),
                          SizedBox(height: 20,),

                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:16.0,top: 8.0),
                                child: new Text(
                                  'Product Details:',
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){

                                  if(showdis){
                                    setState(() {
                                      showdis=false;
                                    });

                                  }
                                  else{
                                    setState(() {
                                      showdis=true;
                                    });


                                  }
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(left: 16.0,top: 8.0),
                                    child:Icon(
                                        showdis? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,

//                                        Icons.keyboard_arrow_down,
                                        size: 30,
                                        color: AppColors.black
                                    )
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          showdis? Column(
                            children: <Widget>[

                              // discription("Warranty: ",widget.plist.warrantys),

                             /* Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:16.0,top: 8.0),
                                    child:  Text("Return: " ,
                                      overflow: TextOverflow.fade,
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:16.0,top: 8.0),
                                    child:  Text(widget.plist.returns=="0"?"No":widget.plist.returns+"day",
                                      overflow: TextOverflow.fade,
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),

                                ],
                              ),*/
                            // discription("Return: ",widget.plist.returns),
//                               discription("Brand: ",widget.plist.productVendor),
                         /*     Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:16.0,top: 8.0),
                                    child:  Text("Cancel: " ,
                                      overflow: TextOverflow.fade,
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:16.0,top: 8.0),
                                    child:  Text(widget.plist.cancels=="0"?"No":widget.plist.cancels+"day",
                                      overflow: TextOverflow.fade,
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),

                                ],
                              ),*/
//                             discription("Cancel: ",widget.plist.cancels),
//                             discription("Delivery: ",widget.plist.cancels),
                              discription1(widget.plist.productDescription),
//                             Padding(
//                                padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                child:  Text(widget.plist.productDescription,
//                                  overflow: TextOverflow.fade,
//                                  style: new TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 14.0,
//                                  ),
//                                ),
//                              ),


                            ],
                          ):Container(),

                          group==null?Container(): Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              group!=null? Padding(
                                padding: EdgeInsets.only(left:10.0,top: 8.0),
                                child:  Text(groupname,
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ):Row(),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                height: 78.0,
                                child:group!=null?ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:group.length,
                                    itemBuilder:(BuildContext context, int index){
                                      return  group[index].img.length>2?Container(
                                        width: 70.0,

                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: InkWell(
                                            onTap: () {
//                                              setState(() {
//
//                                                url=imgList1[index];
//                                                showLongToast("Product is selected ");
//                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ProductDetails1(group[index].productIs)),);
//
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                group[index].img.length>2?SizedBox(
                                                  height: 70,

                                                  child: Image.network(Constant.Product_Imageurl1+group[index].img,  fit: BoxFit.fill,)
                                                /*  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:Constant.Product_Imageurl1+group[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                            child:
                                                            CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                    new Icon(Icons.error),

                                                  ),*/
                                                ):Container(),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ):Row();


                                    }):CircularProgressIndicator(),


                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Text('RELATED PRODUCTS',
                                  style: TextStyle(
                                      color: AppColors.product_title_name,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 8.0, left: 8.0),
                                child: RaisedButton(
                                    color: Colors.white,
                                    child: Text('View All',
                                        style: TextStyle(color: AppColors.button_text_color)),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(catid.length>0?catid[0]:"0","RELATED PRODUCTS")),);
                                    }),
                              )
                            ],
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            height: 255.0,
                            child:topProducts1!=null?ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: topProducts1.length == null
                                    ? 0
                                    : topProducts1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return
                                    Container(
                                      width: topProducts1[index]!=0?150.0:230.0,
                                      color: AppColors.tela1,
                                      margin: EdgeInsets.only(right: 10),

                                      child:
                                      Card(
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
                                                              topProducts1[index])),
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

                                                    child: topProducts1[index].img!=null?Image.network( Constant
                                                        .Product_Imageurl +
                                                        topProducts1[index].img,  fit: BoxFit.fill,)
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
                                                        :Image.asset("assets/images/logo.png"),
                                                  ),





                                                ],
                                              ),
                                            ),


                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(left: 5,right: 5,top: 5),
                                                padding:EdgeInsets.only(left: 3,right: 5),

                                                color:AppColors.white,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: <Widget>[
                                                    Text(
                                                      topProducts1[index].productName,
                                                      overflow:TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 12,color:AppColors.black,

                                                      ),
                                                    ),
                                                    SizedBox(height: 8,),

                                                    Text('(\u{20B9} ${topProducts1[index].buyPrice})',
                                                      overflow:TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontStyle: FontStyle.italic,fontSize: 12,
                                                          color: AppColors.black,
                                                          decoration: TextDecoration.lineThrough
                                                      ),
                                                    ),
                                                    SizedBox(height: 8,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                      child: Text('\u{20B9} ${calDiscount(topProducts1[index].buyPrice,topProducts1[index].discount)}', style: TextStyle(
                                                          color: AppColors.green,
                                                          fontWeight: FontWeight.w700,fontSize: 12
                                                      )),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),





                                          ],
                                        ),
                                      ),
                                    );
                                }):CircularProgressIndicator(),


                          ),

                        ],
                      ),
                      // Builds 1000 ListTiles
                      childCount: 1,
                    ),
                  )
                ]
            )
        ) ,
      ),
    );
  }



//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;
  void _addToproducts(BuildContext context) {

    if(products==null) {
      print((totalmrp*_count).toString()+"............");
      ProductsCart st = new ProductsCart(pid: widget.plist.productIs, pname:widget.plist.productName,  pimage:url,
          pprice:(totalmrp*_count).toString(), pQuantity:_count, pcolor:_dropDownValue!=null?_dropDownValue:"", psize:_dropDownValue1!=null?_dropDownValue1:"", pdiscription: widget.plist.productDescription,sgst: sgst1.toString(),cgst: cgst1.toString(), discount: widget.plist.discount,
          discountValue:dicountValue.toString(), adminper:widget.plist.msrp,adminpricevalue:admindiscountprice.toString(),costPrice:total.toString(),shipping:widget.plist.shipping,totalQuantity: widget.plist.quantityInStock,varient:textval,mv:int.parse(widget.plist.mv) );
      dbmanager.insertStudent(st).then((id)=>{

        print('Student Added to Db ${id}')
      });
    }


  }

  void _addToproducts1(BuildContext context) {

    if(nproducts==null) {
      WishlistsCart st1 = new WishlistsCart(pid: widget.plist.productIs, pname:widget.plist.productName,  pimage:url,
          pprice:totalmrp.toString(), pQuantity:_count, pcolor:_dropDownValue, psize:_dropDownValue1, pdiscription: widget.plist.productDescription,sgst: sgst1.toString(),cgst: cgst1.toString(), discount: widget.plist.discount,
          discountValue:dicountValue.toString(), adminper:widget.plist.msrp,adminpricevalue:admindiscountprice.toString(),costPrice:widget.plist.buyPrice );
      dbmanager1.insertStudent(st1).then((id)=>{
        setState(() {
          wishid=id;

          print('Student Added to Db ${wishid}')  ;                                     print( Constant.totalAmount);

        })

      });
    }


  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1= double.parse(byprice);
    double discount1= double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(Constant.val);
    print(returnStr);
    return returnStr;
  }


  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    if(sgst.length>1) {
      returnStr = discount.toString();
      double byprice1 = double.parse(byprice);
      print(sgst);

      double discount1 = double.parse(sgst);

      discount = ((byprice1 * discount1) / (100.0 + discount1));

      returnStr = discount.toStringAsFixed(2);
      print(returnStr);
      return returnStr;
    }
    else {
      return '0';
    }
  }


  void addTocardval(){

    if(int.parse(widget.plist.quantityInStock)>0) {
      _addToproducts(context);

      showLongToast(" Products  is added to cart ");

      setState(() {
        Constant.itemcount++;

//                                                  print( Constant.totalAmount);

      });
    }
    else{
      showLongToast("Product is out of stock");
    }


  }



  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
  Future _countList(int val) async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setInt("wcount", val);

  }


  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }




  Widget discription1(String Discription ){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:16.0,top: 8.0),
              child:  Text('${_parseHtmlString(Discription??"")}' ,
                overflow: TextOverflow.fade,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }





  Widget discription(String name,String Discription ){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:16.0,top: 8.0),
            child:  Text(name ,
              overflow: TextOverflow.fade,
              style: new TextStyle(
                color: Colors.black,
                fontSize: 15.0,fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:16.0,top: 8.0),
              child:  Text(Discription!=null?Discription:"" ,
                overflow: TextOverflow.fade,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }










}
