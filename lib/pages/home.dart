
import "package:flutter/material.dart";
import "../widget/widget_support.dart";
import "food_details.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> fetchUserName() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return userData['name']; // Assuming 'name' is the field that stores user names.
  }
  return 'No Name'; // Default or error value
}
/* Future<String> fetchUserName() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return userData['name']; // Assuming 'name' is the field that stores user names.
  }
  return 'No Name'; // Default or error value*/

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool appetizer = false, main = false, dessert = false, soda = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top:30.0, left:20.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:FutureBuilder<String>(
                  future: fetchUserName(), // This calls the fetchUserName function
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                   if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading...", style: AppWidget.boldTextFieldStyle());
                   } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}", style: AppWidget.boldTextFieldStyle());
                    } else {
                     return Text("Hello ${snapshot.data}!",
                       style: AppWidget.boldTextFieldStyle(),
                    );
                  }
                },
              ),
              ),
              ///Here is the Shopping Cart Icon
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(10.0)
                ),
                child:const Icon(Icons.shopping_cart_checkout, size: 30.0, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20.0),
          Text("MANJU",
            style: AppWidget.headLineTextFieldStyle(),
          ),
          Text("Delicious food for you to enjoy",
            style: AppWidget.lightTextFieldStyle(),
          ),
          const SizedBox(height: 20.0),
         Container(
           margin: const EdgeInsets.only(right: 20.0),
             child: showItems()),
          const SizedBox(height: 20.0),

     SingleChildScrollView(
       scrollDirection: Axis.horizontal,
            child: Row(children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      const FoodDetails()));
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Image.asset("images/Salad.jpg",
                              height:150,
                              width:150,
                              fit: BoxFit.cover),
                              Text("Mediteranean Salad",
                                style: AppWidget.semiBoldTextFieldStyle(),),
                              const SizedBox(height: 5.0),
                              Text("\$8.50",
                                style: AppWidget.semiBoldTextFieldStyle(),)
                        ],
                      )
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),

              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(

                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        //need to fix this, the card is not dynamic
                        //enough to handle the text overflow
                        Image.asset("images/Salad.jpg",
                            height:150,
                            width:150,
                            fit: BoxFit.cover),
                        Text("Salad Bowl",
                          style: AppWidget.semiBoldTextFieldStyle(),),
                        const SizedBox(height: 5.0),
                        Text("\$8.50",
                          style: AppWidget.semiBoldTextFieldStyle(),)
                      ],
                    )
                ),
              ),
              const SizedBox(width: 10.0),

              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Image.asset("images/Salad.jpg",
                            height:150,
                            width:150,
                            fit: BoxFit.cover),
                        Text("Salad Bowl",
                          style: AppWidget.semiBoldTextFieldStyle(),),
                        const SizedBox(height: 5.0),
                        Text("\$8.50",
                          style: AppWidget.semiBoldTextFieldStyle(),)
                      ],
                    )
                ),
              ),

            ],),
          ),

          const SizedBox(height: 20.0),

          //Here starts the list menu
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("images/Salad.jpg",
                        height:90,
                        width:90,
                        fit: BoxFit.cover),
                    const SizedBox(width: 20.0),
                    Column(
                      children:[
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          //handles the text overflow by wrapping the text
                          child: Text("Mediterranean Salad with feta cheese",
                            style: AppWidget.semiBoldTextFieldStyle(),),
                        ),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          //handles the text overflow by wrapping the text
                          child: Text("\$8.50",
                            style: AppWidget.semiBoldTextFieldStyle(),),
                        ),
                      ]
                    ),
                    
                  ],
                ),
              ),
            ),
          )

        ],


                )
              ),
            );

  }







  Widget showItems(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        //wrap the container with material widget
        //appetizers
        GestureDetector(
          onTap:(){
            appetizer = true;
            main = false;
            dessert = false;
            soda = false;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: const EdgeInsets.all(2),
                child: Image.asset("images/Salad.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),//Main Course
        GestureDetector(
          onTap:(){
            appetizer = false;
            main = true;
            dessert = false;
            soda = false;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: const EdgeInsets.all(2),
                child: Image.asset("images/main.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),

        //Desserts
        GestureDetector(
          onTap:(){
            appetizer = false;
            main = false;
            dessert = true;
            soda = false;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: const EdgeInsets.all(2),
                child: Image.asset("images/dessert.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),
        //Drinks
        GestureDetector(
          onTap:(){
            appetizer = false;
            main = false;
            dessert = false;
            soda = true;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: const EdgeInsets.all(2),
                child: Image.asset("images/soda.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),
      ],
    );
  }
}

