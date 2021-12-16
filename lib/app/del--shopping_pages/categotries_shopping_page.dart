import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/app/home/tester.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:petmet_app/common_widgets/custom_carousel.dart';
import 'package:petmet_app/common_widgets/product_block.dart';
import 'package:petmet_app/app/home/models/pet.dart';

class Category_Shop_page extends StatefulWidget {
  Category_Shop_page({@required this.user});
  final User user;
  @override
  _Category_Shop_pageState createState() => _Category_Shop_pageState();
}

class _Category_Shop_pageState extends State<Category_Shop_page> {
  int _value = 0;

  Widget _firstItem = DropdownMenuItem(
    value: 0,
    child: Text('Hi ', style: TextStyle(fontSize: 20, color: Colors.white)),
    onTap: () {},
  );

  Future<String> _getImageUrl(String petName) async {
    String url = await FirebaseStorage.instance
        .ref()
        .child('petImages/${widget.user.uid + petName}')
        .getDownloadURL();
    return url;
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final _userInput = await showPlatformDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PlatformAlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to Logout?'),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          PlatformDialogAction(
            child: PlatformText('Logout'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (_userInput == true) {
      _signOut(context);
    }
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  navigateToPage(BuildContext context, String page) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }
  //final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    print('userHome -- ${widget.user.uid}');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(pH(54.0)), // here the desired height
            child: AppBar(
              backgroundColor: Color(0xFFF1F1F1),
              elevation: 0,
              iconTheme: IconThemeData(
                color: Color(0xFF343434),
              ),
              centerTitle: true,
              title: Image.asset(
                'images/petmet-logo.png',
                width: pW(130),
                height: pH(33),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.sort,
                  size: 28,
                ),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                  child: InkWell(
                    onTap: () {},
                    child: Icon(Icons.search),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
                  child: InkWell(
                    onTap: () {},
                    child: Icon(Icons.notifications_none),
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  color: petColor,
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.white),
                    title: Text(
                      widget.user.email,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Map Tester",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(Icons.map),
                  onTap: () /*=> /*navigateToPage(context, 'MyMap')*/MyMap()*/ {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) {
//                        return MyMap();
                          return Tester();
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Item 2",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => _confirmSignOut(context),
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: petColor,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        spreadRadius: 2,
                        color: Colors.grey[400]),
                  ],
                ),
                child: _buildContent(context),
              ),
//            SizedBox(height: 50.0),
//          Carousel
              SizedBox(
                child: CustomCarousel(path: "homepage/carousel"),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          pW(12), pH(24), pW(12), pH(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFB5B5B5), width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(4), 0, pH(4)),
                                  child: Text(
                                    "PET FOOD",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pW(20),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                                /*leading: Icon(
                                        Icons.face,
                                        size: 36.0,
                                      ),*/
                              ),
                              children: <Widget>[
                                Wrap(
                                  spacing: pW(15),
                                  runSpacing: pH(25),
                                  children: [
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(15), 0, 0),
                                  width: pW(350),
                                  child: RaisedButton(
                                    color: Color(0xFF36A9CC),
                                    child: Text(
                                      "Veiw All",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pW(16),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ),
                                )
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFB5B5B5), width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(4), 0, pH(4)),
                                  child: Text(
                                    "HARNESS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pW(20),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                                /*leading: Icon(
                                        Icons.face,
                                        size: 36.0,
                                      ),*/
                              ),
                              children: <Widget>[
                                Wrap(
                                  spacing: pW(15),
                                  runSpacing: pH(25),
                                  children: [
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(15), 0, 0),
                                  width: pW(350),
                                  child: RaisedButton(
                                    color: Color(0xFF36A9CC),
                                    child: Text(
                                      "Veiw All",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pW(16),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ),
                                )
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFB5B5B5), width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(4), 0, pH(4)),
                                  child: Text(
                                    "TOYS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pW(20),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                                /*leading: Icon(
                                        Icons.face,
                                        size: 36.0,
                                      ),*/
                              ),
                              children: <Widget>[
                                Wrap(
                                  spacing: pW(15),
                                  runSpacing: pH(25),
                                  children: [
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(15), 0, 0),
                                  width: pW(350),
                                  child: RaisedButton(
                                    color: Color(0xFF36A9CC),
                                    child: Text(
                                      "Veiw All",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pW(16),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ),
                                )
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFB5B5B5), width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(4), 0, pH(4)),
                                  child: Text(
                                    "PET FOOD",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pW(20),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                                /*leading: Icon(
                                        Icons.face,
                                        size: 36.0,
                                      ),*/
                              ),
                              children: <Widget>[
                                Wrap(
                                  spacing: pW(15),
                                  runSpacing: pH(25),
                                  children: [
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                    ProductBlock(),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(15), 0, 0),
                                  width: pW(350),
                                  child: RaisedButton(
                                    color: Color(0xFF36A9CC),
                                    child: Text(
                                      "Veiw All",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pW(16),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Pet>>(
      stream: database.petsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pets = snapshot.data;
          if (pets.isNotEmpty) {
            final children = pets
                .map(
                  (pet) => DropdownMenuItem(
                    value: pets.indexOf(pet),
                    child: _buildTile(pet),
                    onTap: () {},
                  ),
                )
                .toList();
            return DropdownButton(
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 40, color: Colors.white),
              itemHeight: 85,
              dropdownColor: petColor,
              isExpanded: true,
              value: _value,
              items: children +
                  [
                    DropdownMenuItem(
                      value: pets.length,
                      child: _buildAddTile(),
                      onTap: () {},
                    ),
                  ],
              onChanged: (value) {
                setState(() {
                  if (value == pets.length) {
                    Petform.show(context, uid: widget.user.uid);
                  } else {
                    _value = value;
                  }
                });
              },
            );
          } else {
            return GestureDetector(
              onTap: () => Petform.show(context, uid: widget.user.uid),
              child: _buildAddTile(),
            );
          }
        } else if (snapshot.hasError) {
          return Center(child: Text('some error occured'));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildTile(Pet pet) {
    NetworkImage _petImage = pet.image == null ? null : NetworkImage(pet.image);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            image: _petImage == null
                ? null
                : DecorationImage(image: _petImage, fit: BoxFit.fitWidth),
          ),
          child: _petImage == null
              ? Icon(
                  Icons.pets,
                  color: Colors.brown,
                  size: 40,
                )
              : Container(),
        ),
        SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pet.name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Age: ${pet.age}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            Text(
              'Type: ${pet.category}(${pet.breed})',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 0.2)),
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
        SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a Pet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
