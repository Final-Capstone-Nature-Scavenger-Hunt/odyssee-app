import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odyssee/data/hunt_data.dart';
import 'package:odyssee/screens/classification/classification_helpers.dart';
import 'package:odyssee/shared/constants.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/shared/header_nav.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class ClassifyImage extends StatefulWidget {

  final String predictedClass;

  ClassifyImage({this.predictedClass});

  @override
  _ClassifyImageState createState() => _ClassifyImageState();
}

class _ClassifyImageState extends State<ClassifyImage> {

  File _image;
  List _recognitions;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;
  bool findStatus = false;

  Future predictImagePicker(String uid, bool fromCamera) async {


    var imageSource = fromCamera ? ImageSource.camera : ImageSource.gallery;

    var image = await ImagePicker.pickImage(source: imageSource);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);

  }

  Future predictImage(File image) async {
    if (image == null) return;

    await recognizeImage(image);

    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false; 
      });
      print('Model has been lad');
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
            model: "assets/models/odyssee/model_v2.tflite",
            labels: "assets/models/odyssee/labels_imagenet_slim.txt",
      );   

            print('Printing Model next');
            print(res);
    } on PlatformException catch(e) {
      print('Failed to load model.');
      print(e);
    }
  }

  Future recognizeImage(File image) async {
    print('starting RECOGNITION ...................');
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });

    print('Recognitions:');

    print(_recognitions.map((res) => res["label"]).toList());
  
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    final user = Provider.of<User>(context);
    final huntNames = HuntData.huntMap.keys.toList();

    stackChildren.add(
      Container(
        height: 300,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal:20.0),
        child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: _image == null ? Text('No image selected.') : Image.file(_image, fit: BoxFit.fitWidth),
        )

      ),
    );


    if (_busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(
        SpinKitChasingDots(
          color: Colors.brown,
          size: 50.0
          ) 
        );
    }

    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:15.0, left: 10.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text('Select Image',
                  style: Styles.defaultPageTitle
                )
              ]
            )
          ),

          SizedBox(height: 10.0),

          Stack(
            children: stackChildren
          ),

          SizedBox(height: 10.0),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green[900],
                  onPressed: () async {
                    predictImagePicker(user.uid, false );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.photo_library, color: Colors.white),
                      SizedBox(width: 5.0),
                      Text('Gallery',
                        style: Styles.defaultTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                          ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.green[900],
                  onPressed: () async {
                    predictImagePicker(user.uid, true );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 5.0),
                      Text('Camera',
                        style: Styles.defaultTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                          ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          Divider(height: 10.0, 
            color: Colors.black,
            indent: 30.0,
            endIndent: 30.0,
          ),

        Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:10.0),
                height: 50,
                width: 250,
                child: RaisedButton(
                    color: Colors.green[900],
                    onPressed: () => ClassificationHelpers().confirmClassification(context, user, _recognitions, 
                                                                      widget.predictedClass, findStatus, _image),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text('Confirm Finding',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold
                          ),
                    )
                ),
              ),
              SizedBox(height:10.0),
              Container(
                margin: EdgeInsets.only(top:10.0),
                height: 50,
                width: 250,
                child: RaisedButton(
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.black38),
                    ),
                    child: Text('Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold
                          ),
                    )
                ),
              ),
            ],
          ),
        )

        ],
      ),
    );

  }

}