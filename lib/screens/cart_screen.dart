import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) => Scaffold(
        appBar: AppBar(
          title: Text('Total products are ${cartController.count}'),
          
        ),
        body: ListView.builder(
          itemCount: cartController.cartProducts.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          top: 5,
                        ),
                        child: Image.network(
                          cartController.cartProducts[index].image,
                          height: 130,
                          width: MediaQuery.of(context).size.width * 0.25,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                cartController.cartProducts[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              cartController.cartProducts[index].category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  cartController
                                      .cartProducts[index].rating.count
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '  ★(${cartController.cartProducts[index].rating.rate})',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartController.cartProducts[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹ ${cartController.cartProducts[index].price}',
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Remove from Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () {
                                cartController.removeProduct(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
