import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopy_client/models/product/product.dart';
import 'package:shopy_client/models/product_category.dart';

class HomeController extends GetxController {
  //creating an instance for handling database
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //products collection reference
  late CollectionReference productCollection;
//product Catewgory reference
  late CollectionReference catogoryCollection;
  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    //using this colliction we can add delete remove, update...
    productCollection = firestore.collection('Products');
    catogoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProducts);
      productShowInUi.assignAll(products);
      Get.snackbar('Success', 'Product fetch Successfuly',
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot catogorySnapshot = await catogoryCollection.get();
      final List<ProductCategory> retrievedCategories = catogorySnapshot.docs
          .map((doc) =>
              ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  filterByCategory(String category) {
    productShowInUi.clear();
    productShowInUi =
        products.where((product) => product.category == category).toList();
    update();
  }

  filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productShowInUi = products;
    } else {
      List<String> lowerCaseBrands =
          brands.map((brand) => brand.toLowerCase()).toList();

      productShowInUi = products
          .where((product) =>
              lowerCaseBrands.contains(product.brand?.toLowerCase()))
          .toList();
    }
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts = List<Product>.from(productShowInUi);
    sortedProducts.sort((a, b) => ascending
        ? a.price!.compareTo(b.price!)
        : b.price!.compareTo(a.price!));
    productShowInUi = sortedProducts;
    update();
  }
}
