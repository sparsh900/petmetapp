import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/trainerSubscription.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import '../../main.dart';

class ShowTrainerSubscriptions extends StatefulWidget {
  const ShowTrainerSubscriptions({Key key, this.database}) : super(key: key);
  final Database database;

  @override
  _ShowTrainerSubscriptionsState createState() => _ShowTrainerSubscriptionsState();
}

class _ShowTrainerSubscriptionsState extends State<ShowTrainerSubscriptions> {
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
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<TrainerSubscription>>(
        stream: widget.database.trainerSubscriptionStream(), // define stream coming from database , make sure it's type is List<SlotModel>
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      int timeLeft = getDaysDifference(snapshot.data[index].durationInMonths,snapshot.data[index].id);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: pH(10), horizontal: pW(11)),
                        child: Container(
                          decoration:
                              BoxDecoration(color: Color((0xFFFFFFFF)), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey, width: 1)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB( 0,pH(19), 0, pH(16)),
                                    child: Text(
                                      snapshot.data[index].packageName.toString().toUpperCase(),
                                      style: TextStyle(
                                          color: Color(0xFFFF5352),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(22),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                          wordSpacing: 1.2),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, pH(19), pW(15), 0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              " ₹ ${snapshot.data[index].cost}",
                                              //textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF36A9CC),
                                                fontWeight: FontWeight.w400,
                                                fontSize: pH(23),
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Montserrat",
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _buildBulletPoints(snapshot.data[index].description),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(pW(22),pH(8),0,pH(8)),
                                      child: Text(
                                        timeLeft>=0?"EXPIRES IN $timeLeft DAYS":"EXPIRED",
                                        //textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xFFFF5352),
                                          fontWeight: FontWeight.w400,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0,pH(8), pW(22),pH(8)),
                                      child: Text(
                                        "${snapshot.data[index].mode.split("Charges")[0].toUpperCase()}",
                                        //textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xFFFF5352),
                                          fontWeight: FontWeight.w400,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    child: Center(child:EmptyContent(message: "Buy trainer packages to get started ")),
                  );
          } else {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Center(child: CircularProgressIndicator() ),
            );
          }
        },
      ),
    );
  }

  int getDaysDifference(int months,String isoDate){
    String dateStringNew = isoDate.substring(0, 10) + ' ' + isoDate.substring(11);
    DateTime date = DateTime.parse(dateStringNew);
    final date2 = DateTime.now();
    final difference = date2.difference(date);
    return months*30 - difference.inDays;
  }

  List<Widget> _buildBulletPoints(String facilities) {
    List<String> bulletsInfo = facilities.split(".");
    return bulletsInfo
        .map((e) => e != ""
            ? Padding(
                padding: EdgeInsetsDirectional.fromSTEB(pW(22), 0, 0, pH(8)),
                child: Text(
                  "•   $e",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontSize: pH(17),
                    fontStyle: FontStyle.normal,
                    fontFamily: "Montserrat",
                  ),
                ),
              )
            : Container(height: 0))
        .toList();
  }
}
