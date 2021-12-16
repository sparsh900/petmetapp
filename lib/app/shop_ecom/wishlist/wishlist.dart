import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

import '../ui_widgets/eComListCardShop.dart';


class Wishlist extends StatefulWidget {
  Wishlist({@required this.database});
  final Database database;
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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
                  icon:
                  new Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  "YOUR WISHLIST",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowGlow();
                      return false;
                    },
                    child: Expanded(
                      child: StreamBuilder(
                        stream: widget.database.wishlistStream(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            if(snapshot.data.length!=0)
                            return GridView.builder(
                                gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                itemCount:  snapshot.data.length,
                                itemBuilder: (context, index) => EComListCard(itemData: snapshot.data[index],database: widget.database),
                                );

                            return EmptyContent(
                              title: "Wishlist Empty",
                              message: "Add items to wishlist to show",
                            );
                          }else{
                            return Center(child: CircularProgressIndicator());
                          }
                        },

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
