class Dasboard {
  int? totalPendapatan;
  int? totalTransaksi;
  int? pengingatStok;
  String? totalPresentase;
  int? totalPelanggan;

  Dasboard(
      {this.totalPendapatan,
      this.totalTransaksi,
      this.pengingatStok,
      this.totalPresentase,
      this.totalPelanggan});

  Dasboard.fromJson(Map<String, dynamic> json) {
    totalPendapatan = json['totalPendapatan'];
    totalTransaksi = json['totalTransaksi'];
    pengingatStok = json['pengingatStok'];
    totalPresentase = json['totalPresentase'];
    totalPelanggan = json['totalPelanggan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPendapatan'] = this.totalPendapatan;
    data['totalTransaksi'] = this.totalTransaksi;
    data['pengingatStok'] = this.pengingatStok;
    data['totalPresentase'] = this.totalPresentase;
    data['totalPelanggan'] = this.totalPelanggan;
    return data;
  }
}
