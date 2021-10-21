import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/locatization/language_constant.dart';
import 'package:royalmart/model/AddressModel.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/model/RegisterModel.dart';
import 'package:royalmart/screen/checkout.dart';

import 'AddAddress.dart';
import 'UpdateAddress.dart';



class ShowAddress extends StatefulWidget {
  final String valu;
  const ShowAddress(this.valu):super();
  @override
  _ShowAddressState createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  List<UserAddress> add= new List<UserAddress>();

//  void checkAddress(){
//    if(widget.valu=="0"&& add.length>0){
//      Navigator.push(context,
//        MaterialPageRoute(builder: (context) => AddAddress()),);
//
//    }
//  }
  bool  _status= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getAddress().then((usersFromServe) {
    setState(() {
      add=usersFromServe;
      print(add.toString());
      if(add.length<1) {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddAddress(widget.valu)),);
        _status=true;
//        checkAddress();
      }


    });
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor:AppColors.tela,
           actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAddress(widget.valu)),
                );
              },
              color: AppColors.telamoredeep,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              child: Text(
                "${getTranslated(context, 'add3')}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
],
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "${getTranslated(context, 'add2')}",
          maxLines: 2,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),

      body:
      // _status?screen():
      Container(

        child:add.length>0?ListView.builder( scrollDirection: Axis.vertical,
    itemCount: add.length==null?0:add.length,
    itemBuilder:(BuildContext context, int index){
          return  InkWell(
            onTap: (){
              if(widget.valu=="0"){

              Navigator.push(context,
                MaterialPageRoute(builder: (context) => CheckOutPage(add[index])),);}
              else{
//                showLongToast("Please Ente  the address!");
              }
            },
            child: Container(
//            margin: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 5.0,

                child: Column (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    add[index].label!=null?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(add[index].label!=null?add[index].label:"",

                            style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ):Row(),




                    add[index].fullName!=null?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Text(add[index].fullName!=null?add[index].fullName+" ,":"",

                            style: TextStyle(fontSize: 14, color: Colors.black,),
                          ),
                        ),
                      ],
                    ):Row(),

                    add[index].address1.length>1?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,top: 5),
                            child: Text(add[index].address1!=null?add[index].address1:"",

                              style: TextStyle(fontSize: 14, color: Colors.black,),
                            ),
                          ),
                        ),
                      ],
                    ):Container(
                      height: 0,
                    ),

                    add[index].address2.length>1?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,top: 5),
                            child: Text(add[index].address2!=null?add[index].address2:"",

                              style: TextStyle(fontSize: 14, color: Colors.black,),
                            ),
                          ),
                        ),
                      ],
                    ):Row(),

                    add[index].city!=null?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,top: 5),
                            child: Text(add[index].city!=null?add[index].city+", "+add[index].state+", "+add[index].pincode:"",

                              style: TextStyle(fontSize: 14, color: Colors.black,),
                            ),
                          ),
                        ),
                      ],
                    ):Row(),

//                  setContainer("Name",add[index].fullName),
                    setContainer("${getTranslated(context, 'mob')}",add[index].mobile),
                    setContainer("${getTranslated(context, 'email')}",add[index].email),

                    Container(
                      margin: EdgeInsets.only(left: 10,top: 2,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(2.0),
                              child: RaisedButton(
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => UpDateAddress(add[index],widget.valu)),);
                                },
//              splashColor: AppColors.tela,
                                color: AppColors.teladep,
                                shape: new RoundedRectangleBorder(

                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                child: Text("${getTranslated(context, 'u')}",style: TextStyle(fontSize: 12, color: Colors.white,),),

                              )
                          ),
                widget.valu=="0"? Padding(
                              padding: EdgeInsets.all(2.0),
                              child: RaisedButton(
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>CheckOutPage(add[index])),);
                                },
//              splashColor: AppColors.tela,
                                color: AppColors.black,
                                shape: new RoundedRectangleBorder(

                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                child: Text("${getTranslated(context, 'nex')}",style: TextStyle(fontSize: 12, color: Colors.white,),),

                              )
                          ):Row(),

                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child:  RaisedButton(
                              onPressed: (){
                                print("Delete");

//                _deleteAdderss(add[index].addId);
//                add.removeAt(index);
                                showDilogueReviw(context,index);

                              },
                              color: Colors.red,

                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0)),
                              child: Text("${getTranslated(context, 'd')}",style: TextStyle(fontSize: 12, color: Colors.white,),),

                            ),
                          ),

                        ],
                      ),
                    )
//                  getAction(context,index),
//                  setContainer("City",add[index].city),
//                  setContainer("State",add[index].state),
//                  setContainer("Pin",add[index].pincode),
                  ],

                ),
              ),
            ),
          );



    }):Center(child: CircularProgressIndicator()),

      ),
    );
  }




  Widget getAction(BuildContext context, int index){

    return Container(
      margin: EdgeInsets.only(left: 10,top: 2,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: RaisedButton(
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpDateAddress(add[index],widget.valu),),);
              },
//              splashColor: AppColors.tela,
              color: AppColors.teladep,
              shape: new RoundedRectangleBorder(

                  borderRadius: new BorderRadius.circular(20.0),
              ),
              child: Text("Update",style: TextStyle(fontSize: 12, color: Colors.white,),),

            )
          ),

          Padding(
            padding: EdgeInsets.all(2.0),
            child:  RaisedButton(
              onPressed: (){

//                _deleteAdderss(add[index].addId);
//                add.removeAt(index);
                showDilogueReviw(context,index);

              },
              color: Colors.red,

              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              child: Text("Delete",style: TextStyle(fontSize: 12, color: Colors.white,),),

            ),
          ),

        ],
      ),
    );
  }


  Widget setContainer(String title, String value){
    return Container(
      margin: EdgeInsets.only(left: 10,top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              title!=null?title+':':"",
              style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              value!=null?value:"",
              style: TextStyle(fontSize: 12, color: Colors.black,),
            ),
          ),

        ],
      ),
    );






  }


  Future _deleteAdderss(String id,int index) async {

    var map = new Map<String, dynamic>();
    map['add_id']=id;
    map['shop_id']=Constant.Shop_id;
    map['X-Api-Key']=Constant.API_KEY;
    map['user_id']=Constant.user_id;

    final response = await http.post(Constant.base_url+'manage/api/user_address/delete/',body:map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      setState(() {
        add.removeAt(index);
      });
//
//      Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShowAddress()),);
      showLongToast(user.message);

//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));


    } else
      throw Exception("Unable to get Employee list");
  }



  showDilogueReviw(BuildContext context,int index){
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 130.0,
        width: 200.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Do you want to delete!'),

            SizedBox(height: 40,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(onPressed: (){



                  Navigator.of(context).pop();
                },
                    child: Text('Cancle !', style: TextStyle(color: Colors.red, fontSize: 18.0),)),

                SizedBox(height: 20,),
                FlatButton(onPressed: (){
                  Navigator.of(context).pop();

                    _deleteAdderss(add[index].addId,index);



//                  Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShowAddress()),);
                },
                    child: Text('ok !', style: TextStyle(color: AppColors.success, fontSize: 18.0),)),



              ],
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);

  }


  Widget screen(){
    return Center(
      child: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100,),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: <Color>[Colors.orange, Colors.deepOrange.shade900],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child:Text("No address found",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontSize: 30,),),
            ),
//            Text("No address found  ",style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.all(8.0),
              child:  RaisedButton(
                onPressed: (){

                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAddress(widget.valu)),);
                },
                color: AppColors.telamoredeep,

                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                child: Text("Add Address",style: TextStyle(fontSize: 12, color: Colors.white,),),

              ),
            ),
          ],
        ),
      ),
    );
  }


}
