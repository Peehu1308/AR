import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:shirt/ar_screen.dart';

class ItemsUploadScreen extends StatefulWidget {
  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  Uint8List? imageFileUint8List;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {
        isCameraInitialized = true;
      });
    }
  }

  
  Future<void> captureImageWithCamera() async {
    try {
      final XFile image = await _cameraController!.takePicture();
      imageFileUint8List = await image.readAsBytes();
      setState(() {});
    } catch (e) {
      print("Camera Error: $e");
    }
  }

  
  Future<void> chooseImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        imageFileUint8List = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      print("Error: " + e.toString());
      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text(
          'Upload New Items',
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isCameraInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraPreview(_cameraController!),
                      // Image.asset(
                      //   "assets/shirt_outline.png", // Make sure this is just an outline
                      //   width: 250,
                      //   height: 250,
                      // ),
                    ],
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => showDialogBox(),
              child: const Text('Add New Item'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ARShirtScreen()),
              );
            },
            child: const Text('Try AR Simulator'),
          ),
            const SizedBox(height: 10),
            imageFileUint8List != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipPath(
                        clipper: ShirtClipper(),
                        child: Image.memory(
                          imageFileUint8List!,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Image.asset(
                        "assets/shirt.png",
                        width: 250,
                        height: 250,
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (c) {
        return SimpleDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Item Image",
            style: TextStyle(color: Colors.white),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () => captureImageWithCamera(),
              child: const Text(
                "Capture Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => chooseImage(),
              child: const Text(
                "Choose Image from Gallery",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}


class ShirtClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.3, 0);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width * 0.1, size.height * 0.3);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
