import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:talab_market/services/auth.dart';
import 'package:talab_market/services/databaseretailer.dart';
import 'package:talab_market/shared/constants.dart';

class Addretailer extends StatefulWidget {
  @override
  AddretailerState createState() => AddretailerState();
}

class AddretailerState extends State<Addretailer> {
  //final AuthService1 _auth = AuthService1();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  final AuthService _auth = AuthService();

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String privilege = '';
  String photo='';
  List  buy=[];

  File _image;

  Future getImage(context) async {
    FocusScope.of(context).unfocus(focusPrevious: true);
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var dowurl =  await ((taskSnapshot).ref.getDownloadURL());
    photo = dowurl.toString();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'name'),
              validator: (val) => val.isEmpty ? 'Enter retailer name' : null,
              onChanged: (val) {
                setState(() => name = val);
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'email'),
              validator: (val) => val.isEmpty ? 'Enter retailer email' : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Phone'),
              validator: (val) => val.isEmpty ? 'Enter retailer Phone' : null,
              onChanged: (val) {
                setState(() => phone = val);
              },
            ),
            SizedBox(height: 20.0),
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.camera,
                    size: 30.0,
                  ),
                  onPressed: () {
                    getImage(context);
                  },
                )),
            (_image != null)
                ? Image.file(
                    _image,
              height: 50,
              width: 50,
                  )
                : Image.network(
                    "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                height: 50,
              width: 50,
                  ),

            RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await uploadPic(context);

                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = DataRetailer().updateRetailerData(
                      email,
                      name,
                      phone,
                      photo,
                      buy
                    );

                    Navigator.pop(context);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = 'Please supply a valid email';
                      });
                    }
                  }
                }),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}
