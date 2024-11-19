// ignore: file_names
import 'package:flutter/material.dart';

import '../../component/inputTextField.dart';

class Editcategory extends StatefulWidget {
  final String category;
  const Editcategory({super.key, required this.category});

  @override
  State<Editcategory> createState() => _EditcategoryState();
}

class _EditcategoryState extends State<Editcategory> {
  final TextEditingController namecontroler = TextEditingController();
  FocusNode _focusNodeName = FocusNode();
  bool focusname = false;
  int length = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroler.text = widget.category;
    length = namecontroler.text.length;
    _focusNodeName.addListener(() {
      setState(() {
        focusname = _focusNodeName.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNodeName.dispose();
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
          'Edit Kategori',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF121212)),
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 15),
                    // height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius:
                            BorderRadius.all(const Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Kategori',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF979899)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Inputtextfield(
                            height: 47,
                            controller: namecontroler,
                            hintText: 'Masukkan Nama Kategori',
                            onChanged: (p0) {
                              setState(() {
                                length = namecontroler.text.length;
                              });
                            },
                            keyboardType: TextInputType.text),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '$length/20 char',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF979899)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 68,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: const BoxDecoration(color: Color(0xFFF6F8FA)),
                    child: ElevatedButton(
                        onPressed: () {
                          if (namecontroler.text.isNotEmpty) {
                            Navigator.pop(context,
                                'Kategori ${namecontroler.text} berhasil dirubah!');
                          } else {
                            null;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            backgroundColor: namecontroler.text.isNotEmpty
                                ? const Color(0xFF0747CB)
                                : const Color(0xFFDEDEDE),
                            minimumSize: const Size(double.infinity, 50)),
                        child: Text(
                          'Simpan Kategori',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: namecontroler.text.isNotEmpty
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF717179)),
                        )),
                  )
                ],
              ))),
    );
  }
}
