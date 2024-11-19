import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salescheck/Model/Outlet.dart';
import 'package:salescheck/page/Pengaturan/KelolaOutlet/AddOutlet.dart';
import 'package:salescheck/page/Pengaturan/KelolaOutlet/EditOutlet.dart';
import 'package:toastification/toastification.dart';

import '../../../component/customButtonPrimary.dart';
import '../../../component/customButtonColor.dart';

class Kelolaoutlettrue extends StatefulWidget {
  const Kelolaoutlettrue({super.key});

  @override
  State<Kelolaoutlettrue> createState() => _KelolaoutlettrueState();
}

class _KelolaoutlettrueState extends State<Kelolaoutlettrue> {
  List<Outlet> listOutlet = [
    Outlet(
      alamat:
          'RRR9+5FH, Mangu, Sodo, Kec. Pakel, Kabupaten Tulungagung, Jawa Timur 66273',
      photo: '',
      utama: true,
      noCabang: '230981120',
      name: 'Sportstation Pakel',
      kepalaCabang: 'AmigoSniper',
    ),
    Outlet(
      alamat: 'JL. Raya Barat No.7, Kec. Kauman, Tulungagung, Jawa Timur 66261',
      photo: '',
      utama: false,
      noCabang: '230981121',
      name: 'Sportstation Kauman',
      kepalaCabang: 'Santoso',
    ),
    Outlet(
      alamat:
          'JL. MT. Haryono No.45, Kec. Kedungwaru, Tulungagung, Jawa Timur 66224',
      photo: '',
      utama: false,
      noCabang: '230981122',
      name: 'Sportstation Kedungwaru',
      kepalaCabang: 'Tosuhinken',
    ),
    Outlet(
      alamat: 'JL. Basuki Rahmat No.101, Kec. Tulungagung, Jawa Timur 66219',
      photo: '',
      utama: false,
      noCabang: '230981123',
      name: 'Sportstation Tulungagung',
      kepalaCabang: 'Zhongli',
    ),
    Outlet(
      alamat: 'JL. Pahlawan No.23, Kec. Ngunut, Tulungagung, Jawa Timur 66292',
      photo: '',
      utama: false,
      noCabang: '230981124',
      name: 'Sportstation Ngunut',
      kepalaCabang: 'AmigoSniper',
    ),
  ];
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

  void _quickAccesForm(BuildContext context, Outlet outlet) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFFBFBFB),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 16, right: 16, bottom: 24, left: 16),
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
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage('asset/kelolaOutlet/Frame.png'),
                              fit: BoxFit.fitHeight)),
                    ),
                    Flexible(
                      child: Container(
                        height: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 82,
                              height: 24,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color(0xFFF0F9FF)),
                              child: const Text(
                                'ID SPO-01',
                                style: TextStyle(
                                    color: Color(0xFF0EA5E9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              outlet.name,
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
                              outlet.alamat,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xFFA3A3A3),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: 'Koordinator : ',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA3A3A3)),
                                children: [
                                  TextSpan(
                                    text: outlet.kepalaCabang,
                                    style: const TextStyle(
                                        color: Color(0xFF000000)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: CustombuttonColor(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        alignment: Alignment.center,
                        height: 48,
                        color: const Color(0xFFF6F6F6),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF09090B)),
                        )),
                  ),
                  const SizedBox(
                    width: 8,
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
                                  builder: (context) => Editoutlet(
                                        outlet: outlet,
                                      )));

                          if (result != null) {
                            final message = result['message'];
                            final isDeleted = result['isDeleted'];
                            // ignore: use_build_context_synchronously

                            print(message);
                            print(isDeleted);
                            if (isDeleted == true) {
                              print('No cabang : ${outlet.noCabang}');
                              setState(() {
                                //delete item

                                // outlet.removeWhere(
                                //     (item) => item.noCab == outlet.noCabang);
                                listOutlet.removeWhere(
                                    (item) => item.noCabang == outlet.noCabang);
                              });
                              notif(message);
                            } else {
                              notif(message);
                            }
                          }
                        },
                        child: const Text(
                          'Kelola Outlet',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF)),
                        )),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshData() async {
    // Simulasi delay untuk menunggu data baru
    await Future.delayed(Duration(seconds: 2));
    listOutlet.clear();
    // Perbarui data dan setState untuk memperbarui tampilan
    setState(() {
      listOutlet = [
        Outlet(
          alamat:
              'RRR9+5FH, Mangu, Sodo, Kec. Pakel, Kabupaten Tulungagung, Jawa Timur 66273',
          photo: '',
          utama: true,
          noCabang: '230981120',
          name: 'Sportstation Pakel',
          kepalaCabang: 'AmigoSniper',
        ),
        Outlet(
          alamat:
              'JL. Raya Barat No.7, Kec. Kauman, Tulungagung, Jawa Timur 66261',
          photo: '',
          utama: false,
          noCabang: '230981121',
          name: 'Sportstation Kauman',
          kepalaCabang: 'Santoso',
        ),
        Outlet(
          alamat:
              'JL. MT. Haryono No.45, Kec. Kedungwaru, Tulungagung, Jawa Timur 66224',
          photo: '',
          utama: false,
          noCabang: '230981122',
          name: 'Sportstation Kedungwaru',
          kepalaCabang: 'Tosuhinken',
        ),
        Outlet(
          alamat:
              'JL. Basuki Rahmat No.101, Kec. Tulungagung, Jawa Timur 66219',
          photo: '',
          utama: false,
          noCabang: '230981123',
          name: 'Sportstation Tulungagung',
          kepalaCabang: 'Zhongli',
        ),
        Outlet(
          alamat:
              'JL. Pahlawan No.23, Kec. Ngunut, Tulungagung, Jawa Timur 66292',
          photo: '',
          utama: false,
          noCabang: '230981124',
          name: 'Sportstation Ngunut',
          kepalaCabang: 'AmigoSniper',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              shrinkWrap: true,
              itemCount: listOutlet.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _quickAccesForm(context, listOutlet[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 106,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'asset/kelolaOutlet/Frame.png'),
                                    fit: BoxFit.fitWidth)),
                            child: Stack(
                              children: [
                                listOutlet[index].utama
                                    ? Positioned(
                                        left: 0,
                                        top: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 12),
                                          width: 79,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF2E6CE9),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'asset/kelolaOutlet/shop.svg'),
                                              const Text(
                                                'Utama',
                                                style: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ))
                                    : const SizedBox.shrink()
                              ],
                            )),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 82,
                          height: 24,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Color(0xFFF0F9FF)),
                          child: const Text(
                            'ID SPO-01',
                            style: TextStyle(
                                color: Color(0xFF0EA5E9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          listOutlet[index].name,
                          style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          listOutlet[index].alamat,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFFA3A3A3),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
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
                              builder: (context) => const Addoutlet()));
                      if (result != null) {
                        // ignore: use_build_context_synchronously

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
                            'Tambah Outlet',
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
    );
  }
}
