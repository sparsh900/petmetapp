import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/del--ecom/blocs/eCom_bloc.dart';
import 'package:petmet_app/app/del--ecom/eComListCard.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class EComListPage extends StatefulWidget {
  EComListPage({@required this.database});
  final Database database;
  @override
  _EComListPageState createState() => _EComListPageState();
}

class _EComListPageState extends State<EComListPage> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  final TextEditingController _search = new TextEditingController();
  ValueNotifier<String> _searchText = new ValueNotifier<String>("");

  Widget appBarTitle;
  Icon actionIcon = new Icon(Icons.search);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EComBloc, EComState>(
      listener: (context, state) {},
      buildWhen: (previous, current) {
        return current is EComItemsStream;
      },
      builder: (context, state) {
        print("eComListPage :: State is $state");
        if (state is EComItemsStream) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
              child: AppBar(
                backgroundColor: petColor,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                titleSpacing: pW(6),
                title: appBarTitle ??
                    Text(
                      "${state.category}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                actions: [
                  new IconButton(
                    icon: actionIcon,
                    color: Colors.white,
                    iconSize: 26,
                    onPressed: () {
                      setState(() {
                        if (this.actionIcon.icon == Icons.search) {
                          this.actionIcon = new Icon(Icons.close);
                          this.appBarTitle = Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: pH(36.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: new TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.left,
                                  autofocus: true,
                                  controller: _search,
                                  style: new TextStyle(color: Colors.black, fontSize: 16),
                                  maxLines: 1,
                                  decoration: new InputDecoration(
                                    prefixIcon: new Icon(Icons.search, color: Colors.grey),
                                    contentPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(16)),
                                    hintText: "Search",
                                    hintStyle: new TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          this.actionIcon = new Icon(Icons.search);
                          this.appBarTitle = new Text(
                            "${state.category}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          );
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 2, 0, 0),
                    child: InkWell(
                      onTap: () => Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<void>(
                          fullscreenDialog: true,
                          builder: (context) => CartPage(database: widget.database),
                        ),
                      ),
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: pW(88),
                        height: pH(29),
                        child: RaisedButton(
                          color: petColor,
                          textColor: Colors.white,
                          child: Row(
                            children: [
                              Text(
                                "Filter: ",
                                style: TextStyle(fontSize: pH(14)),
                              ),
                              Icon(Icons.keyboard_arrow_down, size: pH(14)),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: pW(10),
                        height: pH(29),
                      ),
                      Container(
                        width: pW(102),
                        height: pH(29),
                        child: RaisedButton(
                          color: petColor,
                          textColor: Colors.white,
                          child: Row(
                            children: [
                              Text("Sort By: ",
                                  style: TextStyle(
                                    fontSize: pH(14),
                                  )),
                              Icon(Icons.keyboard_arrow_down, size: pH(14)),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowGlow();
                      return false;
                    },
                    child: Expanded(
                      child: StreamBuilder(
                        stream: state.items,
                        builder: (context, snapshot) {
                          _search.addListener(() {
                            _searchText.value = _search.text.isEmpty ? "" : _search.text;
                          });

                          if (snapshot.hasData) {
                            return ValueListenableBuilder<String>(
                              valueListenable: _searchText,
                              builder: (context, value, child) {
                                List<Item> searchedItems = new List();
                                if (value.isNotEmpty) {
                                  searchedItems.removeRange(0, searchedItems.length);
                                  for (int i = 0; i < snapshot.data.length; i++) {
                                    print(snapshot.data[i].details["name"].toString().toLowerCase().contains(value.toLowerCase()));
                                    if (snapshot.data[i].details["name"].toString().toLowerCase().contains(value.toLowerCase())) {
                                      searchedItems.add(snapshot.data[i]);
                                    }
                                  }
                                } else {
                                  searchedItems = snapshot.data;
                                }
                                int noOfCrossAxis = MediaQuery.of(context).size.width.toDouble() ~/ 300;
                                double aspectRatio = pH(193.0) / pW(186.0) * 0.97;
                                noOfCrossAxis = noOfCrossAxis < 2 ? 2 : noOfCrossAxis;

                                if (searchedItems.length != 0) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: pW(16.0)),
                                    child: GridView.builder(
                                      addAutomaticKeepAlives: true,
                                      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                          //childAspectRatio: pW(155)/pH(230),
                                          crossAxisSpacing: pW(16),
                                          mainAxisSpacing: pH(24),
                                          crossAxisCount: 2,
                                      ),
                                      // SliverGridDelegateWithMaxCrossAxisExtent(
                                      //   maxCrossAxisExtent: pH(193),
                                      //   childAspectRatio: aspectRatio
                                      // ),
                                      itemCount: searchedItems.length,
                                      itemBuilder: (context, index) => BlocProvider.value(
                                        value: BlocProvider.of<EComBloc>(context),
                                        child: Container(
                                            // margin: EdgeInsets.only(bottom: pH(12)),
                                            child: EComListCard(itemData: searchedItems[index], database: widget.database)),
                                      ),
                                      // }
                                    ),
                                  );
                                } else {
                                  return EmptyContent(title: "No Items", message: "no matching items Found");
                                }
                              },
                            );
                          } else {
                            return EmptyContent(title: "No back", message: "no matching items Found");
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
