
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductList extends StatefulWidget {
  final String cat, title;
  const ProductList(this.cat,this.title) : super();

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>  with SingleTickerProviderStateMixin {




  TabController _tabController;
  bool showFab = true;
  int _current=0;
  int total=000;
  int actualprice=200;
  double mrp,totalmrp=000;
  int _count =1;

  double sgst1,cgst1 ,dicountValue,admindiscountprice;

   List<Products> products1 = List();
  void gatinfoCount() async {
    SharedPreferences pref= await SharedPreferences.getInstance();

    int Count=pref.getInt("itemCount");
    setState(() {
      if(Count==null){
        Constant.carditemCount=0;
      }else {
        Constant.carditemCount = Count;
      }
      print(Constant.carditemCount.toString()+"itemCount");
    });



  }

  @override
  void initState() {
    super.initState();
    gatinfoCount();
    print(widget.title);


    if(widget.cat=="new"){
    DatabaseHelper.getTopProduct1(widget.cat,"1000").then((usersFromServe){
      setState(() {
        products1=usersFromServe;
      });
    });  }

    else if(widget.title=='Featured Products'){
      DatabaseHelper.getfeature('yes',"100").then((usersFromServe){
        setState(() {
          products1=usersFromServe;
        });
      });
    }
    else{
      DatabaseHelper.getTopProduct(widget.cat,"100").then((usersFromServe){
        setState(() {
          products1=usersFromServe;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child:
      Scaffold(
      backgroundColor: AppColors.tela1,
          appBar: AppBar(
            backgroundColor: AppColors.tela,
            leading: Padding(padding: EdgeInsets.only(left: 0.0),
                child:InkWell(
                  onTap: (){
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  },

                  child: Icon(
                    Icons.arrow_back,size: 30,
                    color: Colors.white,
                  ),

                )
            ),


            actions: <Widget>[
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserFilterDemo("0")),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 0,right: 10),
                  child: Icon(Icons.search,color: Colors.white,size: 25,),
                ),
              ),

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
                      padding: EdgeInsets.only(top: 13,right: 30),
                      child: Icon(Icons.add_shopping_cart,color: Colors.white,),
                    ),
                    showCircle(),
                  ],
                ),
              )
            ],
            title:Text(widget.title.isEmpty?Constant.appname:widget.title,

                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold)),





          ),








          body:Column(
        children: <Widget>[



          Expanded(
            child: products1!=null?products1.length>0?ListView.builder(
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.vertical,
              itemCount:products1.length,

              itemBuilder: (BuildContext context, int index) {


                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 6,bottom: 6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: InkWell(
                        onTap: () {
                                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(products1[index])),);
                        },
                        child: Container(

                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(14)),
                                    color: Colors.blue.shade200,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,

                                        image: NetworkImage(products1[index].img!=null?Constant.Product_Imageurl+products1[index].img:"ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg", )


                                    )),
                              ),

                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child:
                                        Text(products1[index].productName==null? 'name':products1[index].productName,

                                          overflow: TextOverflow.fade,
                                          style:TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
                                              .copyWith(fontSize: 14),
                                        ),

                                      ),
                                      SizedBox(height: 6),

                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                            child: Text('\u{20B9} ${calDiscount(products1[index].buyPrice,products1[index].discount)} ${products1[index].unit_type!=null?"/"+products1[index].unit_type:""}', style: TextStyle(
                                              color: AppColors.sellp,
                                              fontWeight: FontWeight.w700,
                                            )),
                                          ),
                                          SizedBox(width: 20,),
                                          Expanded(
                                            child: Text('(\u{20B9} ${products1[index].buyPrice})',
                                              overflow:TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  color: AppColors.mrp,
                                                  decoration: TextDecoration.lineThrough
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      SizedBox(width: 0.0,height: 10.0,),

                                     /* Container(
                                        margin: EdgeInsets.only(left: 0.0,right: 10),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[

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

                                                            color: AppColors.tela,
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
                                                        EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
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

                                                            color: AppColors.tela,
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
                                                      height: 30,
                                                      width:50,

                                                      child:
                                                      Material(

                                                        color: AppColors.sellp,
                                                        elevation: 0.0,
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(2),),
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

                                                                child:Text("ADD",style: TextStyle(color: AppColors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                                                                // Icon(Icons.add_shopping_cart,color: Colors.white,),

                                                              )),),
                                                      )),









                                                ],
                                              ),






                                            ]
                                        ) ,
                                      ),*/

                                    ],
                                  ),


                                ),
                              )
                            ],
                          ),
                        ),







                      ),
                    ),
                    // double.parse(products1[index].discount)>0?  showSticker(index,products1):Row()

                  ],
                );
              },
            ):Center(child: CircularProgressIndicator()):Row(),
          ),
        ],
      )

































      /*
        }
      )*/
    ));
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
  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart products2;
//cost_price=buyprice
  void _addToproducts(String pID,String p_name,String image,int price, int quantity,String c_val,String p_size,String p_disc,String sgst,String cgst,String discount,
      String dis_val,String adminper, String adminper_val,String cost_price,String shippingcharge,String  totalQun) {

    if(products2==null) {
//      print(pID+"......");
//      print(p_name);
//      print(image);
//      print(price);
//      print(quantity);
//      print(c_val);
//      print(p_size);
//      print(p_disc);
//      print(sgst);
//      print(cgst);
//      print(discount);
//      print(dis_val);
//      print(adminper);
//      print(adminper_val);
//      print(cost_price);
      ProductsCart st = new ProductsCart(pid: pID, pname:p_name,  pimage:image,
          pprice:(price*quantity).toString(), pQuantity:quantity, pcolor:c_val, psize:p_size, pdiscription: p_disc,sgst: sgst,cgst: cgst, discount: discount,
          discountValue:dis_val, adminper:adminper,adminpricevalue:adminper_val,costPrice:cost_price,shipping: shippingcharge,totalQuantity: totalQun );
      dbmanager.insertStudent(st).then((id)=>{
        showLongToast(" Products  is added to cart "),
        print(' Added to Db ${id}')
      });
    }


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
}





