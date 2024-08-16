import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopy_client/controller/home_controller.dart';
import 'package:shopy_client/pages/login_page.dart';
import 'package:shopy_client/pages/product_description_page.dart';
import 'package:shopy_client/widgets/multi_select_drop_down.dart';
import 'package:shopy_client/widgets/product_card.dart';

import '../widgets/dropdown_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            centerTitle: true,
            title: Text(
              'Footwear Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  GetStorage box = GetStorage();
                  box.erase();
                  Get.offAll(LoginPage());
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.productCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ctrl.filterByCategory(
                            ctrl.productCategories[index].name ?? '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Chip(
                            label: Text(
                                ctrl.productCategories[index].name ?? 'Error')),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropDownBtn(
                        items: ['Rs: Low to High', 'Rs: High to Low'],
                        selectedItemText: 'Sort',
                        onSelected: (selected) {
                          ctrl.sortByPrice(
                              ascending:
                                  selected == 'Rs: Low to High' ? true : false);
                        },
                      ),
                    ),
                    Expanded(
                      child: MultiSelectDropDown(
                        items: [
                          'Adidas',
                          'Nike',
                          'Puma',
                          'Woodland',
                          'Sketchers'
                        ],
                        onSelectionChanged: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7, // Adjusted childAspectRatio
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ctrl.productShowInUi.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productShowInUi[index].name ?? 'No name',
                        imageUrl: ctrl.productShowInUi[index].image ?? 'url',
                        price: ctrl.productShowInUi[index].price ?? 00,
                        offerTag: '30% off',
                        onTap: () {
                          Get.to(const ProductDescription(),
                              arguments: {'data': ctrl.productShowInUi[index]});
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
