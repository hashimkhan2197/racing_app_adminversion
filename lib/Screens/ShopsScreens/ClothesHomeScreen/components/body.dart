import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:racingappadmin/Constants/constant.dart';
import 'package:racingappadmin/Screens/ShopsScreens/details/details_screen.dart';
import 'package:racingappadmin/models/Cars.dart';
import 'package:racingappadmin/models/Clothes.dart';

import 'item_card.dart';

int selectedIndex = 0;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> clothesCategories = [
    "New in",
    "Men",
    "Women",
    "Accessories",
    "Shoes",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
          child: SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: clothesCategories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: selectedIndex == 0
              ? categoryItems(newInClothes,clothesCategories[0])
              : selectedIndex == 1
                  ? categoryItems(menClothes,clothesCategories[1])
                  : selectedIndex == 2
                      ? categoryItems(womenClothes,clothesCategories[2])
                      : selectedIndex == 3
                          ? categoryItems(accessories,clothesCategories[3])
                          : categoryItems(sheos,clothesCategories[4]),
        ))
      ],
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print(selectedIndex);
        (context as Element).reassemble();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              clothesCategories[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 80,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget categoryItems(List<Product> categoryList,String category) {
    var productCategory= 'all';
    if(category == clothesCategories[1]){
      productCategory = "Men";
    }else if(category == clothesCategories[2]){
      productCategory = "Women";
    }
    else if (category == clothesCategories[3]){
      productCategory = "Accessories";
    }else if(category == clothesCategories[4]){
      productCategory = "Shoes";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: StreamBuilder(
        stream: productCategory == 'all'?Firestore.instance
            .collection('clothes')
            .orderBy('timestamp',descending: true).snapshots()
        :Firestore.instance.collection('clothes')
            .where('productcategory', isEqualTo: productCategory)
            .orderBy('timestamp',descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final snapShotData = snapshot.data.documents;
          if(snapShotData.length == 0){
            return Center(child: Text("No products added"),);
          }
          return GridView.builder(
              itemCount: snapShotData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: kDefaultPaddin,
                crossAxisSpacing: kDefaultPaddin,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                var doc = snapShotData[index].data;

                //Create a product item to pass as arugument
                Productc product = Productc(image: doc['productimage'],
                    price: doc['productprice'],
                    description: doc['productdetails'],
                    id: doc['productid'],
                    title: doc['title'],sellerEmail: doc['selleremail'],
                    sellerPhoneNumber: doc['sellerphonenumber'],
                    sellerUserUid: doc['selleruseruid'],
                    productCategory: doc['productcategory'],
                sellerName: doc['sellername']);
                //-----------------------------------------

                return ItemCard(
                    product: product,
                    press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            product: product,
                          ),
                        )),
                  );
              });
        }
      ),
    );
  }
}
