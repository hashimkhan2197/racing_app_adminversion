import 'package:flutter/material.dart';
import 'package:racingappadmin/Constants/constant.dart';
import 'package:racingappadmin/models/Cars.dart';

class ItemCard extends StatelessWidget {
  final Productc product;
  final Function press;
  const ItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                  // color: product.color,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                      image: NetworkImage(product.image), fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.title,
              style: TextStyle(
                  color: primarycolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Text(
            "\$${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }
}
