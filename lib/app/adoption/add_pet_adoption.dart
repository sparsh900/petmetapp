import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/app/adoption/adoption_input_location.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/common_widgets/custom_image_picker.dart';
import 'package:petmet_app/app/home/models/adoption.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class AdoptionForm extends StatefulWidget {
  AdoptionForm({@required this.database, this.adoptPet, @required this.uid});

  final Database database;
  final AdoptPet adoptPet;
  final String uid;

  @override
  _AdoptionFormState createState() => _AdoptionFormState();
}

class _AdoptionFormState extends State<AdoptionForm> {

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  final _formKey = GlobalKey<FormState>();

  String _color;
  String _name;
  String _category;
  String _breed;
  double _age;
  String _gender;
  double _weight;
  List<File> _image = new List(3);
  List<String> _imageUrl = new List(3);
  String _description;
  Map<dynamic, dynamic> _locationData;

  String dropDownValue1;
  String dropDownValue2;

  List<String> categoryList = [
    'DOG',
    'CAT',
    'BIRD',
  ];

  List<String> genderList = [
    'MALE',
    'FEMALE',
    'OTHERS',
  ];

  bool _isLoading = false;

  final FocusNode _myFocusNode1 = FocusNode();
  final FocusNode _myFocusNode2 = FocusNode();
  final FocusNode _myFocusNode3 = FocusNode();
  final FocusNode _myFocusNode4 = FocusNode();
  final FocusNode _myFocusNode5 = FocusNode();
  final FocusNode _myFocusNode6 = FocusNode();
  final FocusNode _myFocusNode7 = FocusNode();

  int dropDown1;
  int dropDown2;

  Widget _decideProfilePhoto(int imageNo) {
    if (_image[imageNo] == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, pH(8), 0, 0),
            child: Icon(
              Icons.camera_enhance,
              color: Color(0xFF252A62),
              size: pH(20),
            ),
          ),
          Padding(
            padding:
                EdgeInsetsDirectional.fromSTEB(pW(10), pH(4), pW(10), pH(2)),
            child: Text(
              "Add Your Pet's Photo",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2F2E41),
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontFamily: "Montserrat",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(12), 0, pW(12), pH(4)),
            child: Text(
              "${imageNo+1}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2F2E41),
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontFamily: "Montserrat",
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Future<void> _setPhoto(int imageNo) async {
    _image[imageNo] = await CustomImagePicker.show(context);
    setState(() {

    });
  }

  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _myFocusNode1.dispose();
    _myFocusNode2.dispose();
    _myFocusNode3.dispose();
    _myFocusNode4.dispose();
    _myFocusNode5.dispose();
    _myFocusNode6.dispose();
    _myFocusNode7.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(70.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "PET DETAILS",
            style: TextStyle(
              fontSize: pH(24),
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent()
  {
    if(_isLoading==false)
    {
      return SingleChildScrollView(
        reverse: false,
        physics: ScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
            EdgeInsetsDirectional.fromSTEB(pW(18), pH(26), pW(18), pH(60)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  EdgeInsetsDirectional.fromSTEB(pW(57), 0, pW(57), pH(18)),
                  child: Text(
                    "Enter details of the pet you want to put for adoption",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontSize: pH(20),
                      fontStyle: FontStyle.normal,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, pH(24)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(0, 0, pW(12), 0),
                        child: InkWell(
                          onTap: () => _setPhoto(0),
                          child: Container(
                            height: pH(102),
                            width: pW(98),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFF4F3F3),
                              image: _image[0] == null
                                  ? null
                                  : DecorationImage(
                                image: FileImage(_image[0]),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: _decideProfilePhoto(0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(0, 0, pW(12), 0),
                        child: InkWell(
                          onTap: () => _setPhoto(1),
                          child: Container(
                            height: pH(102),
                            width: pW(98),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFF4F3F3),
                              image: _image[1] == null
                                  ? null
                                  : DecorationImage(
                                image: FileImage(_image[1]),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: _decideProfilePhoto(1),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(0, 0, pW(12), 0),
                        child: InkWell(
                          onTap: () => _setPhoto(2),
                          child: Container(
                            height: pH(102),
                            width: pW(98),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFF4F3F3),
                              image: _image[2] == null
                                  ? null
                                  : DecorationImage(
                                image: FileImage(_image[2]),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: _decideProfilePhoto(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: pH(10)),
                Container(
                  color: Colors.grey[200],
                  height: pH(40),
                  padding: EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(
                          Icons.location_on,
                          color: petColor,
                          size: 26,
                        ),
                        Text(
                            _locationData == null
                                ? "Add Pet's Location"
                                : _locationData['address'].toString().substring(
                                0,
                                _locationData['address'].toString().indexOf(
                                    ',')),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ]),
                      Container(
                        margin: EdgeInsets.all(4),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: Border.all(color: petColor),
                        ),
                        child: RaisedButton(
                            color: Colors.white,
                            child: Text(
                              "Change",
                              style: TextStyle(color: petColor, fontSize: 14),
                            ),
                            onPressed: () {
                              navigateAndDisplay(context);
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(10), 0, pH(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 15.0,
                              offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(6)),
                    child: DropdownButtonFormField(
                      focusNode: _myFocusNode1,
                      value: dropDownValue1,
                      onSaved: (Value) => _category = Value,
                      onChanged: (String Value) {
                        setState(() {
                          dropDownValue1 = Value;
                        });
                      },
                      items: categoryList
                          .map((categoryTitle) =>
                          DropdownMenuItem(
                              value: categoryTitle,
                              child: Text("$categoryTitle")))
                          .toList(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFF36A9CC),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            pW(13), pH(15), pW(12), pH(10)),
                        counterStyle:
                        TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
                        labelText: 'Choose Category',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 15.0,
                              offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      focusNode: _myFocusNode7,
                      onSaved: (Value) =>
                      _name =
                          Value.substring(0, 1).toUpperCase() +
                              Value.substring(1),
                      validator: (value) =>
                      value.isNotEmpty ? null : 'Name can\'t be empty',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFF36A9CC),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            pW(13), pH(15), 0, pH(15)),
                        counterStyle:
                        TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
                        labelText: 'Pets Name',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 15.0,
                              offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      focusNode: _myFocusNode2,
                      onSaved: (Value) =>
                      _breed =
                          Value.substring(0, 1).toUpperCase() +
                              Value.substring(1),
                      validator: (value) =>
                      value.isNotEmpty ? null : 'Breed can\'t be empty',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFF36A9CC),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            pW(13), pH(15), 0, pH(15)),
                        counterStyle:
                        TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
                        labelText: 'Pets Breed',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 15.0,
                              offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      focusNode: _myFocusNode3,
                      onSaved: (Value) =>
                      _color =
                          Value.substring(0, 1).toUpperCase() +
                              Value.substring(1),
                      validator: (value) =>
                      value.isNotEmpty ? null : 'Color can\'t be empty',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFF36A9CC),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            pW(13), pH(15), 0, pH(15)),
                        counterStyle:
                        TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
                        labelText: 'Pets Color',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    blurRadius: 15.0,
                                    offset: Offset(0, 2)),
                              ],
                              borderRadius: BorderRadius.circular(6)),
                          child: TextFormField(
                            focusNode: _myFocusNode4,
                            onSaved: (Value) => _weight = double.parse(Value),
                            validator: (value) =>
                            value.isNotEmpty
                                ? null
                                : 'Weight can\'t be empty',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: Color(0xFF36A9CC),
                                  width: 3,
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  pW(13), pH(15), 0, pH(15)),
                              counterStyle: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFBDBDBD),
                              ),
                              labelText: 'Enter Weight (in Kgs)',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: pW(20),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    blurRadius: 15.0,
                                    offset: Offset(0, 2)),
                              ],
                              borderRadius: BorderRadius.circular(6)),
                          child: DropdownButtonFormField(
                            onSaved: (Value) =>
                            _gender =
                                Value.substring(0, 1).toUpperCase() +
                                    Value.substring(1),
                            value: dropDownValue2,
                            onChanged: (String Value) {
                              setState(() {
                                dropDownValue2 = Value;
                              });
                            },
                            items: genderList
                                .map((genderTitle) =>
                                DropdownMenuItem(
                                    value: genderTitle,
                                    child: Text("$genderTitle")))
                                .toList(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: Color(0xFF36A9CC),
                                  width: 3,
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  pW(13), pH(15), pW(12), pH(10)),
                              counterStyle: TextStyle(
                                  fontSize: 15, color: Color(0xFFBDBDBD)),
                              labelText: 'Choose Gender',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 15.0,
                              offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      focusNode: _myFocusNode5,
                      onSaved: (Value) => _age = double.parse(Value),
                      validator: (value) =>
                      value.isNotEmpty ? null : 'Age can\'t be empty',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFF36A9CC),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            pW(13), pH(15), 0, pH(15)),
                        counterStyle:
                        TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
                        labelText: 'Pets Age',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 15.0,
                              offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      focusNode: _myFocusNode6,
                      onSaved: (Value) =>
                      _description =
                          Value.substring(0, 1).toUpperCase() +
                              Value.substring(1),
                      validator: (value) =>
                      value.isNotEmpty ? null : 'Description can\'t be empty',
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines:
                      20,
                      // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                      //expands: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFF36A9CC),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            pW(13), pH(15), 0, pH(15)),
                        counterStyle:
                        TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
                        labelText: 'Short Description',
                      ),
                    ),
                  ),
                ),
                Container(
                  height: pH(50),
                  decoration: BoxDecoration(
                      color: Color(0xFF36A9CC),
                      borderRadius: BorderRadius.circular(pH(25))),
                  child: FlatButton(
                    padding: EdgeInsetsDirectional.fromSTEB(0, pH(11), 0, pH(12)),
                    color: Color(0xFF36A9CC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(pH(25))),
                    child: Text(
                      'SAVE & PROCEED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else
    {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
  
  //Form Bussiness Logic

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  bool validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  navigateAndDisplay(BuildContext context) async {
    final Map<String, dynamic> locationData =
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => AdoptionInputLocation(),
    ));
    print(locationData);
    if (locationData != null) {
      setState(() {
        _locationData = locationData;
      });
    }
  }

  bool validateDropDown() {
    if (_category != null) {
      if (_gender != null)
        return true;
      else {
        ShowErrorDialog.show(
            context: context, title: 'Choose Gender', message: '');
        return false;
      }
    } else {
      ShowErrorDialog.show(
          context: context, title: 'Choose Category', message: '');
      return false;
    }
  }

  Future<void> _uploadFile() async {
    StorageReference storageReference1 =
        FirebaseStorage.instance.ref().child('adoptPetImages/${widget.uid+documentIdFromCurrentDate()}1');
    StorageUploadTask uploadTask1 = storageReference1.putFile(_image[0]);
    await uploadTask1.onComplete;
    _imageUrl[0] = await storageReference1.getDownloadURL();
    StorageReference storageReference2 =
    FirebaseStorage.instance.ref().child('adoptPetImages/${widget.uid+documentIdFromCurrentDate()}2');
    StorageUploadTask uploadTask2 = storageReference2.putFile(_image[1]);
    await uploadTask2.onComplete;
    _imageUrl[1] = await storageReference2.getDownloadURL();
    StorageReference storageReference3 =
    FirebaseStorage.instance.ref().child('adoptPetImages/${widget.uid+documentIdFromCurrentDate()}3');
    StorageUploadTask uploadTask3 = storageReference3.putFile(_image[2]);
    await uploadTask3.onComplete;
    _imageUrl[2] = await storageReference3.getDownloadURL();
    print('Files Uploaded');
  }

  Future<void> _submit() async {
    if (validateAndSaveForm() && validateDropDown()) {
      try {
        setState(() {
          _isLoading = true;
        });

        if (_locationData == null) {
          ShowErrorDialog.show(
            context: context,
            title: 'No location selected',
            message: 'Please Add a location',
          );
          setState(() {
            _isLoading = false;
          });
        }
        else if(_image[0] == null || _image[1] == null || _image[2] == null)
          {
            ShowErrorDialog.show(
              context: context,
              title: 'Photos not added',
              message: 'Please Add a all photos to continue',
            );
            setState(() {
              _isLoading = false;
            });
          }
        else{
          if (_image[0] != null && _image[1] != null && _image[2] != null) {
            await _uploadFile();
          }
        }

        final id = documentIdFromCurrentDate();
        final adoptPet = AdoptPet(
          name: _name,
          category: _category,
          breed: _breed,
          age: _age,
          weight: _weight,
          id: id,
          color: _color,
          description: _description,
          gender: _gender,
          image: _imageUrl,
          locationData: _locationData,
        );
        //Console.log
        await widget.database.setAdoptPet(adoptPet);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        ShowErrorDialog.show(
            context: context,
            title: 'Adding Pet Failed',
            message: e.toString());
      }
    }
  }
}
