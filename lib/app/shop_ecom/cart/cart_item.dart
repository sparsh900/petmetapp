import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/cartNumberNotifier.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/shop_ecom/item_page/item_page.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  CartItem({@required this.item,@required this.database});
  final Item item;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        CartNumber myCartNumber = Provider.of<CartNumber>(context, listen: false);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<CartNumber>.value(
                value: myCartNumber,
                child: ShowItemPage(itemData: item, database: database),
              )),
        );
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => ShowItemPage(database:database,itemData:item))
        // );
      },
      child: Container(
        height: 125,
        padding: EdgeInsets.fromLTRB(16, 15, 12, 26),
        child: Row(
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                color: Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item.details['url']),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250.0,
                    child: Text(
                      item.details['name']+' '+'('+(item.userSelectedSize??'error')+')',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\u20b9${item.details['cost']}  ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '\u20b9${item.details['mrp']}',
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFFA7A7A7)),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: _decreaseItemQuantity,
                        child: Container(
                          height: 22.0,
                          width: 22.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFC4C4C4)),
                          ),
                          child:Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: petColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 22.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFEBFAFF),
                          border: Border.symmetric(vertical:BorderSide(color: Color(0xFFC4C4C4))),
                        ),
                        child: Center(
                          child: Text(
                            '${item.userSelectedQuantity}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _increaseItemQuantity,
                        child: Container(
                          height: 22.0,
                          width: 22.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFC4C4C4)),
                          ),
                          child: Icon(Icons.add, color: petColor, size: 15.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _increaseItemQuantity() async {
    int quantity=item.userSelectedQuantity+1;
    await database.updateCartItem(item, quantity);
  }

  Future<void> _decreaseItemQuantity() async {
    int quantity=item.userSelectedQuantity-1;
    if(quantity!=0)
    await database.updateCartItem(item, quantity);
    else
    await database.deleteCartItem(item);
  }
}
