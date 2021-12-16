part of 'ecom_bloc.dart';

abstract class EComState extends Equatable {
  const EComState();
}

class EComLoading extends EComState {
  @override
  List<Object> get props => [];
}

class EmitCarouselURLs extends EComState{
  final List listOfURLs;
  EmitCarouselURLs({@required this.listOfURLs});
  @override
  List<Object> get props=>[listOfURLs];
}

class LimitedShopPageTitles extends EComState{
  // final Map<String,Stream<List<Item>>> data;
  final Stream data;
  LimitedShopPageTitles({@required this.data});

  @override
  List<Object> get props=>[data];
}