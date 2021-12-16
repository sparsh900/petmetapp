part of 'items_list_bloc.dart';

@immutable
abstract class ItemsListEvent extends Equatable {
  const ItemsListEvent();
}

class ItemsFilterSortEvent extends ItemsListEvent{
  final Map<String,dynamic> filterInfo;
  final int numDecider;
  ItemsFilterSortEvent({this.filterInfo,this.numDecider});
  @override
  List<Object> get props=>[filterInfo,numDecider];
}
class ItemsBuildEvent extends ItemsListEvent{
  final String category;
  ItemsBuildEvent({this.category});
  @override
  List<Object> get props=>[{this.category}];
}
class RefreshEvent extends ItemsListEvent{
  final String category;
  final Map<String,dynamic> filterInfo;
  final int numDecider;
  RefreshEvent({this.category,this.filterInfo,this.numDecider});
  @override
  List<Object> get props=>[category,filterInfo,numDecider];
}

class OpenFilterEvent extends ItemsListEvent{
  OpenFilterEvent();
  @override
  List<Object> get props=>[];
}

class OpenSortEvent extends ItemsListEvent{
  OpenSortEvent();
  @override
  List<Object> get props=>[];
}

