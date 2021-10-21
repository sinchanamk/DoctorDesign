import 'package:flutter/material.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:royalmart/screen/editprofile.dart';
import 'package:royalmart/screen/secondtabview.dart';

import '../General/AppConstant.dart';
class My_Cat extends StatefulWidget {
  @override
  _My_CatState createState() => _My_CatState();
}

class _My_CatState extends State<My_Cat> {
  List<Categary> cat_list = [];
  List<Categary> sub_cat_list = [];

  getlistval(Categary cat){
    getData(cat.pcatId).then((usersFromServe){
      if(this.mounted) {
        setState(() {
          sub_cat_list = usersFromServe;
          if(sub_cat_list!=null){
            if(sub_cat_list.length>0){

            }
            else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(cat.pcatId,cat.pCats)),);


            }
          }


        });
      }
    });

  }
  bool flag=false;
  @override
  void initState() {

   getData("8633").then((usersFromServe){
      if(this.mounted) {
        setState(() {
         cat_list = usersFromServe;
         // cat_list.length>0?getlistval(cat_list[0].pcatId):"";

        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [

          flag?sub_cat_list!=null? sub_cat_list.length>0?Align(
            alignment: Alignment.topRight,
            child: Container(
              child:show_cat_subnam() ,
            ),
          ):Row():Row():Row(),
          cat_list!=null? cat_list.length>0?Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 120,

              height: MediaQuery.of(context).size.height,
              color: AppColors.tela1,
              child:show_catnam() ,
            ),
          ):Row():Row(),





        ],
      ),
    );
  }


   int val=-1;
   int grid=-1;
  ShowColor(int index){
    setState(() {
      val=index;
    });
  }
  GridShowColor(int index){
    setState(() {
      grid=index;
    });
  }

  Widget show_catnam(){

    return Container(

      margin: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.tela1
          ),
        color: AppColors.white
      ),
      width: 130,
      child: ListView.builder(

          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount:cat_list.length,

          itemBuilder: (BuildContext context, int index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){

                        getlistval(cat_list[index]);
                        flag=true;
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(cat_list[index].pcatId,cat_list[index].pCats)),);
                        ShowColor(index);

                      },
                      child: Container(
                        color: val==index?AppColors.tela1: AppColors.white,
                        width: 93,
                        height: 40,
                        child:
                        Center(
                          child: Text(cat_list[index].pCats,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: val==index?AppColors.white: AppColors.black),),
                        ) ,
                      ),
                    ),


                    InkWell(
                      // onTap: (){
                      //   setState(() {
                      //
                      //     getlistval(cat_list[index]);
                      //     flag=true;
                      //     ShowColor(index);
                      //   });
                      //
                      // },
                      child:
                      Container(
                        // padding:EdgeInsets.all(1),
                          child: Icon(Icons.arrow_forward_ios_outlined,size: 25,color: AppColors.black,)),
                    )



                  ],
                ),
                Divider(
                  color: AppColors.tela1,
                ),
              ],
            );


          }

          ),
    );
  }
  Widget show_cat_subnam(){

    return Container(
      // width: 150,
      margin: EdgeInsets.only(left: 120) ,
      child: ListView.builder(
          // separatorBuilder: (context, index) => Divider(
          //   color: Colors.grey,
          // ),
          shrinkWrap: true,
          primary: false,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount:sub_cat_list.length,

          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 5,right: 5),
                  padding: EdgeInsets.only(top:5,bottom: 5),
                  // color: Colors.grey,
                  child:ListTile(
                    title:Text(sub_cat_list[index].pCats,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.black,fontSize: 12),)  ,
                    trailing: Icon(grid!=index?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: AppColors.black, ),
                 onTap: (){
                      if(grid!=index){
                        GridShowColor(index);

                      }
                      else{
                        setState(() {
                          grid=-1;
                        });
                      }


                 },
                  )

                  // Text(sub_cat_list[index].pCats,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: AppColors.black),) ,
                ),
                Divider(
                  color: AppColors.black,
                ),



               grid==index? Container(
                  color: AppColors.tela1,
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  // height: 90,
                  child: FutureBuilder(
                      future: getData( sub_cat_list[index].pcatId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(

                            child: GridView.builder(
                              physics:ClampingScrollPhysics() ,
                              controller: new ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 6, right: 6,),

                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:  3,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,

                                childAspectRatio: 0.7,

                              ),
                              itemBuilder: (context, index) {
                                Categary item = snapshot.data[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(item.pcatId,item.pCats)),);


                                  },
                                  child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: new SizedBox(
                                              width: 60.0,
                                              height: 60.0,
                                              child:item.img.length>0?Image.network(Constant.base_url +
                                                  "manage/uploads/p_category/" +
                                                  item.img, fit: BoxFit.fill):Image.asset("assets/images/logo.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: Text(item.pCats,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 10),),
                                      )
                                    ],
                                  ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data.length == null
                                  ? 0
                                  : snapshot.data.length,
                            ),
                          );


                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ):Row(),
              ],
            );


          }

          ),
    );
  }

}
