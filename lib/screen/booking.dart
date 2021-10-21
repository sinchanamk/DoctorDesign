import 'package:flutter/material.dart';
import 'package:royalmart/BottomNavigation/screenpage.dart';


class BookScreen extends StatefulWidget {
  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  double width = 0.0;

  double height = 0.0;

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
        child: Scaffold(     
      //       key: _scaffoldKey,

      // drawer: Profile1(),
 
            body: Stack(children: [
     
     
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            color: Colors.white,
          ),
          height: height / 1.8,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
              margin: EdgeInsets.only(top: height*.05),
                child: Text('Booking Confirmed',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                
                ),
                SizedBox(height: 10,),
                 Container(height: 200,width: height/2.25,
             decoration:BoxDecoration(color: Colors.grey[300]),
           child: Column(children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('You\'re doctor has been booked',style: TextStyle(fontSize: 15,
                color: Colors.black,fontWeight: FontWeight.bold),)
                
              ),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text('Doctor:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ms.Jeorge'),
                ),
                ],),
                 Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text('Day:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('22-March-2022'),
                ),
                ],),
                 Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text('Time:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('11:00 AM-12 AM'),
                ),
                ],),
                 Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text('Address:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('#44,2nd cross thanisandra,\nBangalore'),
                ),
                ],),
                
           ],),
             ),
              Padding(
              padding: const EdgeInsets.only(top: 20,
                 bottom: 10, left: 24, right: 24),
              child: Container(
                height: 45,
                width: 345,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                    color: Colors.blue),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.yellow,
                  ),
                  onPressed: () {
                   },
                  child: Text(
                    'Set Remainder',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
         InkWell(onTap: (){
           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Screen()));
         },
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('Return to home',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),),
           ),
         )
             ]))),
                
                ),
            
                  ])));}}