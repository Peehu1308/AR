import 'package:flutter/material.dart';
import 'package:shirt/items_upload_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}






class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Ikea App',
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Colors.purple[300],
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsUploadScreen()));
          }, icon: const Icon(Icons.add,color: Colors.white,)),
        ],
      ),
      
    );
  }
}