part of 'vets_bloc.dart';

@immutable
abstract class VetsEvent extends Equatable{
  const VetsEvent();
}

class GetVets extends VetsEvent{
  final double radius;
  const GetVets({@required this.radius});
  @override
  List<Object> get props => [radius];
}

class GotLocationUpdateMain extends VetsEvent{
  final Map<String,dynamic> locationData;
  final double radius;
  const GotLocationUpdateMain({@required this.locationData, @required this.radius});
  @override
  List<Object> get props => [locationData,radius];
}

class RadiusChanged extends VetsEvent{
  final double radius;
  const RadiusChanged({@required this.radius});
  @override
  List<Object> get props => [radius];
}