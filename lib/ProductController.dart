import 'dart:convert';
import 'package:crud_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'model/product.dart';

class ProductController {
  List<Data> products = [];

  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse(Urls.readProduct));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      product productModel = product.fromJson(data);
      products = productModel.data ?? [];
    }
  }

  Future<void> createProduct(String name, String productCode, String img,
      int qty, int price, int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.createProduct),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ProductName": name,
          "ProductCode": productCode,
          "Img": img,
          "Qty": qty,
          "UnitPrice": price,
          "TotalPrice": totalPrice
        }));

    if (response.statusCode == 201) {
      fetchProduct();
    }
  }

  Future<void> updateProduct(String id, String name, String productCode,
      String img, int qty, int price, int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.updateProduct(id)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ProductName": name,
          "ProductCode": productCode,
          "Img": img,
          "Qty": qty,
          "UnitPrice": price,
          "TotalPrice": totalPrice
        }));

    if (response.statusCode == 201) {
      fetchProduct();
    }
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(id)));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
