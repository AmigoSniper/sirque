import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:salescheck/Model/diskonModel.dart';
import 'package:salescheck/component/filterChip.dart';
import 'package:salescheck/page/Pengaturan/Promosi/addPromosi.dart';
import 'package:salescheck/page/Pengaturan/Promosi/editPromosi.dart';
import 'package:toastification/toastification.dart';

import '../../../component/customButtonPrimary.dart';
import '../../../component/customButtonColor.dart';

class Promosipage extends StatefulWidget {
  const Promosipage({super.key});

  @override
  State<Promosipage> createState() => _PromosipageState();
}

class _PromosipageState extends State<Promosipage> {
  TextEditingController search = new TextEditingController();
  final numberFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  String searchQuery = '';
  List<Diskon> diskonList = [];
  List<Diskon> diskonListsearch = [];
  List<String> outletOptions = [
    'Semua',
    'West Coast Coffee',
    'North Coast Coffee',
    'East Coast Coffee',
    'South Coast Coffee'
  ];
  List<String> statusOptions = ['Aktif', 'Expired', 'Promo terhapus', 'Semua'];
  int indexstatus = 3;
  String? selectedOutlet;
  Future<void> _refreshData() async {
    // Simulasi delay untuk menunggu data baru
    await Future.delayed(const Duration(seconds: 2));
    diskonList.clear();
    // Perbarui data dan setState untuk memperbarui tampilan
    setState(() {
      diskonList = [
        Diskon(
            id: 1,
            name: "Diskon Akhir Tahun",
            tipeDiskon: "Percentage",
            percentage: 20,
            deskripsi: "Diskon 20% untuk semua pembelian akhir tahun.",
            semuaOutlet: true,
            minimalPembelian: 100000,
            maxDiskon: 20000,
            tanggalMulai: DateTime(2024, 12, 25),
            tanggalBerakhir: DateTime(2024, 12, 31),
            jamMulai: "00:00",
            jamBerakhir: "23:59",
            hariPromo: [
              "Senin",
              "Selasa",
              "Rabu",
              "Kamis",
              "Jumat",
              "Sabtu",
              "Minggu"
            ],
            tipeAktivation: 'Manual',
            status: 'aktif'),
        Diskon(
            id: 2,
            name: "Promo Spesial Weekend",
            tipeDiskon: "Nominal",
            nominal: 15000,
            deskripsi:
                "Diskon Rp15.000 khusus akhir pekan di outlet North dan South Coast Coffee.",
            semuaOutlet: false,
            outlet: ["North Coast Coffee", "South Coast Coffee"],
            minimalPembelian: 50000,
            maxDiskon: null,
            tanggalMulai: DateTime(2024, 11, 15),
            tanggalBerakhir: DateTime(2024, 11, 17),
            jamMulai: "08:00",
            jamBerakhir: "20:00",
            hariPromo: ["Sabtu", "Minggu"],
            tipeAktivation: 'Manual',
            status: 'aktif'),
        Diskon(
            id: 3,
            name: "Diskon Ulang Tahun",
            tipeDiskon: "Percentage",
            percentage: 25,
            deskripsi:
                "Diskon 25% untuk perayaan hari ulang tahun di outlet West dan East Coast Coffee.",
            semuaOutlet: false,
            outlet: ["West Coast Coffee", "East Coast Coffee"],
            minimalPembelian: 0,
            maxDiskon: 25000,
            tanggalMulai: DateTime(2024, 11, 10),
            tanggalBerakhir: DateTime(2024, 11, 10),
            jamMulai: "10:00",
            jamBerakhir: "22:00",
            hariPromo: ["Minggu"],
            tipeAktivation: 'Otomatis',
            status: 'promo terhapus'),
        Diskon(
            id: 4,
            name: "Flash Sale",
            tipeDiskon: "Nominal",
            nominal: 20000,
            deskripsi:
                "Diskon Rp20.000 untuk Flash Sale selama dua jam di semua outlet.",
            semuaOutlet: true,
            minimalPembelian: 75000,
            maxDiskon: null,
            tanggalMulai: DateTime(2024, 11, 20),
            tanggalBerakhir: DateTime(2024, 11, 20),
            jamMulai: "14:00",
            jamBerakhir: "16:00",
            hariPromo: ["Rabu"],
            tipeAktivation: 'Otomatis',
            status: 'expired'),
        Diskon(
            id: 5,
            name: "Promo Awal Tahun",
            tipeDiskon: "Percentage",
            percentage: 15,
            deskripsi:
                "Diskon 15% di outlet East Coast Coffee untuk menyambut tahun baru.",
            semuaOutlet: false,
            outlet: ["East Coast Coffee"],
            minimalPembelian: 100000,
            maxDiskon: 15000,
            tanggalMulai: DateTime(2025, 1, 1),
            tanggalBerakhir: DateTime(2025, 1, 7),
            jamMulai: "00:00",
            jamBerakhir: "23:59",
            hariPromo: [
              "Senin",
              "Selasa",
              "Rabu",
              "Kamis",
              "Jumat",
              "Sabtu",
              "Minggu"
            ],
            tipeAktivation: 'Otomatis',
            status: 'aktif'),
        Diskon(
            id: 6,
            name: "Promo Happy Hour",
            tipeDiskon: "Nominal",
            nominal: 10000,
            deskripsi:
                "Diskon Rp10.000 pada jam 14:00-16:00 setiap hari kerja.",
            semuaOutlet: false,
            outlet: ["West Coast Coffee", "South Coast Coffee"],
            minimalPembelian: 50000,
            maxDiskon: null,
            tanggalMulai: DateTime(2024, 11, 15),
            tanggalBerakhir: DateTime(2024, 12, 31),
            jamMulai: "14:00",
            jamBerakhir: "16:00",
            hariPromo: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
            tipeAktivation: 'Manual',
            status: 'aktif'),
        Diskon(
            id: 7,
            name: "Promo Natal",
            tipeDiskon: "Percentage",
            percentage: 30,
            deskripsi: "Diskon 30% untuk merayakan Natal di semua outlet.",
            semuaOutlet: true,
            minimalPembelian: 150000,
            maxDiskon: 30000,
            tanggalMulai: DateTime(2024, 12, 24),
            tanggalBerakhir: DateTime(2024, 12, 25),
            jamMulai: "00:00",
            jamBerakhir: "23:59",
            hariPromo: ["Selasa", "Rabu"],
            tipeAktivation: 'Otomatis',
            status: 'aktif'),
        Diskon(
            id: 8,
            name: "Promo Lunch Deal",
            tipeDiskon: "Nominal",
            nominal: 12000,
            deskripsi:
                "Diskon Rp12.000 untuk pembelian pada jam makan siang di East Coast Coffee.",
            semuaOutlet: false,
            outlet: ["East Coast Coffee"],
            minimalPembelian: 60000,
            maxDiskon: null,
            tanggalMulai: DateTime(2024, 11, 5),
            tanggalBerakhir: DateTime(2024, 12, 5),
            jamMulai: "12:00",
            jamBerakhir: "14:00",
            hariPromo: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
            tipeAktivation: 'Manual',
            status: 'promo terhapus'),
        Diskon(
            id: 9,
            name: "Diskon Spesial Halloween",
            tipeDiskon: "Percentage",
            percentage: 10,
            deskripsi:
                "Diskon 10% khusus untuk perayaan Halloween di North Coast Coffee.",
            semuaOutlet: false,
            outlet: ["North Coast Coffee"],
            minimalPembelian: 0,
            maxDiskon: 10000,
            tanggalMulai: DateTime(2024, 10, 31),
            tanggalBerakhir: DateTime(2024, 10, 31),
            jamMulai: "00:00",
            jamBerakhir: "23:59",
            hariPromo: ["Kamis"],
            tipeAktivation: 'Manual',
            status: 'aktif'),
        Diskon(
            id: 10,
            name: "Diskon Spesial Member",
            tipeDiskon: "Percentage",
            percentage: 5,
            deskripsi:
                "Diskon 5% untuk member di semua outlet setiap hari Senin.",
            semuaOutlet: true,
            minimalPembelian: 50000,
            maxDiskon: 5000,
            tanggalMulai: DateTime(2024, 11, 1),
            tanggalBerakhir: DateTime(2025, 1, 1),
            jamMulai: "00:00",
            jamBerakhir: "23:59",
            hariPromo: ["Senin"],
            tipeAktivation: 'Otomatis',
            status: 'aktif'),
      ];
      diskonListsearch = diskonList;
      searchfunction();
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

  void searchfunction() {
    if (selectedOutlet != null && selectedOutlet!.toLowerCase() == 'semua') {
      // Jika 'semua' dipilih, tampilkan semua diskon
      setState(() {
        diskonListsearch = diskonList;
      });
    } else if (selectedOutlet != null && selectedOutlet!.isNotEmpty) {
      // Jika outlet spesifik dipilih, filter berdasarkan outlet tersebut atau semuaOutlet = true
      setState(() {
        diskonListsearch = diskonList
            .where((item) =>
                item
                    .semuaOutlet || // Tambahkan item jika semuaOutlet bernilai true
                item.outlet.any((outlet) =>
                    outlet.toLowerCase() == selectedOutlet!.toLowerCase()))
            .toList();
      });
      print(diskonListsearch.length); // Menampilkan jumlah hasil pencarian
    } else {
      // Jika tidak ada outlet dipilih atau input kosong, tampilkan semua diskon
      setState(() {
        diskonListsearch = diskonList;
      });
    }

    if (indexstatus != 3) {
      String status = statusOptions[indexstatus];
      if (status != null && status.isNotEmpty) {
        setState(() {
          diskonListsearch = diskonListsearch.where((diskon) {
            if (status.toLowerCase() ==
                statusOptions[indexstatus].toLowerCase()) {
              // Filter diskon berdasarkan status 'aktif'
              return diskon.status.toLowerCase() ==
                  statusOptions[indexstatus].toLowerCase();
            } else if (status.toLowerCase() ==
                statusOptions[indexstatus].toLowerCase()) {
              // Filter diskon berdasarkan status 'expired'
              return diskon.status.toLowerCase() ==
                  statusOptions[indexstatus].toLowerCase();
            } else if (status.toLowerCase() ==
                statusOptions[indexstatus].toLowerCase()) {
              // Filter diskon berdasarkan status 'promo terhapus'
              return diskon.status.toLowerCase() ==
                  statusOptions[indexstatus].toLowerCase();
            }
            return false; // Jika status tidak cocok
          }).toList();
        });
      }
    }
  }

  String formatTanggal(DateTime tanggalMulai, DateTime tanggalBerakhir) {
    final DateFormat formatter = DateFormat('d MMM yy');
    String mulai = formatter.format(tanggalMulai);
    String berakhir = formatter.format(tanggalBerakhir);
    return '$mulai - $berakhir';
  }

  String diskontypeFormat(Diskon diskon) {
    if (diskon.tipeDiskon.toLowerCase() == 'percentage') {
      return '${diskon.percentage} %';
    } else {}
    return '${diskon.nominal / 1000}rb';
  }

  bool tipeOtomatis(Diskon diskon) {
    if (diskon.tipeAktivation == 'Otomatis') {
      return true;
    } else {
      return false;
    }
  }

  bool tipeDiskon(Diskon diskon) {
    if (diskon.tipeDiskon.toLowerCase() == 'nominal') {
      return true;
    } else {
      return false;
    }
  }

  String outlet(Diskon diskon) {
    if (diskon.semuaOutlet) {
      return outletOptions.where((outlet) => outlet != 'Semua').join(', ');
    } else {
      return diskon.outlet.join(', ');
    }
  }

  String jadwal(Diskon diskon) {
    return diskon.hariPromo.join(', ');
  }

  String tanggal(Diskon diskon) {
    final formatTanggal = DateFormat('dd MMMM yyyy', 'id');

    return '${formatTanggal.format(diskon.tanggalMulai)} - ${formatTanggal.format(diskon.tanggalBerakhir)}';
  }

  bool statusDiskon(Diskon diskon) {
    if (diskon.status == 'aktif') {
      return false;
    } else {
      return true;
    }
  }

  void _quickAccesForm(BuildContext context, Diskon diskon) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFFBFBFB),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        String otomatis =
            'Promo ini akan terpasang otomatis saat checkout pesanan';
        String manual = 'Promo ini akan dipasang manual saat checkout pesanan';
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, bottom: 24, left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 4,
                      color: const Color(0xFFE9E9E9),
                      margin: const EdgeInsets.only(bottom: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                        SvgPicture.asset(
                          'asset/image/info-circle.svg',
                          color: const Color(0xFFE5851F),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            tipeOtomatis(diskon) ? otomatis : manual,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xFFE5851F)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    diskon.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF303030)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    diskon.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF9399A7)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  labelForm('Outlet'),
                  textForm(outlet(diskon)),
                  labelForm('Kategori'),
                  textForm(
                      '${diskon.tipeDiskon} ${tipeDiskon(diskon) ? diskontypeFormat(diskon) : diskontypeFormat(diskon)}'),
                  labelForm('Tipe Aktivasi'),
                  textForm(diskon.tipeAktivation),
                  labelForm('Minimal Pembelian'),
                  textForm(numberFormat.format(diskon.minimalPembelian)),
                  Divider(
                    color: const Color(0xFF000000).withOpacity(0.1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  labelForm('Tanggal'),
                  textForm(tanggal(diskon)),
                  labelForm('Jam'),
                  textForm('${diskon.jamMulai} - ${diskon.jamBerakhir}'),
                  labelForm('Hari Promo'),
                  textForm(jadwal(diskon)),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: CustombuttonColor(
                              color: const Color(0xFFF6F6F6),
                              alignment: Alignment.center,
                              height: 48,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Batal',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF09090B)),
                              )),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: customButtonPrimary(
                              alignment: Alignment.center,
                              height: 48,
                              onPressed: () async {
                                Navigator.pop(context);
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Editpromosi(diskon: diskon)));

                                if (result != null) {
                                  final message = result['message'];
                                  final isDeleted = result['isDeleted'];
                                  // ignore: use_build_context_synchronously

                                  print(message);
                                  print(isDeleted);
                                  if (isDeleted == true) {
                                    setState(() {
                                      //delete item

                                      // outlet.removeWhere(
                                      //     (item) => item.noCab == outlet.noCabang);
                                      diskonListsearch.removeWhere(
                                          (item) => item.id == diskon.id);
                                    });
                                    notif(message);
                                  } else {
                                    notif(message);
                                  }
                                }
                              },
                              child: const Text(
                                'Edit Promosi',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFF)),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedOutlet = outletOptions.first;
    searchfunction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8FA),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Promosi',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF121212)),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 40,
              decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'asset/promosi/shop.svg',
                    color: const Color(0xFFAAAAAA),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          iconStyleData: IconStyleData(
                            icon: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'asset/image/arrow-down.svg',
                                height: 12,
                                width: 12,
                                color: const Color(0xFFA8A8A8),
                              ),
                            ),
                          ),
                          isExpanded: true,
                          isDense: false,
                          selectedItemBuilder: (context) {
                            return outletOptions.map((String item) {
                              return Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF000000),
                                ),
                              );
                            }).toList();
                          },
                          items: outletOptions.map((String item) {
                            return DropdownMenuItem<String>(
                                value: item,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, bottom: 4, top: 0),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Color(0xFFE1E1E1)))),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF717179),
                                    ),
                                  ),
                                ));
                          }).toList(),
                          value: selectedOutlet,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOutlet = value;
                              searchfunction();
                            });
                            print(diskonListsearch.length);
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            height: 40,
                            width: 213,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            height: 30,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                              elevation: 4,
                              maxHeight: 160,
                              useSafeArea: true,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: statusOptions.length - 1,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Filterchip(
                    selected: index == indexstatus ? true : false,
                    onSelected: (p0) {
                      setState(() {
                        // Jika filter yang sama ditekan, reset ke "Semua"
                        if (indexstatus == index) {
                          indexstatus = 3; // Set ke "Semua"
                        } else {
                          indexstatus = index; // Update ke filter baru
                        }
                      });

                      // Logika Filter
                      switch (indexstatus) {
                        case 0: // Aktif
                          setState(() {
                            index = indexstatus;
                          });
                          break;
                        case 1: // Expired
                          index = indexstatus;
                          break;
                        case 2: // Promo terhapus
                          index = indexstatus;
                          break;
                        case 3: // Semua
                          index = indexstatus; // Tidak ada filter
                          break;
                      }
                      setState(() {
                        searchfunction();
                      });
                      print(indexstatus);
                    },
                    child: Text(
                      statusOptions[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: indexstatus == index
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF09090B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: diskonListsearch.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              height: 375,
                              width: 375,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset(
                                    'asset/pegawai/Group 33979.svg',
                                    width: 105,
                                    height: 105,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    'Belum ada promosi tersedia',
                                    style: TextStyle(
                                        color: Color(0xFFB1B5C0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ))
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 0),
                              shrinkWrap: true,
                              itemCount: diskonListsearch.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _quickAccesForm(
                                        context, diskonListsearch[index]);
                                  },
                                  child: Container(
                                    height: 66,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: statusDiskon(
                                                diskonListsearch[index])
                                            ? const Color(0xFFEAEAED)
                                            : const Color(0xFFFFFFFF),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              diskonListsearch[index].name,
                                              style: const TextStyle(
                                                  color: Color(0xFF303030),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  diskonListsearch[index]
                                                      .tipeAktivation,
                                                  style: const TextStyle(
                                                      color: Color(0xFF979899),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  ' • ',
                                                  style: TextStyle(
                                                      color: const Color(
                                                              0xFF979899)
                                                          .withOpacity(0.5),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  formatTanggal(
                                                      diskonListsearch[index]
                                                          .tanggalMulai,
                                                      diskonListsearch[index]
                                                          .tanggalBerakhir),
                                                  style: const TextStyle(
                                                      color: Color(0xFF979899),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'asset/promosi/receipt-disscount.svg',
                                                color: statusDiskon(
                                                        diskonListsearch[index])
                                                    ? const Color(0xFF717179)
                                                    : const Color(0xFF2E6CE9),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                diskontypeFormat(
                                                    diskonListsearch[index]),
                                                style: TextStyle(
                                                    color: statusDiskon(
                                                            diskonListsearch[
                                                                index])
                                                        ? const Color(
                                                            0xFF717179)
                                                        : const Color(
                                                            0xFF2E6CE9),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Addpromosi()));
                              if (result != null) {
                                notif(result);
                              }
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
                                    'Tambah Promosi',
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
            ),
          )
        ],
      )),
    );
  }

  Widget labelForm(String judul) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        judul,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFAAAAAA)),
      ),
    );
  }

  Widget textForm(String judul) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        judul,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF09090B)),
      ),
    );
  }
}
