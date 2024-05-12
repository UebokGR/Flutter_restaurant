
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manju_restaurant/pages/home.dart';
import '../widget/widget_support.dart';


class FoodDetails extends StatefulWidget {
  //const FoodDetails({super.key, required this.foodId});
  //final String foodId;  // Identifier of the food item
  const FoodDetails({super.key});
  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  int aNumber = 1;
  late Future<DocumentSnapshot<Map<String, dynamic>>> foodItem;
  String foodId = 'eLpTKmM822QJgAENY81Y';  // Ensure this ID is correct

  @override
  void initState() {
    super.initState();
    foodItem = fetchFoodItem();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchFoodItem() async {
    return FirebaseFirestore.instance.collection('Menu').doc(foodId).get();
  }
  Future<void> addCartItem(Map<String, dynamic> item) async {
    String userId = FirebaseAuth.instance.currentUser!.uid; // Ensure the user is logged in

    CollectionReference cart = FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart');

    return cart.doc(item['itemName']).set({
      'name': item['itemName'],
      'imageUrl': item['imageUrl'],
      'price': item['price'],
      'quantity': aNumber,  // Default quantity
    })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add item: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: foodItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Safely access itemData using null checks or fallback values
          Map<String, dynamic> itemData = snapshot.data!.data() ?? {};
          if (itemData.isEmpty) {
            return const Text("No data found7");
          }
          return buildContent(context, itemData);
        },
      ),
    );
  }

  Widget buildContent(BuildContext context, Map<String, dynamic> itemData) {
    // Check each field for null before using
    String imageUrl = itemData['imageUrl'] as String? ?? 'default_image_path.jpg';
    String itemName = itemData['itemName'] as String? ?? 'No Name';
    double rating = (itemData['rating'] as num?)?.toDouble() ?? 0.0;
    double price = (itemData['price'] as num?)?.toDouble() ?? 0.0;

    return Container(
            margin: const EdgeInsets.only(top: 30, left: 10, right: 20),
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Column(children: [
                        Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.black)
                      ])),
                  Image.network(imageUrl,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2.5,
                    fit: BoxFit.fill,),
                  const SizedBox(height: 20,),


                  Row(

                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemName, //NEEDS TO BE DYNAMIC
                              style: AppWidget.boldTextFieldStyle()),
                        ],
                      ),
                      //Spacer() +> ensures maximum space between the two widgets
                      const Spacer(),

                      //Here lies the subtract button
                      GestureDetector(
                        onTap: () {
                          if (aNumber > 1) {
                            --aNumber;
                            setState(() {

                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black, borderRadius: BorderRadius
                              .circular(10)),
                          child: const Icon(Icons.remove, color: Colors.white,
                          ),

                        ),

                      ),
                      const SizedBox(width: 20,),
                      Text(aNumber.toString(),
                          style: AppWidget.semiBoldTextFieldStyle()),
                      const SizedBox(width: 20,),

                      //Here lies the add button
                      GestureDetector(
                        onTap: () {
                          ++aNumber;
                          setState(() {

                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black, borderRadius: BorderRadius
                              .circular(10)),
                          child: const Icon(Icons.add, color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),


                    ],),
                  const SizedBox(height: 20,),
                  Row(
                    children: [


                      Row(
                        children: [Icon(Icons.star, color: Colors.yellow[900],),
                          const SizedBox(width: 5,),
                          Text(
                              " ${rating.toStringAsFixed(1)}", style: AppWidget.semiBoldTextFieldStyle()),
                        ],),


                    ],),
                  const SizedBox(height: 20,),
                  Text(
                    itemData['description'],

                    style: AppWidget.lightTextFieldStyle(),
                    maxLines: 3,),
                  const SizedBox(height: 20,),
                  Text("Chef: ${itemData['chef']}",
                      style: AppWidget.semiBoldTextFieldStyle()),

                  const SizedBox(height: 20,),
                  Text("Allergens: ${itemData['allergens']}",
                      style: AppWidget.semiBoldTextFieldStyle()),
                  const SizedBox(height: 20,),
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Price:",
                                    style: AppWidget.boldTextFieldStyle()),
                                Text( " ${price.toStringAsFixed(2)}", style: AppWidget
                                    .headLineTextFieldStyle())

                              ]
                          ),
                          GestureDetector(
                            onTap: () {

                              Navigator.pop(context);
                              addCartItem(itemData);
                            },
                          child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.5,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  const Text("Add to Cart",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 20),),

                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const Icon(Icons.shopping_cart,
                                      //ON CLICK SET TO HOMEPAGE AND ADD ThiNGs TO CArt
                                      color: Colors.white,
                                      size: 20,),
                                  )
                                ],
                              )
                          ),
                          )
                        ]
                    ),
                  )
                ]),
          );

        }
  }

