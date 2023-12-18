import 'package:get/get.dart';

import '../models/product.dart';

//
class CartController extends GetxController {
  var count = 0.obs;
  var cartProducts = [].obs;
  //
  addProduct(Product product) {
    cartProducts.add(product);
    count += 1;
    update();
  }

  //
  removeProduct(int idx) {
    cartProducts.removeAt(idx);
    count -= 1;
    update();
  }
}
