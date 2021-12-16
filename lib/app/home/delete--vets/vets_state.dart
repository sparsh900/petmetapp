part of 'vets_bloc.dart';


@immutable
abstract class VetsState extends Equatable{
  const VetsState();
}

class VetsInitial extends VetsState {
  const VetsInitial();
  @override
  List<Object> get props => [];
}


class VetsLoading extends VetsState{
  const VetsLoading();
  @override
  List<Object> get props =>[];
}


class VetsLoaded extends VetsState{
  final Stream<List> vetsComplete;
  final Map<String,dynamic> locationData;
  final double radius;
  const VetsLoaded(this.locationData,this.vetsComplete,this.radius);

  @override
  List<Object> get props => [locationData,vetsComplete,radius];
}


class VetsError extends VetsState{
  final String message;
  const VetsError(this.message);

  @override
  List<Object> get props => [message];
}



