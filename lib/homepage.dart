import 'package:flutter/material.dart';
import 'package:food_app/order.dart';
import 'package:food_app/widget/drawer_list.dart';

import 'package:food_app/widget/menu_list.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //menentukan posisi awal index
  int selectedIndex = 0;
  final List<String> menu = ["Makanan", "Minuman", "Snack"];

  List<Map<String, dynamic>> get filteredMenu {
    final selectedCategory = menu[selectedIndex];
    if (selectedCategory == "All") {
      return menuList;
    }
    return menuList
        .where((item) => item["Category"] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Kasirnyong",
            style: GoogleFonts.lobster(
              fontSize: 20,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  Text(
                    "Hari ini terjual :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "20 Item",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: MenuDrawer(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple,
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Bayar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rp.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "(0 Item)",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menu.length,
                  itemBuilder: (context, index) {
                    final menuItem = menu[index];
                    final bool isSelected = selectedIndex == index;
                    return Row(
                      children: [
                        if (index == 0) SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 60,
                              width: 120,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  menuItem,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    padding: EdgeInsets.only(bottom: 15),
                    itemCount: filteredMenu.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final burgerList = filteredMenu[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 1,
                              offset: Offset(1, 3),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 130,
                              width: 150,
                              child: Image.asset(
                                burgerList["image"],
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                burgerList["label"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                burgerList["price"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () => Get.to(
            () => Order(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 300),
          ),
          child: Icon(Icons.point_of_sale, color: Colors.white),
        ),
      ),
    );
  }
}
