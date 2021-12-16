import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/cartNumberNotifier.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/common_widgets/custom_carousel.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

class ShowItemPage extends StatefulWidget {
  ShowItemPage({@required this.itemData, @required this.database});
  final Item itemData;
  final Database database;
  @override
  _ShowItemPageState createState() => _ShowItemPageState();
}

class _ShowItemPageState extends State<ShowItemPage> {
  bool _pdDropdown = false;
  bool _gaDropdown = false;
  String _userSelectedSize = "";
  final TextEditingController _pincodeController = TextEditingController();
  Color _checkColor = petColor;
  bool _isWishList = false;
  bool _showAddedToFavorites = false;

  @override
  void initState() {
    super.initState();
    checkIsWishlist();
    _userSelectedSize = widget.itemData.details["size"][0];
  }

  Future<void> addToCart() async {
    await widget.database.setCartItem(widget.itemData, _userSelectedSize);
  }

  Future<void> addToWishList() async {
    await widget.database.setWishlistItem(widget.itemData);
  }

  Future<void> _checkPincode() async {
    int pincode = int.tryParse(_pincodeController.text) ?? 0;
    if (pincode > 99999 && pincode < 1000000) {
      if (await widget.database.checkPincode(pincode)) {
        setState(() {
          _checkColor = Colors.green;
        });
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).unfocus();
        ShowErrorDialog.show(context: context, title: "Pincode not available", message: "We'll be expanding to new cities soon.");
        setState(() {
          _checkColor = metColor;
        });
      }
    } else {
      setState(() {
        _checkColor = metColor;
        FocusScope.of(context).unfocus();
        ShowErrorDialog.show(context: context, title: "Pincode not valid", message: "A pincode should be like this, e.g. 123456");
      });
    }
  }

  Future<void> checkIsWishlist() async {
    final isWishlist = await widget.database.checkWishlist(widget.itemData);
    setState(() {
      _isWishList = isWishlist;
    });
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(70.0)), // here the desired height
        child: Container(
          child: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Text(
              "${widget.itemData.details["name"]}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontFamily: 'Roboto',
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 10, 0),
                child: InkWell(
                  onTap: () {
                    CartNumber myCartNumber = Provider.of<CartNumber>(context, listen: false);
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider<CartNumber>.value(
                            value: myCartNumber,
                            child: CartPage(database: widget.database),
                          )),
                    );
                  },



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
                    child: Icon(Icons.shopping_cart,
                      color: Color(0xFF36A9CC),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
              //   child: InkWell(
              //     onTap: () => Navigator.of(context, rootNavigator: true).push(
              //       CupertinoPageRoute<void>(
              //         fullscreenDialog: true,
              //         builder: (context) => CartPage(database: widget.database),
              //       ),
              //     ),
              //     child: Icon(Icons.shopping_cart),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: InkWell(
                    onTap: () async {
                      if (_userSelectedSize == "") {
                        ShowErrorDialog.show(context: context, title: 'No Size Selected', message: 'Please choose a size');
                      } else {
                        await addToCart();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage(database: widget.database), fullscreenDialog: true));
                      }
                    },
                    child: Container(
                      height: pH(55),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'BUY NOW',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF36A9CC),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: InkWell(
                    onTap: () async {
                      if (_userSelectedSize == "") {
                        ShowErrorDialog.show(context: context, title: 'No Size Selected', message: 'Please choose a size');
                      } else {
                        await addToCart();
                        Navigator.of(context).pop();
                        ShowErrorDialog.show(context: context, title: 'Item Added to Cart', message: 'Visit cart to checkout after shopping');
                      }
                    },
                    child: Container(
                      height: pH(55),
                      decoration: BoxDecoration(
                        color: petColor,
                      ),
                      child: Center(
                        child: Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
              height: pH(21),
              width: pW(163),
              decoration: BoxDecoration(
                color: _showAddedToFavorites ? metColor : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  'Added to Favourites',
                  style: TextStyle(
                    color: _showAddedToFavorites ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      SizedBox(
        child: CustomCarousel(
          customHeight: pH(231),
          fit: BoxFit.fitHeight,
          dotColor: metColor,
          listOfURL: widget.itemData.details["urlList"],
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(22, 18, 22, 5),
              height: pH(83),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: Container(
                      child: Text(
                        widget.itemData.details['name'],
                        style: TextStyle(fontSize: pH(26),
                          color: Color(0xFF000000),
                          fontFamily: "montserrat",
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: InkWell(
                      onTap: () async {
                        if (_isWishList == true) {
                          widget.database.deleteWishlistItem(widget.itemData);
                          setState(() {
                            _isWishList = false;
                          });
                        } else if (_isWishList == false) {
                          await addToWishList();
                          setState(() {
                            _showAddedToFavorites = true;
                            _isWishList = true;
                          });
                          Timer timer = Timer(Duration(seconds: 2), () {
                            setState(() {
                              _showAddedToFavorites = false;
                            });
                          });
                        }
                      },
                      child: Icon(
                        _isWishList ? MyFlutterApp.heart : MyFlutterApp.outline_heart,
                        color: metColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "₹${widget.itemData.details["cost"]}",
                        style: TextStyle(fontSize: 30, color: petColor, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "₹${widget.itemData.details["mrp"]}",
                        style: TextStyle(fontSize: 20, decoration: TextDecoration.lineThrough, color: Color(0xFFA7A7A7)),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "(${widget.itemData.details["addInfo"]})",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFA7A7A7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Size:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFA7A7A7),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.itemData.details["size"].length,
                          itemBuilder: (context, index) => Container(
                            color: widget.itemData.details["size"][index] == _userSelectedSize ? petColor : Colors.white,
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: OutlineButton(
                              textColor: widget.itemData.details["size"][index] == _userSelectedSize ? Colors.white : petColor,
                              borderSide: BorderSide(
                                color: petColor,
                              ),
                              child: Text(
                                "${widget.itemData.details["size"][index]}",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _userSelectedSize = widget.itemData.details["size"][index];
                                });
                                print(_userSelectedSize);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Eligible for Delivery?',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Container(
                        width: pW(110),
                        height: pH(40),
                        child: TextField(
                          controller: _pincodeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(color: petColor)),
                            labelText: 'Enter Pincode',
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _checkPincode,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        child: FlatButton(
                          color: _checkColor,
                          child: Text(
                            'Check',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _checkPincode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: RichText(
                text: TextSpan(style: TextStyle(fontSize: 18, color: Colors.black), children: [
                  TextSpan(
                    text: 'Ingredients: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '${widget.itemData.details["ingredients"]}')
                ]),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Product Description:',
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pdDropdown = _pdDropdown == false ? true : false;
                          });
                        },
                        child: Icon(_pdDropdown == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 25),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _displayPD(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Guaranteed Analysis:',
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _gaDropdown = _gaDropdown == false ? true : false;
                          });
                        },
                        child: Icon(_gaDropdown == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 25),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _displayGA(),
                ],
              ),
            ),
            SizedBox(height: pH(60)),
          ],
        ),
      ),
    ];
  }

  Widget _displayPD() {
    if (_pdDropdown == true) {
      return Text(
        '${widget.itemData.details["description"]}',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _displayGA() {
    if (_gaDropdown == true) {
      return Text(
        '${widget.itemData.details["guaranteedAnalysis"]}',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      );
    } else {
      return Container();
    }
  }
}
