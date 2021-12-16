part of 'eCom_bloc.dart';

@immutable
abstract class EComState extends Equatable{
  const EComState();
}

class EComInitial extends EComState {
  const EComInitial();
  @override
  List<Object> get props => [];
}
// class EComGetHomePage extends EComState{
//   const EComGetHomePage(this.items);
//   final Stream<List> items;
//
//   @override
//   List<Object> get props => [items];
// }

class EComItemsStream extends EComState{
  const EComItemsStream(this.items,this.category);
  final Stream<List> items;
  final String category;
  @override
  List<Object> get props => [items,category];
}
//
// class EComFilteredItemsStream extends EComState{
//   const EComFilteredItemsStream(this.items,this.category);
//   final Stream<List> items;
//   final String category;
//   @override
//   List<Object> get props => [items,category];
// }

class EComWishlistItemsStream extends EComState{
  const EComWishlistItemsStream(this.items);
  final Stream<List> items;
  @override
  List<Object> get props => [items];
}

class EComLoading extends EComState{
  const EComLoading();
  @override
  List<Object> get props => [];
}

class EComAddedToCart extends EComState{
  final int numberOfCartItems;
  const EComAddedToCart({this.numberOfCartItems});
  @override
  List<Object> get props => [numberOfCartItems];
}

class EComLimitedItems extends EComState{
  const EComLimitedItems(this.data);
  final Map<String,Stream<List<Item>>> data;
  @override
  List<Object> get props => [data];
}