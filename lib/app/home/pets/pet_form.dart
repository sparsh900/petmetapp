import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/common_widgets/custom_image_picker.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class Petform extends StatefulWidget {
  Petform({@required this.database, this.pet, @required this.uid});
  final Database database;
  final Pet pet;
  final String uid;

  static Future<void> show(BuildContext context, {Pet pet, String uid}) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => Petform(
        database: database,
        pet: pet,
        uid: uid,
      ),
    ));
  }

  @override
  _PetformState createState() => _PetformState();
}

class _PetformState extends State<Petform> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _category;
  String _breed;
  int _age;
  double _weight;
  File _image;
  String _imageUrl;

  bool _isLoading = false;

  int dropDownCategory;
  int dropDownBreed;

  final FocusNode _myFocusNode1 = FocusNode();
  final FocusNode _myFocusNode2 = FocusNode();
  final FocusNode _myFocusNode3 = FocusNode();

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  Widget _decideProfilePhoto() {
    if (_image == null) {
      return Center(
        child: Text(
          '+',
          style: TextStyle(
              fontSize: 30,
              color: Color.fromRGBO(54, 169, 204, 1),
              fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> _setPhoto() async {
    _image = await CustomImagePicker.show(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _name = widget.pet.name;
      _weight = widget.pet.weight;
      _age = widget.pet.age;
      _category = widget.pet.category;
      _breed = widget.pet.breed;
      _imageUrl = widget.pet.image;
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _myFocusNode1.dispose();
    _myFocusNode2.dispose();
    _myFocusNode3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xE5E5E5),
            padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(72), pW(24), 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLogoBar(context),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(51), 0, 22),
                  child: Center(
                    child: Text(
                      'Set Up Your Pets Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _buildForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildLogoBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'images/petmet-appbar-logo.png',
          width: pW(171),
          height: pH(63),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border.all(
                  color: Colors.grey,
                ),
              ),
              height: pH(24.0),
              width: pW(74.0),
              child: FlatButton(
                child: Center(
                  child: Text(
                    'SKIP',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: Colors.grey[600],
              ),
            ),
            Container(
              height: pH(22.0),
              width: pW(66.0),
            )
          ],
        ),
      ],
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _setPhoto,
                  child: Container(
                    height: pH(132),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 229, 229, 1),
                      borderRadius: BorderRadius.circular(4),
                      image: (_image == null && _imageUrl != null)
                          ? DecorationImage(
                              image: NetworkImage(_imageUrl),
                              fit: BoxFit.fitWidth,
                            )
                          : (_image == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(_image),
                                  fit: BoxFit.fitWidth,
                                )),
                    ),
                    child: _decideProfilePhoto(),
                  ),
                ),
              ),
              SizedBox(width: pW(11)),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Row(children: [
                      Expanded(
                        child: Container(
                          height: pH(52),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              13, pH(5), 20, pH(5)),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 20.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6)),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            hint: Text(
                              _category ?? 'Choose Category',
                              style: TextStyle(fontSize: 15),
                            ),
                            value: dropDownCategory,
                            onChanged: (int newVal) {
                              setState(() {
                                dropDownCategory = newVal;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Dog'),
                                onTap: () {
                                  _category = 'Dog';
                                },
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Cat'),
                                onTap: () {
                                  _category = 'Cat';
                                },
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Fish'),
                                onTap: () {
                                  _category = 'Fish';
                                },
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text('Others'),
                                onTap: () {
                                  _category = 'Others';
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: pH(21)),
                    Row(children: [
                      Expanded(
                        child: Container(
                          height: pH(52),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              13, pH(5), 20, pH(5)),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 20.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6)),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            hint: Text(
                              _breed ?? 'Choose Breed',
                              style: TextStyle(fontSize: 15),
                            ),
                            value: dropDownBreed,
                            onChanged: (int newVal) {
                              setState(() {
                                dropDownBreed = newVal;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Labradog'),
                                onTap: () {
                                  _breed = 'Labradog';
                                },
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Pug'),
                                onTap: () {
                                  _breed = 'Pug';
                                },
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('German Shepherd'),
                                onTap: () {
                                  _breed = 'German Shepherd';
                                },
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text('Other'),
                                onTap: () {
                                  _breed = 'Other';
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _name,
                    onSaved: (value) => _name =
                        value.substring(0, 1).toUpperCase() +
                            value.substring(1),
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Name can\'t be empty',
                    focusNode: _myFocusNode1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      enabled: widget.pet == null ? true : false,
                      labelText: 'Enter Your Pet\'s Name',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _weight != null ? '$_weight' : null,
                    onSaved: (value) => _weight = double.parse(value),
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Weight can\'t be empty',
                    focusNode: _myFocusNode2,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode3),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Weight (in Kgs)',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _age != null ? '$_age' : null,
                    onSaved: (value) => _age = int.parse(value),
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Age can\'t be empty',
                    focusNode: _myFocusNode3,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _submit,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(54, 169, 204, 1),
                            width: 3,
                          ),
                        ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(6),
                      //   borderSide: BorderSide(
                      //     color: Color.fromRGBO(54, 169, 204, 1),
                      //     width: 3,
                      //   ),
                      // ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Age (in Years)',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(80)),
          Row(children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsetsDirectional.fromSTEB(0, pH(11), 0, pH(11)),
                color: Color.fromRGBO(54, 169, 204, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(pH(40))),
                child: Text(
                  'Proceed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: _submit,
              ),
            ),
          ]),
          SizedBox(height: pH(22)),
          Center(
            child: Image.asset(
              'images/petmet-translucent-logo.png',
              width: pW(140),
              height: pH(140),
            ),
          ),
        ],
      ),
    );
  }

  //Form Business logic

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

  bool validateDropDown() {
    if (_category != null) {
      if (_breed != null)
        return true;
      else {
        ShowErrorDialog.show(
            context: context, title: 'Choose Breed', message: '');
        return false;
      }
    } else {
      ShowErrorDialog.show(
          context: context, title: 'Choose Category', message: '');
      return false;
    }
  }

  Future<void> _uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('petImages/${widget.uid + _name}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    _imageUrl = await storageReference.getDownloadURL();
    print('File Uploaded');
  }

  Future<void> _submit() async {
    if (widget.pet == null) {
      if (validateAndSaveForm() && validateDropDown()) {
        try {
          setState(() {
            _isLoading = true;
          });
          final pets = await widget.database.petsStream().first;
          final allNames = pets.map((pet) => pet.name).toList();
          if (widget.pet != null) {
            allNames.remove(widget.pet.name);
          }
          if (allNames.contains(_name)) {
            ShowErrorDialog.show(
              context: context,
              title: 'Name Already Exists',
              message: 'Please choose a different name',
            );
            _formKey.currentState.reset();
          } else {
            if (_image != null) {
              await _uploadFile();
            }
            final id = widget.pet?.id ?? documentIdFromCurrentDate();
            final pet = Pet(
              name: _name,
              category: _category,
              breed: _breed,
              age: _age,
              weight: _weight,
              id: id,
              image: _imageUrl,
            );
            await widget.database.setPet(pet);
            Navigator.of(context).pop();
          }
        } on PlatformException catch (e) {
          ShowErrorDialog.show(
              context: context,
              title: 'Adding Pet Failed',
              message: e.toString());
        }
      }
    } else {
      if (validateAndSaveForm() && validateDropDown()) {
        try {
          setState(() {
            _isLoading = true;
          });
          if (_image != null) {
            await _uploadFile();
          }
          final id = widget.pet.id;
          final pet = Pet(
            name: _name,
            category: _category,
            breed: _breed,
            age: _age,
            weight: _weight,
            id: id,
            image: _imageUrl,
          );
          await widget.database.setPet(pet);
          Navigator.of(context).pop();
        } on PlatformException catch (e) {
          ShowErrorDialog.show(
              context: context,
              title: 'Updating Pet Failed',
              message: e.toString());
        }
      }
    }
  }
}
