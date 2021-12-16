import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:petmet_app/app/home/models/item.dart';
import './functions/minirepo_list_page.dart';

part 'items_list_event.dart';
part 'items_list_state.dart';

class ItemsListBloc extends Bloc<ItemsListEvent, ItemsListState> {
  final MiniRepo repo;
  ItemsListBloc({this.repo}) : super(ItemsListInitial());

  @override
  Stream<ItemsListState> mapEventToState(
    ItemsListEvent event,
  ) async* {
    if (event is ItemsFilterSortEvent) {
      repo.filterAndSort(event.filterInfo, event.numDecider);
      yield (ItemsBuildState(data: repo.sorted));
    } else if (event is ItemsBuildEvent) {
      await repo.getFromDatabase(category: event.category);
      yield (ItemsBuildState(data: repo.original));
    } else if (event is RefreshEvent) {
      yield (ItemsListInitial());
      repo.refresh();
      await repo.getFromDatabase(category: event.category);
      await repo.getFilters();
      repo.filterAndSort(event.filterInfo, event.numDecider);
      yield (ItemsBuildState(data: repo.sorted));
    } else if (event is OpenFilterEvent) {
      if (repo.dbFilterInfo == null) {
        await repo.getFilters();
      }
      print("Opening Filters");
      yield (OpenFilterState(dbFilterInfo: repo.dbFilterInfo));
    } else if (event is OpenSortEvent) {
      print("Opening Sort");
      yield (OpenSortState());
    }
  }
}
