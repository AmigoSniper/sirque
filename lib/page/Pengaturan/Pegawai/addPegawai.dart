import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salescheck/component/customButtonColor.dart';
import 'package:salescheck/component/customDropDown.dart';
import 'package:salescheck/component/inputTextField.dart';

import '../../../component/customButtonPrimary.dart';

class Addpegawai extends StatefulWidget {
  const Addpegawai({super.key});

  @override
  State<Addpegawai> createState() => _AddpegawaiState();
}

class _AddpegawaiState extends State<Addpegawai> {
  File? _image;
  bool permissionGalery = false;
  bool info = true;
  int stepindex = 1;
  List<String> step = [
    'Detail cabang',
    'Pilih koordinator cabang',
    'Tambah Produk'
  ];
  final TextEditingController namecontroler = TextEditingController();

  final TextEditingController emailcontroler = TextEditingController();
  final TextEditingController searchcontroler = TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool focusname = false;

  bool focusemail = false;
  String? selectRole;
  String selectActive = 'Aktif';
  FocusNode _focusNodeName = FocusNode();
  FocusNode _focusNodeemail = FocusNode();

  List<String> roleOptions = ['Admin', 'Manajer', 'Kasir', 'Hr', 'Staff'];
  List<String> activeOptions = ['Aktif', 'Nonaktif'];

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    print('Memnita permission');
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.manageExternalStorage.request();
      print('Ditolak permission');
      // _showPermissionDialog(); // Tampilkan Alert Dialog jika izin ditolak
      setState(() {
        permissionGalery = false;
      });
    } else if (status.isGranted) {
      print('Diterima permission');
      setState(() {
        permissionGalery = true;
      });
    } else {
      print('Memnita ulang permission');
      await Permission.photos.request(); // Meminta izin
      if (await Permission.photos.isGranted) {
        _pickImage(); // Lanjutkan jika izin diberikan setelah diminta
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Izin Diperlukan'),
          content: const Text(
              'Aplikasi membutuhkan izin akses galeri untuk memilih foto. '
              'Silakan berikan izin melalui pengaturan aplikasi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Membuka pengaturan aplikasi untuk memberikan izin
              },
              child: const Text('Pengaturan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));
      setState(() {
        _image = croppedFile;
      });
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit Media',
            toolbarColor: const Color(0xFFF6F8FA),
            toolbarWidgetColor: const Color(0xFF121212),
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Edit Media',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
        ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _requestPermission();
    _focusNodeName.addListener(() {
      setState(() {
        focusname = _focusNodeName.hasFocus;
      });
    });

    _focusNodeemail.addListener(() {
      setState(() {
        focusemail = _focusNodeemail.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNodeName.dispose();
    _focusNodeemail.dispose();
  }

  bool validForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate() && _image != null) {
      return true;
    } else {
      return false;
    }
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
          'Tambah Pegawai',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF121212)),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          permissionGalery
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFFFF9E6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SvgPicture.asset(
                                          'asset/image/info-circle.svg'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Untuk memudahkan dalam upload foto',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: Color(0xFFE5851F)),
                                          ),
                                          Text(
                                            'Izinkan mengakses galeri',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Color(0xFFE5851F)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 70),
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Foto',
                                      style: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (permissionGalery == true) {
                                          _pickImage();
                                        } else {
                                          _requestPermission();
                                        }
                                      },
                                      child: Container(
                                          width: 105,
                                          height: 105,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              border: _image != null
                                                  ? Border.all(
                                                      width: 0,
                                                      color: Colors.transparent)
                                                  : Border.all(
                                                      width: 1,
                                                      color: const Color(
                                                          0xFFC9C9CE)),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          alignment: Alignment.centerLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: _image != null
                                                ? Image.file(
                                                    _image!,
                                                    height: 100,
                                                    width: 100,
                                                  )
                                                : Container(
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xFFF6F6F6)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          'asset/image/gallery-add.svg',
                                                          width: 24,
                                                          height: 24,
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        const Text(
                                                          'Tambah Foto',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xFFA8A8A8)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const Text(
                                      'Gunakan foto dengan rasio 1:1, Upload dalam format .jpg/.png ukuran maksimal 5 mb',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    labelForm('Nama'),
                                    Inputtextfield(
                                      hintText: 'Masukan Nama',
                                      keyboardType: TextInputType.text,
                                      controller: namecontroler,
                                      focus: _focusNodeName,
                                    ),
                                    labelForm('Email'),
                                    Inputtextfield(
                                      hintText: 'Masukkan email',
                                      keyboardType: TextInputType.text,
                                      controller: emailcontroler,
                                      focus: _focusNodeemail,
                                    ),
                                    labelForm('Role'),
                                    Customdropdown(
                                        selectValue: selectRole,
                                        data: roleOptions,
                                        onChanged: (p0) {
                                          setState(() {
                                            selectRole = p0;
                                          });
                                        },
                                        hintText: 'Pilih role',
                                        heightItem: 50),
                                    labelForm('Status'),
                                    Customdropdown(
                                        data: activeOptions,
                                        onChanged: (p0) {
                                          setState(() {
                                            selectActive = p0!;
                                          });
                                        },
                                        selectValue: selectActive,
                                        hintText: 'Pilih Status',
                                        heightItem: 50)
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          onPressed: () {
                            Navigator.pop(
                                context, 'Berhasil Menambahkan Pegawai baru');
                          },
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
              ))
        ],
      )),
    );
  }

  Widget labelForm(String judul) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Text(
        judul,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8D8D8D)),
      ),
    );
  }
}
