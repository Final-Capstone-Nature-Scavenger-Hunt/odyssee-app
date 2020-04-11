import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odyssee/data/hunt_data.dart';
import 'package:odyssee/screens/classification/classification_helpers.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/shared/header_nav.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class ClassifyImage extends StatefulWidget {
  @override
  _ClassifyImageState createState() => _ClassifyImageState();
}

class _ClassifyImageState extends State<ClassifyImage> {

  File _image;
  List _recognitions;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;
  String predictedClass;
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

    List<Widget> belowImageWidgets = [

      DropdownButtonFormField(
        value: predictedClass ?? huntNames[0],
        items: huntNames.map((huntName) => 
        DropdownMenuItem(
          child: Text(huntName),
          value: huntName,
        )
        ).toList(),
        onChanged: (val) => setState(() => predictedClass = val),
        ),

      FlatButton(
        child: Text('Confirm Image'),
        onPressed: () =>  ClassificationHelpers().confirmClassification(context, user, _recognitions, 
                                                                      predictedClass, findStatus, _image),
        color: Colors.teal[300]
        )
    ];

    stackChildren.add(Center(
      child: Column(
        children: [
          Expanded(
                      child: Container(
            child: _image == null ? Text('No image selected.') : Image.file(_image),
            alignment: Alignment.center,
            height: size.height * 0.7,
            width: size.width * 0.7
            ),
          )
        ]..addAll(belowImageWidgets),
      ),
    ));


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
      appBar: AppBar(
//        leading: Builder(
//          builder: (BuildContext context) {
//            return IconButton(
//              icon: const Icon(Icons.menu),
//              onPressed: () { Scaffold.of(context).openDrawer(); },
//              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//            );
//          },
//        ),
        title: Text('Image Classification'),
        centerTitle: true,
        backgroundColor: Color(0xFF194000),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xFFE86935),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Stack(
          children: stackChildren,
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              predictImagePicker(user.uid, false );
            },
            tooltip: 'Pick Image from Gallery',
            child: Icon(Icons.image),
            heroTag: null,
          ),
          SizedBox(height: 5.0),
          FloatingActionButton(
            onPressed: () async {
              predictImagePicker(user.uid, true);
            },
            tooltip: 'Pick Image from Camera',
            child: Icon(Icons.camera),
            heroTag: null,
          ),
        ],
      )
    );

  }

}