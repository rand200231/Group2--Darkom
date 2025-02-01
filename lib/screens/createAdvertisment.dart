import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase storage
import 'dart:io'; // For using File class

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController? _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).primaryColor,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _barItem(Icons.home_outlined, 'Home', 0, flex: 1),
            _barItem(Icons.whatshot, 'Explore', 1, flex: 1),
            _barItem(Icons.support, 'Support', 2, flex: 2),
            _barItem(Icons.person_outline, 'Profile', 3, flex: 1),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(color: Colors.white),
          AdvertisementScreen(),
          Container(color: Colors.white),
          Container(color: Colors.white),
        ],
      ),
    );
  }

  Widget _barItem(IconData icon, String label, int index, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => _setPage(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: index == _pageIndex ? Colors.white : Colors.grey[300],
              size: index == _pageIndex ? 27 : 25,
            ),
            Text(
              label,
              style: TextStyle(
                color: index == _pageIndex ? Colors.white : Colors.grey[300],
                fontSize: index == _pageIndex ? 13 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}

class AdvertisementScreen extends StatefulWidget {
  @override
  _AdvertisementScreenState createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');

      UploadTask uploadTask = storageRef.putFile(_image!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("Uploading: $progress%");
      });

      await uploadTask;

      String downloadURL = await storageRef.getDownloadURL();

      print('File uploaded successfully! Download URL: $downloadURL');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded successfully!')));
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading file')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 50),
                  SizedBox(width: 10),
                  Text(
                    "Add your post advertisement",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AdvertisementBox(),
              SizedBox(height: 20),
              AdvertisementBox(),
              SizedBox(height: 20),
              AppPrimaryButton(
                text: "Click here\nto add post",
                onPressed: _pickImage,
              ),
              SizedBox(height: 20),
              if (_image != null)
                Image.file(
                  _image!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20),
              AppPrimaryButton(
                text: "Upload Image",
                onPressed: _uploadImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdvertisementBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Icon(Icons.image, size: 50, color: Colors.brown),
      ),
    );
  }
}

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppPrimaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 161, 127, 80),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 110),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 210, 195, 182),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              text,
              style: TextStyle(color: Color.fromARGB(255, 111, 79, 51), fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
