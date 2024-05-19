import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref = _firebaseStorage
        .ref()
        .child('profilePics')
        .child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  Future<String> signUpUsers(String email, String fullName, String phoneNumber,
      String password, Uint8List? image) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          password.isNotEmpty &&
          phoneNumber.isNotEmpty) {
        // ignore: unused_local_variable
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profileImageUrl = await uploadProfileImageToStorage(image);

        await _fireStore.collection("buyers").doc(cred.user!.uid).set({
          'buyerID': cred.user!.uid,
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'address': "",
          'profileImage': profileImageUrl
        });

        res = 'suceess';
      } else {
        res = "All fields must be filled.";
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  loginUsers(String email, String password) async {
    String res = 'Something went wrong';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Fileds must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
