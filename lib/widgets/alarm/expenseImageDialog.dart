import 'dart:async';
import 'dart:ui' as ui;

import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

ExpenseImageDialog(BuildContext context, String imageUrl) {
  Image image = Image.network(imageUrl);
  double _width;
  double _height;
  double _rWidth;
  double _rHeight;
  double _cWidth = customWidth(context: context, widthSize: 0.7);
  double _cHeight = customHeight(context: context, heightSize: 0.7);

  Future<ui.Image> _getImage() {
    Completer<ui.Image> completer = Completer();

    image.image
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    return completer.future;
  }

  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: FutureBuilder(
                future: _getImage(),
                builder:
                    (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                  if (snapshot.data != null) {
                    ui.Image _image = snapshot.data;
                    _width = _image.width.toDouble();
                    _height = _image.height.toDouble();

                    double tmp;
                    /// 위젯 사이즈 조정
                    if (_width <= _cWidth && _height <= _cHeight) {
                      debugPrint("Width and Height is Under");
                      if(_height/_width >= 1.0) {
                        _rHeight = _cHeight;
                        _rWidth = _width * _height/_width;
                      } else {
                        _rWidth = _cWidth;
                        _rHeight = _height * _cWidth/_width;
                      }
                    } else if (_width <= _cWidth || _height <= _cHeight) {
                      debugPrint("Width or Height is Over");
                      if(_height/_width >= 1.0) {
                        _rHeight = _cHeight;
                        _rWidth = _width * _cHeight/_height;
                      } else {
                        _rWidth = _cWidth;
                        _rHeight = _height * _cWidth/_width;
                      }
                    } else {
                      debugPrint("Width and Height is Over");
                      if(_height/_width >= 1.0) {
                        _rHeight = _cHeight;
                        _rWidth = _width * _cHeight/_height;
                      } else {
                        _rWidth = _cWidth;
                        _rHeight = _height * _cWidth/_width;
                      }
                    }


                    return Container(
                        padding: EdgeInsets.all(0.0),
                        color: Colors.blue,
                        width: (_width <= _cWidth ? _width : _cWidth),
                        height: ((_height <= _cHeight ? _height : _cHeight) + 55.0),
                        child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width : _rWidth,
                                        height: _rHeight,
                                        /*width: (_width <= _cWidth
                                            ? _width
                                            : _cWidth),
                                        height: ((_height <= _cHeight
                                            ? _height
                                            : _cHeight)),*/
                                        child: PhotoView(
                                          imageProvider:
                                              NetworkImage(imageUrl),
                                          minScale: PhotoViewComputedScale
                                                  .contained *
                                              0.8,
                                          maxScale: PhotoViewComputedScale
                                                  .covered *
                                              1.8,
                                          initialScale:
                                              PhotoViewComputedScale
                                                      .contained *
                                                  1.0,
                                        )),
                                  ]),
                              Padding(padding: EdgeInsets.only(top:5.0)),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100.0,
                                      height: 50.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                        color: const Color(0xFF1BC0C5),
                                      ),
                                    ),
                                  ])
                            ]));
                  } else {
                    return Container();
                  }
                }

                /*child: Container(
                  height: 300,
                  width : 200,
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<ui.Image>(
                                      future: _getImage(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<ui.Image> snapshot) {
                                        if (snapshot.data != null) {
                                          ui.Image _image = snapshot.data;
                                          _width = _image.width.toDouble();
                                          _height = _image.height.toDouble();
                                          return SizedBox(
                                              width: _width <= _cWidth ? _width: _cWidth,
                                              height: _height <= _cHeight ? _height: _cHeight,
                                              child: PhotoView(
                                                imageProvider:
                                                    NetworkImage(imageUrl),
                                                minScale: PhotoViewComputedScale
                                                        .contained *
                                                    0.8,
                                                maxScale: PhotoViewComputedScale
                                                        .covered *
                                                    1.8,
                                                initialScale:
                                                    PhotoViewComputedScale
                                                            .contained *
                                                        1.0,
                                              ));
                                        } else {
                                          return Container();
                                        }
                                      }
                                      ),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: const Color(0xFF1BC0C5),
                                    ),
                                  ),
                                ])
                          ]))),*/
                ));
      });
}
