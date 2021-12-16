import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/del--ecom/blocs/eCom_bloc.dart';
import 'package:petmet_app/app/del--ecom/eComListPage.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

class ShopHomeButton extends StatelessWidget {
  const ShopHomeButton({
    Key key,this.color,this.text='View All',@required this.category
  }) : super(key: key);
  final String category;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    double pH(double height) {
      return MediaQuery.of(context).size.height * (height / 896);
    }

    double pW(double width) {
      return MediaQuery.of(context).size.width * (width / 414);
    }

    final bloc = BlocProvider.of<EComBloc>(context);
    final Database database = Provider.of<Database>(context, listen: false);
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
      width: pW(350),
      child: RaisedButton(
        color: color??Color(0xFF36A9CC),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
            fontSize: pW(16),
            fontStyle: FontStyle.normal,
            fontFamily: "Montserrat",
          ),
        ),
        onPressed: () {
          bloc.add(GetStream(category: "$category"));
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
              value: bloc,
              child: EComListPage(database: database),
            );
          }
              // builder: (context)=>EComListPage(),
              ));
        },
      ),
    );
  }
}
