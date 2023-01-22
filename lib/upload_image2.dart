import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImageScreenTwo extends StatefulWidget {
  const UploadImageScreenTwo({super.key});

  @override
  State<UploadImageScreenTwo> createState() => _UploadImageScreenTwoState();
}

class _UploadImageScreenTwoState extends State<UploadImageScreenTwo> {
  File? image;
  final _picker = ImagePicker();
  bool showSpinning = false;

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print('No image picked');
    }
  }

  Future uploadImage() async {
    setState(() {
      showSpinning = true;
    });

    var stream = http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request = http.MultipartRequest('post', uri);
    request.fields['title'] = 'Static title';
    var multiport = http.MultipartFile('image', stream, length);
    request.files.add(multiport);
    var response = await request.send();
    print(response.stream.toString());

    if (response.statusCode == 200) {
      setState(() {
        showSpinning = false;
      });
      print("Image Uploaded Successfully");
    } else {
      setState(() {
        showSpinning = false;
      });
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image 2'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              child: image == null
                  ? Center(
                      child: Text("Pick Image"),
                    )
                  : Container(
                      child: Center(
                        child: Image.file(
                          File(image!.path).absolute,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 150,
          ),
          GestureDetector(
            onTap: () {
              uploadImage();
            },
            child: Container(
              height: 50,
              width: 100,
              color: Colors.green,
              child: Center(
                child: Text("Upload Image "),
              ),
            ),
          )
        ],
      ),
    );
  }
}
