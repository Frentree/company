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
  double _cRate = _cHeight / _cWidth;
  double _rRate;

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
        return FutureBuilder(
            future: _getImage(),
            builder:
                (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.data != null) {
                ui.Image _image = snapshot.data;
                _width = _image.width.toDouble();
                _height = _image.height.toDouble();
                _rRate = _height / _width;

                if (_rRate >= _cRate) {
                  debugPrint("first");
                  debugPrint("_cRate " + _cRate.toString());
                  _rHeight = _cHeight;
                  _rWidth = _width * _cHeight / _height;
                  debugPrint("_rRdate " + _rRate.toString());
                  debugPrint("_rHeight " + _rHeight.toString());
                  debugPrint("_rWidth " + _rWidth.toString());
                  debugPrint("_cHeight " + _cHeight.toString());
                  debugPrint("_cWidth " + _cWidth.toString());
                  debugPrint("Screen Width " + customWidth(context: context, widthSize: 1.0).toString());
                  debugPrint("Screen Height " + customHeight(context: context, heightSize: 1.0).toString());

                } else {
                  debugPrint("second");
                  debugPrint("_cRate " + _cRate.toString());
                  _rHeight = _height * _cWidth / _width;
                  _rWidth = _cWidth;
                  debugPrint("_rRdate " + _rRate.toString());
                  debugPrint("_rHeight " + _rHeight.toString());
                  debugPrint("_rWidth " + _rWidth.toString());
                  debugPrint("_cHeight " + _cHeight.toString());
                  debugPrint("_cWidth " + _cWidth.toString());
                  debugPrint("Screen Width " + customWidth(context: context, widthSize: 1.0).toString());
                  debugPrint("Screen Height " + customHeight(context: context, heightSize: 1.0).toString());
                }

                return AlertDialog(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  content: Builder(
                    builder: (context) {
                     return Container(

                         width: _rWidth,
                         height: (_rHeight + 50 ),

                         /*width: ((_width <= _cWidth
                             ? _width
                             : _cWidth)) + 10,
                         height: ((_height <= _cHeight
                             ? _height
                             : _cHeight)+60),*/


                          padding: EdgeInsets.all(0.0),
                          color: Colors.transparent,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: _rWidth*0.9,
                                          height: _rHeight,

                                          /*width: ((_width <= _cWidth
                                              ? _width
                                              : _cWidth) + 10),

                                          height: ((_height <= _cHeight
                                              ? _height
                                              : _cHeight)+10),*/


                                          child: PhotoView(
                                            backgroundDecoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            imageProvider: NetworkImage(imageUrl),
                                            minScale:
                                            PhotoViewComputedScale.contained *
                                                0.6,
                                            maxScale:
                                            PhotoViewComputedScale.covered *
                                                1.8,
                                            initialScale:
                                            PhotoViewComputedScale.contained *
                                                1.0,
                                          )),
                                    ]),
                                Padding(padding: EdgeInsets.only(top: 5.0)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100.0,
                                        height: 40.0,
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
                              ]));
                    }
                  )
                );
              } else {
                return Container();
              }
            });
      });
}
