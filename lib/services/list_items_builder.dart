import 'package:flutter/material.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  ListItemBuilder({@required this.snapshot, @required this.itemBuilder,this.showDivider=true,this.neverScrollable=false});

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final bool showDivider,neverScrollable;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        if(neverScrollable)
          {
            return _buildNeverScrollableList(items);
          }
        else
          {
            return _buildList(items);
          }
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      print("dsfsdfsdfsdfsdfs");
      print(snapshot.error);
      return EmptyContent(
        title: 'Error : something went wrong',
        message: 'Could not load items right now',
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context , index) => Divider(height: 0.5, color:showDivider ? Colors.grey : Colors.transparent,),
      itemBuilder: (context, index) {
        if(index == 0 || index == items.length + 1)
          {
            return Container(height: 0.1,);
          }
        else
        {
          return itemBuilder(context, items[index-1]);}
      },
    );
  }

  Widget _buildNeverScrollableList(List<T> items) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items.length + 2,
      separatorBuilder: (context , index) => Divider(height: 0.5, color:showDivider ? Colors.grey : Colors.transparent,),
      itemBuilder: (context, index) {
        if(index == 0 || index == items.length + 1)
        {
          return Container(height: 0.1,);
        }
        else
        {
          return itemBuilder(context, items[index-1]);}
      },
    );
  }
}
