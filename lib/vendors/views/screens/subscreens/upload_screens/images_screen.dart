import 'dart:io';
import 'package:e_shop/provider/product_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  List<File> _image = [];
  List<String> _urlList = [];
  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print("No Image Selected!");
    } else {
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider provider = Provider.of<ProductProvider>(context);
    return Stack(
      children: [
        Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: _image.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 3),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(_image[index])),
                  ),
                );
              },
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                chooseImage();
              },
              child: Container(
                margin: _image.isNotEmpty
                    ? EdgeInsets.only(top: 495, left: 330)
                    : EdgeInsets.only(top: 530, left: 330),
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blue.shade500,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            _image.isNotEmpty
                ? GestureDetector(
                    onTap: () async {
                      EasyLoading.show(status: 'uploading images');
                      for (var img in _image) {
                        print(_image.length);
                        Reference ref = _storage
                            .ref()
                            .child('productImage')
                            .child(const Uuid().v4());
                        await ref.putFile(img).whenComplete(() async {
                          await ref.getDownloadURL().then((value) {
                            setState(() {
                              _urlList.add(value);
                            });
                          });
                        });
                      }
                      setState(() {
                        provider.getFormData(imageUrlList: _urlList);
                        EasyLoading.dismiss();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.shade500,
                      ),
                      child: const Text(
                        "Upload All Images",
                        style: TextStyle(
                            letterSpacing: 3,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  )
                : Text(""),
          ],
        ),
      ],
    );
  }
}
