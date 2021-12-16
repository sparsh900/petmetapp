import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/del--ecom/blocs/eCom_bloc.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/home/models/order.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/common_widgets/custom_carousel.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    checkIsWishlist();
    _userSelectedSize = widget.itemData.details["size"][0];
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    _pincodeController.dispose();
  }

  String documentIdFromCurrentDate() =>
      DateTime.now().toIso8601String() + widget.database.getUid();
  Order order;
  String orderID;
  void openCheckout(String total) async {
    UserData userData = await widget.database.getUserData();
    List items = [];
    items.add({
      'itemID': widget.itemData.id,
      'itemName': widget.itemData.details["name"],
      'itemSize': _userSelectedSize,
      'itemCategory': widget.itemData.details['category']
    });
    order = new Order(
        customerName: "${userData.firstName} ${userData.lastName}",
        mobileNumber: userData.phone,
        orderId: null,
        amount: num.parse("$total"),
        status: "draft",
        timestamp: Timestamp.now(),
        allItems: items,
        email: userData.mail,
        pincode: _pincodeController.text,
        address: userData.address);

    orderID = documentIdFromCurrentDate();
    await widget.database.setOrder(order, orderID);
    var options = {
      "key": "rzp_test_HpdJifpKFyBE1U",
      "currency": "INR",
      // "order_id":orderID,
      "amount": num.parse("$total") * 100,
      "name": "PetMet",
      "description": "Payment for cart products",
      "prefill": {"contact": "${userData.phone}", "email": "${userData.mail}"},
      "external": {
        "wallets": ["paytm", "freecharge", "payzapp"],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    widget.database.updateOrder(order, "successful", orderID);
    // widget.database.addUserPreviousOrder(order,orderID);
    widget.database.deleteAllCartItems();
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed...");
    widget.database.updateOrder(order, "failed", orderID);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print(
        "External Wallet --  ${response.walletName}\nWe provide external wallet support :)");
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
        ShowErrorDialog.show(
            context: context,
            title: "Pincode not available",
            message: "We'll be expanding to new cities soon.");
        setState(() {
          _checkColor = metColor;
        });
      }
    } else {
      setState(() {
        _checkColor = metColor;
        FocusScope.of(context).unfocus();
        ShowErrorDialog.show(
            context: context,
            title: "Pincode not valid",
            message: "A pincode should be like this, e.g. 123456");
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
    final bloc = BlocProvider.of<EComBloc>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: petColor,
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "${widget.itemData.details["name"]}",
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
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
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
            //   child: InkWell(
            //     onTap: () {},
            //     child: BlocConsumer(
            //       cubit: bloc,
            //       listener: (context, state) {},
            //       buildWhen: (previous, current) {
            //         return current is EComAddedToCart;
            //       },
            //       builder: (context, state) {
            //         if (state is EComAddedToCart) {
            //           return Text("${state.numberOfCartItems}");
            //         } else {
            //           return Text("-");
            //         }
            //       },
            //     ),
            //   ),
            // ),
          ],
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
                      // int pinCode = int.tryParse(_pincodeController.text) ?? 0;

                      if (_userSelectedSize == "") {
                        ShowErrorDialog.show(
                            context: context,
                            title: 'No Size Selected',
                            message: 'Please choose a size');
                      } else {
                        bloc.add(AddToCart(
                            itemData: widget.itemData,
                            userSelectedSize: _userSelectedSize));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CartPage(database: widget.database),
                            fullscreenDialog: true));
                      }

                      //bool isPinCodeValid=await widget.database.checkPincode(pinCode);
                      // if(checkUserAns && _userSelectedSize.isNotEmpty &&  isPinCodeValid)
                      //   openCheckout(widget.itemData.details["cost"]);
                      // else if(_userSelectedSize.isEmpty){
                      //   ShowErrorDialog.show(
                      //       context: context,
                      //       title: 'Please Select Size',
                      //       message: 'Select size to proceed');
                      // }else if(! isPinCodeValid) {
                      //       await _checkPincode();
                      // }else{
                      //   Navigator.push(context,MaterialPageRoute(builder: (context) => Userform(database: widget.database),));
                      // }
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
                            color: metColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: InkWell(
                    onTap: () {
                      if (_userSelectedSize == "") {
                        ShowErrorDialog.show(
                            context: context,
                            title: 'No Size Selected',
                            message: 'Please choose a size');
                      } else {
                        bloc.add(AddToCart(
                            itemData: widget.itemData,
                            userSelectedSize: _userSelectedSize));
                        Navigator.of(context).pop();
                        ShowErrorDialog.show(
                            context: context,
                            title: 'Item Added to Cart',
                            message: 'Visit cart to checkout after shopping');
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
                    color: _showAddedToFavorites
                        ? Colors.white
                        : Colors.transparent,
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
    final bloc = BlocProvider.of<EComBloc>(context);
    return [
      SizedBox(
        child: CustomCarousel(
          path:
              "NOT NEEDED see TODO , inserted due to required", //TODO: make path obsolete change from home-screen improve performance
          customHeight: pH(231),
          fit: BoxFit.fitHeight,
          dotColor: metColor,
          listOfURL: widget.itemData.details["urlList"],
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(22, 18, 22, 5),
              height: pH(83),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 240,
                    child: Text(
                      widget.itemData.details['name'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: InkWell(
                      onTap: () {
                        if (_isWishList == true) {
                          widget.database.deleteWishlistItem(widget.itemData);
                          setState(() {
                            _isWishList = false;
                          });
                        } else if (_isWishList == false) {
                          bloc.add(AddToWishlist(itemData: widget.itemData));
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
                        _isWishList
                            ? MyFlutterApp.heart
                            : MyFlutterApp.outline_heart,
                        color: metColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "₹${widget.itemData.details["cost"]}",
                        style: TextStyle(fontSize: 30, color: metColor),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "₹${widget.itemData.details["mrp"]}",
                        style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFFA7A7A7)),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "(${widget.itemData.details["addInfo"]})",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFA7A7A7),
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
                            color: widget.itemData.details["size"][index] ==
                                    _userSelectedSize
                                ? petColor
                                : Colors.white,
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: OutlineButton(
                              textColor: widget.itemData.details["size"]
                                          [index] ==
                                      _userSelectedSize
                                  ? Colors.white
                                  : petColor,
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
                                  _userSelectedSize =
                                      widget.itemData.details["size"][index];
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
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
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
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: petColor)),
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
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Ingredients: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: '${widget.itemData.details["ingredients"]}')
                    ]),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 13, 22, 13),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Product Description:',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pdDropdown = _pdDropdown == false ? true : false;
                          });
                        },
                        child: Icon(
                            _pdDropdown == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            size: 25),
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
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFA7A7A7), width: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Guaranteed Analysis:',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _gaDropdown = _gaDropdown == false ? true : false;
                          });
                        },
                        child: Icon(
                            _gaDropdown == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            size: 25),
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
