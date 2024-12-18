import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_services.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected.'))
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please capture an image first.'))
      );
      return;
    }

    // Show a loading indicator while we analyze the image
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    final result = await ApiService.analyzeImage(_image!);
    Navigator.pop(context); // Close the loading dialog

    if (result != null && result['foodName'] != null) {
      // Store data in Firestore
      await FirebaseFirestore.instance.collection('meals').add({
        'foodName': result['foodName'],
        'carbs': result['carbs'],
        'protein': result['protein'],
        'fat': result['fat'],
        'timestamp': DateTime.now().toUtc(),
      });

      // Navigate to the results screen to show nutritional info
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultsScreen(data: result)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data received or an error occurred.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Nutrition App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null
              ? Text('No image selected.')
              : Image.file(_image!),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Capture Image'),
          ),
          ElevatedButton(
            onPressed: _analyzeImage,
            child: Text('Analyze Image'),
          ),
        ],
      ),
    );
  }
}
