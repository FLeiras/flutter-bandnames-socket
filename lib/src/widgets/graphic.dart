import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

Widget ShowGraph(List bands) {
  Map<String, double> dataMap = {};
  bands.forEach((band) {
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
  });

  return Container(
    width: double.infinity,
    height: 200,
    child: PieChart(dataMap: dataMap),
  );
}
