import 'package:avatar_plus/avatar_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:salescheck/component/customButtonPrimary.dart';
import 'package:salescheck/page/Transaksi/pembayaranTransaksi.dart';
import '../../Model/selectedProduct.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

class Detailtransaksi extends StatefulWidget {
  final List<SelectedProduct> selectedProducts;
  const Detailtransaksi({super.key, required this.selectedProducts});

  @override
  State<Detailtransaksi> createState() => _DetailtransaksiState();
}

class _DetailtransaksiState extends State<Detailtransaksi> {
  final ScrollController _scrollController = new ScrollController();
  final numberFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  final TextEditingController customerNameControler =
      new TextEditingController();
  String? customerName;
  bool tambahkanEnabel = false;
  List<Diskon> diskon = [
    Diskon(id: 1, name: 'Diskon 8.8', percentage: 10.0),
    Diskon(id: 2, name: 'Diskon Kemerdekaan', percentage: 17.45),
    Diskon(id: 3, name: 'Diskon Rakyat Jelata', percentage: 5.0),
  ];

  List<Diskon> listDiskonselected = [];
  Diskon? diskonSelected;
  double totalAmount = 0;
  int pajak = 11;
  double totalPajak = 0;
  double finalAmount = 0;
  double diskonAmount = 0;
  FocusNode _focusNodeNama = FocusNode();
  bool focusNama = false;
  void increaseStock(int index) {
    if (widget.selectedProducts[index].quantity <
        widget.selectedProducts[index].stock) {
      setState(() {
        widget.selectedProducts[index].quantity += 1;
        calculateTotalAmount();
      });
    }
  }

  void decreaseStock(int index, String namabarang) {
    if (widget.selectedProducts[index].quantity > 1) {
      setState(() {
        widget.selectedProducts[index].quantity -= 1;
        calculateTotalAmount();
      });
    } else {
      _deleteForm(context, namabarang, index);
    }
  }

  void deleteProduct(int index) {
    setState(() {
      widget.selectedProducts.removeAt(index);
      checkIfEmptyAndGoBack();
      calculateTotalAmount();
    });
  }

  void deleteAll() {
    setState(() {
      widget.selectedProducts.clear();
      checkIfEmptyAndGoBack();
    });
  }

  void checkIfEmptyAndGoBack() {
    if (widget.selectedProducts.isEmpty) {
      Navigator.pop(context);
    }
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (var product in widget.selectedProducts) {
      totalAmount += product.price * product.quantity;
    }
    calculateTotalPajak();
    disconCalculate();
    TotalfinalAmount();
  }

  void calculateTotalPajak() {
    double pajakPercentage = pajak / 100;
    double pajakAmount = totalAmount * pajakPercentage;
    setState(() {
      totalPajak = pajakAmount;
    });
  }

  void TotalfinalAmount() {
    print(
        'total harga = $finalAmount = $totalAmount + $totalPajak - ${disconCalculate()}');
    setState(() {
      finalAmount = totalAmount + totalPajak - disconCalculate();
    });
    print(finalAmount);
  }

  double disconCalculate() {
    double disconAmountCalculate = 0;
    for (var listDiskonselectedloop in listDiskonselected) {
      disconAmountCalculate += listDiskonselectedloop.hitungDiskon(totalAmount);
      print('diskon di dapat $diskonAmount');
    }
    return disconAmountCalculate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateTotalAmount();
    customerNameControler.addListener(() {
      setState(() {
        tambahkanEnabel = customerNameControler.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    customerNameControler.dispose();
    super.dispose();
  }

  void _showFormNamCustomer(BuildContext context, String namaBarang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFDFEFE),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 25,
                  top: 24,
                  right: 16,
                  left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambahkan Nama Pelanggan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: 'Nama Pelanggan ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF979899)),
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.transparent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000)),
                    controller: customerNameControler,
                    onChanged: (value) {
                      setModalState(() {
                        tambahkanEnabel = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama user',
                      hintStyle: const TextStyle(
                          color: Color(0xFFA3A3A3),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2E6CE9)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: tambahkanEnabel
                        ? () {
                            if (customerNameControler.text.isNotEmpty) {
                              setState(() {
                                customerName = customerNameControler.text;
                                tambahkanEnabel = false;
                              });
                              customerNameControler.clear();
                              Navigator.pop(context);
                            } else {
                              null;
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        backgroundColor: tambahkanEnabel
                            ? const Color(0xFF0D51D9)
                            : const Color(0xFF979899),
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text(
                      'Tambah',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteForm(BuildContext context, String namaBarang, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Apakah anda yakin ingin menghapus $namaBarang dari keranjang?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000)),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(48))),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(167.5, 50)),
                      child: const Text(
                        'Tidak, batal',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF09090B)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        deleteProduct(index);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          backgroundColor: const Color(0xFFFF3E1D),
                          minimumSize: const Size(167.5, 50)),
                      child: const Text(
                        'Ya, hapus',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF)),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF121212)),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      customerNameControler.clear();
                      setState(() {
                        tambahkanEnabel = false;
                      });
                      _showFormNamCustomer(context, 'Bebek');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      // height: 76,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        height: 44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            border: Border.all(
                                color: const Color(0xFFEBEBED), width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'asset/image/profile.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      height: 39,
                                      child: Text(
                                        (customerName != null &&
                                                customerName!.isNotEmpty)
                                            ? customerName!
                                            : 'Tambah nama pelanggan',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: (customerName != null &&
                                                    customerName!.isNotEmpty)
                                                ? const Color(0xFF000000)
                                                : const Color(0xFFB1B5C0)),
                                      )),
                                ],
                              ),
                            ),
                            (customerName != null && customerName!.isNotEmpty)
                                ? const Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2E6CE9)),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Detail Pesanan',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF303030)),
                            ),
                            Container(
                              height: 24,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(5))),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    deleteAll();
                                  },
                                  child: const Text(
                                    'Hapus Semua',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFE11C48)),
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.selectedProducts.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final product = widget.selectedProducts[index];
                            return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(10))),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 56,
                                            height: 56,
                                            padding: EdgeInsets.zero,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                'asset/barang/Rectangle 894.png',
                                                fit: BoxFit.cover,
                                                width: 56,
                                                height: 56,
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
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
                                                          product.name,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xFF303030)),
                                                        ),
                                                        Text(
                                                          'Sisa stok: ${product.stock}',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF979899)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    width: 95,
                                                    height: 30,
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100)),
                                                        color:
                                                            Color(0xFFF5F2F2)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          width: 22,
                                                          height: 22,
                                                          decoration: const BoxDecoration(
                                                              color: Color(
                                                                  0xFF2E6CE9),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100))),
                                                          child: IconButton(
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              decreaseStock(
                                                                  index,
                                                                  product.name);
                                                            },
                                                            icon: const Icon(
                                                                size: 16,
                                                                Icons
                                                                    .remove_rounded,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          product.quantity
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFF09090B)),
                                                        ),
                                                        Container(
                                                          width: 22,
                                                          height: 22,
                                                          decoration: const BoxDecoration(
                                                              color: Color(
                                                                  0xFF2E6CE9),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100))),
                                                          child: IconButton(
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              increaseStock(
                                                                  index);
                                                            },
                                                            icon: const Icon(
                                                                size: 16,
                                                                Icons
                                                                    .add_rounded,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                numberFormat
                                                    .format(product.price),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF000000)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      left: -5,
                                      top: -5,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFF717179),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            _deleteForm(
                                                context, product.name, index);
                                          },
                                          icon: const Icon(
                                              size: 16,
                                              Icons.close_rounded,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        )),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Diskon',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF303030)),
                              ),
                              listDiskonselected.isEmpty
                                  ? const SizedBox.shrink()
                                  : SizedBox(
                                      height: 56,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Expanded(
                                              child: SizedBox(
                                            height: 40,
                                            width: double.infinity,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  listDiskonselected.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            Color(0xFF00BD45),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    28))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          listDiskonselected[
                                                                  index]
                                                              .name,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFFFFFFFF)),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: const BoxDecoration(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100))),
                                                          child: IconButton(
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              setState(() {
                                                                diskon.add(
                                                                    listDiskonselected[
                                                                        index]);
                                                                listDiskonselected
                                                                    .removeAt(
                                                                        index);
                                                                calculateTotalAmount();
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              size: 16,
                                                              Icons
                                                                  .close_rounded,
                                                              color: Color(
                                                                  0xFF00BD45),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ));
                                              },
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                height: 40,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    border: Border.all(
                                        color: Colors.transparent, width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<Diskon>(
                                    iconStyleData: IconStyleData(
                                        icon: SvgPicture.asset(
                                            'asset/image/arrow-down.svg')),
                                    isExpanded: true,
                                    isDense: false,
                                    hint: const Text(
                                      'Pilih Diskon',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFA8A8A8)),
                                    ),
                                    items: diskon
                                        .map((Diskon item) =>
                                            DropdownMenuItem<Diskon>(
                                              value: item,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 4,
                                                    top: 0),
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color: Color(
                                                                0xFFE1E1E1)))),
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF09090B),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: diskonSelected,
                                    onChanged: (Diskon? newvalue) {
                                      print(newvalue?.name);

                                      setState(() {
                                        listDiskonselected.add(newvalue!);
                                        diskon.remove(newvalue);
                                        calculateTotalAmount();
                                      });
                                      print(listDiskonselected.length);
                                      print(diskon.length);
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      width: double.infinity,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      height: 42,
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                        offset: Offset(0, -10),
                                        elevation: 4,
                                        maxHeight: 160,
                                        useSafeArea: true,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detail Pembayaran',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF303030)),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    border: Border.all(
                                        color: const Color(0xFFE0E0E0),
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Item Total',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2C3E50)),
                                        ),
                                        Text(
                                          numberFormat.format(totalAmount),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF000000)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pajak $pajak%',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF2C3E50)),
                                              ),
                                              // SizedBox(
                                              //   height: 22,
                                              //   child: IconButton(
                                              //       visualDensity:
                                              //           VisualDensity.compact,
                                              //       padding: EdgeInsets.zero,
                                              //       constraints:
                                              //           const BoxConstraints(),
                                              //       onPressed: () {},
                                              //       icon: SvgPicture.asset(
                                              //           'asset/image/edit-2.svg')),
                                              // )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          numberFormat.format(totalPajak),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF000000)),
                                        )
                                      ],
                                    ),
                                    listDiskonselected.isEmpty
                                        ? const SizedBox.shrink()
                                        : ListView.builder(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                listDiskonselected.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      listDiskonselected[index]
                                                          .name,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                              0xFF10B981)),
                                                    ),
                                                    Text(
                                                      '- ${numberFormat.format(listDiskonselected[index].hitungDiskon(totalAmount))}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xFF10B981)),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const DottedLine(
                                      lineThickness: 1,
                                      dashColor: Color(0xFFE0E0E0),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total Tagihan',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2C3E50)),
                                        ),
                                        Text(
                                          numberFormat.format(finalAmount),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2E6CE9)),
                                        )
                                      ],
                                    ),
                                    const Text(
                                      '*Termasuk Pajak ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFA3A3A3)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFDFEFE),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF888888).withOpacity(0.08),
                    offset: const Offset(0, -4),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(12), // Sesuai dengan button radius
              ),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Bayar',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF09090B)),
                        ),
                        Text(
                          numberFormat.format(finalAmount),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customButtonPrimary(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      onPressed: () {
                        if (customerName!.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pembayarantransaksi(
                                        PriceTotal: finalAmount,
                                        name: customerName,
                                      )));
                        } else {
                          null;
                        }
                      },
                      child: const Text(
                        'Lanjut Pembayaran',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF)),
                      ))
                ],
              ))
        ],
      )),
    );
  }
}

class Diskon {
  int id;
  String name;
  double percentage;

  Diskon({
    required this.id,
    required this.name,
    required this.percentage,
  }) {
    // Validasi untuk memastikan nilai percentage berada di antara 0 dan 100
    if (percentage < 0 || percentage > 100) {
      throw ArgumentError("Percentage harus berada di antara 0 dan 100");
    }
  }

  // Metode untuk menghitung jumlah diskon pada harga tertentu
  double hitungDiskon(double harga) {
    return harga * (percentage / 100);
  }

  // Metode untuk mendapatkan harga setelah diskon
  double hargaSetelahDiskon(double harga) {
    return harga - hitungDiskon(harga);
  }

  // Metode untuk menampilkan informasi diskon dalam bentuk string
  @override
  String toString() => name;
}
