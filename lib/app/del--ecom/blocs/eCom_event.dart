part of 'eCom_bloc.dart';

@immutable
abstract class EComEvent extends Equatable {
  const EComEvent();
}

class GetStream extends EComEvent{
  final String category;
  GetStream({this.category});
  @override
  List<Object> get props => [category];
}

// class SearchSort extends EComEvent{
//   final String category;
//   final String search;
//   SearchSort({this.category,this.search});
//   @override
//   List<Object> get props => [category,search];
// }

class GetWishlist extends EComEvent{
  GetWishlist();
  @override
  List<Object> get props => [];
}

class AddToCart extends EComEvent{
  final Item itemData;
  final String userSelectedSize;
  AddToCart({this.itemData,this.userSelectedSize});
  @override
  List<Object> get props => [itemData,userSelectedSize];
}
class UpdateCartNumber extends EComEvent{
  UpdateCartNumber();
  @override
  List<Object> get props => [];
}

class EComGetHomePage extends EComEvent{
  EComGetHomePage();
  @override
  List<Object> get props=>[];
}

class AddToWishlist extends EComEvent{
  final Item itemData;
  AddToWishlist({this.itemData});
  @override
  List<Object> get props => [itemData];
}