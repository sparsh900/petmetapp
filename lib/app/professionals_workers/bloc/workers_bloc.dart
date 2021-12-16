import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';

import 'functions/locationFunctions.dart';
import 'functions/miniRepo.dart';


part 'workers_event.dart';
part 'workers_state.dart';

class WorkersBloc extends Bloc<WorkersEvent, WorkersState> {

  final MiniRepo _repo;
  WorkersBloc(this._repo) : super(WorkersLoadingState());

  @override
  Stream<WorkersState> mapEventToState(
    WorkersEvent event,
  ) async* {

    //To Check whether location permission is granted or not
    if (event is RequestUpdatedPermissionBitEvent){
      print("RequestPermissionBitEvent");
      yield(WorkersLoadingState());
      int addBit = await _repo.changePermissionBit();
      yield PermissionBitState(permissionBit: addBit);
    }

    //To build constant ui element like filters and slider
    else if(event is BuildConstantUIEvent){
      print("ConstantUIEvent");
      double min=5,max=500;
      if(_repo.listWithDifference.length!=0){
        min=5+_repo.listWithDifference[0]["calculatedLocationData"]["value"]/1000;
        max=500+_repo.listWithDifference[0]["calculatedLocationData"]["value"]/1000;
      //  TODO:: May change max distance from here .. currently its nearest pet + 500
      }

      yield ConstantUIState(min:min,max:max);
    }

    //to request user location for first time and then to update it
    else if(event is GetUpdateUserLocationEvent){
      yield WorkersLoadingState();

      print("GetUpdateUserLocationEvent");
      if(event.locationData==null){
        Map<String,dynamic> locationData = await _repo.locationRepo.getLocation();
        yield(CurrentLocationState(locationData: locationData));
      }else{
        yield(CurrentLocationState(locationData: event.locationData));
      }
    }


    //only to be called when firstTimeLoaded or when Location Changed
    else if (event is RequestStreamEvent){
      yield WorkersLoadingState();
      yield WorkersShimmerState();

      print("RequestStreamEvent");
      if(event.isFirstTimeLoaded){
        await _repo.getListFromDatabase(event.profession,event.category);
      }
      List listUpdated=[];
      print(event.locationData);
      await _repo.sortAccordingToDistance(event.locationData);
      if(Professions.hostel.string == event.profession){
        listUpdated = _repo.listWithDifference;

      }else{
         listUpdated = _repo.sort(event.distanceInKM, event.isHomeVisit,event.isVisitClinic, event.isChat, event.isVideo);
      }

      print(listUpdated.toString());
      yield StreamEmissionState(listOfWorkers: listUpdated);
    }

    //Since filters are applied at UI Layer since to increase efficiency, this just refreshes the ui
    else if(event is AllFilterSortEvent){
      print("AllFilterSortEvent");
      List listUpdated=[];
      if(Professions.hostel.string == event.profession){
        listUpdated = _repo.listWithDifference;
      }else{
        listUpdated = _repo.sort(event.distanceInKM, event.isHomeVisit,event.isVisitClinic, event.isChat, event.isVideo);
      }      yield StreamEmissionState(listOfWorkers: listUpdated);
    }

    //Just to show Loading Screen
    else if(event is WorkersLoadingEvent){
      print("WorkersLoadingEvent");
      yield WorkersLoadingState();
    }

    //To Navigate to Input Map Page
    else if(event is NavigateToMapPageEvent){
      print("NavigateToMapState");
      yield NavigateToMapPageState();
    }

    else{
      yield WorkersLoadingState();
    }

  }

}
