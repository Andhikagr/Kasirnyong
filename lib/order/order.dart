import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:food_app/order/bayar.dart';
import 'package:food_app/order/pajak.dart';
import 'package:get/get.dart';

class Order extends StatefulWidget {
  final RxList<Map<String, dynamic>> pesananList;

  const Order({super.key, required this.pesananList});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final List<Map<String, dynamic>> totalOrder = [
    {"label": "Jumlah Item"},
    {"label": "Sub Total"},
    {"label": "Pajak"},
    {"label": "Total"},
  ];

  //hitung jumlah item
  int get jumlahItem {
    int total = 0;
    for (var item in widget.pesananList) {
      total += (item["jumlah"] as RxInt).value;
    }
    return total;
  }

  //hitung subtotal
  double get subTotal {
    double totalSub = 0;
    for (var itemSub in widget.pesananList) {
      final harga = itemSub["harga"] as double;
      final jumlah = (itemSub["jumlah"] as RxInt).value;
      totalSub += harga * jumlah;
    }
    return totalSub;
  }

  final pajakPersen = 0.0.obs;
  double get pajak => subTotal * (pajakPersen.value / 100);
  double get totalBayar => subTotal + pajak;

  @override
  void initState() {
    super.initState();
    DatabaseKasir.getPajak().then(
      (value) => pajakPersen.value = value.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Detail Pesanan"),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    Get.to(
                      () => Pajak(),
                      transition: Transition.native,
                      duration: Duration(milliseconds: 500),
                    )?.then((_) async {
                      final value = await DatabaseKasir.getPajak();
                      pajakPersen.value = value.toDouble();
                    }),
                icon: Icon(Icons.attach_money),
                tooltip: "pajak",
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Apakah kamu yakin?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              widget.pesananList.clear();
                              Get.back();
                            },
                            child: Text(
                              "Ya",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              "Batal",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete_sweep_sharp),
                tooltip: "Hapus",
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final list = widget.pesananList;
              if (list.isEmpty) {
                return Center(child: Text("Pesanan Kosong"));
              }
              return ListView.separated(
                separatorBuilder: (_, _) => Divider(indent: 16, endIndent: 16),
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final data = list[index];
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: Obx(() {
                        final jumlah = (data["jumlah"] as RxInt).value;
                        return Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "$jumlah x ",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        );
                      }),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["nama"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                (data["harga"] as num).toRupiah(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 5),
                              if ((data["diskon"] ?? 0) > 0)
                                Text(
                                  "-(${(data["diskon"] as num).toInt()}%)",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() {
                            final item = widget.pesananList[index];
                            final totalItem =
                                (item["harga"] as double) *
                                (item["jumlah"] as RxInt).value;
                            return Text(
                              totalItem.toRupiah(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          }),
                          SizedBox(width: 5),
                          InkWell(
                            splashColor: Colors.grey.shade400,
                            onTap: () {
                              final current =
                                  widget.pesananList[index]["jumlah"] as RxInt;
                              if (current.value > 1) {
                                current.value -= 1;
                              }
                            },
                            child: Icon(Icons.remove, color: Colors.deepPurple),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            splashColor: Colors.grey.shade400,
                            onTap: () {
                              widget.pesananList.removeAt(index);
                            },
                            child: Icon(
                              Icons.delete,
                              color: const Color(0xFFD10E00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 200,
        padding: EdgeInsets.only(top: 5, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: totalOrder.length,
                itemBuilder: (context, index) {
                  final data = totalOrder[index];
                  String label = data["label"];
                  return Obx(() {
                    String value = "";
                    if (label == "Jumlah Item") {
                      value = jumlahItem.toString();
                    } else if (label == "Sub Total") {
                      value = subTotal.toRupiah();
                    } else if (label == "Pajak") {
                      value =
                          "${pajakPersen.value % 1 == 0 ? pajakPersen.value.toInt() : pajakPersen.value}%";
                    } else if (label == "Total") {
                      value = totalBayar.toRupiah();
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            value,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (widget.pesananList.isEmpty) {
                      Get.snackbar("Ups", "Pesanan masih kosong");
                      return;
                    }
                    Get.to(
                      () => Bayar(totalBayar: totalBayar.toRupiah().obs),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                  child: Ink(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(
                        "Bayar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
