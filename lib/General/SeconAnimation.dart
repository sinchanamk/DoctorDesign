import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';


class SecondAnimation extends StatefulWidget {
  @override
  _SecondAnimationState createState() => _SecondAnimationState();
}

class _SecondAnimationState extends State<SecondAnimation> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
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

      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/splogo.png'),
                )
              ),
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),);

                         },
                      child: getButton('Log In',0)),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp1()),
                        );
                      },
                      child: getButton('Skip', 1)),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget getButton(String text,int val){
    return  Container(

      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 40),
      width: MediaQuery.of(context).size.width/2-40,
      decoration: BoxDecoration(
          color: AppColors.tela1,

    gradient: LinearGradient(
    colors: [
     Color(val==0?0xFFFFE0B2:0xFFfaa41d),
     Color(val!=0?0xFFFFE0B2:0xFFfaa41d),
    ],),



          borderRadius: BorderRadius.circular(20)
      ),
      child: Text("${text}",textAlign: TextAlign.center,style: TextStyle(fontWeight:FontWeight.w700,fontSize: 18),),
    );
  }
}
