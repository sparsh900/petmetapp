import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/services/list_items_builder.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({@required this.database});
  final Database database;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
            "NOTIFICATIONS",
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
      body: _buildContent(context),
    );
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date;
    String dateStringNew;
    if (dateString.contains('+')) {
      dateStringNew =
          dateString.substring(0, 10) + ' ' + dateString.substring(11, 22);
      date = DateTime.parse(dateStringNew);
      date = date.add(Duration(hours: 5, minutes: 30));
    } else {
      dateStringNew =
          dateString.substring(0, 10) + ' ' + dateString.substring(11);
      print(dateStringNew);
      date = DateTime.parse(dateStringNew);
    }
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

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Map>>(
      stream: widget.database.notificationsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder(
            snapshot: snapshot,
            itemBuilder: (context, map) {
              return Dismissible(
                key: Key(map['id']),
                background: Container(
                  color: metColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) async {
                  await widget.database.deleteNotification(map['id']);
                },
                child: ListTile(
                  leading: Image.asset('images/icon-small.png'),
                  title: Text(map['message']),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(timeAgoSinceDate(map['id'])),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
