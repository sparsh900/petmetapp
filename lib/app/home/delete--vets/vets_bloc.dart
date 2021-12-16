import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:petmet_app/app/home/models/vet.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/app/home/delete--vets/locationFunctions.dart';

part 'vets_event.dart';
part 'vets_state.dart';

class VetsBloc extends Bloc<VetsEvent, VetsState> {
  final VetsLogicFunctions _getCustomLocation;
  final Database _db;
  VetsBloc(this._getCustomLocation, this._db) : super(VetsInitial());
  Stream<List<Vet>>  vets;
  Stream<List> vetsComplete;
  Map<String,dynamic> locationData;

  @override
  Stream<VetsState> mapEventToState(VetsEvent event) async* {
    yield(VetsLoading());
    if (event is GetVets) {
      try {
        locationData= await _getCustomLocation.getLocation();
        print(locationData);
        if (locationData != null){
          vets = _db.vetsStream();
          final double radius=event.radius;
          vetsComplete = _getCustomLocation.aStream(vets, locationData);
          print("Flow reached before sending back data");
          print(vetsComplete);
          yield(VetsLoaded(locationData,vetsComplete,radius));
        }else{
          yield(VetsInitial());
        }
      } catch (e) {
        print(e);
      }
    }
    else if(event is GotLocationUpdateMain){
      locationData= event.locationData;
      final double radius=event.radius;
      vets = _db.vetsStream();
      print(locationData);
      vetsComplete = _getCustomLocation.aStream(vets, locationData);
      yield(VetsLoaded(locationData,vetsComplete,radius));
    }
    else if(event is RadiusChanged){
      yield(VetsLoaded(locationData,vetsComplete,event.radius));
    }
  }
}
