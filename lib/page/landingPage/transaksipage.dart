import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:salescheck/Model/chartData.dart';
import 'package:salescheck/page/Detailorder/detailorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Transaksi.dart';
import '../../Service/ApiDasboard.dart';
import '../../Service/ApiTransaksi.dart';
import '../../component/notifError.dart';

class Transaksipage extends StatefulWidget {
  const Transaksipage({super.key});

  @override
  State<Transaksipage> createState() => _TransaksipageState();
}

class _TransaksipageState extends State<Transaksipage> {
  final ScrollController _scrollController = ScrollController();
  late Future<void> _loadDataFuture;
  late Future<void> _loadDataFutureChart;
  final Apitransaksi _apitransaksi = Apitransaksi();
  final Apidasboard _apiDasbord = Apidasboard();
  List<Transaksi> transaksiList = [];
  List<chartData> _chartData = [];
  String tunai = 'asset/image/pembayaranTunai.svg';
  String eWallet = 'asset/image/pembayaranEwallet.svg';
  String transfer = 'asset/image/pembayaranTransfer.svg';
  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  final List<String> chart = [
    'Tahun ini',
    'Bulan ini',
  ];
  final numberFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  final Map<String, List<Map<String, dynamic>>> datatransaksi = {
    "data": [
      {
        "no": "134512032024010",
        "items": "3",
        "amount": 400000,
        "time": "Oct 13, 2024 12.00",
        "jenisPembayaran": "Tunai"
      },
      {
        "no": "134512032024011",
        "items": "2",
        "amount": 200000,
        "time": "Oct 13, 2024 14.30",
        "jenisPembayaran": "Transfer"
      },
      {
        "no": "134512032024012",
        "items": "5",
        "amount": 650000,
        "time": "Oct 13, 2024 09.15",
        "jenisPembayaran": "E-wallet"
      },
      {
        "no": "134512032024013",
        "items": "1",
        "amount": 100000,
        "time": "Oct 13, 2024 11.45",
        "jenisPembayaran": "Tunai"
      },
      {
        "no": "134512032024014",
        "items": "4",
        "amount": 500000,
        "time": "Oct 13, 2024 13.20",
        "jenisPembayaran": "E-wallet"
      },
      {
        "no": "134512032024015",
        "items": "6",
        "amount": 700000,
        "time": "Oct 13, 2024 10.50",
        "jenisPembayaran": "Transfer"
      },
      {
        "no": "134512032024016",
        "items": "2",
        "amount": 150000,
        "time": "Oct 13, 2024 15.10",
        "jenisPembayaran": "Transfer"
      },
      {
        "no": "134512032024017",
        "items": "7",
        "amount": 900000,
        "time": "Oct 13, 2024 16.45",
        "jenisPembayaran": "Tunai"
      },
      {
        "no": "134512032024018",
        "items": "3",
        "amount": 450000,
        "time": "Oct 13, 2024 17.30",
        "jenisPembayaran": "E-wallet"
      },
      {
        "no": "134512032024019",
        "items": "8",
        "amount": 850000,
        "time": "Oct 13, 2024 18.15",
        "jenisPembayaran": "Tunai"
      },
      {
        "no": "134512032024019",
        "items": "8",
        "amount": 1000000,
        "time": "Oct 13, 2024 18.15",
        "jenisPembayaran": "Tunai"
      },
      {
        "no": "134512032024019",
        "items": "8",
        "amount": 750000,
        "time": "Oct 13, 2024 18.15",
        "jenisPembayaran": "Tunai"
      },
    ]
  };
  int touchedGroupIndex = -1;
  double getHighestAmount(
      Map<String, List<Map<String, dynamic>>> datatransaksi) {
    int maxAmount = 0;

    for (var transaction in datatransaksi["data"]!) {
      if (transaction["amount"] > maxAmount) {
        maxAmount = transaction["amount"];
      }
    }

    return maxAmount.toDouble();
  }

  String pembayaran(String jenis) {
    if (jenis.toLowerCase() == "cash") {
      return tunai;
    } else if (jenis.toLowerCase() == "transfer") {
      return transfer;
    } else if (jenis.toLowerCase() == "e-wallet") {
      return eWallet;
    } else {
      return '';
    }
  }

  String? selectedValue;
  int bulan = DateTime.now().month;
  String? selectedChart;

  late int showingTooltip;
  Future<void> getTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    final int idOutlet = prefs.getInt('id_outlet') ?? 0;
    transaksiList =
        await _apitransaksi.getTransaksibyMonth(idOutlet, bulan - 1);
    if (_apitransaksi.statusCode == 200 || _apitransaksi.statusCode == 201) {
      setState(() {
        transaksiList = transaksiList;
      });
    } else {
      Notiferror.showNotif(
          context: context, description: _apitransaksi.message);
    }
  }

  Future<void> getChart() async {
    final prefs = await SharedPreferences.getInstance();
    final int idOutlet = prefs.getInt('id_outlet') ?? 0;
    _chartData =
        await _apiDasbord.getChart(selectedChart ?? chart.first, idOutlet);
    await Future.delayed(Duration(seconds: 2));
    if (_apiDasbord.statusCode == 200 || _apiDasbord.statusCode == 201) {
      setState(() {
        touchedGroupIndex = -1;
        _chartData = _chartData;
      });
    } else {
      Notiferror.showNotif(
          context: context, description: _apitransaksi.message);
    }
  }

  @override
  void initState() {
    showingTooltip = -1;
    selectedValue = months[bulan - 1];
    selectedChart = chart.first;
    _loadDataFuture = getTransaksi();
    _loadDataFutureChart = getChart();
    super.initState();
  }

  Future<void> _refreshData() async {
    transaksiList.clear();

    _loadDataFuture = getTransaksi();
  }

  BarChartGroupData generateGroupData(int x, int y, bool touch) {
    return BarChartGroupData(
      barsSpace: 16,
      x: x,
      showingTooltipIndicators: touch ? [0] : [],
      barRods: [
        BarChartRodData(
            borderSide: BorderSide.none,
            width: 34,
            toY: y.toDouble(),
            color: touch ? const Color(0xFF2E6CE9) : const Color(0xFFE9ECF1),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9), topRight: Radius.circular(8))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: const Text(
              'Transaksi',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0C0D11)),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Pos Statistik',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1B1C1E)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    width: 115,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                              color: const Color(0xFF0EA5E9),
                            ),
                          ),
                        ),
                        isDense: false,
                        isExpanded: true,
                        selectedItemBuilder: (context) {
                          return chart.map((String item) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0EA5E9),
                                ),
                              ),
                            );
                          }).toList();
                        },
                        items: chart
                            .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 12, top: 12),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Color(0xFFE1E1E1)))),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF717179),
                                    ),
                                  ),
                                )))
                            .toList(),
                        value: selectedChart,
                        onChanged: (String? value) {
                          setState(() {
                            selectedChart = value;
                            _loadDataFutureChart = getChart();
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          height: 40,
                          width: 20,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 0),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                            width: 100,
                            maxHeight: 200,
                            offset: Offset(-5, -5),
                            useSafeArea: true,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                            )),
                      ),
                    ),
                  )
                ],
              )),
          FutureBuilder(
            future: _loadDataFutureChart,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Container(
                    alignment: Alignment.center,
                    height: 200,
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
                          'Belum ada data barang tersedia',
                          style: TextStyle(
                              color: Color(0xFFB1B5C0),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ));
              } else {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: selectedChart == 'Tahun ini' ? 600 : 1200,
                          child: selectedChart == 'Tahun ini'
                              ? BarChart(
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 150),
                                  swapAnimationCurve: Curves.linear,
                                  BarChartData(
                                      alignment: BarChartAlignment.start,
                                      barTouchData: BarTouchData(
                                        enabled: true,
                                        touchTooltipData: BarTouchTooltipData(
                                          fitInsideVertically: true,
                                          fitInsideHorizontally: true,
                                          tooltipHorizontalOffset: 10,
                                          getTooltipColor: (group) =>
                                              const Color(0xFFFFFFFF),
                                          getTooltipItem: (group, groupIndex,
                                              rod, rodIndex) {
                                            String month = [
                                              'Januari',
                                              'Februari',
                                              'Maret',
                                              'April',
                                              'Mei',
                                              'Juni',
                                              'Juli',
                                              'Augustus',
                                              'September',
                                              'Oktober',
                                              'November',
                                              'Desember'
                                            ][group.x - 1];
                                            String formattedValue;
                                            int value = rod.toY.toInt();
                                            if (value >= 1000000000000) {
                                              // Untuk triliunan
                                              formattedValue =
                                                  '${(value / 1000000000000).toStringAsFixed(1)} T';
                                            } else if (value >= 1000000000) {
                                              // Untuk miliaran
                                              formattedValue =
                                                  '${(value / 1000000000).toStringAsFixed(1)} M';
                                            } else if (value >= 1000000) {
                                              // Untuk jutaan
                                              formattedValue =
                                                  '${(value / 1000000).toStringAsFixed(1)} Jt';
                                            } else if (value >= 1000) {
                                              // Untuk ribuan
                                              formattedValue =
                                                  '${(value / 1000).toStringAsFixed(0)} Rb';
                                            } else {
                                              // Untuk angka di bawah ribuan
                                              formattedValue =
                                                  value.toStringAsFixed(0);
                                            }

                                            return BarTooltipItem(
                                                formattedValue,
                                                const TextStyle(
                                                    color: Color(0xFF2E6CE9),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          ' pada bulan $month',
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF848484)))
                                                ]);
                                          },
                                        ),
                                        touchCallback: (FlTouchEvent event,
                                            barTouchResponse) {
                                          if (event is FlTapUpEvent &&
                                              barTouchResponse != null) {
                                            setState(() {
                                              if (touchedGroupIndex ==
                                                  barTouchResponse.spot!
                                                      .touchedBarGroupIndex) {
                                                touchedGroupIndex = -1;
                                              } else {
                                                touchedGroupIndex =
                                                    barTouchResponse.spot!
                                                        .touchedBarGroupIndex;
                                              }
                                            });
                                          }
                                        },
                                      ),
                                      gridData: FlGridData(
                                        drawVerticalLine: false,
                                        drawHorizontalLine: true,
                                        horizontalInterval: int.parse(
                                                _chartData.first.maxSumbuX!) /
                                            4,
                                        getDrawingHorizontalLine: (value) {
                                          return const FlLine(
                                              strokeWidth: 1,
                                              dashArray: [2, 4],
                                              color: Color(0xFFB1B5C0));
                                        },
                                      ),
                                      borderData: FlBorderData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                            drawBelowEverything: false,
                                            axisNameSize: 8,
                                            sideTitles: SideTitles(
                                              maxIncluded: false,
                                              reservedSize: 35,
                                              showTitles: true,
                                              interval: int.parse(_chartData
                                                      .first.maxSumbuX!) /
                                                  4,
                                              getTitlesWidget: (value, meta) {
                                                String formattedValue;
                                                if (value >= 1000000000000) {
                                                  // Untuk triliunan
                                                  formattedValue =
                                                      '${(value / 1000000000000).toStringAsFixed(0)} T';
                                                } else if (value >=
                                                    1000000000) {
                                                  // Untuk miliaran
                                                  formattedValue =
                                                      '${(value / 1000000000).toStringAsFixed(0)} M';
                                                } else if (value >= 1000000) {
                                                  // Untuk jutaan
                                                  formattedValue =
                                                      '${(value / 1000000).toStringAsFixed(0)} Jt';
                                                } else if (value >= 1000) {
                                                  // Untuk ribuan
                                                  formattedValue =
                                                      '${(value / 1000).toStringAsFixed(0)} Rb';
                                                } else {
                                                  // Untuk angka di bawah ribuan
                                                  formattedValue =
                                                      value.toStringAsFixed(0);
                                                }

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 1),
                                                  child: Text(
                                                    formattedValue,
                                                    style: const TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF303030),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget:
                                                (double value, TitleMeta meta) {
                                              const months = [
                                                'Jan',
                                                'Feb',
                                                'Mar',
                                                'Apr',
                                                'May',
                                                'Jun',
                                                'Jul',
                                                'Aug',
                                                'Sep',
                                                'Oct',
                                                'Nov',
                                                'Dec'
                                              ];
                                              return Text(
                                                months[value.toInt() - 1],
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w500,
                                                    color: value.toInt() - 1 ==
                                                            touchedGroupIndex
                                                        ? const Color(
                                                            0xFF303030)
                                                        : const Color(
                                                            0xFF717179)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      maxY: int.parse(
                                              _chartData.first.maxSumbuX!) +
                                          int.parse(
                                                  _chartData.first.maxSumbuX!) *
                                              0.05,
                                      minY: 0,
                                      barGroups: List.generate(
                                        _chartData.length,
                                        (index) => generateGroupData(
                                          index + 1,
                                          int.parse(
                                              _chartData[index].total ?? '0'),
                                          touchedGroupIndex == index,
                                        ),
                                      )))
                              : BarChart(
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 150),
                                  swapAnimationCurve: Curves.linear,
                                  BarChartData(
                                      alignment: BarChartAlignment.start,
                                      barTouchData: BarTouchData(
                                        enabled: true,
                                        touchTooltipData: BarTouchTooltipData(
                                          fitInsideVertically: true,
                                          fitInsideHorizontally: true,
                                          tooltipHorizontalOffset: 10,
                                          getTooltipColor: (group) =>
                                              const Color(0xFFFFFFFF),
                                          getTooltipItem: (group, groupIndex,
                                              rod, rodIndex) {
                                            int getDaysInMonth(
                                                int year, int month) {
                                              if (month == DateTime.february) {
                                                final bool isLeapYear =
                                                    (year % 4 == 0) &&
                                                            (year % 100 != 0) ||
                                                        (year % 400 == 0);
                                                return isLeapYear ? 29 : 28;
                                              }
                                              const List<int> daysInMonth =
                                                  <int>[
                                                31,
                                                -1,
                                                31,
                                                30,
                                                31,
                                                30,
                                                31,
                                                31,
                                                30,
                                                31,
                                                30,
                                                31
                                              ];
                                              return daysInMonth[month - 1];
                                            }

                                            int lengthDate = getDaysInMonth(
                                                DateTime.now().year,
                                                DateTime.now().month);
                                            List<String> dateList =
                                                List.generate(
                                                    lengthDate,
                                                    (index) =>
                                                        (index + 1).toString());
                                            String formattedValue;
                                            int value = rod.toY.toInt();
                                            if (value >= 1000000000000) {
                                              // Untuk triliunan
                                              formattedValue =
                                                  '${(value / 1000000000000).toStringAsFixed(1)} T';
                                            } else if (value >= 1000000000) {
                                              // Untuk miliaran
                                              formattedValue =
                                                  '${(value / 1000000000).toStringAsFixed(1)} M';
                                            } else if (value >= 1000000) {
                                              // Untuk jutaan
                                              formattedValue =
                                                  '${(value / 1000000).toStringAsFixed(1)} Jt';
                                            } else if (value >= 1000) {
                                              // Untuk ribuan
                                              formattedValue =
                                                  '${(value / 1000).toStringAsFixed(0)} Rb';
                                            } else {
                                              // Untuk angka di bawah ribuan
                                              formattedValue =
                                                  value.toStringAsFixed(0);
                                            }

                                            return BarTooltipItem(
                                                formattedValue,
                                                const TextStyle(
                                                    color: Color(0xFF2E6CE9),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          ' pada tanggal ${dateList[group.x - 1]}',
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF848484)))
                                                ]);
                                          },
                                        ),
                                        touchCallback: (FlTouchEvent event,
                                            barTouchResponse) {
                                          if (event is FlTapUpEvent &&
                                              barTouchResponse != null) {
                                            setState(() {
                                              if (touchedGroupIndex ==
                                                  barTouchResponse.spot!
                                                      .touchedBarGroupIndex) {
                                                touchedGroupIndex = -1;
                                              } else {
                                                touchedGroupIndex =
                                                    barTouchResponse.spot!
                                                        .touchedBarGroupIndex;
                                              }
                                            });
                                          }
                                        },
                                      ),
                                      gridData: FlGridData(
                                        drawVerticalLine: false,
                                        drawHorizontalLine: true,
                                        horizontalInterval: int.parse(
                                                _chartData.first.maxSumbuX!) /
                                            4,
                                        getDrawingHorizontalLine: (value) {
                                          return const FlLine(
                                              strokeWidth: 1,
                                              dashArray: [2, 4],
                                              color: Color(0xFFB1B5C0));
                                        },
                                      ),
                                      borderData: FlBorderData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                            drawBelowEverything: false,
                                            axisNameSize: 8,
                                            sideTitles: SideTitles(
                                              maxIncluded: false,
                                              reservedSize: 35,
                                              showTitles: true,
                                              interval: int.parse(_chartData
                                                      .first.maxSumbuX!) /
                                                  4,
                                              getTitlesWidget: (value, meta) {
                                                String formattedValue;
                                                if (value >= 1000000000000) {
                                                  // Untuk triliunan
                                                  formattedValue =
                                                      '${(value / 1000000000000).toStringAsFixed(0)} T';
                                                } else if (value >=
                                                    1000000000) {
                                                  // Untuk miliaran
                                                  formattedValue =
                                                      '${(value / 1000000000).toStringAsFixed(0)} M';
                                                } else if (value >= 1000000) {
                                                  // Untuk jutaan
                                                  formattedValue =
                                                      '${(value / 1000000).toStringAsFixed(0)} Jt';
                                                } else if (value >= 1000) {
                                                  // Untuk ribuan
                                                  formattedValue =
                                                      '${(value / 1000).toStringAsFixed(0)} Rb';
                                                } else {
                                                  // Untuk angka di bawah ribuan
                                                  formattedValue =
                                                      value.toStringAsFixed(0);
                                                }

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 1),
                                                  child: Text(
                                                    formattedValue,
                                                    style: const TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF303030),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget:
                                                (double value, TitleMeta meta) {
                                              int lengthDate = DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month + 1,
                                                      0)
                                                  .day;

                                              List<String> dates =
                                                  List.generate(
                                                      lengthDate,
                                                      (index) => (index + 1)
                                                          .toString());
                                              int index = value.toInt() - 1;
                                              if (index < 0 ||
                                                  index >= dates.length) {
                                                return const Text('');
                                              }
                                              return Text(
                                                dates[index],
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w500,
                                                    color: value.toInt() - 1 ==
                                                            touchedGroupIndex
                                                        ? const Color(
                                                            0xFF303030)
                                                        : const Color(
                                                            0xFF717179)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      maxY: int.parse(
                                              _chartData.first.maxSumbuX!) +
                                          int.parse(
                                                  _chartData.first.maxSumbuX!) *
                                              0.05,
                                      minY: 0,
                                      barGroups: List.generate(
                                        _chartData.length,
                                        (index) => generateGroupData(
                                          index + 1,
                                          int.parse(
                                              _chartData[index].total ?? '0'),
                                          touchedGroupIndex == index,
                                        ),
                                      ))),
                        ),
                      )),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Transaksi',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        width: 115,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                                  color: const Color(0xFF0EA5E9),
                                ),
                              ),
                            ),
                            isDense: false,
                            isExpanded: true,
                            selectedItemBuilder: (context) {
                              return months.map((String item) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF0EA5E9),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items: months
                                .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 12,
                                          top: 12),
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE1E1E1)))),
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF717179),
                                        ),
                                      ),
                                    )))
                                .toList(),
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                                bulan = months.indexOf(value!) + 1;
                                _refreshData();
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              height: 40,
                              width: 20,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                            dropdownStyleData: const DropdownStyleData(
                                width: 110,
                                maxHeight: 200,
                                offset: Offset(-5, -5),
                                useSafeArea: true,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      height: 400,
                      child: FutureBuilder(
                          future: _loadDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Container(
                                  alignment: Alignment.center,
                                  height: 375,
                                  width: 375,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        'Belum ada data barang tersedia',
                                        style: TextStyle(
                                            color: Color(0xFFB1B5C0),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ));
                            } else {
                              if (transaksiList.isEmpty) {
                                return Container(
                                    alignment: Alignment.center,
                                    height: 375,
                                    width: 375,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          'Belum ada data barang tersedia',
                                          style: TextStyle(
                                              color: Color(0xFFB1B5C0),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ));
                              } else {
                                return ListView.builder(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: transaksiList.length,
                                  padding: const EdgeInsets.only(bottom: 50),
                                  itemBuilder: (context, index) {
                                    String logoPembayaran = pembayaran(
                                        transaksiList[index].tipeBayar ?? '');
                                    String tanggalTransaksi =
                                        DateFormat('MMM dd, yyyy hh:mm').format(
                                            DateTime.parse(transaksiList[index]
                                                    .createdAt ??
                                                ''));
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Detailorder(
                                                      transaksi:
                                                          transaksiList[index],
                                                      outlateName:
                                                          transaksiList[index]
                                                                  .outletName ??
                                                              '',
                                                      iconjenisPembayaran:
                                                          logoPembayaran,
                                                    )));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(15),
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 41,
                                                    height: 41,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 11,
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: const Color(
                                                                0xFF2E6CE9)
                                                            .withOpacity(0.12)),
                                                    child: SvgPicture.asset(
                                                      logoPembayaran,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${transaksiList[index].penjualanId}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF303030)),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        tanggalTransaksi,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF717179)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  numberFormat.format(
                                                      transaksiList[index]
                                                          .total),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF2E6CE9)),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${transaksiList[index].detailtransaksi!.length} item',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF717179)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          })),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
