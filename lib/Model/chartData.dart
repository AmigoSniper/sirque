class chartData {
  String? maxSumbuX;
  String? tanggal;
  String? total;

  chartData({this.maxSumbuX, this.tanggal, this.total});

  chartData.fromJson(Map<String, dynamic> json) {
    maxSumbuX = json['maxSumbu_x'];
    tanggal = json['tanggal'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxSumbu_x'] = this.maxSumbuX;
    data['tanggal'] = this.tanggal;
    data['total'] = this.total;
    return data;
  }
}
