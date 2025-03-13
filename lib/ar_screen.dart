import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';

class ARShirtScreen extends StatefulWidget {
  @override
  _ARShirtScreenState createState() => _ARShirtScreenState();
}

class _ARShirtScreenState extends State<ARShirtScreen> {
  ArCoreController? arCoreController;
  Uint8List? imageFileUint8List;
  ArCoreNode? imageNode;

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
  }

  
  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFileUint8List = await pickedImage.readAsBytes();
      setState(() {
        _addImageToAR();
      });
    }
  }

  
  void _addImageToAR() {
    if (imageFileUint8List == null || arCoreController == null) return;

    // Create AR Plane with Image
    imageNode = ArCoreNode(
      image: ArCoreImage(bytes: imageFileUint8List!, width: 512, height: 512),
      position: Vector3(0, -1, -3),
      scale: Vector3(1.5, 1.5, 1), 
    );

    arCoreController!.addArCoreNode(imageNode!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR T-shirt Simulator")),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          Positioned(
            bottom: 30,
            left: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: pickImage,
              child: Text("Select T-shirt Image"),
            ),
          ),
        ],
      ),
    );
  }
}
