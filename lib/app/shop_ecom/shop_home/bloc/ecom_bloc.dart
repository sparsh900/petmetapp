import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'functions/miniRepo_shop.dart';

part 'ecom_event.dart';
part 'ecom_state.dart';

class EComBloc extends Bloc<EComEvent, EComState> {
  final MiniRepo miniRepo;

  EComBloc({this.miniRepo}) : super(EComLoading());

  @override
  Stream<EComState> mapEventToState(
    EComEvent event,
  ) async* {
    if (event is LoadCarousel) {
      print("Getting list of URLs");
      List listOfURLs = await miniRepo.getListOfURLs();
      yield EmitCarouselURLs(listOfURLs: listOfURLs);
    } else if (event is LoadEventShopHomePage) {
      yield LimitedShopPageTitles(data: miniRepo.getLimitedOuterPageItems());
    } else if (event is EComLoadingEvent) {
      yield EComLoading();
      miniRepo.refresh();
      add(LoadCarousel());
      add(LoadEventShopHomePage());
    }
  }
}
