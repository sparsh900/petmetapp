import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomSlider extends StatefulWidget {
  CustomSlider({this.path});
  final String path;
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  Future<bool> _data;
  List<dynamic> _images;
  @override
  void initState() {
    super.initState();
    _images = [];
    _data = getImagesList();
  }

  Future<bool> getImagesList() {
    if (widget.path != null) {
      return Firestore.instance.document(widget.path).get().then((value) {
        _images = value.data["images"];
      }).then((value) {
        return true;
      });
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                viewportFraction: 0.8,
                autoPlayInterval: Duration(seconds: 15),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: true,
              ),
              items: imageSliders(_images),
            );
          } else {
            return Container(
              height: pH(100),
              child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Loading...",style: TextStyle(
                    fontSize: pH(18)
                  ),),
                )
              ])),
            );
          }
        });
  }
}

List<Widget> imageSliders(List images) {
  return images
      .map((item) => Container(
    margin: EdgeInsets.all(2.0),

    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
// Positioned(
//   bottom: 0.0,
//   left: 0.0,
//   right: 0.0,
//   child: Container(
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [
//           Color.fromARGB(200, 0, 0, 0),
//           Color.fromARGB(0, 0, 0, 0)
//         ],
//         begin: Alignment.bottomCenter,
//         end: Alignment.topCenter,
//       ),
//     ),
//     padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//     child: Text(
//       'No. ${imgList.indexOf(item)} image',
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 20.0,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
// ),

    ),

  ))
      .toList();
}
