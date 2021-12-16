import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petmet_app/app/manageAddresses/addAddress.dart';
import 'package:petmet_app/app/shop_ecom/paymentScreens/cartPromo.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:dotted_decoration/dotted_decoration.dart';

class ManageAddress extends StatefulWidget {
  ManageAddress({@required this.database, @required this.isManageAddress,this.isVetAddress=false, this.order});
  final Database database;
  final bool isManageAddress,isVetAddress;
  final Map<String, dynamic> order;
  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  int _radioValue = 0;
  Stream deliverAddresses;
  ValueNotifier<List> refresh = new ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    print("Hello initState");
    deliverAddresses = getDeliverAddresses();
  }

  void _handleRadioChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  bool oneTimeGiveValue = true;

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  Stream getDeliverAddresses() async* {
    DocumentSnapshot deliverAddress = await widget.database.getDeliverAddresses();
    print("Database called");
    yield deliverAddress;
  }

  void handleDelete(Map val, int index) async {
    //delete
    var list = [];
    list.add(val);
    widget.database.operationsForAParticularFieldInUserDocument({'secondaryAddresses': FieldValue.arrayRemove(list)});
    //updating the display list
    refresh.value = List.from(refresh.value)..removeAt(index);
  }

  void _handleEdit(Map<String, dynamic> obj, index) async {
    //Navigating and returning
    Map<String, dynamic> editedAddress =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAddress(database: widget.database, editAddress: obj)));
    if (editedAddress == null) {
      return;
    }
    //delete
    var list = [];
    list.add(obj);
    await widget.database.operationsForAParticularFieldInUserDocument({'secondaryAddresses': FieldValue.arrayRemove(list)});
    //add
    list.remove(obj);
    list.add(editedAddress);
    await widget.database.operationsForAParticularFieldInUserDocument({'secondaryAddresses': FieldValue.arrayUnion(list)});
    //updating the display list
    refresh.value = List.from(refresh.value)..removeAt(index);
    refresh.value = List.from(refresh.value)..insert(index, editedAddress);
  }

  void _handleAdd() async {
    //Navigating and returning
    Map<String, dynamic> editedAddress = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAddress(database: widget.database)));
    if (editedAddress == null) {
      return;
    }
    //adding to database
    var list = [];
    list.add(editedAddress);
    await widget.database.operationsForAParticularFieldInUserDocument({'secondaryAddresses': FieldValue.arrayUnion(list)});
    //updating front end
    refresh.value = List.from(refresh.value)..add(editedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(57.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "ADDRESS",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: pH(10),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: StreamBuilder(
                stream: deliverAddresses,
                builder: (context, snapshot) {
                  print("Stream start");
                  if (snapshot.hasData && snapshot.data['secondaryAddresses'] != null) {
                    if (oneTimeGiveValue) {
                      refresh.value = snapshot.data['secondaryAddresses'];
                      oneTimeGiveValue = !oneTimeGiveValue;
                    }

                    return ValueListenableBuilder(
                      valueListenable: refresh,
                      builder: (context, value, child) => NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll) {
                          overScroll.disallowGlow();
                          return true;
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.length,
                          itemBuilder: (context, index) => Card(
                            shadowColor: Colors.grey,
                            margin: EdgeInsets.symmetric(vertical: pH(9), horizontal: pW(18.37)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              // EdgeInsets.fromLTRB(pW(22), pH(23), pH(18), pH(14)),
                              child: Column(
                                children: [
                                  RadioListTile(
                                    activeColor: Color(0xFF36A9CC),
                                    value: index,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioChange,
                                    title: Text(
                                      value[index]['name'],
                                      style: TextStyle(fontSize: pH(23), color: Colors.black, fontWeight: FontWeight.w400),
                                    ),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      SizedBox(
                                        height: pH(7),
                                      ),
                                      Text(
                                        // "$index",
                                        value[index]["address"],
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: pH(18), color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: pH(7)),
                                      Text(
                                        // "$index",
                                        value[index]["zip"].toString(),
                                        style: TextStyle(fontSize: pH(21), color: Colors.black, fontWeight: FontWeight.w400),
                                      ),
                                    ]),
                                    isThreeLine: true,
                                  ),
                                  snapshot.data['address'] == value[index]["address"] && value[index]["name"] == (snapshot.data["firstName"]+' '+snapshot.data["lastName"]) && value[index]["zip"] == snapshot.data["zip"]
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Original Account  Address",
                                            style: TextStyle(fontSize: pH(18), color: Color(0xFF36A9CC), fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        width: pW(10),
                                        height: pH(10),
                                      ),
                                    ],
                                  )
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              side: BorderSide(
                                                color: Colors.black54,
                                              )),
                                          onPressed: () => handleDelete(value[index], index),
                                          child: Text("Remove")),
                                      SizedBox(
                                        width: pW(10),
                                      ),
                                      FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              side: BorderSide(
                                                color: Colors.black54,
                                              )),
                                          onPressed: () async => _handleEdit(value[index], index),
                                          child: Text("Edit")),
                                      SizedBox(
                                        width: pW(10),
                                        height: pH(10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                }),
          ),
          SizedBox(
            width: pW(378),
            child: InkWell(
              onTap: _handleAdd,
              child: Container(
                margin: EdgeInsets.only(top: pH(10)),
                decoration: DottedDecoration(shape: Shape.box),
                padding: EdgeInsets.symmetric(horizontal: pW(20), vertical: pH(10)),
                child: Text(
                  "+  Add  New  Address",
                  style: TextStyle(fontSize: pH(18), color: Color(0xFF36A9CC), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: widget.isManageAddress ? pH(20) : pH(70),
          )
        ],
      ),
      bottomSheet: widget.isManageAddress
          ? (widget.isVetAddress?InkWell(
          onTap: () async => {
            if (refresh.value.toList().isNotEmpty && refresh.value.toList()[_radioValue]["zip"] != null)
              {
                if (await widget.database.checkPincode(int.parse(refresh.value.toList()[_radioValue]["zip"])))
                  {
                    Navigator.of(context).pop(refresh.value.toList()[_radioValue])
                  }
                else
                  {
                    ShowErrorDialog.show(context: context, title: "Pincode not available", message: "We'll be expanding to new cities soon."),
                  }
              }
            else
              {
                ShowErrorDialog.show(context: context, title: "Add/Select Address", message: "Please select address to get your items delivered."),
              }
          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(pW(20), pH(28), pW(20), pH(18)),
              child: Container(
                height: pH(55),
                padding: EdgeInsets.all(pH(14)),
                decoration: BoxDecoration(
                    color: Color(0xFF36A9CC),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Text(
                  "Proceed to Payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: pH(23), color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
          )

          :Container(height: 0,))
      // ValueListenableBuilder(
      //       valueListenable: ,
      //       child: InkWell(
      //           onTap: () async => {
      //                 if (refresh.value.toList().isNotEmpty && refresh.value.toList()[_radioValue]["zip"] != null)
      //                   {
      //                     if (await widget.database.checkPincode(int.parse(refresh.value.toList()[_radioValue]["zip"])))
      //                       {
      //                         // Logic to Set Primary Address
      //                       }
      //                     else
      //                       {
      //                         ShowErrorDialog.show(context: context, title: "Pincode not available", message: "We'll be expanding to new cities soon."),
      //                       }
      //                   }
      //                 else
      //                   {
      //                     ShowErrorDialog.show(context: context, title: "Add/Select Address", message: "Please select address to get your items delivered."),
      //                   }
      //               },
      //           child: SizedBox(
      //             width: double.infinity,
      //             child: Container(
      //               height: pH(55),
      //               padding: EdgeInsets.all(pH(14)),
      //               color: petColor,
      //               child: Text(
      //                 'Set Primary Address'.toUpperCase(),
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(fontSize: pH(23), color: Colors.white),
      //               ),
      //             ),
      //           )),
      //     )
          : InkWell(
              onTap: () async => {
                    if (refresh.value.toList().isNotEmpty && refresh.value.toList()[_radioValue]["zip"] != null)
                      {
                        if (await widget.database.checkPincode(int.parse(refresh.value.toList()[_radioValue]["zip"])))
                          {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CartWithPromo(
                                      database: widget.database,
                                      order: widget.order,
                                      addressAndDetails: refresh.value.toList()[_radioValue],
                                    )))
                          }
                        else
                          {
                            ShowErrorDialog.show(context: context, title: "Pincode not available", message: "We'll be expanding to new cities soon."),
                          }
                      }
                    else
                      {
                        ShowErrorDialog.show(context: context, title: "Add/Select Address", message: "Please select address to get your items delivered."),
                      }
                  },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(pW(20), pH(28), pW(20), pH(18)),
              child: Container(
                height: pH(55),
                padding: EdgeInsets.all(pH(14)),
                decoration: BoxDecoration(
                    color: Color(0xFF36A9CC),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Text(
                  "Proceed to Payement",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: pH(23), color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
              ),
    );
  }
}
