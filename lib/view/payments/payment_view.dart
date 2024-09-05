import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/payment_type_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_widgets/text_widget.dart';
import '../../view_model/provider/landing_view_provider.dart';
import '../../view_model/provider/order_type_provider.dart';
import '../../view_model/provider/pagination_provider.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  var selectedPageNumber = 3;
  final List<String> items = [
    '10 Items',
    '20 Items',
    '30 Items',
    '40 Items',
  ];
  String? selectedValue = '10 Items';

  @override
  Widget build(BuildContext context) {
    final  landingProvider = Provider.of<LandingViewProvider>(
        context, listen: false);
    return Consumer<PaginationProvider>(
      builder: (context, provider, child) {
        return ReusableContainer(
          height: 600,
          width: double.infinity,
          bgColor: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder(
              stream: _fetchDocsForPage(provider.selectedPageNumber, provider.itemsPerPage, provider.lastDocumentId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Column(
                      children: [
                        PaymentTypeWidget(),
                        Consumer<PaymentTypeProvider>(builder: (context, value, child) {
                          return value.selectedIndex == 0? ReusableContainer(
                              height: 600,
                              width: double.infinity,
                              bgColor: whiteColor,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ListView(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xffF8FAFC),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10))),
                                          child: Table(
                                            children: [
                                              TableRow(children: [
                                                TextWidget(
                                                  text: "Order Id",
                                                  textColor: Color(0xff94A3B8),
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: "User Name",
                                                  textColor: Color(0xff94A3B8),
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: "Project Name",
                                                  textColor: Color(0xff94A3B8),
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: "Amount",
                                                  textColor: Color(0xff94A3B8),
                                                  fontsize: 14,
                                                ),
                                              ])
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              var snap = snapshot.data!.docs[index];
                                              return Column(
                                                children: [
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                            topRight:
                                                            Radius.circular(10))),
                                                    child: Table(
                                                      children: [
                                                        TableRow(children: [
                                                          TextWidget(
                                                            text: snap['id'],
                                                            textColor: blackColor,
                                                            fontsize: 14,
                                                          ),
                                                          TextWidget(
                                                            text: snap['userName'],
                                                            textColor: blackColor,
                                                            fontsize: 14,
                                                          ),
                                                          TextWidget(
                                                            text: snap['projectName'],
                                                            textColor: blackColor,
                                                            fontsize: 14,
                                                          ),
                                                          TextWidget(
                                                            text: snap['price'],
                                                            textColor: blackColor,
                                                            fontsize: 14,
                                                          ),
                                                        ])
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                ],
                                              );
                                            }),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text('Show Rows', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 16),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            provider.itemsPerPage.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: items.map((String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item, style: const TextStyle(fontSize: 14)),
                                          )).toList(),
                                          value: '${provider.itemsPerPage} Items',
                                          onChanged: (String? value) {
                                            int items = int.parse(value!.replaceRange(3, 8, ''));
                                            provider.setItemsPerPage(items);
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            height: 48,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                                            ),
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(height: 48),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            NumberPagination(
                                              onPageChanged: (int pageNumber) {
                                                provider.setLastDocumentId(snapshot.data!.docs.last.id);

                                                provider.setSelectedPageNumber(pageNumber);
                                              },

                                              pageTotal: (provider.totalDocuments / provider.itemsPerPage).ceil(),
                                              pageInit: provider.selectedPageNumber,
                                              colorPrimary: primaryColor,
                                              colorSub: whiteColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                              :ReusableContainer(
                              height: 600,
                              width: double.infinity,
                              bgColor: whiteColor,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ListView(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Color(0xffF8FAFC),
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10))),
                                            child: Table(
                                              children: [
                                                TableRow(children: [
                                                  TextWidget(
                                                    text: "Order Id",
                                                    textColor: Color(0xff94A3B8),
                                                    fontsize: 14,
                                                  ),
                                                  TextWidget(
                                                    text: "Refunded By",
                                                    textColor: Color(0xff94A3B8),
                                                    fontsize: 14,
                                                  ),
                                                  TextWidget(
                                                    text: "Refund Amount",
                                                    textColor: Color(0xff94A3B8),
                                                    fontsize: 14,
                                                  ),
                                                  TextWidget(
                                                    text: "Date",
                                                    textColor: Color(0xff94A3B8),
                                                    fontsize: 14,
                                                  ),
                                                ])
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: int.parse(
                                                  selectedValue!.replaceRange(3, 8, '')),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          color: whiteColor,
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              topRight:
                                                              Radius.circular(10))),
                                                      child: Table(
                                                        children: [
                                                          TableRow(children: [
                                                            TextWidget(
                                                              text: "SKn1200$index",
                                                              textColor: blackColor,
                                                              fontsize: 14,
                                                            ),
                                                            TextWidget(
                                                              text: "Robert Fox",
                                                              textColor: blackColor,
                                                              fontsize: 14,
                                                            ),
                                                            TextWidget(
                                                              text: "\$5000",
                                                              textColor: redColor,
                                                              fontsize: 14,
                                                            ),
                                                            TextWidget(
                                                              text: DateTime.now().toString(),
                                                              textColor: blackColor,
                                                              fontsize: 14,
                                                            ),
                                                          ])
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(),
                                                  ],
                                                );
                                              }),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(
                                          height: MySize.size20,
                                        ),
                                        Text(
                                          'Show Rows',
                                          style: AppTextStylesInter.label16600B,
                                        ),
                                        SizedBox(
                                          width: MySize.size16,
                                        ),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              selectedValue!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).hintColor,
                                              ),
                                            ),
                                            items: items
                                                .map((String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                                .toList(),
                                            value: selectedValue,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              height: 48, // Set height to 48px
                                              width: 160, // Set width to 122px
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    12), // Set radius to 12px
                                                border: Border.all(
                                                  color: Color(
                                                      0xFFE2E8F0), // Set border color to #E2E8F0
                                                  width: 1, // Set border width to 1px
                                                ),
                                              ),
                                            ),
                                            menuItemStyleData: MenuItemStyleData(
                                              height:
                                              48, // Match the height of the dropdown items
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              NumberPagination(
                                                onPageChanged: (int pageNumber) {
                                                  print(selectedPageNumber);

                                                  //To optimize further, use a package that supports partial updates instead of setState (e.g. riverpod)
                                                  setState(() {
                                                    print(pageNumber);
                                                    selectedPageNumber = pageNumber;
                                                  });
                                                  print(selectedPageNumber);
                                                },
                                                threshold: 8,
                                                pageTotal: 100,
                                                pageInit:
                                                selectedPageNumber, // picked number when init page
                                                colorPrimary: primaryColor,

                                                colorSub: whiteColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   decoration: const BoxDecoration(
                                    //       color: Color(0xffF8FAFC),
                                    //       borderRadius:
                                    //       BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                    //
                                    //   child: Table(
                                    //     children: [
                                    //       TableRow(children: [
                                    //         TextWidget(
                                    //           text: "Order Id",
                                    //           textColor: Color(0xff94A3B8),
                                    //           fontsize: 14,
                                    //         ),
                                    //         TextWidget(
                                    //           text: "User Name",
                                    //           textColor: Color(0xff94A3B8),
                                    //           fontsize: 14,
                                    //         ),
                                    //         TextWidget(
                                    //           text: "Project Name",
                                    //           textColor: Color(0xff94A3B8),
                                    //           fontsize: 14,
                                    //         ),
                                    //         TextWidget(
                                    //           text: "Amount",
                                    //           textColor: Color(0xff94A3B8),
                                    //           fontsize: 14,
                                    //         ),
                                    //       ])
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ));
                        }),
                      ],
                    );
                  }else{
                    return const Center(child: Text('No Item Found'));
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      },
    );
  }
  Stream<QuerySnapshot> _fetchDocsForPage(int pageNumber, int itemsPerPage, String? lastDocumentId) {
    print('Fetching payments - Page: $pageNumber, ItemsPerPage: $itemsPerPage, LastDocumentId: $lastDocumentId');

    Query query = FirebaseFirestore.instance.collection('Payments')
        .orderBy('id', descending: true);  // Reverse order

    if (lastDocumentId != null && pageNumber > 1) {
      query = query.startAfter([lastDocumentId]);
    }

    return query.limit(itemsPerPage).snapshots();
  }  int totalDocuments =0;

  @override
  void initState() {
    super.initState();
    // Example: Fetch total documents and update the provider
    _fetchTotalDocuments();
  }

  Future<void> _fetchTotalDocuments() async {
    totalDocuments = await getTotalDocuments();
    Provider.of<PaginationProvider>(context, listen: false).setTotalDocuments(totalDocuments);

    // You can set this total to a provider if needed
    // _paginationProvider.setTotalDocuments(totalDocuments);
  }

  Future<int> getTotalDocuments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Payments') // Replace 'User' with your collection name
        .get();

    return querySnapshot.size;
  }
}

class PaymentTypeWidget extends StatelessWidget {
  final List<String> statuses = [
    'All Payments',
    'Refund History',
  ];

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    final provider = Provider.of<PaymentTypeProvider>(context);
    return Container(
      height: MySize.size90,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(statuses.length, (index) {
                bool isSelected = provider.selectedIndex == index;
                return InkWell(
                  onTap: () {
                    provider.setSelectedIndex(index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(MySize.size25),
                        child: Text(
                          statuses[index],
                          style: isSelected
                              ? AppTextStylesInter.label16700P
                              : AppTextStylesInter.label16500Color,
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 150,
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
