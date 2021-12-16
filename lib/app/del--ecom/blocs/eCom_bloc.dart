import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/services/database.dart';
part 'eCom_event.dart';
part 'eCom_state.dart';

class EComBloc extends Bloc<EComEvent, EComState> {
  final Database _db;
  EComBloc(this._db) : super(EComInitial());

  @override
  Stream<EComState> mapEventToState(
    EComEvent event,
  ) async* {
    yield (EComLoading());

    if (event is EComGetHomePage) {
      Map<String, Stream<List<Item>>> data = Map();
      Stream<List> categories = _db.getItemsCategories();
      List<dynamic> categoriesHeading = await categories.first;
      for (var category in categoriesHeading) {
        data.putIfAbsent("${category['id']}",
            () => _db.getLimitedItemsForHomePage("${category['id']}", 4));
      }
      data.forEach((key, value) {
        print(key);
        print(value.toString());
      });
      yield (EComLimitedItems(data));
    } else if (event is GetStream) {
      Stream<List<Item>> items = _db.itemsStream(event.category);
      yield (EComItemsStream(items, event.category));
    }

    // else if (event is SearchSort) {
    //
    //
    //   // yield (EComItemsStream(items, event.category));
    //   print(event.search);
    //   print("In Bloc Logic");
    //   Stream<List<Item>> itemsFiltered =await  filterStreamList(items, event.search);
    //   yield (EComItemsStream(itemsFiltered, event.category));
    //
    //
    // }
    else if (event is GetWishlist) {
      Stream<List<Item>> wishListItems = _db.wishlistStream();
      yield (EComWishlistItemsStream(wishListItems));
    } else if (event is AddToCart) {
      Stream<List<Item>> cartItems = _db.cartStream();
      _db.setCartItem(event.itemData, event.userSelectedSize);
    } else if (event is AddToWishlist) {
      _db.setWishlistItem(event.itemData);
    }
  }
}

// Stream<List<Item>> filterStreamList(Stream<List<Item>> items, String search) async* {
//   List dataToReturn = List();
//   await for (List<Item> list in items) {
//     for (var item in list) {
//       if(item.details["name"].toString().toLowerCase().contains(search.toLowerCase())){
//         dataToReturn.add(item);
//       }
//     }
//     print(dataToReturn.toString());
//     print("Returning data");
//     yield dataToReturn;
//   }
// }
