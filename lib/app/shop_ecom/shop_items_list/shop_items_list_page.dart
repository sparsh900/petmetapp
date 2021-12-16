import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:petmet_app/app/home/models/cartNumberNotifier.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'itemsList_bloc/items_list_bloc.dart';
import '../ui_widgets/eComListCardShop.dart';
import './itemsList_bloc/functions/minirepo_list_page.dart';

class EComListPage extends StatefulWidget {
  EComListPage({@required this.category});
  final String category;
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

  TextEditingController _search;
  ValueNotifier<String> _searchText;

  Widget categoryTitle;
  Widget searchTitle;
  Widget appBarTitle;

  Icon searchIcon = Icon(Icons.search);
  Icon closeIcon = Icon(Icons.close);
  Icon actionIcon;
  List<String> _checked;
  RangeValues _currentRangeValues;
  String _selected = "";
  int _numSort = 0;

  Database database;

  @override
  void initState() {
    super.initState();
    database = Provider.of<Database>(context, listen: false);
    _search = new TextEditingController();
    _searchText = new ValueNotifier<String>("");

    _search.addListener(() {
      _searchText.value = _search.text.isEmpty ? "" : _search.text;
    });

    _checked = [];
    _currentRangeValues = RangeValues(0, 10000);

    actionIcon = searchIcon;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryTitle = Text(
        "${widget.category}",
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
      searchTitle = Column(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsListBloc(repo: MiniRepo(database: database))..add(ItemsBuildEvent(category: widget.category)),
      lazy: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
          child: AppBar(
            backgroundColor: petColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            titleSpacing: pW(6),
            title: appBarTitle ??
                Text(
                  "${widget.category}",
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
              IconButton(
                icon: actionIcon ?? searchIcon,
                color: Colors.white,
                iconSize: 26,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = closeIcon;
                      this.appBarTitle = searchTitle;
                    } else {
                      this.actionIcon = searchIcon;
                      this.appBarTitle = categoryTitle;
                      _search.text = "";
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 10, 0),
                child: InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute<void>(
                      fullscreenDialog: true,
                      builder: (context) => CartPage(database: database),
                    ),
                  ),
                  child: Badge(
                    badgeColor: metColor,
                    shape: BadgeShape.circle,
                    position: BadgePosition.topEnd(top: -4, end: -6),
                    badgeContent: Text(
                      Provider.of<CartNumber>(context).cartNumber.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Icon(Icons.shopping_cart),
                  ),
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
                    margin: EdgeInsets.only(right: pW(5)),
                    child: BlocConsumer<ItemsListBloc, ItemsListState>(
                      listener: (context, state) async {
                        if (state is OpenFilterState) {
                          List keys = state.dbFilterInfo.keys.toList();
                          await buildShowFilters(context, keys, state);
                          BlocProvider.of<ItemsListBloc>(context).add(ItemsFilterSortEvent(filterInfo: {
                            "minCost": _currentRangeValues.start.round(),
                            "maxCost": _currentRangeValues.end.round(),
                            "filterArray": _checked,
                          }, numDecider: _numSort));
                        }
                      },
                      listenWhen: (previous, current) => current is OpenFilterState,
                      buildWhen: (previous, current) => current is ItemsListInitial,
                      builder: (context, state) => RaisedButton(
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
                        onPressed: () {
                          BlocProvider.of<ItemsListBloc>(context).add(OpenFilterEvent());
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: pW(102),
                    height: pH(29),
                    margin: EdgeInsets.only(right: pW(10)),
                    child: BlocConsumer<ItemsListBloc, ItemsListState>(
                      listener: (context, state) async {
                        if (state is OpenSortState) {
                          await buildShowSort(context);
                          BlocProvider.of<ItemsListBloc>(context).add(ItemsFilterSortEvent(filterInfo: {
                            "minCost": _currentRangeValues.start.round(),
                            "maxCost": _currentRangeValues.end.round(),
                            "filterArray": _checked,
                          }, numDecider: _numSort));
                        }
                      },
                      listenWhen: (previous, current) => current is OpenSortState,
                      buildWhen: (previous, current) => current is ItemsListInitial,
                      builder: (context, state) => RaisedButton(
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
                        onPressed: () {
                          BlocProvider.of<ItemsListBloc>(context).add(OpenSortEvent());
                        },
                      ),
                    ),
                  ),
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
                  child: BlocConsumer<ItemsListBloc, ItemsListState>(
                    listener: (context, state) {},
                    buildWhen: (previous, current) => current is ItemsListInitial || current is ItemsBuildState,
                    builder: (context, state) {
                      if (state is ItemsBuildState) {
                        print(state.data.toString());
                        return ValueListenableBuilder(
                          valueListenable: _searchText,
                          builder: (context, value, child) {
                            //Filtering on the basis of search
                            List<Item> searchedItems = new List();
                            if (_search.text.isNotEmpty) {
                              for (int i = 0; i < state.data.length; i++) {
                                if (state.data[i].details["name"].toString().toLowerCase().contains(_search.text.toLowerCase())) {
                                  searchedItems.add(state.data[i]);
                                }
                              }
                            } else {
                              searchedItems = state.data;
                            }

                            if (searchedItems.length != 0) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: pW(16.0)),
                                child: RefreshIndicator(
                                  onRefresh: () {
                                    // _selected="";
                                    // _numSort=0;
                                    // _currentRangeValues=RangeValues(0.0, 10000.0);
                                    // _checked=[];

                                    BlocProvider.of<ItemsListBloc>(context).add(RefreshEvent(filterInfo: {
                                      "minCost": _currentRangeValues.start.round(),
                                      "maxCost": _currentRangeValues.end.round(),
                                      "filterArray": _checked,
                                    }, numDecider: _numSort, category: widget.category));
                                    return Future.delayed(Duration.zero);
                                  },
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: pW(155) / pH(230), crossAxisSpacing: pW(16), mainAxisSpacing: pH(24), crossAxisCount: 2),
                                    itemCount: searchedItems.length,
                                    itemBuilder: (context, index) => Container(child: EComListCard(itemData: searchedItems[index], database: database)),
                                  ),
                                ),
                              );
                            } else {
                              return EmptyContent(
                                title: "No Items",
                                message: "no matching items Found",
                                belowWidget: Container(
                                  margin: EdgeInsets.only(top: pH(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RaisedButton(
                                        onPressed: () {
                                          BlocProvider.of<ItemsListBloc>(context).add(RefreshEvent(filterInfo: {
                                            "minCost": _currentRangeValues.start.round(),
                                            "maxCost": _currentRangeValues.end.round(),
                                            "filterArray": _checked,
                                          }, numDecider: _numSort, category: widget.category));
                                        },
                                        child: Text(
                                          "Refresh Page",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        color: petColor,
                                      ),
                                      SizedBox(
                                        width: pW(20),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          _selected = "";
                                          _numSort = 0;
                                          _currentRangeValues = RangeValues(0.0, 10000.0);
                                          _checked = [];
                                          BlocProvider.of<ItemsListBloc>(context).add(ItemsFilterSortEvent(filterInfo: {
                                            "minCost": _currentRangeValues.start.round(),
                                            "maxCost": _currentRangeValues.end.round(),
                                            "filterArray": _checked,
                                          }, numDecider: _numSort));
                                        },
                                        child: Text(
                                          "Clear Filters",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        color: petColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        return shimmerLoading();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future buildShowSort(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text(
          "Sort",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Container(
            width: 200,
            height: 120,
            child: Column(children: [
              Text(
                "PRICE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioButtonGroup(
                labels: <String>[
                  "Low to High",
                  "High to Low",
                ],
                picked: _selected,
                onSelected: (String selected) => setState(() {
                  _selected = selected;
                }),
              ),
            ]),
          ),
        ),
        actions: [
          RaisedButton(
            onPressed: () {
              if (_selected == "Low to High") {
                _numSort = 1;
              } else if (_selected == "High to Low") {
                _numSort = 2;
              } else {
                _numSort = 0;
              }
              Navigator.of(context).pop();
            },
            child: Text(
              "Sort",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: petColor,
          ),
        ],
      ),
    );
  }

  Future buildShowFilters(BuildContext context, List keys, OpenFilterState state) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Filters:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              width: pW(400),
              height: pH(450),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowGlow();
                  return;
                },
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: keys.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => keys[index].toString().toUpperCase()!="COST"?Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            keys[index].toString().toUpperCase() + ":",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                          ),
                          CheckboxGroup(
                            onSelected: (List selected) => setState(() {
                              _checked = selected;
                            }),
                            labels: List<String>.from(state.dbFilterInfo[keys[index]]),
                            labelStyle: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w500),
                            checked: _checked,
                          ),
                          SizedBox(
                            height: pH(10),
                          ),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          )
                        ],
                      ):Container(height: 0,),
                    ),
                    Text(
                      "PRICE:",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    ),
                    RangeSlider(
                      values: _currentRangeValues,
                      min: 0,
                      max: 10000,
                      divisions: 100,
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Flexible(
                          child: Text(
                            "₹ " + _currentRangeValues.start.truncate().toString(),
                            textAlign: TextAlign.end,
                          )),
                      Flexible(child: Container(child: Text("₹ " + _currentRangeValues.end.truncate().toString()))),
                    ]),
                  ]),
                ),
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _checked = [];
                    _currentRangeValues = RangeValues(0, 10000);
                  });
                },
                child: Text(
                  "Clear",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Apply",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: petColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: pW(16.0)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: pW(155) / pH(230), crossAxisSpacing: pW(16), mainAxisSpacing: pH(24), crossAxisCount: 2),
          itemCount: 10,
          itemBuilder: (context, index) => Container(height: pH(50), color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: pH(10))),
        ),
      ),
    );
  }
}
