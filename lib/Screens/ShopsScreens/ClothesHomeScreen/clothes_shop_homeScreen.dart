import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:racingappadmin/Constants/constant.dart';
import 'package:racingappadmin/Screens/ShopsScreens/ClothesHomeScreen/addNewClothes/add_new_clothes.dart';
import 'package:racingappadmin/Screens/ShopsScreens/ClothesHomeScreen/components/body.dart';

class ClothesHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: primarycolor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Text(
          "Clothes",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        SizedBox(width: kDefaultPaddin / 2),
        InkWell(
          onTap: () async{
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddclothesScreen();
            }));
          },
          child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              // child: CircleAvatar(
              //   backgroundImage: AssetImage("assets/logo.png"),
              // ),
              child: Text("Add Clothes",style: TextStyle(color: Colors.white),)),
        ),
        SizedBox(width: kDefaultPaddin / 2),

//        IconButton(
//          icon: SvgPicture.asset(
//            "assets/icons/search.svg",
//            // By default our  icon color is white
//            color: Colors.white,
//          ),
//          onPressed: () {},
//        ),
//        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
