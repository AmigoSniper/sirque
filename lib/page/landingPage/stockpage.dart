// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:salescheck/component/searchBar.dart';
import 'package:salescheck/page/Barang/addBarang.dart';
import 'package:salescheck/page/Barang/addCategory.dart';
import 'package:salescheck/page/Barang/editBarang.dart';
import 'package:salescheck/page/Barang/editCategory.dart';
import 'package:toastification/toastification.dart';

class Stockpage extends StatefulWidget {
  const Stockpage({super.key});

  @override
  State<Stockpage> createState() => _StockpageState();
}

class _StockpageState extends State<Stockpage> {
  TextEditingController search = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  final numberFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  // Kategori yang dipilih
  Map<String, bool> selectedCategories = {};
  Map<String, bool> selectedProducts = {};
  Map<String, int> quantityProduct = {};
  List<Map<String, dynamic>> displayedProducts = [];
  String searchQuery = '';
  int totalAmount = 0;
  int totalBarang = 0;
  List<String> searchBarang = [];
  List<int> searchstock = [];
  List<int> searchnominal = [];
  Map<String, List<Map<String, dynamic>>> product = {
    'Bola Olahraga': [
      {
        'name': 'Baju Polos',
        'price': 100000,
        'stock': 50,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Baju Batik',
        'price': 150000,
        'stock': 30,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Baju Kemeja',
        'price': 200000,
        'stock': 20,
        'quantity': 0,
        'active': false
      },
      {
        'name': 'Baju Muslim',
        'price': 175000,
        'stock': 25,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Baju Kaos',
        'price': 85000,
        'stock': 60,
        'quantity': 0,
        'active': true
      }
    ],
    'Kaos': [
      {
        'name': 'Kaos Polos',
        'price': 80000,
        'stock': 40,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Kaos Lengan Panjang',
        'price': 90000,
        'stock': 35,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Kaos Band',
        'price': 95000,
        'stock': 50,
        'quantity': 0,
        'active': false
      },
      {
        'name': 'Kaos Raglan',
        'price': 75000,
        'stock': 45,
        'quantity': 0,
        'active': true
      }
    ],
    'Celana': [
      {
        'name': 'Celana Jeans',
        'price': 120000,
        'stock': 25,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Celana Pendek',
        'price': 70000,
        'stock': 60,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Celana Chino',
        'price': 130000,
        'stock': 30,
        'quantity': 0,
        'active': false
      },
      {
        'name': 'Celana Kargo',
        'price': 140000,
        'stock': 20,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Celana Bahan',
        'price': 110000,
        'stock': 40,
        'quantity': 0,
        'active': true
      }
    ],
    'Sepatu': [
      {
        'name': 'Sepatu Sneakers',
        'price': 250000,
        'stock': 15,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Sepatu Boots',
        'price': 300000,
        'stock': 10,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Sepatu Lari',
        'price': 220000,
        'stock': 20,
        'quantity': 0,
        'active': false
      },
      {
        'name': 'Sepatu Formal',
        'price': 320000,
        'stock': 12,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Sepatu Futsal',
        'price': 180000,
        'stock': 25,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Sepatu Sandal',
        'price': 100000,
        'stock': 50,
        'quantity': 0,
        'active': false
      }
    ],
    'Sandal': [
      {
        'name': 'Sandal Jepit',
        'price': 50000,
        'stock': 70,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Sandal Gunung',
        'price': 85000,
        'stock': 40,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Sandal Kulit',
        'price': 150000,
        'stock': 25,
        'quantity': 0,
        'active': false
      },
      {
        'name': 'Sandal Selop',
        'price': 60000,
        'stock': 60,
        'quantity': 0,
        'active': true
      }
    ],
    'Jaket': [
      {
        'name': 'Jaket Kulit',
        'price': 350000,
        'stock': 10,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Jaket Denim',
        'price': 250000,
        'stock': 20,
        'quantity': 0,
        'active': true
      },
      {
        'name': 'Jaket Bomber',
        'price': 300000,
        'stock': 15,
        'quantity': 0,
        'active': false
      },
      {
        'name': 'Jaket Parasut',
        'price': 200000,
        'stock': 25,
        'quantity': 0,
        'active': true
      }
    ],
    'Topi': [],
  };

  @override
  void initState() {
    super.initState();
    // Inisialisasi semua kategori dengan status tidak dipilih (false)
    selectedCategories['Semua'] = true;
    sortProductsByActive();
    product.forEach((category, products) {
      selectedCategories[category] = false;
      products.forEach((prod) {
        selectedProducts[prod['name']] = false;
      });
    });
    _showAllProducts();
    totalBarang = _getTotalItems();
  }

  // Function untuk menghitung total barang dari semua kategori
  int _getTotalItems() {
    int total = 0;
    product.forEach((category, items) {
      print(items.length);
      total += items.length; // Tambahkan jumlah item di setiap kategori
    });
    return total;
  }

  // Tampilkan semua produk dari semua kategori
  void _showAllProducts() {
    displayedProducts = [];
    product.forEach((category, products) {
      displayedProducts.addAll(products);
    });
  }

  //Method Mengurutkan Nama
  void sortProductsByActive() {
    product.forEach((key, productList) {
      productList.sort((a, b) {
        // Produk dengan 'active: true' akan muncul sebelum 'active: false'
        if (a['active'] == b['active']) return 0;
        return a['active'] ? -1 : 1;
      });
    });
  }

  // Function untuk menghitung total barang dalam satu kategori
  int _getTotalItemsInCategory(String category) {
    if (product.containsKey(category)) {
      return product[category]!.length; // Kembalikan jumlah item di kategori
    }
    return 0; // Jika kategori tidak ditemukan
  }

  // Function untuk menampilkan produk berdasarkan kategori dan query pencarian
  List<Map<String, dynamic>> _getFilteredProducts() {
    List<Map<String, dynamic>> filteredProducts = [];

    // Cek apakah kategori "Semua" dipilih
    if (selectedCategories['Semua'] == true) {
      // Jika "Semua" dipilih, tampilkan semua produk
      product.forEach((category, products) {
        filteredProducts.addAll(products);
      });
    } else if (selectedCategories.values.every((isSelected) => !isSelected)) {
      // Jika tidak ada kategori yang dipilih, tampilkan semua produk
      product.forEach((category, products) {
        filteredProducts.addAll(products);
      });
    } else {
      // Jika ada kategori yang dipilih selain "Semua"
      selectedCategories.forEach((category, isSelected) {
        if (isSelected && category != 'Semua') {
          filteredProducts.addAll(product[category]!);
        }
      });
    }

    // Filter berdasarkan kata kunci pencarian jika ada
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
              product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredProducts;
  }

//Mendapatkan jumlah stock
  int getQuantity(String productName) {
    return quantityProduct[productName] ?? 0;
  }

// Menambah jumlah barang (dengan batas maksimal stok)
  void incrementQuantity(Map<String, dynamic> product) {
    setState(() {
      if (getQuantity(product['name']) < product['stock']) {
        quantityProduct[product['name']] =
            (quantityProduct[product['name']] ?? 0) + 1;
      }
    });
  }

  // Mengurangi jumlah barang (jika 0, hapus dari daftar terpilih)
  void decrementQuantity(Map<String, dynamic> product) {
    setState(() {
      if (getQuantity(product['name']) > 1) {
        quantityProduct[product['name']] =
            quantityProduct[product['name']]! - 1;
      } else {
        quantityProduct.remove(product['name']);
        selectedProducts[product['name']] = false; // Hapus status selected
      }
    });
  }

  void notif(String title) {
    toastification.show(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        autoCloseDuration: const Duration(seconds: 8),
        progressBarTheme: const ProgressIndicatorThemeData(
            color: Color(0xFFFFFFFF), linearTrackColor: Color(0xFFCDCDCD)),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        primaryColor: const Color(0xFF28A745),
        backgroundColor: Colors.black,
        context: context,
        showProgressBar: false,
        closeOnClick: true,
        closeButtonShowType: CloseButtonShowType.always,
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFFFFFFFF),
        ),
        title: const Text(
          'Berhasil',
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w700,
              fontSize: 12),
        ),
        description: Text(
          title,
          style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ));
  }

  void _showAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFDFEFE),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 36,
              top: 25,
              right: 32,
              left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Addcategory()));
                  if (result != null) {
                    notif(result);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tambah Kategori',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0B0C17)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Gunakan untuk mengelompokan barang.',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFA3A3A3)),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: Color(0xFF9CA3AF),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                color: const Color(0xFF000000).withOpacity(0.1),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Addbarang()));
                  if (result != null) {
                    notif(result);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tambah Barang',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0B0C17)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Tambahkan barang sesuai kategori yang telah dibuat.',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFA3A3A3)),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: Color(0xFF9CA3AF),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                color: const Color(0xFF000000).withOpacity(0.1),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuickAction(
      BuildContext context,
      String namaBarang,
      int harga,
      String deskripsi,
      String category,
      bool status,
      int Stock,
      String imageUrl) {
    final TextEditingController stockValue = TextEditingController();
    int stockModal;
    stockValue.text = Stock.toString();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFDFEFE),
      builder: (BuildContext context) {
        bool stokcTakTerbatas = false;
        bool statusActive = status;
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 25,
                  top: 16,
                  right: 16,
                  left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset('asset/image/info-circle.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Item ini ${statusActive ? 'tersedia' : 'tidak'} dan ${stokcTakTerbatas ? 'tidak ada batas stok' : 'punya batas stok'}',
                          style: const TextStyle(
                              color: Color(0xFFE5851F),
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 140,
                            height: 140,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'asset/barang/Rectangle 894.png',
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          width: 187,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                namaBarang,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF303030)),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                'Bola berwarna hijau untuk berman tenis',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF9399A7)),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                numberFormat.format(harga),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF303030)),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                // width: 77,
                                height: 24,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF8F8F8)),
                                padding: EdgeInsets.zero,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Editbarang(
                                                    name: namaBarang,
                                                    deskripis: deskripsi,
                                                    category: category,
                                                    harga: harga,
                                                    imageUrl: imageUrl,
                                                  )));
                                      if (result != null) {
                                        final message = result['message'];
                                        final isDeleted = result['isDeleted'];
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        print(message);
                                        print(isDeleted);
                                        if (isDeleted == true) {
                                          setState(() {
                                            //delete item
                                            product[category]?.removeWhere(
                                                (item) =>
                                                    item['name'] == namaBarang);
                                          });
                                          notif(message);
                                        } else {
                                          notif(message);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      shadowColor: Colors.transparent,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      backgroundColor: const Color(0xFFF8F8F8),
                                    ),
                                    child: const Text(
                                      'Edit Detail',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0EA5E9)),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF303030)),
                      ),
                      SizedBox(
                          width: 44,
                          height: 24,
                          child: CupertinoSwitch(
                            activeColor: const Color(0xFF10B981),
                            trackColor: const Color(0xFFE2E8F0),
                            thumbColor: const Color(0xFFFFFFFF),
                            value: statusActive,
                            onChanged: (value) {
                              print('tekan');
                              print(value);
                              setModalState(() {
                                statusActive = value;
                              });
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Stok tak terbatas',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF303030)),
                      ),
                      SizedBox(
                          width: 44,
                          height: 24,
                          child: CupertinoSwitch(
                            activeColor: const Color(0xFF10B981),
                            trackColor: const Color(0xFFE2E8F0),
                            thumbColor: const Color(0xFFFFFFFF),
                            value: stokcTakTerbatas,
                            onChanged: (value) {
                              setModalState(() {
                                stokcTakTerbatas = value;
                              });
                            },
                          )),
                    ],
                  ),
                  stokcTakTerbatas
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFEEEEEE),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Jumlah Stock',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF303030)),
                                ),
                                Container(
                                  width: 115,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Color(0xFFF4F4F5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          stockModal =
                                              int.parse(stockValue.text);
                                          if (stockModal > 0) {
                                            setModalState(() {
                                              stockModal =
                                                  (stockModal ?? 0) - 1;
                                              stockValue.text =
                                                  stockModal.toString();
                                            });
                                          } else {
                                            null;
                                          }
                                        },
                                        icon: const Icon(
                                            size: 24,
                                            Icons.remove_circle,
                                            color: Color(0xFF2E6CE9)),
                                      ),
                                      Container(
                                        width: 35,
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          controller: stockValue,
                                          maxLength: 3,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Isi data lebih dahulu';
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          style: const TextStyle(
                                              color: Color(0xFF101010),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          decoration: const InputDecoration(
                                              isCollapsed: true,
                                              isDense: true,
                                              counterText: '',
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Color(0xFFA8A8A8)),
                                              hintText: '1',
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          stockModal =
                                              int.parse(stockValue.text);
                                          setModalState(() {
                                            stockModal = (stockModal ?? 0) + 1;
                                            stockValue.text =
                                                stockModal.toString();
                                          });
                                        },
                                        icon: const Icon(
                                            size: 24,
                                            Icons.add_circle,
                                            color: Color(0xFF2E6CE9)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          notif('Stok $namaBarang berhasil diedit');
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            backgroundColor: const Color(0xFF0D50D7),
                            minimumSize: const Size(double.infinity, 50)),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF)),
                        )),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refreshData() async {
    // Simulasi delay untuk menunggu data baru
    await Future.delayed(const Duration(seconds: 2));
    product.clear();
    // Perbarui data dan setState untuk memperbarui tampilan
    setState(() {
      product = {
        'Bola Olahraga': [
          {
            'name': 'Baju Polos',
            'price': 100000,
            'stock': 50,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Baju Batik',
            'price': 150000,
            'stock': 30,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Baju Kemeja',
            'price': 200000,
            'stock': 20,
            'quantity': 0,
            'active': false
          },
          {
            'name': 'Baju Muslim',
            'price': 175000,
            'stock': 25,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Baju Kaos',
            'price': 85000,
            'stock': 60,
            'quantity': 0,
            'active': true
          }
        ],
        'Kaos': [
          {
            'name': 'Kaos Polos',
            'price': 80000,
            'stock': 40,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Kaos Lengan Panjang',
            'price': 90000,
            'stock': 35,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Kaos Band',
            'price': 95000,
            'stock': 50,
            'quantity': 0,
            'active': false
          },
          {
            'name': 'Kaos Raglan',
            'price': 75000,
            'stock': 45,
            'quantity': 0,
            'active': true
          }
        ],
        'Celana': [
          {
            'name': 'Celana Jeans',
            'price': 120000,
            'stock': 25,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Celana Pendek',
            'price': 70000,
            'stock': 60,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Celana Chino',
            'price': 130000,
            'stock': 30,
            'quantity': 0,
            'active': false
          },
          {
            'name': 'Celana Kargo',
            'price': 140000,
            'stock': 20,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Celana Bahan',
            'price': 110000,
            'stock': 40,
            'quantity': 0,
            'active': true
          }
        ],
        'Sepatu': [
          {
            'name': 'Sepatu Sneakers',
            'price': 250000,
            'stock': 15,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Sepatu Boots',
            'price': 300000,
            'stock': 10,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Sepatu Lari',
            'price': 220000,
            'stock': 20,
            'quantity': 0,
            'active': false
          },
          {
            'name': 'Sepatu Formal',
            'price': 320000,
            'stock': 12,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Sepatu Futsal',
            'price': 180000,
            'stock': 25,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Sepatu Sandal',
            'price': 100000,
            'stock': 50,
            'quantity': 0,
            'active': false
          }
        ],
        'Sandal': [
          {
            'name': 'Sandal Jepit',
            'price': 50000,
            'stock': 70,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Sandal Gunung',
            'price': 85000,
            'stock': 40,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Sandal Kulit',
            'price': 150000,
            'stock': 25,
            'quantity': 0,
            'active': false
          },
          {
            'name': 'Sandal Selop',
            'price': 60000,
            'stock': 60,
            'quantity': 0,
            'active': true
          }
        ],
        'Jaket': [
          {
            'name': 'Jaket Kulit',
            'price': 350000,
            'stock': 10,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Jaket Denim',
            'price': 250000,
            'stock': 20,
            'quantity': 0,
            'active': true
          },
          {
            'name': 'Jaket Bomber',
            'price': 300000,
            'stock': 15,
            'quantity': 0,
            'active': false
          },
          {
            'name': 'Jaket Parasut',
            'price': 200000,
            'stock': 25,
            'quantity': 0,
            'active': true
          }
        ],
        'Topi': [],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffF6F8FA),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Inventori',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF121212)),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Searchbar(
                        hintText: 'Cari Barang',
                        onChanged: (p0) {
                          setState(() {
                            searchQuery = search.text;
                          });
                        },
                        controller: search)
                  ],
                )),
            Expanded(
                child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            itemCount: product.keys.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              String category = product.keys.elementAt(index);
                              List<Map<String, dynamic>> productsInCategory =
                                  _getFilteredProducts().where((prod) {
                                // Filter produk yang hanya sesuai dengan kategori saat ini
                                return product[category]!.contains(prod);
                              }).toList();

                              List<Map<String, dynamic>> products =
                                  product[category]!;
                              int totalbarang =
                                  _getTotalItemsInCategory(category);
                              return ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                shape: const Border(),
                                title: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            category,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Color(0xFF303030)),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            width: 80,
                                            height: 17,
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero),
                                              onPressed: () async {
                                                final result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Editcategory(
                                                                  category:
                                                                      category,
                                                                )));
                                                if (result.isNotEmpty) {
                                                  notif(result);
                                                }
                                              },
                                              child: const Text(
                                                'Edit Kategori',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Color(0xFF2E6CE9)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '$totalbarang Products',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Color(0xFF717179)),
                                      ),
                                    ],
                                  ),
                                ),
                                children: [
                                  totalbarang == 0
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Divider(
                                              thickness: 1,
                                              color: Color(0xFFEEEEEE),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  right: 8, bottom: 16),
                                              child: const Text(
                                                'Belum ada barang yang ditambahkan',
                                                style: TextStyle(
                                                    color: Color(0xFFB1B5C0),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: productsInCategory.length,
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic>? prod =
                                                productsInCategory[index];

                                            String harga = numberFormat.format(
                                                int.parse(
                                                    prod['price'].toString()));
                                            bool status = prod['active'];
                                            bool isSelected = selectedProducts[
                                                    prod['name']] ??
                                                false;
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    String deskripsi =
                                                        'Bola ini hijau';
                                                    String imageUrl =
                                                        'Bola ini hijau';
                                                    _showQuickAction(
                                                        context,
                                                        prod['name'],
                                                        int.parse(
                                                            harga.replaceAll(
                                                                RegExp(
                                                                    r'[^\d]'),
                                                                '')),
                                                        deskripsi,
                                                        category,
                                                        status,
                                                        prod['stock'],
                                                        imageUrl);
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: status
                                                          ? (isSelected
                                                              ? const Color(
                                                                  0xFF2E6CE9)
                                                              : const Color(
                                                                  0xFFFFFFFF))
                                                          : const Color(
                                                              0xFFEEEEEE),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  width: 50,
                                                                  height: 52,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .blue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: Image
                                                                        .asset(
                                                                      'asset/barang/Rectangle 894.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: 50,
                                                                      height:
                                                                          52,
                                                                    ),
                                                                  )),
                                                              const SizedBox(
                                                                width: 16,
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      prod[
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              14,
                                                                          color: status
                                                                              ? (isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF303030))
                                                                              : const Color(0xFF979899)),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          harga,
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color(0xFF979899)),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .circle,
                                                                          color:
                                                                              const Color(0xFF979899).withOpacity(0.5),
                                                                          size:
                                                                              4,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                          'Stock: ${prod['stock']}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: status ? const Color(0xFF979899) : const Color(0xFF979899)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          // width: 47,
                                                          // height: 24,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              final result =
                                                                  await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => Editbarang(
                                                                                name: prod['name'],
                                                                                deskripis: 'Ulalala',
                                                                                category: category,
                                                                                harga: prod['price'],
                                                                                imageUrl: 'Bola ini hijau',
                                                                              )));
                                                              if (result !=
                                                                  null) {
                                                                final message =
                                                                    result[
                                                                        'message'];
                                                                final isDeleted =
                                                                    result[
                                                                        'isDeleted'];
                                                                // ignore: use_build_context_synchronously

                                                                if (isDeleted ==
                                                                    true) {
                                                                  setState(() {
                                                                    product[category]?.removeWhere((item) =>
                                                                        item[
                                                                            'name'] ==
                                                                        prod[
                                                                            'name']);
                                                                  });
                                                                  notif(
                                                                      message);
                                                                } else {
                                                                  notif(
                                                                      message);
                                                                }
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  'Edit',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color(
                                                                          0xFF2E6CE9),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  'asset/image/edit.svg',
                                                                  width: 16,
                                                                  height: 16,
                                                                  color: const Color(
                                                                      0xFF2E6CE9),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                  totalbarang == 0
                                      ? const SizedBox.shrink()
                                      : const Divider(
                                          thickness: 1,
                                          color: Color(0xFFEEEEEE),
                                        ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      )),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              _showAdd(context);
                            },
                            child: Container(
                              height: 48.0,
                              // width: 170,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    offset: const Offset(2, 4),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ],
                                color: const Color(0xFF2E6CE9),
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Tambah Produk',
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ))
              ],
            )),
          ],
        ));
  }
}
