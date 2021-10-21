import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/booking.dart';
class DoctorPage extends StatefulWidget {
//  final Products plist;
//   const DoctorPage(this.plist) : super();

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  ScrollController _scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {

     var now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: 346));
    DateTime endDate = now.add(Duration(days: 346));
    print('startDate = $startDate ; endDate = $endDate');
    
    return Scaffold(
     
      body: SingleChildScrollView(
        child: Column(children: [
          Container(color: Colors.blue,padding: EdgeInsets.only(top: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
              IconButton(onPressed: (){}, icon:Icon(Icons.favorite_outline,color: Colors.white,))
        
            ],),
          ),
          Container(color: Colors.blue,
          height: 200,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(right:26,top: 20),
                    child: Text('Dr. Jennifer',style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),),
                  ),   SizedBox(height: 5,),
             
               Padding(
                    padding: const EdgeInsets.only(left:18.0),
                    child: Text('Senior Cardilogist',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                    fontSize: 18),),
                  ),
                  SizedBox(height: 5,),
              Row(
                                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 5,right: 20),
                                          child: RatingBar.builder(itemSize: 20,
                                          // initialRating:double.parse(item.stars),
                                           initialRating: 4,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,size: 10,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          )
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: IconButton(onPressed: (){}, icon: Icon(Icons.location_on,color: Colors.white,)),
                    ),
                    Text('Hospital,near\nthanisandra\nbangalore',style: TextStyle(color: Colors.white),)
                  ],
                ),                
                ],),
              Image.asset("assets/images/d.png"),
              ],
            ),
          ),
          Container(alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 18,top: 10),
            child: Text('About',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,
            ),),
          ),
          Padding(
             padding: EdgeInsets.only(left: 18,top: 8),
         child: Text('Dr.Jennifer gets it. From his excellent treatment, curiosity, investigative mind and ability to connect, you know where you stand immediately and what next steps look like.',
            style: TextStyle(fontSize: 12),),
          ),
          Container(alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 18,top: 15),
            child: Text('Appointment',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),),
          ),
          Container(alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 18,top: 13),
            child: Text('Select Date',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,))),
      
             Container(
          padding: EdgeInsets.only(top: 8),
        alignment: Alignment.center,
        child: HorizontalDatePickerWidget(
          startDate: startDate,
          endDate: endDate,
          selectedDate: now,
          selectedColor: Colors.blue,
          widgetWidth: MediaQuery.of(context).size.width,
          datePickerController: DatePickerController(),
          onValueSelected: (date) {
            print('selected = ${date.toIso8601String()}');
          },
        ),
         ),
         Container(alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 18,top: 14),
            child: Text('Choose Time Slot',style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,))),
           SizedBox(
             height: 160,
             child: GridView.builder(
               controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Container(height: 50,width: 200,
              child: new Card(
                child: TextButton(onPressed: (){},child:Text('12 AM - Tuesday',
                style: TextStyle(color: Colors.black,fontSize: 12),
                )),
              ),
          )]));
         } ),
           ),
           
           Padding(
              padding: const EdgeInsets.only(top: 10,
                 bottom: 10, left: 24, right: 24),
              child: Container(
                height: 45,
                width: 345,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.blue),
                    color: Colors.blue),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.yellow,
                  ),
                  onPressed:(){ Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>BookScreen()));
                                                  // UserFilterDemo("0")));
                                                 

                   },
                  child: Text(
                    'Continue Booking',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
         
           ],),
      ),
    );
  }
}