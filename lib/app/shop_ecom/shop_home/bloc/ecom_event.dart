part of 'ecom_bloc.dart';

abstract class EComEvent extends Equatable {
  const EComEvent();
}
class LoadEventShopHomePage extends EComEvent {
  @override
  List<Object> get props => [];
}

class LoadCarousel extends EComEvent{
  @override
  List<Object> get props=>[];
}

class EComLoadingEvent extends EComEvent{
  @override
  List<Object> get props=>[];
}
