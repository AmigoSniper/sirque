import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:salescheck/component/filterChip.dart';
import 'package:salescheck/component/searchBar.dart';

import 'package:salescheck/page/Transaksi/detailTransaksi.dart';

import '../../Model/selectedProduct.dart';
import '../../component/customButtonPrimary.dart';

class Transaksiadd extends StatefulWidget {
  const Transaksiadd({super.key});

  @override
  State<Transaksiadd> createState() => _TransaksiaddState();
}

class _TransaksiaddState extends State<Transaksiadd> {
  final ScrollController _scrollControllerCategory = new ScrollController();
  final ScrollController _scrollController = new ScrollController();
  final ScrollController _scrollControllerbarang = new ScrollController();
  final TextEditingController _searchControler = new TextEditingController();
  final numberFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  bool isGalerry = false;
  File? _image;
  final Map<String, List<Map<String, dynamic>>> product = {
    'Baju': [
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
    ]
  };

  // Kategori yang dipilih
  Map<String, bool> selectedCategories = {};
  Map<String, bool> selectedProducts = {};
  Map<String, int> quantityProduct = {};
  List<Map<String, dynamic>> displayedProducts = [];
  int totalAmount = 0;
  int totalBarang = 0;
  String searchQuery = '';

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

// Mendapatkan detail produk berdasarkan nama
  Map<String, dynamic> _getProductDetailByName(String productName) {
    for (var products in product.values) {
      for (var prod in products) {
        if (prod['name'] == productName) {
          return prod;
        }
      }
    }
    return {};
  }

  // Tampilkan semua produk dari semua kategori
  void _showAllProducts() {
    displayedProducts = [];
    product.forEach((category, products) {
      displayedProducts.addAll(products);
    });
  }

  // Fungsi untuk memperbarui total harga saat produk dipilih atau tidak dipilih
  void _updateTotalAmount() {
    setState(() {
      totalAmount = quantityProduct.entries.fold(0, (sum, entry) {
        // Ambil detail produk berdasarkan nama produk (key)
        var productDetail = _getProductDetailByName(entry.key);

        // Kalikan harga produk dengan jumlah yang dipilih
        int productPrice = int.parse(productDetail['price'].toString());
        int quantity = entry.value; // Jumlah produk yang dipilih

        // Tambahkan ke total
        return sum + (productPrice * quantity);
      });
    });
    print(totalAmount);
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

  // Mengambil jumlah barang terpilih untuk produk
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

  //function untuk melihat jumlah barang yang dipilih sesuai category
  int getSelectedItemsInCategory(String category) {
    int totalSelected = 0;

    // Cek apakah kategori ada di dalam product map
    if (product.containsKey(category)) {
      // Loop melalui semua produk dalam kategori tertentu
      for (var productItem in product[category]!) {
        String productName = productItem['name'];

        // Cek apakah produk dipilih, hanya hitung produk satu kali meskipun quantity bertambah
        if (selectedProducts[productName] == true &&
            quantityProduct.containsKey(productName) &&
            quantityProduct[productName]! > 0) {
          // Tambahkan 1 ke totalSelected jika produk dipilih (hanya hitung satu kali per produk)
          totalSelected++;
        }
      }
    }

    return totalSelected;
  }

//function untuk melihat jumlah barang yang dipilih semua
  int getTotalSelectedItems() {
    int totalSelected = 0;

    // Loop melalui seluruh quantityProduct dan hitung jumlah totalnya
    quantityProduct.forEach((productName, quantity) {
      if (selectedProducts[productName] == true &&
          quantityProduct.containsKey(productName) &&
          quantityProduct[productName]! > 0) {
        // Tambahkan 1 ke totalSelected jika produk dipilih (hanya hitung satu kali per produk)
        totalSelected++;
      }
    });

    return totalSelected;
  }

//function mendapatkan setiap brang yang dilist
  List<SelectedProduct> getSelectedProducts() {
    List<SelectedProduct> selectedProductsList = [];

    product.forEach((category, products) {
      for (var prod in products) {
        String productName = prod['name'];
        if (selectedProducts[productName] == true &&
            quantityProduct[productName]! > 0) {
          selectedProductsList.add(
            SelectedProduct(
              name: prod['name'],
              stock: prod['stock'],
              quantity: quantityProduct[productName]!,
              price: prod['price'],
            ),
          );
        }
      }
    });

    return selectedProductsList;
  }

  int getTotalSelectItemQuantity() {
    int quantity = 0;
    product.forEach((category, products) {
      for (var prod in products) {
        String productName = prod['name'];
        if (selectedProducts[productName] == true &&
            quantityProduct[productName]! > 0) {
          quantity += quantityProduct[productName]!;
        }
      }
    });

    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffF6F8FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F8FA),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Transaksi Baru',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF121212)),
          ),
        ),
        body: SafeArea(
            bottom: true,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Searchbar(
                        hintText: 'Cari sesuai nama',
                        onChanged: (p0) {
                          searchQuery = _searchControler.text;
                        },
                        controller: _searchControler,
                      ),
                      Container(
                        height: 55,
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isGalerry = !isGalerry;
                                });
                              },
                              iconSize: 24,
                              icon: isGalerry
                                  ? SvgPicture.asset(
                                      'asset/image/galeryView.svg')
                                  : SvgPicture.asset(
                                      'asset/image/tabler-icon-list-check.svg'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollControllerCategory,
                                child: Row(
                                  children: [
                                    FilterChip(
                                      backgroundColor: const Color(0xFFFFFFFF),
                                      selectedColor: const Color(0xFF2E6CE9),
                                      side: BorderSide.none,
                                      showCheckmark: false,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      label: Container(
                                        alignment: Alignment.center,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Semua',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: selectedCategories[
                                                            'Semua'] ==
                                                        true
                                                    ? const Color(0xFFFFFFFF)
                                                    : const Color(0xFF00409A),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: selectedCategories[
                                                              'Semua'] ==
                                                          true
                                                      ? const Color(0xFFFFFFFF)
                                                      : const Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                              child: Text(
                                                '$totalBarang',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  color: selectedCategories[
                                                              'Semua'] ==
                                                          true
                                                      ? const Color(0xFF2E6CE9)
                                                      : const Color(0xFF979899),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      selected:
                                          selectedCategories['Semua'] ?? false,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            selectedCategories
                                                .forEach((key, value) {
                                              selectedCategories[key] = key ==
                                                  'Semua'; // Select only "Semua"
                                            });
                                            _showAllProducts(); // Show all products
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: product.keys.map((category) {
                                        int jumlahbarang =
                                            _getTotalItemsInCategory(category);
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Filterchip(
                                                selected: selectedCategories[
                                                        category] ??
                                                    false,
                                                onSelected: (p0) {
                                                  setState(() {
                                                    // Reset all categories to false before selecting a new one
                                                    selectedCategories
                                                        .updateAll(
                                                            (key, value) =>
                                                                false);

                                                    // Set the selected category to true
                                                    selectedCategories[
                                                        category] = p0;

                                                    // Setelah memilih kategori, periksa apakah ada kategori selain 'Semua' yang terpilih
                                                    bool anyCategorySelected =
                                                        selectedCategories
                                                            .entries
                                                            .any((entry) =>
                                                                entry.key !=
                                                                    'Semua' &&
                                                                entry.value ==
                                                                    true);

                                                    // Jika tidak ada kategori yang terpilih, set 'Semua' ke true
                                                    if (!anyCategorySelected) {
                                                      selectedCategories[
                                                          'Semua'] = true;
                                                      _showAllProducts();
                                                    } else {
                                                      selectedCategories[
                                                              'Semua'] =
                                                          false; // Pastikan 'Semua' tidak dipilih jika ada kategori lain yang dipilih
                                                      _getFilteredProducts(); // Tampilkan produk yang difilter
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      category,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                        color: selectedCategories[
                                                                    category] ==
                                                                true
                                                            ? const Color(
                                                                0xFFFFFFFF)
                                                            : const Color(
                                                                0xFF00409A),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          color: selectedCategories[
                                                                      'Semua'] ==
                                                                  true
                                                              ? const Color(
                                                                  0xFFFFFFFF)
                                                              : const Color(
                                                                  0xFFF1F1F1),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100))),
                                                      child: Text(
                                                        '$jumlahbarang',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: selectedCategories[
                                                                      category] ==
                                                                  true
                                                              ? const Color(
                                                                  0xFF2E6CE9)
                                                              : const Color(
                                                                  0xFF979899),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )));
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 55),
                        controller: _scrollControllerbarang,
                        shrinkWrap: true,
                        itemCount: product.keys.length,
                        itemBuilder: (context, index) {
                          String category = product.keys.elementAt(index);
                          List<Map<String, dynamic>> productsInCategory =
                              _getFilteredProducts().where((prod) {
                            // Filter produk yang hanya sesuai dengan kategori saat ini
                            return product[category]!.contains(prod);
                          }).toList();

                          if (productsInCategory.isEmpty) {
                            // Jika tidak ada produk dalam kategori ini setelah filter, lewati
                            return const SizedBox.shrink();
                          }
                          List<Map<String, dynamic>> products =
                              product[category]!;
                          int totalbarang = _getTotalItemsInCategory(category);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFF303030)),
                                    ),
                                    Text(
                                      '$totalbarang Item',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xFF979899)),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                isGalerry
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: productsInCategory.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> prod =
                                              productsInCategory[index];

                                          String harga = numberFormat.format(
                                              int.parse(
                                                  prod['price'].toString()));
                                          bool status = prod['active'];
                                          bool isSelected =
                                              selectedProducts[prod['name']] ??
                                                  false;
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onLongPress: () {
                                                  // Membatalkan pemilihan produk ketika long press
                                                  setState(() {
                                                    if (status == true &&
                                                        selectedProducts[
                                                                prod['name']] ==
                                                            true) {
                                                      selectedProducts[
                                                          prod['name']] = false;
                                                      quantityProduct.remove(prod[
                                                          'name']); // Menghapus quantity produk saat dibatalkan
                                                      _updateTotalAmount();
                                                    }
                                                  });
                                                },
                                                onTap: () {
                                                  // Ketika produk diklik, hanya pilih produk (tidak membatalkan)
                                                  setState(() {
                                                    if (status == true &&
                                                        selectedProducts[
                                                                prod['name']] !=
                                                            true) {
                                                      selectedProducts[
                                                              prod['name']] =
                                                          true; // Tetapkan produk sebagai dipilih
                                                      quantityProduct[
                                                              prod['name']] =
                                                          1; // Set default quantity ke 1 jika dipilih
                                                      _updateTotalAmount();
                                                    } else if (status != true) {
                                                      print(
                                                          'Barang mati'); // Jika status false, produk tidak bisa dipilih
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: isSelected
                                                            ? const Color(
                                                                0xFF2E6CE9)
                                                            : Colors
                                                                .transparent,
                                                        width: 1),
                                                    color: status
                                                        ? (isSelected
                                                            ? const Color(
                                                                0xFFE2ECFE)
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image
                                                                      .asset(
                                                                    'asset/barang/Rectangle 894.png',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: 50,
                                                                    height: 52,
                                                                  ),
                                                                )),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Container(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 85,
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
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            14,
                                                                        color: status
                                                                            ? const Color(0xFF303030)
                                                                            : const Color(0xFF979899)),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    harga,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: status
                                                                            ? const Color(0xFF979899)
                                                                            : const Color(0xFF979899)),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      isSelected
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  'Tersisa ${prod['stock'] - getQuantity(prod['name'])}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: status
                                                                          ? const Color(
                                                                              0xFF979899)
                                                                          : const Color(
                                                                              0xFF979899)),
                                                                ),
                                                                const SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            4),
                                                                    width: 85,
                                                                    height: 30,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                100)),
                                                                        color: Color(
                                                                            0xFFFFFFFF)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              22,
                                                                          height:
                                                                              22,
                                                                          decoration: const BoxDecoration(
                                                                              color: Color(0xFF2E6CE9),
                                                                              borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                          child:
                                                                              IconButton(
                                                                            visualDensity:
                                                                                VisualDensity.compact,
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            onPressed:
                                                                                () {
                                                                              decrementQuantity(prod);
                                                                              _updateTotalAmount();
                                                                            },
                                                                            icon: const Icon(
                                                                                size: 16,
                                                                                Icons.remove_rounded,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          getQuantity(prod['name'])
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(0xFF09090B)),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              22,
                                                                          height:
                                                                              22,
                                                                          decoration: const BoxDecoration(
                                                                              color: Color(0xFF2E6CE9),
                                                                              borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                          child:
                                                                              IconButton(
                                                                            visualDensity:
                                                                                VisualDensity.compact,
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            onPressed:
                                                                                () {
                                                                              incrementQuantity(prod);
                                                                              _updateTotalAmount();
                                                                            },
                                                                            icon: const Icon(
                                                                                size: 16,
                                                                                Icons.add_rounded,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          : Text(
                                                              'Stok ${prod['stock']}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: status
                                                                      ? (isSelected
                                                                          ? const Color(
                                                                              0xFFFFFFFF)
                                                                          : const Color(
                                                                              0xFF979899))
                                                                      : const Color(
                                                                          0xFF979899)),
                                                            ),
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
                                      )
                                    : MasonryGridView.count(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 2,
                                        itemCount: productsInCategory.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> prod =
                                              productsInCategory[index];
                                          final numberFormat =
                                              NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0);
                                          String harga = numberFormat.format(
                                              int.parse(
                                                  prod['price'].toString()));
                                          bool status = prod['active'];
                                          bool isSelected =
                                              selectedProducts[prod['name']] ??
                                                  false;
                                          return GestureDetector(
                                            onLongPress: () {
                                              // Membatalkan pemilihan produk ketika long press
                                              setState(() {
                                                if (status == true &&
                                                    selectedProducts[
                                                            prod['name']] ==
                                                        true) {
                                                  selectedProducts[
                                                      prod['name']] = false;
                                                  quantityProduct.remove(prod[
                                                      'name']); // Menghapus quantity produk saat dibatalkan
                                                  _updateTotalAmount();
                                                }
                                              });
                                            },
                                            // onTap: () {
                                            //   // Ketika produk diklik, hanya pilih produk (tidak membatalkan)
                                            //   setState(() {
                                            //     if (status == true &&
                                            //         selectedProducts[
                                            //                 prod['name']] !=
                                            //             true) {
                                            //       selectedProducts[
                                            //               prod['name']] =
                                            //           true; // Tetapkan produk sebagai dipilih
                                            //       quantityProduct[
                                            //               prod['name']] =
                                            //           1; // Set default quantity ke 1 jika dipilih
                                            //       _updateTotalAmount();
                                            //     } else if (status != true) {
                                            //       print(
                                            //           'Barang mati'); // Jika status false, produk tidak bisa dipilih
                                            //     }
                                            //   });
                                            // },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFF2E6CE9)
                                                          : Colors.transparent,
                                                      width: 1),
                                                  color: status
                                                      ? (isSelected
                                                          ? const Color(
                                                              0xFFE2ECFE)
                                                          : const Color(
                                                              0xFFFFFFFF))
                                                      : const Color(0xFFEEEEEE),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                        height: 150,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        // alignment: Alignment.centerLeft,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  Image.asset(
                                                                'asset/barang/Rectangle 894.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 150,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              left: 8,
                                                              top: 8,
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                                decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            5)),
                                                                    color: Color(
                                                                        0xFFF6F8FA)),
                                                                child: Text(
                                                                  'Stok ${prod['stock']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: const Color(
                                                                              0xFF303030)
                                                                          .withOpacity(
                                                                              0.7)),
                                                                ),
                                                              ),
                                                            ),
                                                            isSelected
                                                                ? Positioned(
                                                                    bottom: 8,
                                                                    right: 8,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              4),
                                                                      width: 85,
                                                                      height:
                                                                          30,
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              100)),
                                                                          color:
                                                                              Color(0xFFFFFFFF)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                22,
                                                                            height:
                                                                                22,
                                                                            decoration:
                                                                                const BoxDecoration(color: Color(0xFF2E6CE9), borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                            child:
                                                                                IconButton(
                                                                              visualDensity: VisualDensity.compact,
                                                                              padding: EdgeInsets.zero,
                                                                              onPressed: () {
                                                                                decrementQuantity(prod);
                                                                                _updateTotalAmount();
                                                                              },
                                                                              icon: const Icon(size: 16, Icons.remove_rounded, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            getQuantity(prod['name']).toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Color(0xFF09090B)),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                22,
                                                                            height:
                                                                                22,
                                                                            decoration:
                                                                                const BoxDecoration(color: Color(0xFF2E6CE9), borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                            child:
                                                                                IconButton(
                                                                              visualDensity: VisualDensity.compact,
                                                                              padding: EdgeInsets.zero,
                                                                              onPressed: () {
                                                                                incrementQuantity(prod);
                                                                                _updateTotalAmount();
                                                                              },
                                                                              icon: const Icon(size: 16, Icons.add_rounded, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ))
                                                                : Positioned(
                                                                    right: 8,
                                                                    bottom: 8,
                                                                    child:
                                                                        Container(
                                                                      width: 24,
                                                                      height:
                                                                          24,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              100)),
                                                                          color: status
                                                                              ? const Color(0xFF2E6CE9)
                                                                              : const Color(0xFFB1B5C0)),
                                                                      child:
                                                                          IconButton(
                                                                        visualDensity:
                                                                            VisualDensity.compact,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (status == true &&
                                                                                selectedProducts[prod['name']] != true) {
                                                                              selectedProducts[prod['name']] = true; // Tetapkan produk sebagai dipilih
                                                                              quantityProduct[prod['name']] = 1; // Set default quantity ke 1 jika dipilih
                                                                              _updateTotalAmount();
                                                                            } else if (status != true) {
                                                                              print('Barang mati'); // Jika status false, produk tidak bisa dipilih
                                                                            }
                                                                          });
                                                                        },
                                                                        icon: const Icon(
                                                                            size:
                                                                                16,
                                                                            Icons
                                                                                .add_rounded,
                                                                            color:
                                                                                Color(0xFFF6F8FA)),
                                                                      ),
                                                                    ),
                                                                  )
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            prod['name'],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                color: status
                                                                    ? (isSelected
                                                                        ? const Color(
                                                                            0xFF303030)
                                                                        : const Color(
                                                                            0xFF303030))
                                                                    : const Color(
                                                                        0xFF979899)),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            harga,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: status
                                                                    ? (isSelected
                                                                        ? const Color(
                                                                            0xFF979899)
                                                                        : const Color(
                                                                            0xFF979899))
                                                                    : const Color(
                                                                        0xFF979899)),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          );
                                        },
                                      )
                              ],
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                ),
                if (totalAmount > 0)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 20, top: 12),
                        child: customButtonPrimary(
                          height: 56,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detailtransaksi(
                                        selectedProducts:
                                            getSelectedProducts())));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'asset/image/shopping-bag.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${getTotalSelectItemQuantity()} Barang',
                                      style: const TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Text(
                                      numberFormat.format(totalAmount),
                                      style: const TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    // const SizedBox(width: 8),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           const BorderRadius.all(
                                    //               Radius.circular(8)),
                                    //       color: Colors.white
                                    //           .withOpacity(0.4)),
                                    //   child: const Icon(Icons.arrow_forward,
                                    //       color: Colors.white),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                else
                  const SizedBox.shrink(),
              ],
            )));
  }
}
