import 'package:flutter/material.dart';
import 'ProductController.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = ProductController();

  void productDialog(
      {String? id,
      String? name,
      int? qty,
      String? img,
      int? unitPrice,
      int? totalPrice})
  {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productCodeController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productQtyController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    productNameController.text = name ?? '';
    productQtyController.text = qty.toString() ?? '';
    productImageController.text = img ?? '';
    productUnitPriceController.text = unitPrice.toString() ?? '';
    productTotalPriceController.text = totalPrice.toString() ?? '';

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(id == null ? 'Add product' : 'Update Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: productNameController,
                    decoration: InputDecoration(labelText: 'product name'),
                  ),
                  TextField(
                    controller: productCodeController,
                    decoration: InputDecoration(labelText: 'product code'),
                  ),
                  TextField(
                    controller: productImageController,
                    decoration: InputDecoration(labelText: 'product Image'),
                  ),
                  TextField(
                    controller: productQtyController,
                    decoration: InputDecoration(labelText: 'product Qty'),
                  ),
                  TextField(
                    controller: productUnitPriceController,
                    decoration:
                        InputDecoration(labelText: 'product unit price'),
                  ),
                  TextField(
                    controller: productTotalPriceController,
                    decoration: InputDecoration(labelText: 'Total price'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            if (id == null) {
                              productController.createProduct(
                                  productNameController.text,
                                  productCodeController.text,
                                  productImageController.text,
                                  int.parse(productQtyController.text),
                                  int.parse(productUnitPriceController.text),
                                  int.parse(productTotalPriceController.text));
                            } else {
                              productController.updateProduct(
                                  id,
                                  productNameController.text,
                                  productCodeController.text,
                                  productImageController.text,
                                  int.parse(productQtyController.text),
                                  int.parse(productUnitPriceController.text),
                                  int.parse(productTotalPriceController.text));
                            }

                            fetchData();
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Text(
                            id == null ? 'Add product' : 'Update product',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  Future<void> fetchData() async {
    await productController.fetchProduct();
    print(productController.products.length);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CRUD APP',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            var product = productController.products[index];
            return Card(
              elevation: 3,
              child: ListTile(
                leading: Image.network(
                  product.img.toString(),
                ),
                title: Text(product.productName.toString()),
                subtitle:
                    Text('Price: \$ ${product.unitPrice} | Qty:${product.qty}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => productDialog(
                              id: product.sId,
                              name: product.productName,
                              img: product.img,
                              qty: product.qty,
                              unitPrice: product.unitPrice,
                              totalPrice: product.totalPrice,
                            ),
                        icon: Icon(Icons.edit)),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            fetchData();
                            productController
                                .deleteProduct(product.sId.toString())
                                .then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Product deleted"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Something Wrong"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
