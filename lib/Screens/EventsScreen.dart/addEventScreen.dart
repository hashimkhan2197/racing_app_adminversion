import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:racingappadmin/Providers/user.dart';
import 'package:racingappadmin/Widgets/custom_shape.dart';
import 'package:racingappadmin/Widgets/custom_textfield.dart';
import 'package:racingappadmin/Widgets/customappbar.dart';
import 'package:racingappadmin/Widgets/responsive_widget.dart';
import 'package:racingappadmin/services/payment_service.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  UserModel userProfile;

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  bool signupLoading = false;
  List<String> imageUrlList=[];
  var _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TextEditingController eventTitleController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController eventDateContoller = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventIDController = TextEditingController();

  @override
  void dispose() {
    eventIDController.dispose();
    eventDescriptionController.dispose();
    eventDateContoller.dispose();
    eventTitleController.dispose();
    languageController.dispose();
    countryController.dispose();
    super.dispose();
  }

  bool imagecheck = false;
  File image;
  bool imagecheck1 = false;
  File image1;
  bool imagecheck2 = false;
  File image2;
  bool urlcheck = false;
  List<File> imageList;


  @override
  Future<void> didChangeDependencies() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.photos
    ].request();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    userProfile = Provider.of<User>(context).userProfile;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    ///Main function for screen ui
    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),

                //acceptTermsTextRow(),
                SizedBox(
                  height: _height / 17,
                ),
                addProductButton(context),
                // infoTextRow(),
                // socialIconsRow(),
                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Function to make pick profile image ui
  Widget clipShape() {
    return Container(margin: EdgeInsets.all(8),
      //padding: EdgeInsets.all(8),
      height: _height / 5.5,
      alignment: Alignment.center,
//      color: Colors.black12,
      child: ListView(shrinkWrap:true,scrollDirection: Axis.horizontal,children: <Widget>[
        pic0(),pic1(),pic2()],),
    );
  }

  /// form ui here
  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            productidTextFormField(),
            SizedBox(
              height: _height / 60.0,
            ),
            titleTextFormField(),
            SizedBox(height: _height / 60.0),
            priceTextFormField(),
            SizedBox(height: _height / 60.0),
            descriptionTextFormField(),
            SizedBox(height: _height / 60.0),
          ],
        ),
      ),
    );
  }

  ///Custom form fields for form elements section
  Widget productidTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      icon: Icons.person,
      hint: "Event ID e.g 721926",
      textEditingController: eventIDController,
      validator: (String val) {
        if (val.trim().isEmpty) {
          return "ID must not be empty";
        }
        return null;
      },
    );
  }

  Widget titleTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Title",
      textEditingController: eventTitleController,
      validator: (String val) {
        if (val.trim().isEmpty) {
          return "Title must not be empty";
        }
        return null;
      },
    );
  }

  Widget priceTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.numberWithOptions(signed: true),
      obscureText: false,
      icon: Icons.phone,
      hint: "Event Date",
      textEditingController: eventDateContoller,
      validator: (String val) {
        if (val.trim().isEmpty) {
          return "Date must not be empty";
        }
        return null;
      },
    );
  }

  Widget descriptionTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: false,
      icon: Icons.card_travel,
      hint: "Description",
      textEditingController: eventDescriptionController,
      validator: (String val) {
        if (val.trim().isEmpty) {
          return "Description must not be empty";
        }
        return null;
      },
    );
  }

  ///Add Event button function
  //TODO form validation for sign up form
  Widget addProductButton(BuildContext ctx) {
    return signupLoading
        ? CircularProgressIndicator()
        : RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async {
              //Condition to see if profile image is uploaded
              if ((imagecheck || imagecheck1 || imagecheck2) && _formKey.currentState.validate()) {
                addProduct(ctx);
              } else {
                imagecheck == false
                    ? showDialog(
                        context: context,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: Colors.red[400],
                              )),
                          title: Text("Wait..."),
                          content: Text("Images Not Uploaded"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.red[400]),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ))
                    : null;
              }
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
//        height: _height / 20,
              width: _large
                  ? _width / 4
                  : (_medium ? _width / 3.75 : _width / 3.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                      colors: [Colors.red[400], Colors.red[100]])),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Add Event',
                style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 12)),
              ),
            ),
          );
  }

  ///Firebase creating user with email & password and error handling
  Future<void> addProduct(BuildContext ctx) async {
    try {
      if (userProfile.email == null) {
        throw Exception;
      }
      setState(() {
        signupLoading = true;
      });
      await addEventToFirebase(userProfile);

      setState(() {
        signupLoading = false;
      });
      Navigator.pop(context);
    } catch (signUpError) {
      setState(() {
        signupLoading = false;
      });
//    throw signUpError;
      showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Colors.red[400],
                )),
            title: Text(signUpError.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.red[400]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
    }
  }

  ///function to add user data to a firebase collection
  Future<void> addEventToFirebase(UserModel userModel) async {
    await Firestore.instance.collection("events").add({
      'timestamp': Timestamp.now(),
      'eventid': eventIDController.text,
      'title': eventTitleController.text,
      'eventdescription': eventDescriptionController.text,
      'eventdate': eventDateContoller.text,
      'eventimages': imageUrlList,
    });
  }

  ///Picking up user profile image
  Widget pic0() {
    return imagecheck
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal:3.0),
          child: CircleAvatar(maxRadius: 65, backgroundImage: FileImage(image)),
        )
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: CircleAvatar(maxRadius: 65,backgroundColor: Colors.grey[300],
            child: GestureDetector(
            onTap: () async {
              image = await pickImage(context, ImageSource.gallery);

              if (image != null) {
                setState(() {
                  imagecheck = true;
                });

                final FirebaseStorage _storgae = FirebaseStorage(
                    storageBucket: 'gs://racing-app-55a9e.appspot.com/');
                StorageUploadTask uploadTask;
                String filePath = '${DateTime.now()}.png';
                uploadTask = _storgae.ref().child(filePath).putFile(image);
                uploadTask.onComplete.then((_) async {
                  print(1);
                  String url1 =
                  await uploadTask.lastSnapshot.ref.getDownloadURL();
                  setState(() {

                  });
                  print('downloadedUrl'+url1);
                  imageUrlList.add(url1.toString());
                });
              }
            },
            child: Icon(Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: Colors.red[400])),
          ),
        );
  }
  Widget pic1() {
    return imagecheck1
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal:3.0),
      child: CircleAvatar(maxRadius: 65, backgroundImage: FileImage(image1)),
    )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: CircleAvatar(maxRadius: 65,backgroundColor: Colors.grey[300],
        child: GestureDetector(
            onTap: () async {
              image1 = await pickImage(context, ImageSource.gallery);

              if (image1 != null) {
                setState(() {
                  imagecheck1 = true;
                });

                final FirebaseStorage _storgae = FirebaseStorage(
                    storageBucket: 'gs://racing-app-55a9e.appspot.com/');
                StorageUploadTask uploadTask;
                String filePath = '${DateTime.now()}pic1.png';
                uploadTask = _storgae.ref().child(filePath).putFile(image1);
                uploadTask.onComplete.then((_) async {
                  print(1);
                  String url1 =
                  await uploadTask.lastSnapshot.ref.getDownloadURL();

                  setState(() {

                  });
                  print('downloadedUrl: '+url1);
                  imageUrlList.add(url1.toString());
                });
              }
            },
            child: Icon(Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: Colors.red[400])),
      ),
    );
  }
  Widget pic2() {
    return imagecheck2
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal:3.0),
      child: CircleAvatar(maxRadius: 65, backgroundImage: FileImage(image2)),
    )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: CircleAvatar(maxRadius: 65,backgroundColor: Colors.grey[300],
        child: GestureDetector(
            onTap: () async {
              image2 = await pickImage(context, ImageSource.gallery);

              if (image2 != null) {
                setState(() {
                  imagecheck2 = true;
                });

                final FirebaseStorage _storgae = FirebaseStorage(
                    storageBucket: 'gs://racing-app-55a9e.appspot.com/');
                StorageUploadTask uploadTask;
                String filePath = '${DateTime.now()}pic2.png';
                uploadTask = _storgae.ref().child(filePath).putFile(image2);
                uploadTask.onComplete.then((_) async {
                  print(1);
                  String url1 =
                  await uploadTask.lastSnapshot.ref.getDownloadURL();
                  setState(() {

                  });
                  print('downloadedurl2: '+url1);
                  imageUrlList.add(url1.toString());
                });
              }
            },
            child: Icon(Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: Colors.red[400])),
      ),
    );
  }


  Future<File> pickImage(BuildContext context, ImageSource source) async {
    File selected = await ImagePicker.pickImage(
      source: source,
      imageQuality: 20,
    );
    return selected;
  }
}
