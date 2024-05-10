import 'package:flutter/material.dart';
import "../widget/widget_support.dart";
import "food_details.dart";
import "cart_details.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerOrder extends StatefulWidget {
  const CustomerOrder({super.key});

  @override
  State<CustomerOrder> createState() => _CustomerOrderState();
}

class _CustomerOrderState extends State<CustomerOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(  // Ensures nothing goes under system status or navigation bars
        child: SingleChildScrollView(  // Allows vertical scrolling
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),  // Added padding to match the original design
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Carts",
                      style: AppWidget.headLineTextFieldStyle().copyWith(fontSize: 45),
                    ),
                    Text(
                      "Saved for your convenience",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    const SizedBox(height: 20.0),  // Space before the cards start
                  ],
                ),
              ),
              buildCard("Cart 1", "images/Salad.jpg", "\$8.50"),
              const SizedBox(height: 10.0),
              buildCard("Cart 2", "images/Salad.jpg", "\$8.50"),
              const SizedBox(height: 10.0),
              buildCard("Cart 3", "images/Salad.jpg", "\$8.50"),
              const SizedBox(height: 10.0),
              buildCard("Cart 4", "images/Salad.jpg", "\$8.50"),
              const SizedBox(height: 50.0),  // Extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }


  Widget buildCard(String title, String imagePath, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartDetails())); //should be changed to order details function eventually
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                Text(
                  title,
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                const SizedBox(height: 5.0),
                Text(
                  price,
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
