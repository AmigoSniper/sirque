import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salescheck/Model/Pegawai.dart';
import 'package:salescheck/component/searchBar.dart';
import 'package:salescheck/page/Pengaturan/Pegawai/addPegawai.dart';
import 'package:salescheck/page/Pengaturan/Pegawai/editPegawai.dart';
import 'package:toastification/toastification.dart';

import '../../../component/customButtonPrimary.dart';

class pegawaiPage extends StatefulWidget {
  const pegawaiPage({super.key});

  @override
  State<pegawaiPage> createState() => _pegawaiPageState();
}

class _pegawaiPageState extends State<pegawaiPage> {
  TextEditingController search = new TextEditingController();
  String searchQuery = '';
  List<Pegawai> listPegawai = [];
  List<Pegawai> listPegawaisearch = [];

  Future<void> _refreshData() async {
    // Simulasi delay untuk menunggu data baru
    await Future.delayed(const Duration(seconds: 2));
    listPegawai.clear();
    // Perbarui data dan setState untuk memperbarui tampilan
    setState(() {
      listPegawai = [
        Pegawai(
            noPegawai: "001",
            name: "Andi Santoso",
            email: "andi.santoso@company.com",
            role: "Manajer",
            photo: "https://example.com/photos/andi.jpg",
            status: true),
        Pegawai(
            noPegawai: "002",
            name: "Budi Wijaya",
            email: "budi.wijaya@company.com",
            role: "Staff",
            photo: "https://example.com/photos/budi.jpg",
            status: true),
        Pegawai(
            noPegawai: "003",
            name: "Citra Purnama",
            email: "citra.purnama@company.com",
            role: "Supervisor",
            photo: "https://example.com/photos/citra.jpg",
            status: true),
        Pegawai(
            noPegawai: "004",
            name: "Dewi Ayu",
            email: "dewi.ayu@company.com",
            role: "Staff",
            photo: "https://example.com/photos/dewi.jpg",
            status: false),
        Pegawai(
            noPegawai: "005",
            name: "Eka Pratama",
            email: "eka.pratama@company.com",
            role: "HR",
            photo: "https://example.com/photos/eka.jpg",
            status: true),
        Pegawai(
            noPegawai: "006",
            name: "Fajar Maulana",
            email: "fajar.maulana@company.com",
            role: "Staff",
            photo: "https://example.com/photos/fajar.jpg",
            status: false),
        Pegawai(
            noPegawai: "007",
            name: "Gita Larasati",
            email: "gita.larasati@company.com",
            role: "Supervisor",
            photo: "https://example.com/photos/gita.jpg",
            status: true),
        Pegawai(
            noPegawai: "008",
            name: "Hendra Saputra",
            email: "hendra.saputra@company.com",
            role: "Staff",
            photo: "https://example.com/photos/hendra.jpg",
            status: true),
        Pegawai(
            noPegawai: "009",
            name: "Ika Rahmadani",
            email: "ika.rahmadani@company.com",
            role: "Manager",
            photo: "https://example.com/photos/ika.jpg",
            status: false),
        Pegawai(
            noPegawai: "010",
            name: "Joko Susilo",
            email: "joko.susilo@company.com",
            role: "Admin",
            photo: "https://example.com/photos/joko.jpg",
            status: true),
      ];
      listPegawaisearch = listPegawai;
      search.clear();
      searchQuery = '';
    });
  }

  void searchfunction() {
    if (searchQuery.isNotEmpty) {
      listPegawaisearch = listPegawai;
      setState(() {
        listPegawaisearch = listPegawaisearch
            .where((item) =>
                item.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      });
      print(listPegawai.length);
    } else {
      listPegawaisearch = listPegawai;
    }
  }

  Color getRoleColorBackground(String role, bool status) {
    if (status) {
      switch (role.toLowerCase()) {
        case 'admin':
          return const Color(0xFFF0F9FF);
        case 'manajer':
          return const Color(0xFFECFDF5);
        case 'kasir':
          return const Color(0xFFFFFBEB);
        case 'nonaktif':
          return const Color(0xFFFFF1F2);
        default:
          return const Color(0xFFF0F9FF);
      }
    } else {
      return const Color(0xFFFFF1F2);
    }
  }

  Color getRoleColorFont(String role, bool active) {
    if (active == true) {
      switch (role.toLowerCase()) {
        case 'admin':
          return const Color(0xFF0EA5E9);
        case 'manajer':
          return const Color(0xFF10B981);
        case 'kasir':
          return const Color(0xFFF59E0B);
        case 'nonaktif':
          return const Color(0xFFF43F5E);
        default:
          return Colors.grey;
      }
    } else {
      return const Color(0xFFF43F5E);
    }
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

  void _quickAccesForm(BuildContext context, Pegawai pegawai) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFFBFBFB),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, bottom: 24, left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 4,
                    color: const Color(0xFFE9E9E9),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  pegawai.status
                      ? const SizedBox.shrink()
                      : Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFFF1F2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                'asset/image/info-circle.svg',
                                color: const Color(0xFFF43F5E),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                'Status pengguna ini tidak aktif',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Color(0xFFF43F5E)),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.transparent,
                          ),
                          child: AvatarPlus(
                            pegawai.name,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          width: 187,
                          height: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        color: getRoleColorBackground(
                                            pegawai.role, pegawai.status)),
                                    child: Text(
                                      pegawai.status
                                          ? pegawai.role
                                          : 'Nonaktif',
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: getRoleColorFont(
                                              pegawai.role, pegawai.status),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                pegawai.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                pegawai.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color(0xFFA3A3A3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF6F6F6),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text(
                                      'Aktif',
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
                                          value: pegawai.status,
                                          onChanged: (value) {
                                            setModalState(() {
                                              pegawai.status = value;
                                            });
                                            setState(() {
                                              pegawai.status = value;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
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
                                      BorderRadius.all(Radius.circular(12))),
                              backgroundColor: const Color(0xFFF6F6F6),
                              foregroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(167.5, 50)),
                          child: const Text(
                            'Kembali',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF09090B)),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      customButtonPrimary(
                          alignment: Alignment.center,
                          height: 48,
                          width: 167.5,
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Editpegawai(
                                          pegawai: pegawai,
                                        )));

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
                                  listPegawaisearch.removeWhere((item) =>
                                      item.noPegawai == pegawai.noPegawai);
                                });
                                notif(message);
                              } else {
                                notif(message);
                              }
                            }
                          },
                          child: const Text(
                            'Edit Pengguna',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFFFFF)),
                          ))
                    ],
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F8FA),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Pegawai',
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
                  child: Searchbar(
                      hintText: 'Cari Pegawai',
                      onChanged: (p0) {
                        print('cari');
                        setState(() {
                          searchQuery = search.text;
                        });
                        searchfunction();
                        print('hasil');
                      },
                      controller: search)),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _refreshData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: listPegawaisearch.isEmpty
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
                                      'Belum ada data pegawai tersedia',
                                      style: TextStyle(
                                          color: Color(0xFFB1B5C0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ))
                            : MasonryGridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                itemCount: listPegawaisearch.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _quickAccesForm(
                                          context, listPegawaisearch[index]);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 16),
                                        decoration: BoxDecoration(
                                            color:
                                                listPegawaisearch[index].status
                                                    ? const Color(0xFFFFFFFF)
                                                    : const Color(0xFFEAEAED),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(0))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 75,
                                                width: 75,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    AvatarPlus(
                                                      listPegawaisearch[index]
                                                          .name,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 24,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 12),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        100)),
                                                            color: getRoleColorBackground(
                                                                listPegawaisearch[
                                                                        index]
                                                                    .role,
                                                                listPegawaisearch[
                                                                        index]
                                                                    .status)),
                                                        child: Text(
                                                          listPegawaisearch[
                                                                      index]
                                                                  .status
                                                              ? listPegawaisearch[
                                                                      index]
                                                                  .role
                                                              : 'Nonaktif',
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: TextStyle(
                                                              color: getRoleColorFont(
                                                                  listPegawaisearch[
                                                                          index]
                                                                      .role,
                                                                  listPegawaisearch[
                                                                          index]
                                                                      .status),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    listPegawaisearch[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF0B0C17),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    listPegawaisearch[index]
                                                        .email,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFFA3A3A3),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                },
                              ),
                      ),
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
                                              const Addpegawai()));
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        'Tambah Pegawai',
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
          ),
        ));
  }
}
