import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/shop_ecom/item_page/item_page.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/services/database.dart';

class PreviousOrders extends StatefulWidget {
  PreviousOrders({@required this.database});
  final Database database;
  @override
  _PreviousOrdersState createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    String dateStringNew =
        dateString.substring(0, 10) + ' ' + dateString.substring(11);
    DateTime date = DateTime.parse(dateStringNew);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  OverlayEntry _overlayEntry;
  @override
  void initState() {
    super.initState();
    createOverlay();
  }

  void createOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
          color: Colors.black.withOpacity(0.75),
          child: Center(child: CircularProgressIndicator())),
      opaque: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Previous Orders"),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: widget.database.prevOrderStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.length != 0) {
                  return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, i) {
                        if (snapshot.data[i]["data"]["products"] != null) {
                          return Divider(
                            color: Colors.grey[400],
                            indent: 19,
                            endIndent: 19,
                          );
                        } else {
                          return Container(width: 0, height: 0);
                        }
                      },
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, i) {
                        List items = snapshot.data[i]["data"]["products"];
                        return Column(children: [
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length,
                            separatorBuilder: (context, index) {
                              if (items[index] != null) {
                                return Divider(
                                  color: Colors.grey[400],
                                  indent: 19,
                                  endIndent: 19,
                                );
                              } else {
                                return Container(width: 0, height: 0);
                              }
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () async {
                                    Overlay.of(context).insert(_overlayEntry);
                                    DocumentSnapshot dd = await widget.database
                                        .getItemsData(
                                            snapshot.data[i]["data"]["products"]
                                                [index]["category"],
                                            snapshot.data[i]["data"]["products"]
                                                [index]["productId"])
                                        .then((value) {
                                      _overlayEntry.remove();
                                      return value;
                                    });
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ShowItemPage(
                                        database: widget.database,
                                        itemData: Item.fromMap(
                                            dd.data, dd.documentID),
                                      ),
                                    ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        pW(29), pH(16), pW(27), pH(7)),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              height: pH(81),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: new DecorationImage(
                                                  image: NetworkImage(
                                                    "${snapshot.data[i]["data"]["products"][index]["productImageLink"]}" ??
                                                        "https://cdn1.vectorstock.com/i/1000x1000/46/10/icon-for-veterinary-services-vector-6704610.jpg",
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(pW(10), 0, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 0, pH(4)),
                                                    child: Text(
                                                      "${snapshot.data[i]["data"]["products"][index]["itemName"]}",
                                                      //items.length==1?"${snapshot.data[index].allItems[0]["itemName"]}":"${snapshot.data[index].allItems[0]["itemName"]} & ${items.length} more",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF2B3B47),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: pH(21),
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontFamily: "Montserrat",
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(4)),
                                                  //   child: Text(
                                                  //     "${snapshot.data[i]["data"]["paymentVerified"] ? "Paid" : "Not Paid/Cancelled"}",
                                                  //     //items.length==1?"${snapshot.data[index].allItems[0]["itemName"]}":"${snapshot.data[index].allItems[0]["itemName"]} & ${items.length} more",
                                                  //     overflow: TextOverflow.ellipsis,
                                                  //     style: TextStyle(
                                                  //       color: snapshot.data[i]["data"]["paymentVerified"] ? Color(0xFF03A300) : Colors.red,
                                                  //       fontWeight: FontWeight.w500,
                                                  //       fontSize: pH(21),
                                                  //       fontStyle: FontStyle.normal,
                                                  //       fontFamily: "Montserrat",
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 0, pH(4)),
                                                    child: Text(
                                                      "${snapshot.data[i]["data"]["deliveryStatus"]}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: snapshot.data[i]
                                                                    ["data"][
                                                                "paymentVerified"]
                                                            ? Color(0xFF03A300)
                                                            : Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: pH(18),
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontFamily: "Montserrat",
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 0, pH(4)),
                                                    child: Text(
                                                      " ₹${snapshot.data[i]["data"]["products"][index]["cost"]} * ${snapshot.data[i]["data"]["products"][index]["units"]}",
                                                      //items.length==1?"${snapshot.data[index].allItems[0]["itemName"]}":"${snapshot.data[index].allItems[0]["itemName"]} & ${items.length} more",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: pH(21),
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontFamily: "Montserrat",
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 0),
                                                      child: Text(
                                                        timeAgoSinceDate(DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    snapshot.data[i]["data"]["paymentDetails"]
                                                                            [
                                                                            "created_at"] *
                                                                        1000)
                                                            .toIso8601String()),
                                                        //items.length==1?"${snapshot.data[index].allItems[0]["itemName"]}":"${snapshot.data[index].allItems[0]["itemName"]} & ${items.length} more",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF757575),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: pH(12),
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontFamily: "Montserrat",
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ]);
                      });
                } else if (snapshot.hasData && snapshot.data.length == 0) {
                  return ConstrainedBox(
                    //Use MediaQuery.of(context).size.height for max Height
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    child: Center(
                      child: EmptyContent(
                        message: "no orders placed yet",
                        title: "No Orders",
                      ), //Widget,
                    ),
                  );
                } else {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
        ));
  }
}
