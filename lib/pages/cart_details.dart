import 'package:flutter/material.dart';
import 'package:manju_restaurant/pages/customer_order.dart';
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
  double subtotal = 0.0;  // Subtotal of the cart items
  String userId = FirebaseAuth.instance.currentUser!.uid;  // Ensure the user is logged in
  Future<void> _updateCartAmount(int newAmount,String itemName) async {
    String cartId = itemName ;  // You need to define how you get this ID

    try {
      await FirebaseFirestore.instance
          .doc('users/$userId/Cart/$cartId')
          .update({'quantity': newAmount});
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manju",
                    style: AppWidget.headLineTextFieldStyle().copyWith(fontSize: 45),
                  ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerOrder()));  // Assumes OrdersPage exists
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                      elevation: 5

                    ),
                    child: const Text('Orders'),
                  ),
              )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot> (
                stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Text("No items in cart");
                  }

                  double newSubtotal = 0.0; // Temporary variable to calculate subtotal
                  List<Widget> itemList = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    double price = double.parse(data['price'].toString());
                    int quantity = data['quantity'];
                    newSubtotal += price * quantity;  // Add to the subtotal for each item
                    return buildCard(data['name'], data['imageUrl'], "\$${price.toStringAsFixed(2)}", quantity);
                  }).toList();
                  // Update the state of subtotal after building the list
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (newSubtotal != subtotal) {
                      setState(() {
                        subtotal = newSubtotal;
                      });
                    }
                  });

                  return Column(children: itemList);
                },

            ),
            const SizedBox(height: 50.0),  // Extra space at the bottom
            // Subtotal Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${subtotal.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

        Padding(
          padding: const EdgeInsets.only(bottom: 80), // Adjust the padding to make room for the navigation bar
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodDetails()));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Proceed to Checkout'),
          ),
        ),
          ],
        ),

      ),
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),  // Adjust the position slightly above the bottom navigation bar
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodDetails()));
          },
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Go to checkout', style: TextStyle(fontSize: 16)),  // Adjust font size as necessary
          backgroundColor: Colors.blue,
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
                Image.network(
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
                   _updateCartAmount(newAmount, title);
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
