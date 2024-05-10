import 'package:flutter/material.dart';
import '../widget/widget_support.dart';
import "food_details.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CartDetails extends StatefulWidget {
  const CartDetails({super.key});

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  int aNumber = 1;
  Future<void> _updateCartAmount(int newAmount) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;  // Ensure the user is logged in
    String cartId = "HgqqLg8rdgmonMkQpYEk";  // You need to define how you get this ID

    try {
      await FirebaseFirestore.instance
          .doc('users/$userId/Carts/$cartId')
          .update({'Salad Bowl': newAmount});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating cart amount: $e'),backgroundColor: Colors.red));
      // Optionally handle errors, e.g., by showing a snackbar
    }
  }
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
                    "Restaurant Name",
                    style: AppWidget.headLineTextFieldStyle().copyWith(fontSize: 45),
                  ),
                  const SizedBox(height: 20.0),  // Space before the cards start
                ],
              ),
            ),
            buildCard("Salad Bowl", "images/Salad.jpg", "\$8.50",1),
            const SizedBox(height: 10.0),
            buildCard("Soda", "images/soda.jpg", "\$8.50",3),
            const SizedBox(height: 10.0),
            buildCard("Cake", "images/dessert.jpg", "\$8.50",2),
            const SizedBox(height: 50.0),  // Extra space at the bottom
          ],
        ),
      ),
    ),
    );
  }


  Widget buildCard(String title, String imagePath, String price, int amount) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodDetails())); //should be changed to order details function eventually
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                      Text(
                        title,
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        price,
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                    ],
                    ),
                  ),
                ),
                  AmountControl(amount: amount, onUpdate: (newAmount) {
                   setState(() {
                    amount = newAmount;
                    });
                   _updateCartAmount(newAmount);
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class AmountControl extends StatefulWidget {
  final int amount;
  final Function(int) onUpdate;

  const AmountControl({super.key, required this.amount, required this.onUpdate});

  @override
  _AmountControlState createState() => _AmountControlState();
}

class _AmountControlState extends State<AmountControl> {
  late int currentAmount;

  @override
  void initState() {
    super.initState();
    currentAmount = widget.amount;
  }

  void _increment() async {
    setState(() {
      currentAmount++;
    });
    widget.onUpdate(currentAmount);
  }

  void _decrement() {
    if (currentAmount > 0) {
      setState(() {
        currentAmount--;
      });
      widget.onUpdate(currentAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,  // Adjust size as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _decrement,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.red,  // Example color
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          Text('$currentAmount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: _increment,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.green,  // Example color
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
