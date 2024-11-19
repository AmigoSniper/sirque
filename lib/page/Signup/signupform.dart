import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salescheck/page/Login/loginform.dart';
import 'package:salescheck/page/Signup/signupformklien.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  bool isSelectTab1 = true;
  bool isSelectTab2 = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numbercontroller = TextEditingController();
  final TextEditingController passwordcontroler = TextEditingController();
  String initialCountry = 'ID';
  String? countryCode;
  bool focusnumber = false;
  bool focuspass = false;
  bool passSecure = true;
  bool rememberMe = false;
  FocusNode _focusNodeNumber = FocusNode();
  FocusNode _focusNodePass = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNodeNumber.addListener(() {
      setState(() {
        focusnumber = _focusNodeNumber.hasFocus;
      });
    });
    _focusNodePass.addListener(() {
      setState(() {
        focuspass = _focusNodePass.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNodeNumber.dispose();
    _focusNodePass.dispose();
    super.dispose();
  }

  Widget TabButton(BuildContext context, String textTitle, bool isSelected) {
    return Expanded(
      child: Container(
        height: 31,
        decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: isSelected
            //         ? Colors.black.withOpacity(0.2)
            //         : Colors.transparent,
            //     spreadRadius: -1,
            //     blurRadius: 2.7,
            //     offset: const Offset(2, 2),
            //   ),
            // ],
            color: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        child: ElevatedButton(
            onPressed: isSelected
                ? null
                : () {
                    setState(() {
                      if (isSelectTab1 == true) {
                        isSelectTab1 = false;
                        isSelectTab2 = true;
                      } else if (isSelectTab1 == false) {
                        isSelectTab1 = true;
                        isSelectTab2 = false;
                      }
                    });
                  },
            style: ButtonStyle(
                backgroundColor: isSelected
                    ? WidgetStateProperty.all(const Color(0xFFFFFFFF))
                    : WidgetStateProperty.all(Colors.transparent),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                overlayColor: WidgetStateProperty.all(Colors.transparent)),
            child: Center(
              child: Text(textTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF333333))),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
            centerTitle: true,
            titleSpacing: 0,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'asset/image/celocelo.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Sirqu',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xFFFFFFFF)),
                  )
                ],
              ),
            )),
        body: Stack(fit: StackFit.expand, children: [
          SvgPicture.asset(
            'asset/background/BgformNew.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            bottom: true,
            child: Container(
                width: double.infinity,
                color: Colors.transparent,
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buat akun baru',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Lengkapi form dibawah untuk membuat akun',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xFFCBD5E1)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                height: 39,
                                width: 360,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    TabButton(context, 'Klien', isSelectTab1),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    TabButton(context, 'Pegawai', isSelectTab2)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                'No. Handphone',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF979899)),
                              ),
                            ),
                            Container(
                                // height: 72,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    border: focusnumber
                                        ? Border.all(
                                            width: 1,
                                            color: const Color(0xFF101010))
                                        : Border.all(
                                            width: 0,
                                            color: const Color(0xFFF6F6F6)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 0.1))),
                                      child: Row(
                                        children: [
                                          CountryCodePicker(
                                            onInit: (value) {
                                              countryCode = value?.dialCode;
                                            },
                                            flagWidth: 16,
                                            padding: const EdgeInsets.only(
                                                right: 4,
                                                left: 4,
                                                top: 7,
                                                bottom: 7),
                                            showFlag: true,
                                            showDropDownButton: true,
                                            initialSelection: initialCountry,
                                            textStyle: const TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            onChanged: (value) {
                                              setState(() {
                                                countryCode = value.dialCode;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      width: double.infinity,
                                      child: TextField(
                                        keyboardType: TextInputType.phone,
                                        controller: numbercontroller,
                                        focusNode: _focusNodeNumber,
                                        style: const TextStyle(
                                            color: Color(0xFF101010),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        decoration: const InputDecoration(
                                            hintText: 'Nomor Telepon Anda',
                                            hintStyle: TextStyle(
                                                color: Color(0xFF979899),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                            border: InputBorder.none),
                                      ),
                                    ))
                                  ],
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'kata Kunci',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF979899)),
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          padding: WidgetStateProperty.all<
                                              EdgeInsets>(EdgeInsets.zero),
                                          minimumSize: WidgetStateProperty.all(
                                              const Size(0, 0)),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          overlayColor: WidgetStateProperty.all(
                                              Colors.transparent)),
                                      child: const Text(
                                        'Lupa Password ?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Color(0xFF2E6CE9)),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                                // height: 72,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    border: focuspass
                                        ? Border.all(
                                            width: 1,
                                            color: const Color(0xFF101010))
                                        : Border.all(
                                            width: 0,
                                            color: const Color(0xFFF6F6F6)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          controller: passwordcontroler,
                                          focusNode: _focusNodePass,
                                          obscureText: passSecure,
                                          obscuringCharacter: '*',
                                          style: const TextStyle(
                                              color: Color(0xFF101010),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          decoration: const InputDecoration(
                                              hintText: 'Tulis Password',
                                              hintStyle: const TextStyle(
                                                  color: Color(0xFF979899),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passSecure = !passSecure;
                                          });
                                        },
                                        icon: Icon(
                                          passSecure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: passSecure
                                              ? const Color(0xFFACB5BB)
                                              : const Color(0xFF101010),
                                          size: 16,
                                        )),
                                  ],
                                )),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  String nomerhp =
                                      countryCode! + numbercontroller.text;
                                  print(nomerhp);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Signupformklien()));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    backgroundColor: const Color(0xFF0747CB),
                                    minimumSize:
                                        const Size(double.infinity, 50)),
                                child: const Text(
                                  'Buat Akun',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF)),
                                )),
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Sudah punya akun? ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF101010)),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: 'Masuk',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF2E6CE9),
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print("Teken");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Signupform()));
                                          })
                                  ])),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ]));
  }
}
