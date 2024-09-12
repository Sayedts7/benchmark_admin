import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/constants/MySize.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_path.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/custom_widgets/text_widget.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('S', 2),
      _ChartData('M', 5),
      _ChartData('Tu', 8),
      _ChartData('W', 4),
      _ChartData('T', 4),
      _ChartData('F', 5),
      _ChartData('Sa', 2)


    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MySize.screenWidth);

    return ReusableContainer(
      width: MySize.screenWidth > 1200 ? MySize.screenWidth * 0.8:  1200,
      bgColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoCard(context, 'Sales', '\$1200.00', '+12%', sales, AppTextStylesInter.label12500G),
                  SizedBox(width: MySize.size24),
                  _buildInfoCard(context, 'Total Revenue', '\$10566.00', '+35%', revenue, AppTextStylesInter.label12500G),
                  SizedBox(width: MySize.size24),
                  _buildInfoCard(context, 'Return', '\$950.00', '+12%', returns, AppTextStylesInter.label12500Pink),
                  SizedBox(width: MySize.size24),
                  _buildInfoCard(context, 'Completed', '\$5150.00', '+15%', marketing, AppTextStylesInter.label12500G),
                  SizedBox(width: MySize.size24),
                  _buildInfoCard(context, 'Running Orders', '\$5150.00', '+15%', marketing, AppTextStylesInter.label12500G),

                ],
              ),
            ),
            Row(
              children: [
                ReusableContainer2(
                  height: MySize.screenHeight * 0.65,
                  width: 650,
                  bgColor: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Overall Revenue', style: AppTextStylesInter.label12400BTC,),
                                Text('\$ 5000', style: AppTextStylesInter.label18700B,),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5,color: bodyTextColor2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('This Year'),
                                    Icon(Icons.arrow_drop_down_outlined)
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                // height: 430,
                                color: whiteColor,
                                child:const LineChartSample2()
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ReusableContainer2(
                  height: MySize.screenHeight * 0.65,
                  width: 400,
                  bgColor: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User Activity',style: AppTextStylesInter.label12400BTC,),
                                Text('10300', style: AppTextStylesInter.label18700B,),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5,color: bodyTextColor2),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('This Week'),
                                    Icon(Icons.arrow_drop_down_outlined)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 350,
                              // height: 430,
                              color: whiteColor,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: SfCartesianChart(
                                  plotAreaBorderColor: Colors.transparent ,
                                    primaryXAxis: const CategoryAxis(
                                      majorGridLines: MajorGridLines(width: 0),

                                    ),
                                    primaryYAxis: const NumericAxis(minimum: 0, maximum: 10, interval: 2),
                                    tooltipBehavior: _tooltip,
                                    series: <CartesianSeries<_ChartData, String>>[
                                      ColumnSeries<_ChartData, String>(
                                          dataSource: data,
                                          xValueMapper: (_ChartData data, _) => data.x,
                                          yValueMapper: (_ChartData data, _) => data.y,
                                          name: 'Users',
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8)),
                                          color: primaryColor)
                                    ]),
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
            Row(
              children: [
                ReusableContainer2(
                  height: 450,
                  width: 650,
                  bgColor: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text('Best Selling', style: AppTextStylesInter.label16600B,),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Expanded(
                          flex: 3,
                          child: ListView(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffF8FAFC),
                                    borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),

                                child: Table(
                                  children: [
                                    TableRow(children: [
                                      TextWidget(
                                        text: "ID",
                                        textColor: const Color(0xff94A3B8),
                                        fontsize: 14,
                                      ),
                                      TextWidget(
                                        text: "Name",
                                        textColor: const Color(0xff94A3B8),
                                        fontsize: 14,
                                      ),
                                      TextWidget(
                                        text: "Email",
                                        textColor: const Color(0xff94A3B8),
                                        fontsize: 14,
                                      ),
                                      TextWidget(
                                        text: "Project Name",
                                        textColor: const Color(0xff94A3B8),
                                        fontsize: 14,
                                      ),

                                    ])
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 4,//int.parse(selectedValue!.replaceRange(3,8, '')),
                                  itemBuilder: (context, index){
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                              BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),

                                          child: Table(
                                            children: [
                                              TableRow(children: [
                                                TextWidget(
                                                  text: index.toString(),
                                                  textColor: blackColor,
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: "Robert Fox",
                                                  textColor: blackColor,
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: "Watch@gmail.com",
                                                  textColor: blackColor,
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: "Last Dance",
                                                  textColor: blackColor,
                                                  fontsize: 14,
                                                ),
                                              ])
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    );
                                  }),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                 ReusableContainer2(
                   height: 450,
                   width: 400,
                   bgColor: bgColor,
                   child: Padding(
                     padding: EdgeInsets.all(15.0),
                     child: SingleChildScrollView(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                       Text('Transaction History',style: AppTextStylesInter.label16600B,),
                           SizedBox(
                             height: 15,
                           ),
                           ListView.builder(
                               itemCount: 14,
                               shrinkWrap: true,
                               itemBuilder: (context, index){
                             return ListTile(
                               leading: Container(
                                 height: 40,
                                 width: 40,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(5),
                                   color: greenLight
                                 ),
                                 child: Icon(Icons.done, color: greenDark ,),
                               ),
                               title: Text('Payment from #1099',style: AppTextStylesInter.label12600B,),
                               trailing: Text('\$430.90', style: AppTextStylesInter.label14700B,),
                               subtitle: Text('Dec 23, 04:50 PM', style: AppTextStylesInter.label12500BTC,),
                             );
                           })
                         ],
                       ),
                     ),
                   ),
                 ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String amount, String percentage, String asset, TextStyle percentageStyle) {
    return Container(
      height: MySize.size110,
      width: MySize.size240,
      padding: EdgeInsets.symmetric(vertical: MySize.size15, horizontal: MySize.size15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: whiteColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(asset),
          SizedBox(width: MySize.size14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: AppTextStylesInter.label12500BTC),
              SizedBox(height: MySize.size4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: amount,
                      style: AppTextStylesInter.label16600B,
                    ),
                    TextSpan(
                      text: percentage,
                      style: percentageStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    primaryColor,
    whiteColor,
  ];


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 12,
              bottom: 12,
            ),
            child: LineChart(

               mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = AppTextStylesInter.label12400BTC;

    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Jan', style: style);
        break;
      case 3:
        text = const Text('March', style: style);
        break;
      case 5:
        text = const Text('May', style: style);
        break;
      case 7:
        text = const Text('July', style: style);
        break;
      case 9:
        text = const Text('Sept', style: style);
        break;
      case 11:
        text = const Text('Nov', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = AppTextStylesInter.label12400BTC;
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 2:
        text = '20k';
        break;
      case 3:
        text = '30k';
        break;
      case 4:
        text = '40k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      showingTooltipIndicators: [],
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return  FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          // gradient: LinearGradient(
          //   colors: gradientColors,
          // ),
          color: primaryColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

}



// barchart
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}