import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petmet_app/app/home/drawer.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/delete--vets/vets_input_location.dart';
import 'package:petmet_app/app/home/delete--vets/vets_bloc.dart';
import 'package:petmet_app/app/personal_vet_page/inner_vet_page.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/main.dart';
import 'package:provider/provider.dart';
import 'package:petmet_app/services/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/home/delete--vets/locationFunctions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart' as gpsNative;

class VetsMain extends StatefulWidget {
  VetsMain({this.title});
  final String title;
  @override
  _VetsMainState createState() => _VetsMainState();
}

class _VetsMainState extends State<VetsMain> {
  ValueNotifier<double> distance = new ValueNotifier(5);
  ValueNotifier<int> locationPermissionBit = new ValueNotifier(1000); //1000 -> check permissions -> bit set -> user -> dialogs
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    changePermissionBit();

  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  void changePermissionBit() async {
    print("Hello");
    var status = await Permission.location.status;
    int bit = 100;
    switch (status) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
        bit += 10;
        break;
      default:
    }
    if (!(await Permission.location.serviceStatus.isEnabled)) {
      bit += 1;
    }
    locationPermissionBit.value = bit;
    print(locationPermissionBit);
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);


    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
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
          leading: IconButton(
            icon: Icon(
              Icons.sort,
              size: 28,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.search),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.notifications_none),
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer.show(database: database, context: context, checkUserAns: checkUserAns),
      body: BlocProvider(
        create: (context) => VetsBloc(VetsLogicFunctions(), database)..add(GetVets(radius: distance.value)),
        child: BlocConsumer<VetsBloc, VetsState>(
            listener: (context, state) {},

            // buildWhen: (previous, current) {
            //   print("Checked if current is VetsLoaded");
            //   // return current is VetsLoaded;
            // },
            builder: (context, state) {
              print("Hello --- inside builder");
              return Column(
                children: [
                  Container(
                    color: petColor,
                    height: pH(48),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            widget.title != null ? widget.title.toUpperCase() : "Vets Near You",
                            style: TextStyle(color: Colors.white, wordSpacing: 3, fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(4),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: Border.all(color: petColor),
                          ),
                          child: RaisedButton(
                              color: Colors.white,
                              child: Text(
                                "Change",
                                style: TextStyle(color: petColor, fontSize: 12),
                              ),
                              onPressed: () {
                                // overlay.insert();
                              }),
                        ),
                      ]),
                    ),
                  ),

                  //Location and Change option
                  Flexible(
                      child: ValueListenableBuilder(
                    valueListenable: locationPermissionBit,
                    builder: (context, locationPermissionBit, child) => (locationPermissionBit == 100 && (state is VetsLoaded)) //bits calculated and vetsLoaded
                        ? Column(
                            children: [
                              Container(
                                color: Colors.grey[200],
                                height: pH(30),
                                padding: EdgeInsets.only(right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Icon(
                                        Icons.location_on,
                                        color: petColor,
                                      ),
                                      Text("${state.locationData["address"]}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ]),
                                    Container(
                                      margin: EdgeInsets.all(4),
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: Border.all(color: petColor),
                                      ),
                                      child: RaisedButton(
                                          color: Colors.white,
                                          child: Text(
                                            "Change",
                                            style: TextStyle(color: petColor, fontSize: 12),
                                          ),
                                          onPressed: () {
                                            navigateAndDisplay(context);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
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
                                            min: 5,
                                            max: 500,
                                            onChanged: (newDistance) {
                                              distance.value = newDistance;
                                            },
                                            onChangeEnd: (newDistance) {
                                              distance.value = newDistance;
                                              BlocProvider.of<VetsBloc>(context).add(RadiusChanged(radius: distance.value));
                                            },
                                            value: value,
                                            divisions: 9,
                                            label: "$value",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                              Flexible(
                                  child: StreamBuilder(
                                stream: state.vetsComplete,
                                builder: (context, snapshot) {
                                  int ch = 0;
                                  if (snapshot.hasData) {
                                    for (int i = 0; i < snapshot.data.length; i++) {
                                      if (snapshot.data[i]["extraData"] != null && snapshot.data[i]["extraData"]["value"] < state.radius * 1000) {
                                        ch = 1;
                                      }
                                    }
                                    if (ch == 1) {
                                      return ListView.separated(
                                          itemCount: snapshot.data.length,
                                          separatorBuilder: (_, index) {
                                            if (snapshot.data[index]["extraData"] != null && snapshot.data[index]["extraData"]["value"] < state.radius * 1000) {
                                              return Divider(
                                                color: Colors.grey[400],
                                                indent: 19,
                                                endIndent: 19,
                                              );
                                            } else {
                                              return Container(width: 0, height: 0);
                                            }
                                          },
                                          itemBuilder: (_, index) {
                                            if (snapshot.data[index]["extraData"] != null && snapshot.data[index]["extraData"]["value"] < state.radius * 1000) {
                                              return InkWell(
                                                onTap: () => Navigator.of(context, rootNavigator: true).push(
                                                  MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        InnerVetPage(pet: globalCurrentPet, database: database, vetData: snapshot.data[index]["vetData"]),
                                                  ),
                                                ),
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
                                                                  snapshot.data[index]["vetData"].iconPath ??
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
                                                                  "${snapshot.data[index]["vetData"].clinicName}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: pW(200),
                                                                child: Text(
                                                                  "${snapshot.data[index]["vetData"].Name}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: pW(200),
                                                                child: Text(
                                                                  "${snapshot.data[index]["vetData"].Address}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(color: Colors.grey),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: pW(200),
                                                                child: Text(
                                                                  "Open:${snapshot.data[index]["vetData"].openTime} - Closes:${snapshot.data[index]["vetData"].closeTime}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(color: Colors.grey),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Positioned(
                                                        right: 0,
                                                        bottom: 5,
                                                        child: Text("${snapshot.data[index]["extraData"]["text"]}", style: TextStyle(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                width: 0,
                                                height: 0,
                                              );
                                            }
                                          });
                                    } else {
                                      return EmptyContent(title: 'No Vets found', message: 'Please increase distance');
                                    }
                                    //TODO:: cross check the below cases
                                  } else if (snapshot.data != null) {
                                    //streambuilder got response no entry
                                    return EmptyContent(title: 'No Vets found', message: 'Please increase distance');
                                  } else {
                                    //streambuilder didnt get any messages yet
                                    return Center(child: CircularProgressIndicator());
                                  }
                                },
                              )),
                            ],
                          )
                        : permissionScreen(locationPermissionBit),
                  ))
                ],
              );
            }),
      ),
    );
  }

  Padding permissionScreen(locationPermissionBit) {
    return Padding(
                          padding: EdgeInsets.all(pW(40)),
                          child: Center(
                            child: locationPermissionBit != 1000 && locationPermissionBit != 100
                                ? //bit calculated and flow will come if permissions not set
                                Column(children: [
                                    Text(
                                      ((locationPermissionBit % 100) / 10).round() == 1
                                          ? "Looks like your location settings are not configured"
                                          : "Turn on GPS to get going",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: petColor, fontSize: pH(24), fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, wordSpacing: 2),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: pH(20)),
                                      child: SvgPicture.asset('images/svg/001-location.svg', semanticsLabel: 'Location not Enabled'),
                                    ),
                                    ((locationPermissionBit % 100) / 10).round() == 1
                                        ? RaisedButton(
                                            onPressed: () async {
                                              PermissionStatus status = await Permission.location.request();
                                              print(status);
                                              if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
                                                openAppSettings();
                                              }
                                              changePermissionBit();
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
                                    ((locationPermissionBit % 100) / 10).round() == 1
                                        ? SizedBox(
                                            height: pH(10),
                                          )
                                        : Container(
                                            height: 0,
                                          ),
                                    (locationPermissionBit % 10) == 1
                                        ? RaisedButton(
                                            onPressed: () async {
                                              await gpsNative.Location().requestService();
                                              changePermissionBit();
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
                                  ])
                                : CircularProgressIndicator() //bit not calculated  or bit calculated but Vets not Loaded
                            ,
                          ),
                        );
  }

  navigateAndDisplay(BuildContext context) async {
    final Map<String, dynamic> locationData = await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => InputLocation(),
    ));
    print(locationData);
    if (locationData != null) {
      BlocProvider.of<VetsBloc>(context).add(GotLocationUpdateMain(locationData: locationData, radius: distance.value));
    }
  }

}
