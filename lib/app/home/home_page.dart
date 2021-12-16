import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petmet_app/app/adoption/pet_adoption_homepage.dart';
import 'package:petmet_app/app/dogwalker/selectpetdogwalker.dart';
import 'package:petmet_app/app/home/custom_dropdown.dart';
import 'package:petmet_app/app/home/drawer.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/notification.dart';
import 'package:petmet_app/app/personal_vet_page/my_appointments.dart';
import 'package:petmet_app/app/professionals_workers/overlays/overlayData.dart';
import 'package:petmet_app/app/professionals_workers/overlays/overlayMaterial.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/shop_ecom/previous_orders/previousOrders.dart';
import 'package:petmet_app/common_widgets/custom_slider.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';
import 'package:petmet_app/common_widgets/show_error_dialog_dogwalker.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

import 'package:petmet_app/app/shop_ecom/shop_items_list/shop_items_list_page.dart';
import 'package:petmet_app/app/shop_ecom/ui_widgets/eComListCardShop.dart';

import 'models/item.dart';
import 'models/pet.dart';

class HomePage extends StatefulWidget {
  HomePage({this.user});
  final User user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final _userInput = await showPlatformDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PlatformAlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to Logout?'),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          PlatformDialogAction(
            child: PlatformText('Logout'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (_userInput == true) {
      _signOut(context);
    }
  }

  Future<void> _checkUserData(Database database) async {
    bool ans = await database.checkUserData();

    if (!mounted) return;

    if (ans) {
      setState(() {
        checkUserAns = true;
      });
    } else {
      setState(() {
        checkUserAns = false;
      });
    }
  }

  Future<void> _setDeviceToken(Database database) async {
    var deviceTokenLocal = await fcm.getToken();
    UserData user = await database.getUserData();
    if (user != null) await database.updateDeviceToken(user, deviceTokenLocal);
  }

  Future<List> getBestSellingItems(Database database) async {
    DocumentSnapshot bestSellingAddresses = await database.getBestSellingItemsForHomePage();
    List data = bestSellingAddresses.data["items"];
    return data;
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  navigateToPage(BuildContext context, String page) {
    Navigator.of(context).pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }

  Future<void> _notificationsSetup(Database database) async {
    var _status = await Permission.notification.status;
    if (_status.isUndetermined) {
      fcm.requestNotificationPermissions();
    }
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (message['notification']['title'] != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
        switch (message['data']['screen']) {
          case 'appointment':
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => MyAppointmentsPage(database: database),
              ),
            );
            break;
          case 'order':
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => PreviousOrders(database: database),
              ),
            );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
        switch (message['data']['screen']) {
          case 'appointment':
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => MyAppointmentsPage(database: database),
              ),
            );
            break;
          case 'order':
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => PreviousOrders(database: database),
              ),
            );
        }
      },
    );

    _setDeviceToken(database);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // ...
    super.initState();
    final Database database = Provider.of<Database>(context, listen: false);
    _checkUserData(database);
    _notificationsSetup(database);
  }

  Widget build(BuildContext context) {
    NetworkImage _globalPetImage = globalCurrentPet == null ? null : (globalCurrentPet.image == null ? null : NetworkImage(globalCurrentPet.image));

    final Database database = Provider.of<Database>(context, listen: false);

    Stream getPhotoTiles() async* {
      DocumentSnapshot tiles = await database.getTilesForHomePage();
      yield tiles;
    }

    Stream getBestCategories() async* {
      DocumentSnapshot categories = await database.getCategoriesForHomePage();
      yield categories;
    }

    Stream getPetGrooming() async* {
      DocumentSnapshot groomingCategories = await database.getPetGroomingForHomePage();
      yield groomingCategories;
    }

    Stream getAquaticEssentials() async* {
      DocumentSnapshot aquaticCategories = await database.getAquaticEssentialsForHomePage();
      yield aquaticCategories;
    }

    Future<List> getBestSellingItems() async {
      DocumentSnapshot bestSellingAddresses = await database.getBestSellingItemsForHomePage();
      List data = bestSellingAddresses.data["items"];
      return data;
    }

    print('userHome -- ${widget.user.uid}');
    // fixme Widget Rebuilds
    // print("Widget Rebuild Calls are being made ...comment before pushing");
    //_checkUserData(database); //Cancer call don't uncomment

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
                onPressed: () {
                  setState(() {});
                  _scaffoldKey.currentState.openDrawer();
                },
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
          ),
          drawer: CustomDrawer.show(database: database, context: context, checkUserAns: checkUserAns),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF36A9CC),

                ),
                child: _buildContent(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: pH(11)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /////////////////////////////Carousel
                        SizedBox(
                          height: pH(166),
                          child: CustomSlider(
                            path: "homepage/carousel",
                          ),
                        ),
                        //////////////////////////////Tiles
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(20), 0, 0),
                        //   child: Text(
                        //     "SERVICES",
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //       color: Color(0xFF000000),
                        //       fontWeight: FontWeight.w700,
                        //       fontSize: pH(28),
                        //       fontStyle: FontStyle.normal,
                        //       fontFamily: "Montserrat",
                        //     ),
                        //   ),
                        // ),
                        _heading(heading: "SERVICES"),
                        Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(pW(21), pH(25), pW(21), pH(35)),
                            child: Wrap(
                              spacing: pW(16),
                              runSpacing: pH(18),
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      child: ImageTile("images/vet_b.png"),
                                      onTap: () {
                                        globalNavBarController.index = 1;
                                      },
                                      // onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder: (context) => OverlayMaterial(overlayData: OverlayData(heading: "For what purpose are you looking for a Vet?",options:[Categories.consultation.string,Categories.deworming.string,Categories.vaccine.string],profession:Professions.vet.string)))),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                                      child: Text(
                                        "Vet",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF272727),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                        child: ImageTile("images/grooming_b.png"),
                                        onTap: () {
                                          globalNavBarController.tileNavigator = 1;
                                          globalNavBarController.navigatingTheOthers();
                                          globalNavBarController.index = 3;
                                          // Navigator.of(context).push(
                                          // MaterialPageRoute(
                                          //     builder: (context) => OverlayMaterial(
                                          //         overlayData: OverlayData(
                                          //             heading:
                                          //             "Where do you want to groom your pet?",
                                          //             options: [
                                          //               Filters.home.string,
                                          //               Filters.clinic.string
                                          //             ],
                                          //             profession: Professions
                                          //                 .petGroomer
                                          //                 .string))));
                                        }),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                                      child: Text(
                                        "Grooming",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF272727),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      child: ImageTile("images/dog trainer_b.png"),
                                      onTap: () {
                                        // globalNavBarController.tileNavigator=2;
                                        // globalNavBarController.navigatingTheOthers();
                                        // globalNavBarController.index = 3;
                                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                            builder: (context) => OverlayMaterial(
                                                database: database,
                                                overlayData: OverlayData(
                                                    heading: "Where do you want to train your pet?",
                                                    options: [Filters.atMyHome.string, Filters.atTrainingCentre.string, Filters.online.string],
                                                    profession: Professions.trainer.string))));
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                                      child: Text(
                                        "Training",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF272727),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (globalCurrentPet == null) {
                                          ShowErrorDialog2.show(context: context, title: 'No Pet Found', message: 'Please add a Pet to continue', user: widget.user,database: database);
                                        } else {
                                          Navigator.of(context, rootNavigator: true).push(
                                            MaterialPageRoute(
                                                builder: (context) => DogWalkerHomepage(
                                                      database: database,
                                                      uid: database.getUid(),
                                                    )),
                                          );
                                        }
                                      },
                                      child: ImageTile("images/dog walker_b.png"),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                                      child: Text(
                                        "Dog Walker",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF272727),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                        builder: (context) => AdoptionHomepage(database: database, uid: database.getUid()),
                                      )),
                                      child: ImageTile("images/adoption_b.png"),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                                      child: Text(
                                        "Adoption",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF272727),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        globalNavBarController.tileNavigator = 2;
                                        globalNavBarController.navigatingTheOthers();
                                        globalNavBarController.index = 3;
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //       builder: (context) => WidgetAssigner.hostels(database: database),
                                        //     ));
                                      },
                                      child: ImageTile('images/hostel_b.png'),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                                      child: Text(
                                        "Hostel",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF272727),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        /*
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(pW(16), pH(10), pW(6), pH(5.5)),
                          child: Container(
                            child: _categoriesTiles(getPhotoTiles, bloc, database),
                          ),
                        ),
                      */

                        _heading(heading: "BEST SELLING CATEGORIES"),
                        _redirectToCategories(() => getBestCategories(), database),
                        _heading(heading: "BEST SELLING ITEMS"),
                        // TODO:: change Future Builder implementation in future

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(pW(14), pH(20), 0, 0),
                          child: Container(
                            height: pH(230),
                            child: FutureBuilder(
                                future: getBestSellingItems(),
                                builder: (context, itemsInfo) {
                                  if (itemsInfo.hasData) {
                                    List itemsPath = itemsInfo.data;
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: itemsPath.length,
                                        itemBuilder: (context, index) {
                                          String fullPath = itemsPath[index];
                                          int num = fullPath.lastIndexOf('/');
                                          String path = fullPath.substring(0, num);
                                          String documentID = fullPath.substring(num + 1, fullPath.length);

                                          return FutureBuilder(
                                              future: database.getItemForHomePage(path, documentID),
                                              builder: (context, snapshot) {
                                                // print(itemsPath[index]);
                                                if (snapshot.hasData) {
                                                  Item itemData = snapshot.data;
                                                  return EComListCard(itemData: itemData, database: database);
                                                } else
                                                  return Container(height: 0);
                                              });
                                        });
                                  } else {
                                    return Container(
                                      height: 0,
                                    );
                                  }
                                }),
                          ),
                        ),
                        _heading(heading: "PET GROOMING"),
                        _redirectToCategories(getPetGrooming, database),
                        _heading(heading: "AQUATIC PET ESSENTIALS"),
                        _redirectToCategories(getAquaticEssentials, database),
                        Padding(
                          padding: EdgeInsets.only(bottom: pH(60)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container ImageTile(String path) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF36A9CC),
            width: 3
          ),
            borderRadius: BorderRadius.circular(16)
        ),
        height: pH(113),
        width: pW(113),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //decoration: BoxDecoration(shape: BoxShape.circle, color: petColor[400]),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              height: pH(100),
              width: pW(100),
            ),
          ),
        ));

  Padding _redirectToCategories(Stream getAquaticEssentials(), Database database) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(pW(14), pH(20), 0, 0),
      child: Container(
        height: pH(210),
        child: StreamBuilder(
            stream: getAquaticEssentials(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map categories = snapshot.data["categories"];
                List keys = categories.keys.toList();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: keys.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return EComListPage(
                          category: keys[index].toString(),
                        );
                      }));
                    },
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          width: pW(140),
                          margin: EdgeInsets.only(right: pH(15), bottom: pH(10)),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            image: new DecorationImage(
                              image: NetworkImage(categories["${keys[index]}"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "${keys[index]}",
                        style: TextStyle(color: petColor, fontSize: pH(20), fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Padding _heading({String heading, double paddingTop = 40}) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(paddingTop), 0, 0),
      child: Text(
        heading,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.w600,
          fontSize: pH(22),
          fontStyle: FontStyle.normal,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }

  StreamBuilder _categoriesTiles(Stream getPhotoTiles(), Database database) {
    return StreamBuilder(
        stream: getPhotoTiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map tiles = snapshot.data["tiles"];
            List keys = tiles.keys.toList();
            return GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: keys.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(childAspectRatio: 1, maxCrossAxisExtent: pW(207)),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return EComListPage(
                        category: keys[index].toString(),
                      );
                    }));
                  },
                  child: Container(
                    width: pW(207),
                    margin: EdgeInsetsDirectional.fromSTEB(0, 0, pW(10), pW(10)),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: new DecorationImage(
                        image: NetworkImage(tiles["${keys[index]}"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Pet>>(
      stream: database.petsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pets = snapshot.data;
          if (pets.isNotEmpty) {
            final children = pets
                .map(
                  (pet) => CustomDropdownMenuItem(
                    value: pets.indexOf(pet),
                    child: _buildTile(pet),
                    onTap: () {},
                  ),
                )
                .toList();
            globalCurrentPet = pets.elementAt(globalCurrentPetValue);
            // print(globalCurrentPet.name);
            return CustomDropdownButton(
              icon: Icon(Icons.keyboard_arrow_down, size: 40, color: Color(0xFFFFFFFF)),
              itemHeight: 50,
              dropdownColor: Color(0xFF36A9CC),
              isExpanded: true,
              value: globalCurrentPetValue,
              items: children +
                  [
                    CustomDropdownMenuItem(
                      value: pets.length,
                      child: _buildAddTile(),
                      onTap: () {},
                    ),
                  ],
              onChanged: (value) {
                setState(() {
                  if (value == pets.length) {
                    Petform.show(context, uid: widget.user.uid);
                  } else {
                    globalCurrentPetValue = value;
                  }
                });
              },
            );
          } else {
            return GestureDetector(
              onTap: () => Petform.show(context, uid: widget.user.uid),
              child: _buildAddTile(),
            );
          }
        } else if (snapshot.hasError) {
          return Center(child: Text('some error occured'));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildTile(Pet pet) {
    NetworkImage _petImage = pet.image == null ? null : NetworkImage(pet.image);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            image: _petImage == null ? null : DecorationImage(image: _petImage, fit: BoxFit.fitWidth),
          ),
          child: _petImage == null
              ? Icon(
                  Icons.pets,
                  color: Colors.brown,
                  size: 20,
                )
              : Container(),
        ),
        SizedBox(width: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pet.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat",
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(color: Color(0xFFFFFFFF), shape: BoxShape.circle, border: Border.all(width: 0.2)),
          child: Icon(
            Icons.add,
            size: 24,
            color: Color(0xFF000000),
          ),
        ),
        SizedBox(width: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a Pet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
