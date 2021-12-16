part of 'items_list_bloc.dart';

@immutable
abstract class ItemsListState{
  const ItemsListState();
}

class ItemsListInitial extends ItemsListState {
  // @override
  // List<Object> get props => [];
}

class ItemsUpdateState extends ItemsListState {
  // @override
  // List<Object> get props => [];
}
class ItemsBuildState extends ItemsListState {
  final List<Item> data;
  ItemsBuildState({this.data});
  // @override
  // List<Object> get props => [data];
}
class OpenFilterState extends ItemsListState{
  OpenFilterState({this.dbFilterInfo});
  final Map<String,dynamic> dbFilterInfo;
  // @override
  // List<Object> get props=>[dbFilterInfo];
}

class OpenSortState extends ItemsListState{
  OpenSortState();
  // @override
  // List<Object> get props=>[];
}