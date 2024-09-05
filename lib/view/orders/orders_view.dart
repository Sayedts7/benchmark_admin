import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/image_path.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate_admin_panel/utils/utils.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/custom_widgets/text_widget.dart';
import '../../view_model/provider/order_type_provider.dart';
import '../../view_model/provider/pagination_provider.dart';
import '../meet_with_client/meet_with_client_view.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'dart:html' as html;

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  var selectedPageNumber = 3;
  final List<String> items = [
    '10 Items',
    '20 Items',
    '30 Items',
    '40 Items',
  ];
  String? selectedValue = '10 Items';

  // final LandingPageController landingPageController =
  //     Get.put(LandingPageController());

  final String apiKey = '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';

  Future<void> sendEmail() async {
    print('testing email api');
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'personalizations': [
          {
            'to': [{'email': 'sayedts00777@gmail.com'}],
            'subject': 'Test Email from Flutter Web'
          }
        ],
        'from': {'email': 'your-verified-sender@example.com'},
        'content': [
          {
            'type': 'text/plain',
            'value': 'This is a test email sent from a Flutter web app.'
          }
        ]
      }),
    );
    print(response);

    if (response.statusCode == 202) {
      print('Email sent successfully');
    } else {
      print('Failed to send email. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
  @override
  Widget build(BuildContext context) {
    final landingProvider =
    Provider.of<LandingViewProvider>(context, listen: false);

    return Expanded(
      child: SizedBox(
        height: 630,
        child: Column(
          children: [
            OrderStatusWidget(),
            Consumer<PaginationProvider>(builder: (context, provider, child) {
              return Consumer<OrderStatusProvider>(
                  builder: (context, value, child) {
                    return ReusableContainer(
                        height: 600,
                        width: double.infinity,
                        bgColor: whiteColor,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child:   StreamBuilder(
                            stream: _fetchDocsForPage(
                            provider.selectedPageNumber,
                            provider.itemsPerPage,
                            provider.lastDocumentId,
                            value.selectedIndex,
                            landingProvider.clientOrders,
                            landingProvider.clientDocId),

                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Icon(Icons.error));
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
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
                                              topRight: Radius.circular(10)
                                          )
                                      ),
                                      child: Table(
                                        children: [
                                          TableRow(children: [
                                            Consumer<LandingViewProvider>(
                                              builder: (context, value, child) {
                                                bool allSelected = docs.every((doc) => value.selectedProjectIds.contains(doc['id']));
                                                return Padding(
                                                  padding: const EdgeInsets.only(top:15.0),
                                                  child: Checkbox(
                                                    value: allSelected,
                                                    onChanged: (bool? isChecked) {
                                                      if (isChecked ?? false) {
                                                        value.selectAllProjects(docs.map((doc) => doc['id'] as String).toList());
                                                      } else {
                                                        value.clearSelection();
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            TextWidget(
                                              text: "Order Id",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                            TextWidget(
                                              text: "Project Name",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                            TextWidget(
                                              text: "Customer",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                            TextWidget(
                                              text: "Deadline",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                            TextWidget(
                                              text: "Status",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                            TextWidget(
                                              text: "Price",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                            TextWidget(
                                              text: "Actions",
                                              textColor: const Color(0xff94A3B8),
                                              fontsize: 14,
                                            ),
                                          ])
                                        ],
                                      ),
                                    ),
                                    Consumer<LandingViewProvider>(
                                        builder: (context, value, child) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (context, index) {
                                                var snap = snapshot.data!.docs[index];
                                                String projectId = snap['id'];

                                                // Calculate remaining time percentage
                                                DateTime deadline = snap['deadLine'].toDate();
                                                DateTime startDate = snap['startDate'].toDate();
                                                Duration totalTimeSpan = deadline.difference(startDate);
                                                Duration remainingTime = deadline.difference(DateTime.now());
                                                double remainingPercentage = remainingTime.inSeconds / totalTimeSpan.inSeconds;

                                                // Determine the row color based on remaining time percentage
                                                Color rowColor = remainingPercentage <= 0.20 ? const Color(0xffFFC3C3) : whiteColor;

                                                String name = snap['projectName'];

                                                if (name.toLowerCase().contains(value.searchQuery.toLowerCase())) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: rowColor,
                                                            borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(10)
                                                            )
                                                        ),
                                                        child: Table(
                                                          children: [
                                                            TableRow(children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15.0),
                                                                child: Checkbox(
                                                                  value: value.selectedProjectIds.contains(projectId),
                                                                  onChanged: (bool? isChecked) {
                                                                    value.toggleProjectSelection(projectId);
                                                                  },
                                                                ),
                                                              ),
                                                              TextWidget(
                                                                text: snap['id'],
                                                                textColor: blackColor,
                                                                fontsize: 14,
                                                              ),
                                                              TextWidget(
                                                                text: snap['projectName'],
                                                                textColor: blackColor,
                                                                fontsize: 14,
                                                              ),
                                                              TextWidget(
                                                                text: snap['customerName'],
                                                                textColor: blackColor,
                                                                fontsize: 14,
                                                              ),
                                                              TextWidget(
                                                                text: DateFormat('yyyy-MM-dd').format(snap['deadLine'].toDate()),
                                                                textColor: blackColor,
                                                                fontsize: 14,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: MySize.size15),
                                                                child: Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                  decoration: BoxDecoration(
                                                                    color: snap['status'] == 'Requirements Submitted'
                                                                        ? Colors.grey.withOpacity(0.2)
                                                                        : snap['status'] == 'Completed'
                                                                        ? greenLight
                                                                        : snap['status'] == 'Project Started'
                                                                        ? blueLight
                                                                        : yellowLight,
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    border: Border.all(
                                                                      color: snap['status'] == 'Requirements Submitted'
                                                                          ? Colors.grey
                                                                          : snap['status'] == 'Completed'
                                                                          ? greenDark
                                                                          : snap['status'] == 'Project Started'
                                                                          ? blueDark
                                                                          : yellowDark,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      snap['status'],
                                                                      style: TextStyle(
                                                                        fontSize: MySize.size12,
                                                                        color: snap['status'] == 'Requirements Submitted'
                                                                            ? Colors.grey
                                                                            : snap['status'] == 'Completed'
                                                                            ? greenDark
                                                                            : snap['status'] == 'Project Started'
                                                                            ? blueDark
                                                                            : yellowDark,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextWidget(
                                                                text: snap['price'] == '' ? 'NA' : '\$${snap['price']}',
                                                                textColor: blackColor,
                                                                fontsize: MySize.size14,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: MySize.size10),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        landingProvider.getDocId(snap['id']);
                                                                        landingProvider.updateIndex(7);
                                                                      },
                                                                      child: const Text(
                                                                        'View',
                                                                        style: TextStyle(
                                                                          color: primaryColor,
                                                                          decoration: TextDecoration.underline,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        sendEmail();
                                                                      },
                                                                      child: const Text(
                                                                        'Assign',
                                                                        style: TextStyle(
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
                                                } else {
                                                  return Container();
                                                }
                                              }
                                          );
                                        }
                                    )
                                  ],
                                ),
                              ),
                              Consumer<LandingViewProvider>(
                                  builder: (context, lp, child) {
                                    return Visibility(
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
                                              items: items
                                                  .map((String item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item, style: const TextStyle(fontSize: 14)),
                                              ))
                                                  .toList(),
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
                                                    provider.setLastDocumentId(snapshot.data!.docs.last['id']);
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
                                  }
                              )
                            ],
                          );
                        } else {
                          return const Center(child: Text('No Item Found'));
                        }
                      },
                    )
                        ));
                  });
            })
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _fetchDocsForPage(int pageNumber,
      int itemsPerPage,
      String? lastDocumentId,
      int selectedIndex,
      bool clientOrders,
      String? clientId) {
    print(
        'Fetching docs - Page: $pageNumber, Index: $selectedIndex, ClientOrders: $clientOrders, ClientId: $clientId');

    // if(landingPageController.searchQuery.value.isEmpty){
    Query query = FirebaseFirestore.instance.collection('Projects');

    // Apply filters
    if (clientOrders && clientId != null) {
      query = query.where('userId', isEqualTo: clientId);
    }

    if (selectedIndex != 0) {
      query =
          query.where('status', isEqualTo: _getStatusForIndex(selectedIndex));
    }

    // Order by 'id' in descending order and apply pagination
    query = query.orderBy('id', descending: true);
    if (lastDocumentId != null && pageNumber > 1) {
      query = query.startAfter([lastDocumentId]);
    }

    return query.limit(itemsPerPage).snapshots();
    // }else{
    //   Query query = FirebaseFirestore.instance.collection('Projects').where('projectName'
    //
    //       , isEqualTo: landingPageController.searchQuery.value.toLowerCase());
    //
    //   // Apply filters
    //   if (clientOrders && clientId != null) {
    //     query = query.where('userId', isEqualTo: clientId);
    //   }
    //
    //   if (selectedIndex != 0) {
    //     query = query.where('status', isEqualTo: _getStatusForIndex(selectedIndex));
    //   }
    //
    //   // Order by 'id' in descending order and apply pagination
    //   query = query.orderBy('id', descending: true);
    //   if (lastDocumentId != null && pageNumber > 1) {
    //     query = query.startAfter([lastDocumentId]);
    //   }
    //
    //   return query.limit(itemsPerPage).snapshots();
    // }
  }


  int totalDocuments = 0;

  @override
  void initState() {
    super.initState();
    // Example: Fetch total documents and update the provider
    _fetchTotalDocuments();
  }

  Future<void> _fetchTotalDocuments() async {
    totalDocuments = await getTotalDocuments(context);
    Provider.of<PaginationProvider>(context, listen: false)
        .setTotalDocuments(totalDocuments);
  }
}
Future<int> getTotalDocuments(BuildContext context) async {
  final landingProvider = Provider.of<LandingViewProvider>(
      context, listen: false);
  final orderStatusProvider = Provider.of<OrderStatusProvider>(
      context, listen: false);

  Query query = FirebaseFirestore.instance.collection('Projects');

  // Apply client filter if necessary
  if (landingProvider.clientOrders && landingProvider.clientDocId != null) {
    query = query.where('userId', isEqualTo: landingProvider.clientDocId);
  }

  // Apply status filter if a specific status is selected
  if (orderStatusProvider.selectedIndex != 0) {
    String status = _getStatusForIndex(orderStatusProvider.selectedIndex);
    query = query.where('status', isEqualTo: status);
  }

  QuerySnapshot querySnapshot = await query.get();
  return querySnapshot.size;
}
String _getStatusForIndex(int index) {
  switch (index) {
    case 1:
      return 'Requirements Submitted';
    case 2:
      return 'Quote Submitted';
    case 3:
      return 'Project Started';
    case 4:
      return 'Completed';
    default:
      throw ArgumentError('Invalid status index: $index');
  }
}

void recalculateTotalDocuments(BuildContext context) async {
  final totalDocuments = await getTotalDocuments(context);
  Provider.of<PaginationProvider>(context, listen: false)
      .setTotalDocuments(totalDocuments);
}


  // String _getStatusForIndex(int index) {
  //   switch (index) {
  //     case 1:
  //       return 'Project Submitted';
  //     case 2:
  //       return 'Wait for quote';
  //     case 3:
  //       return 'Wait for delivery';
  //     case 4:
  //       return 'Completed';
  //     default:
  //       throw ArgumentError('Invalid status index: $index');
  //   }
  // }}

class OrderStatusWidget extends StatelessWidget {
  final List<String> statuses = [
    'All Orders',
    'Project Created',
    'Quote Submitted',
    'Project Started',
    'Complete Orders'
  ];

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    final provider = Provider.of<OrderStatusProvider>(context);
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
                     recalculateTotalDocuments(context);

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.size50),
              child: InkWell(
                onTap: (){
                  final landingProvider = Provider.of<LandingViewProvider>(context,listen: false);
                  // Utils.toastMessage('Under Development');
                  if(landingProvider.selectedProjectIds.isEmpty){
                    Utils.toastMessage('Please select a project');
                  }else{
                    showCustomDialog(context);
                  }

                },
                child: Container(
                  height: MySize.size50,
                  width: MySize.size110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: secondaryTextColor)),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(export),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Export',
                        style: AppTextStylesInter.label14500BTC,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<int> getTotalDocuments(BuildContext context) async {
  //   final landingProvider = Provider.of<LandingViewProvider>(context, listen: false);
  //   final orderStatusProvider = Provider.of<OrderStatusProvider>(context, listen: false);
  //
  //   Query query = FirebaseFirestore.instance.collection('Projects');
  //
  //   if (landingProvider.clientOrders && landingProvider.clientDocId != null) {
  //     query = query.where('userId', isEqualTo: landingProvider.clientDocId);
  //   }
  //
  //   print('))))))))))))))))))))))))))))))${orderStatusProvider.selectedIndex}');
  //   if (orderStatusProvider.selectedIndex != 0) {
  //     String status = _getStatusForIndex(orderStatusProvider.selectedIndex);
  //     query = query.where('status', isEqualTo: status);
  //   }
  //
  //   QuerySnapshot querySnapshot = await query.get();
  //   return querySnapshot.size;
  // }
  // String _getStatusForIndex(int index) {
  //   switch (index) {
  //     case 1:
  //       return 'Project Submitted';
  //     case 2:
  //       return 'Wait for quote';
  //     case 3:
  //       return 'Wait for delivery';
  //     case 4:
  //       return 'Completed';
  //     default:
  //       throw ArgumentError('Invalid status index: $index');
  //   }
  // }




  Future<void> exportToPDFWeb(BuildContext context) async {
    List<Map<String, dynamic>> projectsData = await fetchProjectsData(context);

    if (projectsData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No projects selected or found')),
      );
      return;
    }

    for (var project in projectsData) {
      final pdf = pw.Document();
      String formattedCategories = formatCategories(project['category']);

      // Create a PDF document for each project
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('Project Name: ${project['projectName']}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text('Project ID: ${project['id']}'),
                  pw.Text('Customer: ${project['customerName']}'),
                  pw.Text('Status: ${project['status']}'),
                  pw.Text('Start Date: ${project['startDate'].toDate().toString()}'),
                  pw.Text('Deadline: ${project['deadLine'].toDate().toString()}'),
                  pw.Text('Price: \$${project['price']}'),
                  pw.Text('Assigned To: ${project['assigneeName']}'),
                  pw.Text('Assignee Email: ${project['assignedTo']}'),
                  pw.Text('Admin Quote Message: ${project['adminMessage']}'),
                  pw.Text('Admin final message: ${project['adminMessageOnComplete']}'),
                  pw.Text('Categories: $formattedCategories'),

                  // Add more project details as needed
                ],
              ),
            );
          },
        ),
      );

      // Convert the PDF to bytes
      final bytes = await pdf.save();

      // Create a blob and anchor element for downloading
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'project_${project['id']}.pdf')
        ..click();

      // Clean up the URL object
      html.Url.revokeObjectUrl(url);

      // Add a small delay to prevent browser from blocking multiple downloads
      await Future.delayed(Duration(milliseconds: 100));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDFs generated for ${projectsData.length} projects')),
    );
  }
  String formatCategories(dynamic categories) {
    if (categories == null) return 'None';

    if (categories is Map) {
      List<String> formattedList = [];
      categories.forEach((key, value) {
        if (value is List) {
          formattedList.addAll(value.map((item) => item.toString()));
        } else {
          formattedList.add(value.toString());
        }
      });
      return formattedList.join(', ');
    }

    return categories.toString();
  }
  Future<List<Map<String, dynamic>>> fetchProjectsData(BuildContext context) async {
    final landingProvider = Provider.of<LandingViewProvider>(context, listen: false);
    List<Map<String, dynamic>> projects = [];

    // Get the selected project IDs from the provider
    Set<String> selectedProjectIds = landingProvider.selectedProjectIds;

    // Check if any projects are selected
    if (selectedProjectIds.isEmpty) {
      print("No orders selected");
      return projects; // Return an empty list
    }

    try {
      // Fetch only the selected projects from Firebase Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Projects')
          .where(FieldPath.documentId, whereIn: selectedProjectIds.toList())
          .get();

      // Loop through the documents and add them to the list
      for (var doc in querySnapshot.docs) {
        projects.add(doc.data() as Map<String, dynamic>);
      }

      // Check if we found all selected projects
      if (projects.length != selectedProjectIds.length) {
        print("Warning: Some selected projects were not found in the database");
      }

    } catch (e) {
      print("Error fetching projects: $e");
    }

    return projects;
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: MySize.size335,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    projectCreated,
                    width: MySize.size120,
                    height: MySize.size120,
                  ),
                  SizedBox(height: MySize.size10),
                  Text(
                    'Export Projects',
                    style: TextStyle(
                        fontSize: MySize.size20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: MySize.size16),
                  CustomButton8(
                    height: 40,
                    onPressed: () {
                      Navigator.of(context).pop();
                      exportToPDFWeb(context); // Export to PDF
                    },
                    text: 'Export PDF',
                  ),
                  // SizedBox(height: MySize.size8),
                  // CustomButton8(
                  //   height: 40,
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //     // exportToExcel(context); // Export to Excel
                  //   },
                  //   text: 'Export Excel',
                  // ),
                  SizedBox(height: MySize.size8),
                  CustomButton8(
                    height: 40,
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.pushReplacement(
                      //     context, MaterialPageRoute(builder: (context) => HomeView()));
                    },
                    text: 'Close',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
