import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe/Widget/banner.dart';
import 'package:recipe/Widget/food_items_display.dart';
import 'package:recipe/Widget/my_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/utils/const.dart';
import 'package:recipe/views/view_all_items.dart';

class MtAppHomeScreen extends StatefulWidget {
  const MtAppHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MtAppHomeScreen();
}

class _MtAppHomeScreen extends State<MtAppHomeScreen> {
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("app-Category");
  String category = "all";
  Query get filteredRecipes => FirebaseFirestore.instance
      .collection("recipe")
      .where("Category", isEqualTo: category);
  Query get allRecipes => FirebaseFirestore.instance.collection("recipe");
  Query get selectedRecipes => category == "all" ? allRecipes : filteredRecipes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerPart(),
                  mySearchBar(),
                  BannerToExplore(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // for category
                  selectedCategory(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quick & Easy",
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewAllItems(),
                              ),
                            );
                          },
                          child: Text(
                            "View all ",
                            style: TextStyle(
                                color: kBannerColor,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: selectedRecipes.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> recipes =
                      snapshot.data?.docs ?? [];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: recipes
                            .map((e) => FoodItemsDisplay(documentSnapshot: e))
                            .toList(),
                      ),
                    ),
                  );
                }
                // it means if snapshot has date then show the date otherwise show the progress bar
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      )),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
        stream: categoriesItems.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    streamSnapshot.data!.docs.length,
                    (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              category =
                                  streamSnapshot.data!.docs[index]['Cname'];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: category ==
                                      streamSnapshot.data!.docs[index]['Cname']
                                  ? kprimaryColor
                                  : Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                              streamSnapshot.data!.docs[index]['Cname'],
                              style: TextStyle(
                                color: category ==
                                        streamSnapshot.data!.docs[index]
                                            ['Cname']
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Padding mySearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(Iconsax.search_normal),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: "Search any recipes",
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Row headerPart() {
    return Row(
      children: [
        Text(
          'What are you\ncooking today?',
          style:
              TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1),
        ),
        Spacer(),
        MyIconButton(icon: Iconsax.notification, pressed: () {})
      ],
    );
  }
}
