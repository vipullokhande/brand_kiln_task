import 'package:brand_kiln_task/controllers/cart_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../services/product_api.dart';
import 'authentication/login_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var cartController = Get.put(CartController());
  var searchController = TextEditingController();
  bool isSort = false;
  bool isLoading = false;
  bool isSearch = false;
  List<Product> list = [];
  List<Product> search = [];
  List<String> categories = [
    'electronics',
    'jewelery',
    'men\'s clothing',
    'women\'s clothing',
  ];
  //
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isSort = false;
      isLoading = true;
    });
    ProductApi().fetchAllProducts().then((value) {
      setState(() {
        list = value;
        isLoading = false;
      });
    });
  }

  //
  getFiltered() async {
    setState(() {
      isSort = true;
      isLoading = true;
    });
    ProductApi().fetchSorted().then((value) {
      setState(() {
        list = value;
        isLoading = false;
      });
    });
  }

  //
  fetchByCategory(int index) async {
    setState(() {
      isLoading = true;
    });
    ProductApi().fetchByCategory(categories[index]).then((value) {
      setState(() {
        list = value;
        isLoading = false;
      });
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );
    //
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            if (isSort) {
              getData();
            } else {
              getFiltered();
            }
            setState(() {});
          },
          icon: Column(
            children: [
              Icon(
                !isSort ? Icons.filter_list : Icons.filter_list_off,
              ),
              Text(
                isSort ? 'Unsort' : 'Sort',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        title: SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextField(
            autofocus: false,
            controller: searchController,
            keyboardType: TextInputType.text,
            onSubmitted: (value) async {
              if (value.isEmpty) {
                setState(() {
                  isLoading = false;
                  isSearch = false;
                });
                return;
              }
              if (value.isNotEmpty) {
                setState(() {
                  isLoading = true;
                  isSearch = true;
                });
                await ProductApi().fetchSingle().then((value) {
                  search.add(value);
                });
                setState(() {
                  isLoading = false;
                });
                return;
              }
            },
            decoration: InputDecoration(
              border: inputBorder,
              hintText: 'Search',
              suffix: IconButton(
                onPressed: () {
                  if (searchController.text.isEmpty) {
                    if (isSearch) {
                      setState(() {
                        isSearch = false;
                      });
                      return;
                    }
                  }
                  if (searchController.text.isNotEmpty) {
                    searchController.clear();
                    search.clear();
                    if (isSearch) {
                      setState(() {
                        isSearch = false;
                      });
                    }
                    return;
                  }
                },
                icon: const Icon(
                  Icons.clear,
                ),
              ),
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 48, 48, 48),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getData();
            },
            icon: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_alt_off,
                ),
                Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(
                () => const CartScreen(),
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.red,
                    child: GetBuilder<CartController>(
                      builder: (c) => Text(
                        c.count.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                isLoading = false;
              });
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: SizedBox(
                      height: 45,
                      width: 100,
                      child: ActionChip(
                        shape: const StadiumBorder(),
                        onPressed: () {
                          fetchByCategory(index);
                        },
                        label: Text(
                          categories[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: isSearch ? search.length : list.length,
              scrollDirection: Axis.vertical,
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
                              isSearch
                                  ? search[index].image
                                  : list[index].image,
                              height: 130,
                              width: MediaQuery.of(context).size.width * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    isSearch
                                        ? search[index].title
                                        : list[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  isSearch
                                      ? search[index].category
                                      : list[index].category,
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
                                      isSearch
                                          ? search[index].rating.toString()
                                          : list[index].rating.count.toString(),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      '  ★(${isSearch ? search[index].rating.rate : list[index].rating.rate})',
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
                              isSearch
                                  ? search[index].description
                                  : list[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹ ${isSearch ? search[index].price : list[index].price}',
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
                                    'Add to Cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    cartController.addProduct(
                                      Product(
                                        id: list[index].id,
                                        title: list[index].title,
                                        price: list[index].price,
                                        description: list[index].description,
                                        category: list[index].category,
                                        image: list[index].image,
                                        rating: list[index].rating,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${list[index].title} ',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              const Text(
                                                'added in Cart',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
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
    );
  }
}
