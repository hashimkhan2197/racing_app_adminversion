import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:racingappadmin/Constants/constant.dart';
import 'package:racingappadmin/Providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () async{
              await FirebaseAuth.instance.signOut();
//              var prefs = await SharedPreferences.getInstance();
//              prefs.clear();
              Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
            },
            child: Container(
              alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                // child: CircleAvatar(
                //   backgroundImage: AssetImage("assets/logo.png"),
                // ),
                child: Text("Logout",style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}
class SettingsScreenState extends State<SettingsScreen> {
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;


  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    final FirebaseStorage _storgae = FirebaseStorage(
        storageBucket: 'gs://racing-app-b96b1.appspot.com/');
    StorageUploadTask uploadTask;
    String filePath = '${DateTime.now()}.png';
    uploadTask = _storgae.ref().child(filePath).putFile(avatarImageFile);
    uploadTask.onComplete.then((_) async {
      print(1);
      String url1 =
      await uploadTask.lastSnapshot.ref.getDownloadURL();
      avatarImageFile.delete().then((onValue) {
        setState(() {
          isLoading = false;
        });
        print(2);
      });
      print(url1);

      photoUrl = url1;
//      filename = filePath;
      print(photoUrl);
    });
//    String filePath = '${DateTime.now()}.png';
//    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
//    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
//    StorageTaskSnapshot storageTaskSnapshot;
//    uploadTask.onComplete.then((value) {
//      if (value.error == null) {
//        storageTaskSnapshot = value;
//        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//          photoUrl = downloadUrl;
//        }, onError: (err) {
//          setState(() {
//            isLoading = false;
//          });
//          Fluttertoast.showToast(msg: 'This file is not an image');
//        });
//      } else {
//        setState(() {
//          isLoading = false;
//        });
//        Fluttertoast.showToast(msg: 'This file is not an image');
//      }
//    }, onError: (err) {
//      setState(() {
//        isLoading = false;
//      });
//      Fluttertoast.showToast(msg: err.toString());
//    });
  }

  void handleUpdateData() {
    setState(() {
      isLoading = true;
    });

//    if (photoUrl==''){
//      photoUrl = userProfile.userimage;
//    }
    Firestore.instance.collection('ads').add({
      "url": photoUrl
    }).then((data) async {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Add success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ?Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: Container(
                              color: Colors.black12,
                              child: Center(

                              ),
                            ),
                            width: 250.0,
                            height: 250.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: photoUrl,
                          width: 250.0,
                          height: 250.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(100.0)),
                        clipBehavior: Clip.hardEdge,
                      ): Material(
                        child: Image.file(
                          avatarImageFile,
                          width: 250.0,
                          height: 250.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Positioned(
                        left: 70,
                        top: 160,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: primarycolor.withOpacity(0.5),
                          ),
                          onPressed: getImage,
                          padding: EdgeInsets.all(30.0),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.grey,
                          iconSize: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(10.0),
              ),

              // Input

              // Button
              Container(
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: handleUpdateData,
                  child: Text(
                    'Add Advertisement',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: primarycolor,
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 250,
//            width: 250,
            margin: EdgeInsets.only(top: 8,left: 16,bottom: 25),
            //padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('ads')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final snapShotData = snapshot.data.documents;
                  if (snapShotData.length == 0) {
                    return Center(
                      child: Text("No products added"),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapShotData.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.documents[index];
                        return Container(
                          child: Align(alignment:Alignment.bottomRight,child: FlatButton(onPressed:(){
                            Firestore.instance.collection('ads').document(data.documentID).delete();
                          },child: Text("Delete",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 24),),)),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(color: Colors.grey),
                            image: DecorationImage(
                              image: NetworkImage(data.data['url']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ),
        // Loading
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        ),
      ],
    );
  }
}
