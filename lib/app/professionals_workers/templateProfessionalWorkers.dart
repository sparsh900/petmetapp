import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petmet_app/app/grommers/inner_grommers_page.dart';
import 'package:petmet_app/app/home/drawer.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/hostel/inner_hostel_page.dart';
import 'package:petmet_app/app/notification.dart';
import 'package:petmet_app/app/personal_vet_page/inner_vet_page.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as gpsNative;
import 'package:shimmer/shimmer.dart';

//module/directory level materials
import '../../main.dart';
import 'bloc/functions/miniRepo.dart';
import 'overlays/overlayData.dart';
import 'overlays/overlayMaker.dart';
import './bloc/workers_bloc.dart';
import 'vets_input_location.dart';

class TemplateProfessionalWorkers extends StatefulWidget {
  TemplateProfessionalWorkers(
      {@required this.category,
      @required this.overlayData,
      @required this.title,
      @required this.isOverlayAgainButton,
      @required this.isHomeVisitFilter,
      @required this.isVisitClinicFilter,
      @required this.isVideoFilter,
      @required this.isChatFilter,
      @required this.isHomeVisitSelected,
      @required this.isVisitClinicSelected,
      @required this.isVideoSelected,
      @required this.isChatSelected,
      this.database});

  final Database database;
  final String category, title;
  final OverlayData overlayData;

  final bool isOverlayAgainButton;
  final bool isHomeVisitFilter, isVisitClinicFilter, isVideoFilter, isChatFilter;
  final bool isHomeVisitSelected, isVisitClinicSelected, isVideoSelected, isChatSelected;

  @override
  _TemplateProfessionalWorkersState createState() => _TemplateProfessionalWorkersState();
}

class _TemplateProfessionalWorkersState extends State<TemplateProfessionalWorkers> {
  Database database;

  OverlayMaker _overlay;

  ValueNotifier<double> distance = new ValueNotifier(5.0);
  ValueNotifier<bool> homeVisitNotifier;
  ValueNotifier<bool> videoNotifier;
  ValueNotifier<bool> chatNotifier;
  ValueNotifier<bool> visitClinicNotifier;

  ScrollController _scrollController;
  ValueNotifier<double> filterButtonHeight;

  Map<String, dynamic> locationData;
  bool isFirstTimeLoaded = true;

  _scrollListener() {
    if (_scrollController.offset < pH(50)) {
      filterButtonHeight.value = pH(80) - _scrollController.offset;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.database == null) {
      database = Provider.of<Database>(context, listen: false);
    } else {
      database = widget.database;
    }

    homeVisitNotifier = new ValueNotifier(widget.isHomeVisitSelected);
    videoNotifier = new ValueNotifier(widget.isVideoSelected);
    chatNotifier = new ValueNotifier(widget.isChatSelected);
    visitClinicNotifier = new ValueNotifier(widget.isVisitClinicSelected);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlay = new OverlayMaker(context: context, overlayData: widget.overlayData, isInner: true);
      filterButtonHeight = new ValueNotifier(pH(80));
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    try {
      visitClinicNotifier.dispose();
      chatNotifier.dispose();
      distance.dispose();
      homeVisitNotifier.dispose();
      videoNotifier.dispose();
      _scrollController.dispose();
      filterButtonHeight.dispose();
    } on NoSuchMethodError catch (e) {
      print(e.stackTrace.toString());
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMethod(database: database),
        drawer: CustomDrawer.show(database: database, context: context, checkUserAns: checkUserAns),

//-------------------------------->>>>>>Body Starts here
        body: BlocProvider(
          create: (context) => WorkersBloc(MiniRepo(database: database))..add(RequestUpdatedPermissionBitEvent()),
          lazy: false,
          child: Column(children: [
            Container(
              height: pH(50),
              color: Color(0xFFFFFFFF),
              padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(0), pW(25), pH(0)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(color: Color(0xFF36A9CC), wordSpacing: 3, fontSize: pH(18), fontWeight: FontWeight.w600),
                ),
                widget.isOverlayAgainButton
                    ? Container(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(4), pH(10)),
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: IconButton(
                              icon: new Icon(Icons.keyboard_arrow_down_sharp, size: 22, color: Color(0xFF36A9CC)),
                              onPressed: () {
                                _overlay.insert();
                              }),
                        ),
                        // child: RaisedButton(
                        //     elevation: 5,
                        //     color: Colors.white,
                        //     shape: Border.all(color: Colors.grey[300]),
                        //     child: Text(
                        //       "Change",
                        //       style: TextStyle(fontSize: 14, color: petColor),
                        //     ),
                        //     onPressed: () {
                        //       _overlay.insert();
                        //     }),
                      )
                    : Container(
                        height: 0,
                      ),
              ]),
            ),
            BlocConsumer<WorkersBloc, WorkersState>(
              listener: (context, state) {
                if (state is PermissionBitState && state.permissionBit == 100) {
                  BlocProvider.of<WorkersBloc>(context).add(GetUpdateUserLocationEvent());
                }
              },
              listenWhen: (previous, current) => current is PermissionBitState,
              buildWhen: (previous, current) => current is PermissionBitState,
              builder: (context, state) {
                if (state is PermissionBitState) {
                  if (state.permissionBit != 100) {
                    return Padding(
                      padding: EdgeInsets.all(pW(40)),
                      child: Center(
                          child: Column(children: [
                        Text(
                          ((state.permissionBit % 100) / 10).round() == 1 ? "Looks like your location settings are not configured" : "Turn on GPS to get going",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(color: petColor, fontSize: pH(24), fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, wordSpacing: 2),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: pH(20)),
                          child: SvgPicture.asset('images/svg/001-location.svg', semanticsLabel: 'Location not Enabled'),
                        ),
                        ((state.permissionBit % 100) / 10).round() == 1
                            ? RaisedButton(
                                onPressed: () async {
                                  PermissionStatus status = await Permission.location.request();
                                  print(status);
                                  if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
                                    openAppSettings();
                                  }
                                  BlocProvider.of<WorkersBloc>(context).add(RequestUpdatedPermissionBitEvent());
                                },
                                color: petColor,
                                textColor: Colors.white,
                                child: Text(
                                  "Give Permission",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: pH(24), fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, wordSpacing: 2),
                                ),
                              )
                            : Container(
                                height: 0,
                              ),
                        ((state.permissionBit % 100) / 10).round() == 1
                            ? SizedBox(
                                height: pH(10),
                              )
                            : Container(
                                height: 0,
                              ),
                        (state.permissionBit % 10) == 1
                            ? RaisedButton(
                                onPressed: () async {
                                  await gpsNative.Location().requestService();
                                  BlocProvider.of<WorkersBloc>(context).add(RequestUpdatedPermissionBitEvent());
                                },
                                color: petColor,
                                textColor: Colors.white,
                                child: Text(
                                  "Turn on GPS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: pH(24), fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, wordSpacing: 2),
                                ),
                              )
                            : Container(
                                height: 0,
                              )
                      ])),
                    );
                  } else {
                    //permission state is emitted but logic not needed hence we Request onto next event
                    return Container(
                      height: 0,
                    );
                  }
                }
                return Container(
                  height: 0,
                );
              },
            ),
            BlocConsumer<WorkersBloc, WorkersState>(
              listener: (context, state) async {
                if (state is NavigateToMapPageState) {
                  final Map<String, dynamic> newLocationDataFromMap = await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => BlocProvider.value(value: BlocProvider.of<WorkersBloc>(context), child: InputLocation()),
                  ));
                  if (newLocationDataFromMap != null) {
                    BlocProvider.of<WorkersBloc>(context).add(GetUpdateUserLocationEvent(locationData: newLocationDataFromMap));

                    //needs to be stored ...since pull to refresh needs to trigger RequestStream and requires locationData
                    locationData = newLocationDataFromMap;
                  }
                }
                if (state is CurrentLocationState) {
                  //needs to be stored ...since pull to refresh needs to trigger RequestStream and requires locationData
                  locationData = state.locationData;

                  BlocProvider.of<WorkersBloc>(context).add(RequestStreamEvent(
                      isChat: chatNotifier.value,
                      isHomeVisit: homeVisitNotifier.value,
                      isVideo: videoNotifier.value,
                      isVisitClinic: visitClinicNotifier.value,
                      isFirstTimeLoaded: isFirstTimeLoaded,
                      distanceInKM: distance.value,
                      locationData: state.locationData,
                      profession: widget.overlayData.profession,
                      category: widget.category));
                  BlocProvider.of<WorkersBloc>(context).add(BuildConstantUIEvent());

                  //Scenario ::  if tile is contracted and the new sorted data has less results (tile should be expanded)
                  filterButtonHeight.value = pH(80);
                  isFirstTimeLoaded = false;
                }
              },
              listenWhen: (previous, current) => current is NavigateToMapPageState || current is CurrentLocationState || current is RefreshState,
              buildWhen: (previous, current) => current is CurrentLocationState,
              builder: (context, state) {
                if (state is CurrentLocationState) {
                  return Column(children: [
                    Container(
                      height: pH(32),
                      decoration: BoxDecoration(color: Color(0xFFE5E5E5), borderRadius: BorderRadius.only(bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(pW(18), 0, 0, 0),
                            child: Row(children: [
                              Icon(
                                Icons.location_on,
                                color: petColor,
                              ),
                              Text("${state.locationData["address"].toString().split(",")[0]} ", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey)),
                              Flexible(
                                child: Text(" ${state.locationData["address"].toString().split(",")[1]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, pH(6), pW(16), pH(7)),
                          child: Container(
                            child: RaisedButton(
                                color: Colors.white,
                                shape: Border.all(color: petColor),
                                child: Text(
                                  "Change",
                                  style: TextStyle(color: petColor, fontSize: pH(12), fontFamily: "Montserrat", fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  BlocProvider.of<WorkersBloc>(context).add(NavigateToMapPageEvent());
                                }),
                          ),
                        ),
                      ]),
                    )
                  ]);
                }
                return Container(
                  height: pH(6),
                );
              },
            ),
            BlocConsumer<WorkersBloc, WorkersState>(
              listener: (context, state) {
                if (state is ConstantUIState) {
                  distance.value = state.min;
                  BlocProvider.of<WorkersBloc>(context).add(AllFilterSortEvent(
                      profession: widget.overlayData.profession,
                      isVisitClinic: visitClinicNotifier.value,
                      isVideo: videoNotifier.value,
                      isHomeVisit: homeVisitNotifier.value,
                      distanceInKM: distance.value,
                      isChat: chatNotifier.value));
                }
              },
              listenWhen: (previous, current) => current is ConstantUIState,
              buildWhen: (previous, current) => current is ConstantUIState,
              builder: (context, state) {
                if (state is ConstantUIState) {
                  return Column(children: [
                    Container(
                      height: pH(30),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(children: [
                        Text("Distance : "),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: distance,
                            builder: (context, value, _) {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3.0,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                                ),
                                child: Slider(
                                  min: state.min,
                                  max: state.max,
                                  onChanged: (newDistance) {
                                    distance.value = newDistance;
                                  },
                                  onChangeEnd: (newDistance) {
                                    distance.value = newDistance;
                                    BlocProvider.of<WorkersBloc>(context).add(AllFilterSortEvent(
                                        profession: widget.overlayData.profession,
                                        isVisitClinic: visitClinicNotifier.value,
                                        isVideo: videoNotifier.value,
                                        isHomeVisit: homeVisitNotifier.value,
                                        distanceInKM: distance.value,
                                        isChat: chatNotifier.value));
                                  },
                                  value: value,
                                  divisions: 9,
                                  label: value.toString().split(".")[0],
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                    Row(
                      children: [
                        widget.isVideoFilter
                            ? ValueListenableBuilder(
                                valueListenable: videoNotifier,
                                builder: (context, value, child) => filterTile(context, Filters.video.string, MyFlutterApp.video, videoNotifier, false),
                              )
                            : Container(
                                height: 0,
                              ),
                        widget.isChatFilter
                            ? ValueListenableBuilder(
                                valueListenable: chatNotifier,
                                builder: (context, value, child) => filterTile(context, Filters.chat.string, MyFlutterApp.chat, chatNotifier, true),
                              )
                            : Container(
                                height: 0,
                              ),
                        widget.isVisitClinicFilter
                            ? ValueListenableBuilder(
                                valueListenable: visitClinicNotifier,
                                builder: (context, value, child) => filterTile(context, Filters.onlyClinic.string, MyFlutterApp.visit_clinic, visitClinicNotifier, false),
                              )
                            : Container(
                                height: 0,
                              ),
                        widget.isHomeVisitFilter
                            ? ValueListenableBuilder(
                                valueListenable: homeVisitNotifier,
                                builder: (context, value, child) => filterTile(context, Filters.onlyHome.string, MyFlutterApp.home_visit, homeVisitNotifier, true),
                              )
                            : Container(
                                height: 0,
                              ),
                      ],
                    ),
                    SizedBox(
                      height: pH(10),
                    )
                  ]);
                }
                return Container(height: 0);
              },
            ),
            BlocBuilder<WorkersBloc, WorkersState>(
              buildWhen: (previous, current) => current is StreamEmissionState || current is WorkersLoadingState || current is WorkersShimmerState,
              //loading state is also handled because when changing location previous vets also shown
              builder: (context, state) {
                print("Building UI Main List of Workers");
                if (state is StreamEmissionState) {
                  if (state.listOfWorkers.length != 0)
                    return Flexible(
                      child: RefreshIndicator(
                        onRefresh: () {
                          isFirstTimeLoaded = true;
                          BlocProvider.of<WorkersBloc>(context).add(RequestStreamEvent(
                              isChat: chatNotifier.value,
                              isHomeVisit: homeVisitNotifier.value,
                              isVideo: videoNotifier.value,
                              isVisitClinic: visitClinicNotifier.value,
                              isFirstTimeLoaded: isFirstTimeLoaded,
                              distanceInKM: distance.value,
                              locationData: locationData,
                              profession: widget.overlayData.profession,
                              category: widget.category));
                          isFirstTimeLoaded = false;

                          return Future.delayed(Duration.zero);
                        },
                        child: ListView.separated(
                            controller: _scrollController,
                            itemCount: state.listOfWorkers.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (_, index) {
                              return Divider(
                                color: Colors.grey[400],
                                indent: 19,
                                endIndent: 19,
                              );
                            },
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  if (widget.overlayData.profession == Professions.vet.string) {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => InnerVetPage(pet: globalCurrentPet, database: database, vetData: state.listOfWorkers[index]["workerData"]),
                                      ),
                                    );
                                  } else if (widget.overlayData.profession == Professions.petGroomer.string) {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => InnerGPage(pet: globalCurrentPet, database: database, groomerData: state.listOfWorkers[index]["workerData"]),
                                      ),
                                    );
                                  } else if (widget.overlayData.profession == Professions.hostel.string) {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => InnerHostelPage(pet: globalCurrentPet, database: database, hostelData: state.listOfWorkers[index]["workerData"]),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 19, vertical: 8),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: pW(94),
                                            height: pH(94),
                                            margin: EdgeInsets.only(right: 17),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(3),
                                              child: Image.network(
                                                  state.listOfWorkers[index]["workerData"].iconPath ??
                                                      "https://cdn1.vectorstock.com/i/1000x1000/46/10/icon-for-veterinary-services-vector-6704610.jpg",
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: pW(200),
                                                child: Text(
                                                  "${widget.overlayData.profession != Professions.hostel.string ? state.listOfWorkers[index]["workerData"].clinicName : state.listOfWorkers[index]["workerData"].hostelName}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              widget.overlayData.profession != Professions.hostel.string
                                                  ? Container(
                                                      width: pW(200),
                                                      child: Text(
                                                        "${state.listOfWorkers[index]["workerData"].Name}",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    ),
                                              Container(
                                                width: pW(200),
                                                child: Text(
                                                  "${state.listOfWorkers[index]["workerData"].Address}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                              ),

                                              widget.overlayData.profession != Professions.hostel.string
                                                  ? Container(
                                                      width: pW(200),
                                                      child: Text(
                                                        "Open:${state.listOfWorkers[index]["workerData"].openTime} - Closes:${state.listOfWorkers[index]["workerData"].closeTime}",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(color: Colors.grey),
                                                      ),
                                                    )
                                                  : Container(height: 0),

                                              //CITY  ex, Chandigarh
                                              widget.overlayData.profession == Professions.hostel.string
                                                  ? Container(
                                                      width: pW(200),
                                                      child: Text(
                                                        "${state.listOfWorkers[index]["workerData"].city}",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(color: Colors.grey),
                                                      ),
                                                    )
                                                  : Container(height: 0)
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 5,
                                        child: Text("${state.listOfWorkers[index]["calculatedLocationData"]["text"]}", style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  else //if no vet found
                    return Expanded(child: Center(child: EmptyContent(title: 'No ${widget.overlayData.profession} found', message: 'Please increase distance or change location')));
                } else if (state is WorkersShimmerState) {
                  return Flexible(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Container(height: pH(90), color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: pH(10), horizontal: pW(10))),
                        itemCount: 10,
                      ),
                    ),
                  );
                }
                //for loading state
                return Container(
                  height: 0,
                );
              },
            ),
            BlocBuilder<WorkersBloc, WorkersState>(
              builder: (context, state) {
                if (state is WorkersLoadingState) {
                  return Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: pH(15),
                      ),
                      Text("Loading....")
                    ],
                  ));
                }
                return Container(
                  height: 0,
                );
              },
            ),
          ]),
        ));
//-------------------------------->>>>>>Body Ends here
  }

  ValueListenableBuilder filterTile(BuildContext context, String text, IconData iconOfTile, ValueNotifier isChecked, bool isRed) {
    Color colorOfTile = isChecked.value ? (isRed ? Color(0xFFFF5352) : petColor) : Colors.grey;
    //Two ValueNotifiers nested ...could be implemented using blocs as well ...
    //blocs are used only for separating the logic ...not for ui changes
    return ValueListenableBuilder(
      valueListenable: filterButtonHeight,
      builder: (context, valueHeight, childHeight) => Container(
        width: pW(86),
        height: valueHeight,
        margin: EdgeInsets.only(left: pW(11)),
        child: OutlineButton(
          color: colorOfTile,
          onPressed: () {
            isChecked.value = !isChecked.value;
            BlocProvider.of<WorkersBloc>(context).add(AllFilterSortEvent(
                profession: widget.overlayData.profession,
                isVisitClinic: visitClinicNotifier.value,
                isVideo: videoNotifier.value,
                isHomeVisit: homeVisitNotifier.value,
                distanceInKM: distance.value,
                isChat: chatNotifier.value));

            //Scenario ::  if tile is contracted and the new sorted data has less results (tile should be expanded)
            filterButtonHeight.value = pH(80);
          },
          borderSide: BorderSide(color: colorOfTile),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconOfTile,
                color: colorOfTile,
              ),
              valueHeight > pH(55)
                  ? Text(
                      text.toUpperCase(),
                      style: TextStyle(
                        fontSize: pH(14),
                        color: colorOfTile,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    )
                  : Container(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  PreferredSize appBarMethod({@required Database database}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(pH(54.0)), // here the desired height
      child: AppBar(
        backgroundColor: Color(0xFFF1F1F1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF343434),
        ),
        centerTitle: true,
        title: Image.asset(
          'images/petmet-logo.png',
          width: pW(130),
          height: pH(33),
        ),
        actions: <Widget>[
          /*Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
            child: InkWell(
              onTap: () {},
              child: Icon(Icons.search),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(database: database),
                  ),
                );
              },
              child: Icon(Icons.notifications),
            ),
          ),
        ],
      ),
    );
  }
}
