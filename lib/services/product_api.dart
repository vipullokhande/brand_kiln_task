
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/product.dart';

//
class ProductApi {
  //
  Future<List<Product>> fetchAllProducts() async {
    http.Response response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    return productFromJson(response.body);
  }

  //
  Future<List<Product>> fetchSorted() async {
    http.Response response = await http
        .get(Uri.parse('https://fakestoreapi.com/products?sort=desc'));
    return productFromJson(response.body);
  }

  //
  Future<List<Product>> fetchByCategory(String category) async {
    http.Response response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/category/$category'));
    return productFromJson(response.body);
  }

  //
  Future<List<String>> fetchCategories() async {
    http.Response response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/categories'));
    return [response.body];
  }

  //
  Future<Product> fetchSingle() async {
    http.Response response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/1'));
    return Product.fromJson(jsonDecode(response.body));
  }
}
