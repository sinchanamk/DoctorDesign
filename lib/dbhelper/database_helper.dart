import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/model/AddressModel.dart';
import 'package:royalmart/model/BlogModel.dart';
import 'package:royalmart/model/CategaryModal.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:royalmart/model/CityName.dart';
import 'package:royalmart/model/CoupanModel.dart';
import 'package:royalmart/model/Gallerymodel.dart';
import 'package:royalmart/model/GroupProducts.dart';
import 'package:royalmart/model/InvoiceTrackmodel.dart';
import 'package:royalmart/model/MyReviewModel.dart';
import 'package:royalmart/model/TrackInvoiceModel.dart';
import 'package:royalmart/model/Varient.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/model/slidermodal.dart';







// abstract class ArticleRepository {
//   Future<List<Categary>> getArticles();
// }
//
// class ArticleRepositoryImpl implements ArticleRepository {
//   String link = Constant.base_url + "manage/api/p_category/all/?X-Api-Key=" +Constant.API_KEY +"&start=0&limit=20&field=shop_id&ield=shop_id&filter=" + Constant.Shop_id + "&parent=0&loc_id= ";
//   @override
//   Future<List<Categary>> getArticles() async {
//     var response = await http.get(link);
//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<dynamic> galleryArray = responseData["data"]["p_category"];
//       List<Categary> glist = Categary.getListFromJson(galleryArray);
//       return glist;
//     } else {
//       throw Exception();
//     }
//   }
//
// }

class DatabaseHelper {


  static Future<List<Categary>> getData(String id) async {
    String link = Constant.base_url + "manage/api/p_category/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
        Constant.Shop_id + "&parent="+id+"&loc_id="+Constant.cityid;
    print(link);

    final response = await http.get(link);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["p_category"];
      List<Categary> list = Categary.getListFromJson(galleryArray);
      return list;
    }
//    print("List Size: ${list.length}");

  }

  static Future<List<Slider1>> getSlider() async {
    String link = Constant.base_url + "manage/api/gallery/all/?X-Api-Key=" +
        Constant.API_KEY + "&start=0&limit=&field=shop_id&filter=" + Constant.Shop_id + "&place=appslide";
    print(" Slider link"+  link);
    final response = await http.get(link);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Slider1> list = Slider1.getListFromJson(galleryArray);

      return list;
    }


  }






  static Future<List<Products>> getTopProduct(String dil , String lim) async {
    String link = Constant.base_url + "manage/api/products/all/?X-Api-Key=" +
        Constant.API_KEY + "&start=0&limit="
        +lim+"&deals="+dil+"&field=shop_id&filter=" +
        Constant.Shop_id + "&loc_id="+Constant.cityid+"&type=0";
    print("${dil} ...."+link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(link);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");

  }
  static Future<List<Products>> getfeature(String dil , String lim) async {
    String link = Constant.base_url + "manage/api/products/all/?X-Api-Key=" +
        Constant.API_KEY + "&start=0&limit="
        +lim+"&featured=yes&field=shop_id&filter=" +
        Constant.Shop_id + "&loc_id="+Constant.cityid+"&type=0";
    print("${dil} ...."+link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(link);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");

  }



  static Future<List<Products>> getTopProduct1(String dil , String lim) async {
    String link = Constant.base_url + "manage/api/products/all/?X-Api-Key=" +
        Constant.API_KEY + "&start=0&limit="+lim+"&field=shop_id&filter=" +
        Constant.Shop_id + "&sort=DESC&loc_id="+Constant.cityid+"&type=0";
    print("new.........."+link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(link);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");

  }

  static Future<List<Gallery>> getImage(String id) async {
    print ("Future id"+ id);
    String link = Constant.base_url + "manage/api/gallery/all/?X-Api-Key="+Constant.API_KEY + "&start=0&limit=10&place="+id;
//print("Slider"+link);
    final response = await http.get(link);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Gallery> glist = Gallery.getListFromJson(galleryArray);

      return glist;
    }
//    print("List Size: ${list.length}");


  }

//  Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=5000&cats=" + pcategoryid + "&field=shop_id&filter=" + Const.Shop_id+"&loc_id="
}
Future<List<Categary>> getData(String id) async {
  String link = Constant.base_url + "manage/api/p_category/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
      Constant.Shop_id + "&parent="+id+"&loc_id="+Constant.cityid;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_category"];

    return Categary.getListFromJson(galleryArray);;
  }

}


Future<List<Products>> catby_productData(String id,String lim) async {
  String link = Constant.base_url + "manage/api/products/all/?X-Api-Key="+Constant.API_KEY
      +"&start="+lim+"&limit=15&cats="+id+"&field=shop_id&filter="+Constant.Shop_id + "&loc_only="+Constant.cityid;

  print('linkcatpro   ${link}');
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);;
  }

}


Future<List<TrackInvoice>> trackInvoice(String mobile) async {
  String link = Constant.base_url + "manage/api/invoices/all/?X-Api-Key="+Constant.API_KEY
      +"&field=client_id&filter="+mobile ;
  print(link);

  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];

    return TrackInvoice.getListFromJson(galleryArray);;
  }


}



Future<List<InvoiceInvoice>> trackInvoiceOrder(String invoice) async {
  String link = Constant.base_url + "manage/api/invoice_details/all/?X-Api-Key="+Constant.API_KEY
      +"&field=invoice_id&filter="+invoice ;

  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoice_details"];

    return InvoiceInvoice.getListFromJson(galleryArray);;
  }

}



Future<List<Products>> productdetail(String id) async {
  String link = Constant.base_url + "manage/api/products/all/?X-Api-Key="+Constant.API_KEY
      +"&start=0&limit=10&field=shop_id&filter="+Constant.Shop_id +"&id="+id;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {

    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);;
  }

}
Future<List<Products>> search(String query,String type) async {
  String link = Constant.base_url + "manage/api/products/all/?X-Api-Key="+Constant.API_KEY
      +"&start=0&limit=5&field=shop_id&filter="+Constant.Shop_id +"&id=&type="+type;
  print("Serch  ${link}");

  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);;
  }

}

Future<List<Review>> myReview(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = Constant.base_url+"manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id="+userid+"&field=shop_id&filter="+Constant.Shop_id ;
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["reviews"];

    return Review.getListFromJson(galleryArray);;
  }

}


Future<List<GroupProducts>> GroupPro(String userid) async {
  String link = "https://www.bigwelt.com/api/pg.php?id="+userid+"&shop_id="+Constant.Shop_id ;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData;
//    GroupProducts  groupProducts= GroupProducts.fromMap(json.decode(response.body));
////    List<dynamic> galleryArray = responseData["data"]["reviews"];
//    print(galleryArray.toString()+"Gallery");
    if(galleryArray==null){
      return  galleryArray;
    }
    else{
      return GroupProducts.getListFromJson(galleryArray);

    }
  }

}


Future<List<Products> > searchval(String query,String type)async  {
  String link = Constant.base_url + "manage/api/products/all/?X-Api-Key="+Constant.API_KEY
      +"&start=0&limit=50&field=shop_id&filter="+Constant.Shop_id +"&q="+query+"&user_id="+Constant.User_ID+"&id=&type="+type;
  print(link);
  List<dynamic> galleryArray;
  final date2 = DateTime.now();
//  String md5=Constant.Shop_id+date2.day.toString()+date2.month.toString()+date2.year.toString();
  String md5=Constant.Shop_id+DateFormat("dd-MM-yyyy").format(date2);

  print(md5);
//  searchdatasave(query);
  generateMd5(md5,query);
  final response = await http.get(link);
  if (response.statusCode == 200) {

    var responseData = json.decode(response.body);
    galleryArray = responseData["data"]["products"];


    return Products.getListFromJson(galleryArray);
  }


}

searchdatasave(String query,String md5)async  {

  String link = Constant.base_url + "api/search.php?shop_id="+Constant.Shop_id+"&user_id="+Constant.User_ID+"&q="+query+"&key="+md5;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {

//      var responseData = json.decode(response.body);



  }

}

void generateMd5(String input ,String q) {

  String key= md5.convert(utf8.encode(input)).toString();
  searchdatasave(q,key);
  print(key);
}



Future<List<Slider1>> getBanner() async {
  String link = Constant.base_url + "manage/api/gallery/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=&field=shop_id&filter=" +
      Constant.Shop_id + "&place=appbanner";
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["gallery"];
    List<Slider1> list = Slider1.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");


}
Future<List<UserAddress>> getAddress() async {
  String link = Constant.base_url + "manage/api/user_address/all/?X-Api-Key=" +
      Constant.API_KEY +"&start=0&limit=&shop_id="+
      Constant.Shop_id + "&user_id="+Constant.user_id;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["user_address"];
//    List<UserAddress> list =

    return UserAddress.getListFromJson(galleryArray);
  }
//    print("List Size: ${list.length}");


}

Future<Coupan> getCoupan(String code) async {
  String link =Constant.base_url+"manage/api/coupon_codes/all/?X-Api-Key="+Constant.API_KEY+"&shop_id="+Constant.Shop_id+"&code="+code;
//      Constant.base_url + "manage/api/coupon_codes/all/?X-Api-Key=" +
//      Constant.API_KEY + "shop_id=" + Constant.Shop_id +"code="+code;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    Coupan coupan = Coupan.fromMap(json.decode(response.body));
    return coupan;
  }
//    print("List Size: ${list.length}");


}


Future<List<PVariant>> getPvarient(String id) async {
  String link =Constant.base_url+"manage/api/p_variant/all/?X-Api-Key="+Constant.API_KEY+"&start=0&limit=100&pid="+id;
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_variant"];
    List<PVariant> list = PVariant.getListFromJson(galleryArray);

    return list;
  }

}


Future<List<CityName>> getPcity() async {
  String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  print(link);
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_delivery_locations"];
    List<CityName> list = CityName.getListFromJson(galleryArray);

    return list;
  }

}




Future<List<BlogModel>> getfeature(String dil , String lim) async {
  String link = Constant.base_url + "manage/api/manage_pages/all?X-Api-Key=" +
      Constant.API_KEY + "&start=0&limit=" +lim+"&wht=blog&shop_id="+Constant.Shop_id + "&place=publish&type=";
  print("${dil} ...."+link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["manage_pages"];
    List<BlogModel> list = BlogModel.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");

}

Future<List<BlogModel>> searchBlogs(String q , String lim) async {
  String link = Constant.base_url + "manage/api/manage_pages/all?X-Api-Key=" +
      Constant.API_KEY + "&start=0&limit=" +lim+"&wht=blog&shop_id="+Constant.Shop_id + "&place=publish&type=&q="+q;
  print("${q} ...."+link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(link);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["manage_pages"];
    List<BlogModel> list = BlogModel.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");

}