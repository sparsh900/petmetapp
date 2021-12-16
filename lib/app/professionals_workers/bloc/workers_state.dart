part of 'workers_bloc.dart';

//Equatable is commented out because we need to refresh the page with same state as filters are at front end to increase speed




@immutable
abstract class WorkersState
    extends Equatable
{
  const WorkersState();
}

class WorkersLoadingState extends WorkersState {
  const WorkersLoadingState();
  @override
  List<Object> get props => [];
}

class WorkersShimmerState extends WorkersState {
  const WorkersShimmerState();
  @override
  List<Object> get props => [];
}

class PermissionBitState extends WorkersState{
  final int permissionBit;
  const PermissionBitState({@required this.permissionBit});
  @override
  List<Object> get props => [permissionBit];
}

class CurrentLocationState extends WorkersState{
  const CurrentLocationState({this.locationData});
  final Map<String,dynamic> locationData;
  @override
  List<Object> get props => [locationData];
}

class ConstantUIState extends WorkersState{
  const ConstantUIState({this.max,this.min});
  final double min,max;
  @override
  List<Object> get props => [max,min];
}


class NavigateToMapPageState extends WorkersState{
  const NavigateToMapPageState();
  @override
  List<Object> get props => [];
}


class RefreshState extends WorkersState{
  const RefreshState();
  @override
  List<Object> get props => [];
}


class StreamEmissionState extends WorkersState{
  final List listOfWorkers;
  const StreamEmissionState({this.listOfWorkers});
  @override
  List<Object> get props => [listOfWorkers];
}