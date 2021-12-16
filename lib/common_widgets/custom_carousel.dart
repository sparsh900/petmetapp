import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCarousel extends StatefulWidget {
  CustomCarousel(
      {this.path,
      this.customHeight: 166,
      this.customWidth: 414,
      this.fit = BoxFit.fitWidth,
      this.dotColor = Colors.white,
      this.listOfURL});
  final String path;
  final double customHeight, customWidth;
  final BoxFit fit;
  final Color dotColor;
  final List<dynamic> listOfURL;
  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  double circleIndicatorSize = 8.0;
  PageController _pageController;
  ValueNotifier<int> _pageNumber;

  Future<bool> _data;
  List<dynamic> _colors;

  Future<bool> getImagesList() {
    if (widget.listOfURL != null && widget.listOfURL.isNotEmpty) {
      _colors = widget.listOfURL;
      automaticSlider();
      return Future.value(true);
    } else if (widget.path != null) {
      return Firestore.instance.document(widget.path).get().then((value) {
        _colors = value.data["images"];
      }).then((value) {
        automaticSlider();
        return true;
      });
    }
    return Future.value(false);
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  void initState() {
    super.initState();
    _colors = [];
    _data = getImagesList();
    _pageController = PageController(initialPage: 0);
    _pageNumber = ValueNotifier<int>(0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return SizedBox(
            height: pH(widget.customHeight),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: PageView.builder(
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int idx) {
                        int index = getRealIndex(idx);
                        return Container(
                          child: Image.network(
                            _colors[index],
                            fit: widget.fit,
                          ),
                        );
                      },
                      onPageChanged: (index) {
                        _pageNumber.value = index;
                      }),
                ),
                ValueListenableBuilder(
                  valueListenable: _pageNumber,
                  child: _buildDots(),
                  builder: (context, idx, c) {
                    return _buildDots();
                  },
                ),
              ],
            ),
          );
        } else {
          print(snapshot);
          return Container(
            height: pH(widget.customHeight),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  int getRealIndex(int idx) {
    int index;
    try {
      index = idx % _colors.length;
    } catch (e) {
      print("Values not fetched yet");
    }
    return index;
  }

  void nextSlide() {
    try {
      _pageNumber.value += 1;
      _pageController.animateToPage(
        _pageNumber.value,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeIn,
      );
      if (flag == 0) automaticSlider();
    } catch (e) {
      // print(e);
    }
  }

  void automaticSlider() {
    Timer(Duration(seconds: 10), nextSlide);
  }

  Widget _buildDots() {
    int index = getRealIndex(_pageNumber.value);
    List<Widget> dots = [];
    for (int i = 0; i < _colors.length; i++) {
      dots.add(
        i == index ? _dot(widget.dotColor) : _dot(Colors.grey),
      );
    }
    double fullWidth = MediaQuery.of(context).size.width;
    return Align(
        // top: pH(widget.customHeight)- circleIndicatorSize * 3,
        // left: (fullWidth - 3 * circleIndicatorSize * dots.length) / 2.0,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dots,
        ));
  }

  Widget _dot(Color c) {
    return Padding(
      padding: EdgeInsets.all(circleIndicatorSize),
      child: Container(
        width: circleIndicatorSize,
        height: circleIndicatorSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circleIndicatorSize / 2),
          color: c,
        ),
      ),
    );
  }

  int flag = 1;
  @override
  void dispose() {
    super.dispose();
    flag = 0;
  }
}
