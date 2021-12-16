
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/services/database.dart';

class MiniRepo{
  final Database database;
  MiniRepo({this.database});

  List listOfURLs;
  Map<String, Stream<List<Item>>> items4ShopHome=Map();

  Future<List> getListOfURLs() async{
    if(listOfURLs==null){
      DocumentSnapshot snapshot=await database.getShopCarouselImages();
      listOfURLs=snapshot.data["images"];
    }
    return listOfURLs;
  }

  Stream getLimitedOuterPageItems(){
    Stream anotherStream = database.getItemsCategories().map((listHeadings){
      for (var category in listHeadings) {
        items4ShopHome.putIfAbsent("${category['id']}", () => database.getLimitedItemsForHomePage("${category['id']}", 4));
      }
      return items4ShopHome;
    });
    return anotherStream;
  }

  void refresh(){
    listOfURLs=null;
    items4ShopHome=Map();
  }



//Implementation using Lists
// Future<Map<String, Stream<List<Item>>>> getLimitedOuterPageItems() async{
//   if(items4ShopHome==null || items4ShopHome.length==0){
//     List<dynamic> categoriesHeading = await database.getItemsCategories();
//     for (var category in categoriesHeading) {
//       items4ShopHome.putIfAbsent("${category['id']}", () => database.getLimitedItemsForHomePage("${category['id']}", 4));
//     }
//   }
//   return items4ShopHome;
// }
}