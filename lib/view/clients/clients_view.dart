// import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
// import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
// import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
// import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:number_pagination/number_pagination.dart';
//
// import '../../utils/custom_widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:number_pagination/number_pagination.dart';
//
// class ClientsView extends StatefulWidget {
//   const ClientsView({super.key});
//
//   @override
//   State<ClientsView> createState() => _ClientsViewState();
// }
//
// class _ClientsViewState extends State<ClientsView> {
//   var selectedPageNumber = 1; // Start with page 1
//   final List<String> items = [
//     '10 Items',
//     '20 Items',
//     '30 Items',
//     '40 Items',
//   ];
//   String? selectedValue = '10 Items';
//   int itemsPerPage = 10;
//    String Id = '0xButqSxAlRqngemrw96dfDGAyD2';
//
//   @override
//   Widget build(BuildContext context) {
//     return ReusableContainer(
//       height: 600,
//       width: double.infinity,
//       bgColor: whiteColor,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: StreamBuilder(
//           stream: _fetchDocsForPage(selectedPageNumber,Id ),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Icon(Icons.error));
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasData) {
//               return Column(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: ListView(
//                       children: [
//                         Container(
//                           decoration: const BoxDecoration(
//                               color: Color(0xffF8FAFC),
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10))),
//                           child: Table(
//                             children: [
//                               TableRow(children: [
//                                 TextWidget(
//                                   text: "ID",
//                                   textColor: Color(0xff94A3B8),
//                                   fontsize: 14,
//                                 ),
//                                 TextWidget(
//                                   text: "Name",
//                                   textColor: Color(0xff94A3B8),
//                                   fontsize: 14,
//                                 ),
//                                 TextWidget(
//                                   text: "Email",
//                                   textColor: Color(0xff94A3B8),
//                                   fontsize: 14,
//                                 ),
//                                 TextWidget(
//                                   text: "Phone No.",
//                                   textColor: Color(0xff94A3B8),
//                                   fontsize: 14,
//                                 ),
//                                 TextWidget(
//                                   text: "Action",
//                                   textColor: Color(0xff94A3B8),
//                                   fontsize: 14,
//                                 ),
//                               ])
//                             ],
//                           ),
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             var snap = snapshot.data!.docs[index];
//                             return Column(
//                               children: [
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                       color: whiteColor,
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10))),
//                                   child: Table(
//                                     children: [
//                                       TableRow(children: [
//                                         TextWidget(
//                                           text: (index + 1).toString(),
//                                           textColor: blackColor,
//                                           fontsize: 14,
//                                         ),
//                                         TextWidget(
//                                           text: snap['name'],
//                                           textColor: blackColor,
//                                           fontsize: 14,
//                                         ),
//                                         TextWidget(
//                                           text: snap['email'],
//                                           textColor: blackColor,
//                                           fontsize: 14,
//                                         ),
//                                         TextWidget(
//                                           text: snap['phone'],
//                                           textColor: blackColor,
//                                           fontsize: 14,
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 15.0),
//                                           child: Row(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               TextButton(
//                                                 onPressed: () {
//                                                   // Add your onPressed functionality here
//                                                 },
//                                                 child: Text(
//                                                   'View Orders',
//                                                   style: TextStyle(
//                                                     color: primaryColor,
//                                                     decoration: TextDecoration
//                                                         .underline,
//                                                   ),
//                                                 ),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   // Add your onPressed functionality here
//                                                 },
//                                                 child: Text(
//                                                   'Block',
//                                                   style: TextStyle(
//                                                     color: primaryColor,
//                                                     decoration: TextDecoration
//                                                         .underline,
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ])
//                                     ],
//                                   ),
//                                 ),
//                                 Divider(),
//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         height: MySize.size20,
//                       ),
//                       Text(
//                         'Show Rows',
//                         style: AppTextStylesInter.label16600B,
//                       ),
//                       SizedBox(
//                         width: MySize.size16,
//                       ),
//                       DropdownButtonHideUnderline(
//                         child: DropdownButton2<String>(
//                           isExpanded: true,
//                           hint: Text(
//                             selectedValue!,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                           items: items
//                               .map((String item) => DropdownMenuItem<String>(
//                             value: item,
//                             child: Text(
//                               item,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ))
//                               .toList(),
//                           value: selectedValue,
//                           onChanged: (String? value) {
//                             setState(() {
//                               selectedValue = value;
//                               itemsPerPage =
//                                   int.parse(value!.replaceRange(3, 8, ''));
//                               selectedPageNumber = 1; // Reset to first page
//                               Id = '0xButqSxAlRqngemrw96dfDGAyD2';
//                             });
//                           },
//                           buttonStyleData: ButtonStyleData(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             height: 48, // Set height to 48px
//                             width: 160, // Set width to 122px
//                             decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.circular(12), // Set radius to 12px
//                               border: Border.all(
//                                 color: Color(0xFFE2E8F0), // Set border color to #E2E8F0
//                                 width: 1, // Set border width to 1px
//                               ),
//                             ),
//                           ),
//                           menuItemStyleData: MenuItemStyleData(
//                             height: 48, // Match the height of the dropdown items
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             NumberPagination(
//                               onPageChanged: (int pageNumber) {
//                                 setState(() {
//                                   selectedPageNumber = pageNumber;
//                                   Id = snapshot.data!.docs.last.id;
//                                 });
//                               },
//                               // threshold: 2,
//                               pageTotal: (snapshot.data!.docs.length / itemsPerPage).ceil() ,
//                               pageInit: selectedPageNumber, // picked number when init page
//                               colorPrimary: primaryColor,
//                               colorSub: whiteColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             } else {
//               return Container();
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Stream<QuerySnapshot> _fetchDocsForPage(int pageNumber, String id) {
//     print(pageNumber);
//     print('--------------------------');
//     print(itemsPerPage);
//     return FirebaseFirestore.instance
//         .collection('User')
//         .orderBy('id') // Ensure you have an indexed field for ordering
//         .startAt([id])
//         .limit(itemsPerPage)
//         .snapshots();
//   }
// }


import 'package:benchmark_estimate_admin_panel/utils/constants/image_path.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate_admin_panel/utils/utils.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';
import 'package:number_pagination/number_pagination.dart';
import '../../utils/constants/colors.dart';
import '../../utils/custom_widgets/reusable_container.dart';
import '../../utils/custom_widgets/text_widget.dart';
import '../../view_model/provider/pagination_provider.dart';


class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final List<String> items = [
    '10 Items',
    '20 Items',
    '30 Items',
    '40 Items',
  ];

  @override
  Widget build(BuildContext context) {
    // final LandingPageController landingPageController =
    // Get.put(LandingPageController());

    final  landingProvider = Provider.of<LandingViewProvider>(
        context, listen: false);
    return Consumer<PaginationProvider>(
      builder: (context, provider, child) {
        print(landingProvider.searchQuery);
        print('===========================================1');
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
                                        text: "Phone No.",
                                        textColor: const Color(0xff94A3B8),
                                        fontsize: 14,
                                      ),
                                      TextWidget(
                                        text: "Action",
                                        textColor: const Color(0xff94A3B8),
                                        fontsize: 14,
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                              Consumer<LandingViewProvider>(
                                builder: (context, value,child){
                                  print(value.searchQuery);
                                  print('===========================================');
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var snap = snapshot.data!.docs[index];
                                      String name = snap['name'];
                                      if(name.toLowerCase().contains(value.searchQuery.toLowerCase()) ){
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10))),
                                              child: Table(
                                                children: [
                                                  TableRow(children: [
                                                    TextWidget(
                                                      text: snap['id'],
                                                      textColor: blackColor,
                                                      fontsize: 14,
                                                    ),
                                                    TextWidget(
                                                      text: name,
                                                      textColor: blackColor,
                                                      fontsize: 14,
                                                    ),
                                                    TextWidget(
                                                      text: snap['email'],
                                                      textColor: blackColor,
                                                      fontsize: 14,
                                                    ),
                                                    TextWidget(
                                                      text: snap['phone'],
                                                      textColor: blackColor,
                                                      fontsize: 14,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 15.0),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              // Add your onPressed functionality here
                                                              landingProvider.getClientId(snap['id'], true);
                                                              landingProvider.updateIndex(10);
                                                            },
                                                            child: const Text(
                                                              'View Orders',
                                                              style: TextStyle(
                                                                color: primaryColor,
                                                                decoration: TextDecoration.underline,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _showConfirmationDialog(context, snap['isBlocked'], snap['id']);
                                                              // Add your onPressed functionality here
                                                            },
                                                            child: Text(
                                                              snap['isBlocked'] == true ? 'Unblock' : 'Block',
                                                              style: const TextStyle(
                                                                color: primaryColor,
                                                                decoration: TextDecoration.underline,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ])
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                          ],
                                        );
                                      }
                                     else{
                                        return Container();
                                      }
                                    },
                                  );
                                },

                              ),
                            ],
                          ),
                        ),
                        Consumer<LandingViewProvider>(builder: (context, lp, child){
                          return                         Visibility(
                            visible: lp.searchQuery.isEmpty,
                            child: Row(
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
                          );
                        })
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
    Query query = FirebaseFirestore.instance.collection('User').orderBy('id');

    if (lastDocumentId != null && pageNumber > 1) {
      query = query.startAfter([lastDocumentId]);
    }

    return query.limit(itemsPerPage).snapshots();
  }
   int totalDocuments =0;

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
        .collection('User') // Replace 'User' with your collection name
        .get();

    return querySnapshot.size;
  }
  void _showConfirmationDialog(BuildContext context, bool status, String docId) {
    String stat = (status == true ? 'Unblock' : 'Block');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(projectCreated, height: 150,), // Replace with your image asset
              const SizedBox(height: 20),
              const Text(
                'Confirmation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure, you want to $stat this user?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomButton8(
                    width: 120,
                    height: 40,
                    backgroundColor: whiteColor,
                    textColor: blackColor,
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    text:
                      'Cancel',


                  ),
                  CustomButton8(
                    width: 120,
                    height: 40,
                    onPressed: () {
                      FirebaseFirestore.instance.collection('User').doc(docId).update({
                        'isBlocked': status == true ? false: true,
                      }).then((value) {
                        Navigator.pop(context);
                        Utils.toastMessage(status == true ? 'Unblocked' : 'Blocked');
                      }).onError((error, stackTrace) {
                        Utils.toastMessage(error.toString());
                      });
                    },
                    text:
                    'Confirm',


                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
