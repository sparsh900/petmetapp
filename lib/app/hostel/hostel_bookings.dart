import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/hostelBooking.dart';
import 'package:petmet_app/services/database.dart';

import '../../main.dart';

class HostelBookings extends StatefulWidget {
  const HostelBookings({Key key, this.database}) : super(key: key);
  final Database database;

  @override
  _HostelBookingsState createState() => _HostelBookingsState();
}

class _HostelBookingsState extends State<HostelBookings> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: petColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "MY SUBSCRIPTIONS",
            style: TextStyle(
              fontSize: pH(24),
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<HostelBooking>>(
        stream: widget.database.hostelBookingsStream(), // define stream coming from database , make sure it's type is List<SlotModel>
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: pH(10), horizontal: pW(11)),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration:
                            BoxDecoration(color: Color((0xFFFFFFFF)), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    snapshot.data[index].hostelName.toUpperCase(),
                                    style: TextStyle(
                                        color: Color(0xFFFF5352),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pH(22),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Roboto",
                                        wordSpacing: 1.2),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    " ₹ ${snapshot.data[index].cost}",
                                    //textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w400,
                                      fontSize: pH(23),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(pW(22),pH(8),0,pH(8)),
                                    child: Text(
                                      "PICKUP :",
                                      //textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFFFF5352),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Roboto",
                                      ),
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0,pH(8), pW(22),pH(8)),
                                    child: Text(
                                      "${snapshot.data[index].pickupDate} at ${snapshot.data[index].pickupTime}",
                                      //textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF36A9CC),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Roboto",
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(pW(22),pH(8),0,pH(8)),
                                    child: Text(
                                      "RETURN :",
                                      //textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFFFF5352),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Roboto",
                                      ),
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0,pH(8), pW(22),pH(8)),
                                    child: Text(
                                      "${snapshot.data[index].returnDate} at ${snapshot.data[index].returnTime}",
                                      //textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF36A9CC),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Roboto",
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    child: Center(child: CircularProgressIndicator()),
                  );
          } else {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
