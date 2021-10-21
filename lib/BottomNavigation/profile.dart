import 'package:flutter/material.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/menu_line.dart';
import 'package:royalmart/locatization/language_constant.dart';
import 'package:royalmart/screen/MyReview.dart';
import 'package:royalmart/screen/ShowAddress.dart';
import 'package:royalmart/screen/editprofile.dart';
import 'package:royalmart/screen/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileView extends StatefulWidget {
  final Function changeView;

  const ProfileView({Key key, this.changeView}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {


  String name="" ;
  String image;
  String email="";
  String user_id="";
  bool isloginv=false;
  void gatinfo() async {
    SharedPreferences pref= await SharedPreferences.getInstance();

    isloginv=pref.get("isLogin");
    name=pref.get("name");
    email=pref.get("email");
    String image  =   pref.get("pp");
    String userid=pref.get("user_id");
    if(isloginv==null){
      isloginv= false;
    }

    setState(() {
      user_id=userid;
      Constant.name=name;
      Constant.email=email;
      Constant.isLogin=isloginv;
      Constant.User_ID=userid;
      Constant.image=image;

      // print(Constant.image.length);
      // print(Constant.name.length);
      // print("Constant.name");
    });

  }
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    Constant.isLogin=false;

    gatinfo();
  }
  @override
  Widget build(BuildContext context) {

    print("Constant.check");
    print(Constant.check);
    if(Constant.check){
      gatinfo();
      setState(() {
        Constant.check=false;
      });
    }
    //
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 240,
                color: AppColors.tela1,

                child: Column(
                 children:<Widget> [
                  Align(
                    alignment: Alignment.center,
                    child:
                    Container(
                      margin: EdgeInsets.only(top: 45),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.white,
                        child: ClipOval(
                          child: new SizedBox(
                            width: 120.0,
                            height: 120.0,
                            child:Constant.image==null? Image.asset('assets/images/logo.png',
                              fit: BoxFit.fill,):Constant.image.length==1? Image.asset('assets/images/logo.png', fit: BoxFit.cover):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? Image.asset('assets/images/logo.png',): Image.network(
                                Constant.image,
                                fit: BoxFit.fill
                          ),
                        ),
                      ),
                  ),
                    ),),
                   Padding(
                     padding: EdgeInsets.only(top: 5),
                     child: Text(
                       Constant.name==null?"${getTranslated(context, 'hg')}": Constant.name.length==1?"${getTranslated(context, 'hg')}":Constant.name,
                       style: TextStyle(
                         color: AppColors.white,
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),

                   Constant.isLogin? Text(
                     Constant.email==null?" ": Constant.email,
                     style: TextStyle(
                         color: AppColors.black, fontWeight: FontWeight.bold),
                   ):
                   InkWell(
                     onTap: (){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => SignInPage()),
                       );
                     },
                     child: Padding(
                         padding: EdgeInsets.only(left: 20),
                         child: Text("${getTranslated(context, 'login')}",
                           style: TextStyle(
                               color: AppColors.black, fontWeight: FontWeight.bold,fontSize: 18),
                         )
                     ),
                   ),


                 ]
                ),

              ),


              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 5),
                height: 70,
                child: InkWell(
                  onTap: (){
                    if(Constant.isLogin){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrackOrder()),
                      );}

                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Padding(
                         padding: EdgeInsets.only(left: 10,right: 20),
                         child: Icon(Icons.ac_unit, color:AppColors.tela, size: 30.0,),
                       ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                              "${getTranslated(context, 'mo')}",
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 5),
                height: 70,
                child: InkWell(
                  onTap: (){
                    if(Constant.isLogin){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowAddress("1")),
                      );}

                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Padding(
                         padding: EdgeInsets.only(left: 10,right: 20),
                         child: Icon(Icons.home, color: AppColors.tela, size: 30.0,),
                       ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                              "${getTranslated(context, 'sa')}",
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 5),
                height: 70,
                child: InkWell(
                  onTap: (){
                    if(Constant.isLogin){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyReview()),
                      );}

                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Padding(
                         padding: EdgeInsets.only(left: 10,right: 20),
                         child: Icon(Icons.streetview, color: AppColors.tela, size: 30.0,),
                       ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                              "${getTranslated(context, 'mr')}",
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                height: 70,
                child: InkWell(
                  onTap: (){
                    if(Constant.isLogin){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage(user_id)),
                      );}

                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Padding(
                         padding: EdgeInsets.only(left: 10,right: 20),
                         child: Icon(Icons.edit, color: AppColors.tela, size: 30.0,),
                       ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                              "${getTranslated(context, 'up')}",
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Constant.isLogin?Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 5),
                height: 70,
                child: InkWell(
                  onTap: (){
                    _callLogoutData();
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 20),
                          child: Icon(Icons.exit_to_app, color: AppColors.tela, size: 30.0,),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              "${getTranslated(context, 'logout')} ",
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ):
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top:5),
                height: 70,
                child: InkWell(
                  onTap: (){
                    if(Constant.isLogin){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );}

                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Padding(
                         padding: EdgeInsets.only(left: 10,right: 20),
                         child: Icon(Icons.power_settings_new, color: AppColors.tela, size: 30.0,),
                       ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                              "${getTranslated(context, 'login')} ",
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),





            ],
          )
        ],
      ),
    );
  }


  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.isLogin = false;
    Constant.email = " ";
    Constant.name = " ";
    Constant.image = " ";

    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
