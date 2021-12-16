part of 'workers_bloc.dart';

@immutable
abstract class WorkersEvent extends Equatable{
  const WorkersEvent();
}


class WorkersLoadingEvent extends WorkersEvent{
  const WorkersLoadingEvent();
  @override
  List<Object> get props => [];
}

//1 checks if location permission given
class RequestUpdatedPermissionBitEvent extends WorkersEvent{
  const RequestUpdatedPermissionBitEvent();
  @override
  List<Object> get props => [];
}

//2 gets users location
class GetUpdateUserLocationEvent extends WorkersEvent{
  final Map<String,dynamic> locationData;
  const GetUpdateUserLocationEvent({this.locationData});
  @override
  List<Object> get props => [locationData];
}

//3 builds constant elements of UI which are to be loaded after location
class BuildConstantUIEvent extends WorkersEvent{
  const BuildConstantUIEvent();
  @override
  List<Object> get props => [];
}

//4 to input location from user in case he/she wants to change
class NavigateToMapPageEvent extends WorkersEvent{
  const NavigateToMapPageEvent();
  @override
  List<Object> get props => [];
}

//5 refreshes ui on usage of slider or filters
class AllFilterSortEvent extends WorkersEvent{
  const AllFilterSortEvent({@required this.profession,@required this.distanceInKM,@required this.isHomeVisit,@required this.isVisitClinic,@required this.isChat,@required this.isVideo});
  final double distanceInKM;
  final bool isHomeVisit;
  final bool isVisitClinic;
  final bool isChat;
  final bool isVideo;
  final String profession;
  @override
  List<Object> get props => [distanceInKM,isHomeVisit,isVisitClinic,isChat,isVideo,profession];
}

//6 gets Data
class RequestStreamEvent extends WorkersEvent{
  final double distanceInKM;
  final String profession;
  final bool isFirstTimeLoaded;
  final Map<String,dynamic> locationData;
  final bool isHomeVisit;
  final bool isVisitClinic;
  final bool isChat;
  final bool isVideo;
  final String category;
  const RequestStreamEvent({@required this.category,@required this.distanceInKM,@required this.locationData,@required this.profession,@required this.isFirstTimeLoaded,@required this.isHomeVisit,@required this.isVisitClinic,@required this.isChat,@required this.isVideo});
  @override
  List<Object> get props => [category,distanceInKM,locationData,profession,isFirstTimeLoaded,isHomeVisit,isVisitClinic,isChat,isVideo];
}


//7 To refresh on pull
class RefreshEvent extends WorkersEvent{
  const RefreshEvent();
  @override
  List<Object> get props => [];
}