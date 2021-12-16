import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/home/drawer.dart';
import 'package:petmet_app/app/home/models/cartNumberNotifier.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

import 'package:petmet_app/common_widgets/customExpansionTile.dart' as custom;
import 'package:shimmer/shimmer.dart';

//module level imports
import '../ui_widgets/appBar_withCartButton.dart';
import './bloc/ecom_bloc.dart';
import './bloc/functions/miniRepo_shop.dart';
import '../ui_widgets/eComListCardShop.dart';
import '../ui_widgets/view_all_button.dart';

class ShopHomePage extends StatefulWidget {
  ShopHomePage();
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  Database database;
  @override
  void initState() {
    super.initState();
    database = Provider.of<Database>(context, listen: false);
  }

  int userIndex = -1;

  @override
  Widget build(BuildContext context) {
    print('Build widget of ShopHomePage...If no other message of bloc gets printed..assume no extra database call');
    return Scaffold(
      appBar: buildAppBar(context, database, Provider.of<CartNumber>(context).cartNumber),
      drawer: CustomDrawer.show(database: database, context: context, checkUserAns: checkUserAns),

      //----------------------->>>>>>>>>Body Starts Here
      body: BlocProvider(
        create: (context) => EComBloc(miniRepo: MiniRepo(database: database))..add(LoadCarousel())..add(LoadEventShopHomePage()),
        lazy: false,
        child: Builder(
          builder: (context) => Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: petColor,
                ),
                child: _buildContent(context),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    BlocProvider.of<EComBloc>(context).add(EComLoadingEvent());
                    return Future.delayed(Duration.zero);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: pH(12.0)),
                          child: BlocBuilder<EComBloc, EComState>(
                            buildWhen: (previous, current) => current is EComLoading || current is EmitCarouselURLs,
                            builder: (context, state) {
                              if (state is EmitCarouselURLs) {
                                return SizedBox(
                                  height: pH(166),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      aspectRatio: 2.0,
                                      viewportFraction: 0.8,
                                      autoPlayInterval: Duration(seconds: 15),
                                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      pauseAutoPlayOnTouch: true,
                                      enlargeCenterPage: true,
                                    ),
                                    items: state.listOfURLs
                                        .map((item) => Container(
                                              margin: EdgeInsets.all(2.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                );

                                //   SizedBox(
                                //   child: CustomCarousel(
                                //     listOfURL: state.listOfURLs,
                                //   ),
                                // );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: pW(8.0)),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Container(
                                      child: SizedBox(
                                        width: pW(414),
                                        height: pH(166),
                                        child: Container(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(pW(12), pH(12), pW(12), pH(24)),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              BlocBuilder<EComBloc, EComState>(
                                buildWhen: (previous, current) => current is LimitedShopPageTitles || current is EComLoading,
                                builder: (context, state) {
                                  if (state is LimitedShopPageTitles) {
                                    return StreamBuilder(
                                        stream: state.data,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            Map keyMap = snapshot.data;
                                            List keys = keyMap.keys.toList();
                                            return Column(mainAxisSize: MainAxisSize.min, children: [
                                              Container(
                                                child: ListView.builder(
                                                  key: Key('builder ${userIndex.toString()}'),
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: keys.length,
                                                  itemBuilder: (context, index) {
                                                    return Column(mainAxisSize: MainAxisSize.min, children: [
                                                      SizedBox(
                                                        height: pH(10),
                                                      ),
                                                      buildExpansionTile(keys[index], snapshot.data[keys[index]], index),
                                                    ]);
                                                  },
                                                ),
                                              ),
                                            ]);
                                          }
                                          return Container(height: 0);
                                        });
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => Container(height: pH(50), color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: pH(10))),
                                        itemCount: 10,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ]))
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

  custom.ExpansionTile buildExpansionTile(String category, Stream<List<Item>> items, int normalIndex) {
    return custom.ExpansionTile(
      key: Key(userIndex.toString()),
      initiallyExpanded: normalIndex == userIndex,
      onExpansionChanged: (value) {
        if (value) {
          setState(() {
            Duration(seconds: 20000);
            userIndex = normalIndex;
          });
        } else {
          setState(() {
            userIndex = -1;
          });
        }
      },
      title: Text(
        "$category",
        textAlign: TextAlign.left,
        style: TextStyle(
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
              return Column(mainAxisSize: MainAxisSize.min, children: [
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: pW(155) / pH(230), crossAxisSpacing: pW(16), mainAxisSpacing: pH(24), crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => EComListCard(database: Provider.of<Database>(context), itemData: snapshot.data[index]),
                ),
                ShopHomeButton(category: category),
              ]);
            } else {
              return EmptyContent(title: "Items", message: "Items for this category will be added soon");
            }
          },
        ),
        SizedBox(
          height: pH(10),
        ),
      ],
    );
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  // ------------------
  //  Pet Dropdown

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
              icon: Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.white),
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
                    Petform.show(context, uid: database.getUid());
                  } else {
                    globalCurrentPetValue = value;
                  }
                });
              },
            );
          } else {
            return GestureDetector(
              onTap: () => Petform.show(context, uid: database.getUid()),
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
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(width: 0.2)),
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
