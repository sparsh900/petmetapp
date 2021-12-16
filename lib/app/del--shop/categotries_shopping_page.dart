import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/app/del--ecom/blocs/eCom_bloc.dart';
import 'package:petmet_app/app/del--ecom/eComListCard.dart';
import 'package:petmet_app/app/del--shop/shop_home_button.dart';
import 'package:petmet_app/app/home/drawer.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:petmet_app/common_widgets/custom_carousel.dart';

import 'package:petmet_app/common_widgets/customExpansionTile.dart' as custom;

class ShopHomePage extends StatefulWidget {
  ShopHomePage({this.user});
  final User user;
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
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

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  navigateToPage(BuildContext context, String page) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    final bloc = BlocProvider.of<EComBloc>(context);
    bloc.add(EComGetHomePage());
    print('userHome -- ${widget.user.uid}');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Scaffold(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                  child: InkWell(
                    onTap: () {},
                    child: Icon(Icons.search),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                  child: InkWell(
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<void>(
                        fullscreenDialog: true,
                        builder: (context) => CartPage(database: database),
                      ),
                    ),
                    child: Icon(Icons.shopping_cart),
                  ),
                ),
              ],
            ),
          ),
          drawer: CustomDrawer.show(
              database: database, context: context, checkUserAns: checkUserAns),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: petColor,
                ),
                child: _buildContent(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: CustomCarousel(
                          path: "homepage/carousel",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            pW(12), pH(12), pW(12), pH(24)),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          BlocConsumer<EComBloc, EComState>(
                            buildWhen: (previous, current) {
                              return current is EComLimitedItems;
                            },
                            listener: (context, state) {},
                            builder: (context, state) {
                              print("eComHomePage :: State is $state");
                              if (state is EComLimitedItems) {
                                List keys = state.data.keys.toList();
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: keys.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: pH(10),
                                                  ),
                                                  buildExpansionTile(
                                                      keys[index],
                                                      state.data[keys[index]])
                                                ]);
                                          },
                                        ),
                                      )
                                    ]);
                              } else {
                                return Container(
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),

                          SizedBox(height: 20),
                          // ShopHomeButton(text: 'View All Items',color: metColor),//Temporary for testing
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  custom.ExpansionTile buildExpansionTile(
      String category, Stream<List<Item>> items) {
    return custom.ExpansionTile(
      title: Text(
        "$category",
        textAlign: TextAlign.left,
        style: TextStyle(
          // color: Color(0xFF36A9CC),
          fontWeight: FontWeight.w600,
          fontSize: pW(20),
          fontStyle: FontStyle.normal,
          fontFamily: "Montserrat",
        ),
      ),
      children: <Widget>[
        SizedBox(
          height: pH(10),
        ),
        StreamBuilder(
          stream: items,
          builder: (context, snapshot) {

            if (snapshot.hasData && snapshot.data.length != 0) {
              print(snapshot.data.toString());

              int noOfCrossAxis=MediaQuery.of(context).size.height.toDouble()~/300;
              print(MediaQuery.of(context).size.width.toDouble());
              noOfCrossAxis=noOfCrossAxis<3?2:noOfCrossAxis;
              print(noOfCrossAxis);
              print(MediaQuery.of(context).size.height.toDouble());
              // double aspectRatio=MediaQuery.of(context).
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(pW(16), pH(16), pW(16), pH(16)),
                child: Column(//mainAxisSize: MainAxisSize.min,
                    children: [
                  GridView.builder(
                      shrinkWrap: true,
                      primary: false,

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: pW(155)/pH(230),
                        crossAxisSpacing: pW(16),
                          mainAxisSpacing: pH(24),
                          crossAxisCount: 2),

                      // SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: noOfCrossAxis,
                      //     childAspectRatio: 1.2
                      // ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => BlocProvider.value(
                            value: BlocProvider.of<EComBloc>(context),
                            child: EComListCard(
                                database: Provider.of<Database>(context),
                                itemData: snapshot.data[index]),
                          )),
                  ShopHomeButton(category: category),
                ]),
              );
            } else {
              return EmptyContent(
                  title: "Items",
                  message: "Items for this category will be added soon");
            }
          },
        ),
        SizedBox(
          height: pH(10),
        ),
      ],
    );
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
                  (pet) => DropdownMenuItem(
                    value: pets.indexOf(pet),
                    child: _buildTile(pet),
                    onTap: () {},
                  ),
                )
                .toList();
            globalCurrentPet = pets.elementAt(globalCurrentPetValue);
            print(globalCurrentPet.name);
            return DropdownButton(
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 40, color: Colors.white),
              itemHeight: 50,
              dropdownColor: petColor,
              isExpanded: true,
              value: globalCurrentPetValue,
              items: children +
                  [
                    DropdownMenuItem(
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
            image: _petImage == null
                ? null
                : DecorationImage(image: _petImage, fit: BoxFit.fitWidth),
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
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 0.2)),
          child: Icon(
            Icons.add,
            size: 20,
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
