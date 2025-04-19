import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe/provider/fav_provider.dart';
import 'package:recipe/views/recipe_details.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailScreen(documentSnapshot: documentSnapshot)));
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          width: 230,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            documentSnapshot['image'], // image from firestore
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    documentSnapshot['name'],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.flash_1,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(
                        "${documentSnapshot['cal']} cal",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Iconsax.clock,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(
                        "${documentSnapshot['time']} Time",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () {
                        provider.toggleFavorite(documentSnapshot);
                      },
                      child: Icon(
                          provider.isExist(documentSnapshot)
                              ? Iconsax.heart5
                              : Iconsax.heart,
                          color: provider.isExist(documentSnapshot)
                              ? Colors.red
                              : Colors.black,
                          size: 20),
                    ),
                  ))
            ],
          ),
        ));
  }
}
