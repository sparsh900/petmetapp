import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/del--ecom/eComListPage.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/common_widgets/custom_raised_button.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

import 'blocs/eCom_bloc.dart';

class EComHomePage extends StatefulWidget {
  @override
  _EComHomePageState createState() => _EComHomePageState();
}

class _EComHomePageState extends State<EComHomePage> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    return BlocProvider(
      create: (BuildContext context) => EComBloc(database),
      child: Scaffold(
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
              "Shop Home",
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
                  onTap: () => Navigator.of(context,rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      fullscreenDialog: true,
                      builder: (context) => CartPage(database: database),
                    ),
                  ),
                  child: Icon(Icons.shopping_cart),
                ),
              ),
            ],
          ),
        ),
        body: BodyHome(),

      ),
    );
  }
}

class BodyHome extends StatelessWidget {
  const BodyHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc=BlocProvider.of<EComBloc>(context);
    final Database database = Provider.of<Database>(context, listen: false);
    return Center(
      child: CustomRaisedButton(
        child: Text("Show All Items"),
        onPressed: (){
          bloc.add(GetStream(category:"Food"));
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context){
                    return BlocProvider.value(
                      value: bloc,
                      child: EComListPage(database: database),
                    );
                  }
                // builder: (context)=>EComListPage(),
              )
          );
        },
      ),
    );
  }
}


