import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_textfield.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate_admin_panel/utils/utils.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/loader_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/image_path.dart';
import '../../utils/custom_widgets/text_widget.dart';
import '../../view_model/provider/checkbox_provider.dart';
import '../../view_model/provider/landing_view_provider.dart';
import '../../view_model/provider/pagination_provider.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  var selectedPageNumber = 3;
  final List<String> items = [
    '10 Items',
    '20 Items',
    '30 Items',
    '40 Items',
  ];
  String? selectedValue = '10 Items';
  Stream<QuerySnapshot> _fetchDocsForPage(int pageNumber, int itemsPerPage, String? lastDocumentId) {
    print(lastDocumentId);

    // Query to fetch documents from the "Admins" collection where "superAdmin" is not true
    Query query = FirebaseFirestore.instance
        .collection('Admins')
        // .where('superAdmin', isEqualTo: false) // Exclude documents with "superAdmin" set to true
        .orderBy('id');

    if (lastDocumentId != null && pageNumber > 1) {
      query = query.startAfter([lastDocumentId]);
    }

    return query.limit(itemsPerPage).snapshots();
  }

  int totalDocuments = 0;

  @override
  void initState() {
    super.initState();
    // Fetch total documents and update the provider
    _fetchTotalDocuments();
  }

  Future<void> _fetchTotalDocuments() async {
    totalDocuments = await getTotalDocuments();
    Provider.of<PaginationProvider>(context, listen: false).setTotalDocuments(totalDocuments);
  }

  Future<int> getTotalDocuments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Admins')
        // .where('superAdmin', isEqualTo: false) // Exclude documents with "superAdmin" set to true
        .get();

    return querySnapshot.size;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<PaginationProvider>(
        builder: (context, provider, child) {
    return ReusableContainer(
      height: 600,
      width: double.infinity,
      bgColor: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: _fetchDocsForPage(
              provider.selectedPageNumber, provider.itemsPerPage,
              provider.lastDocumentId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              print(snapshot.data!.docs.isNotEmpty);
              if (snapshot.data!.docs.isNotEmpty) {
                return Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomButton8(text: 'Add Admin', onPressed: () {
                          showCustomCheckBoxDialog(context, false, '',
                              false, false, false, false,  );
                        }, width: MySize.size150, height: MySize.size45,)
                      ],
                    ),
                    SizedBox(height: MySize.size20),
                    // Main Content
                    Expanded(
                      flex: 3,
                      child: ListView(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffF8FAFC),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
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
                                    text: "Password",
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
                         Consumer<LandingViewProvider>(builder: (context, value, child){
                           return  ListView.builder(
                             shrinkWrap: true,
                             itemCount: snapshot.data!.docs.length,
                             itemBuilder: (context, index) {
                               var snap = snapshot.data!.docs[index];
                               String name = snap['name'];
                               print(name);
                               print(snap['superAdmin']);

                               if (name.toLowerCase().contains(value.searchQuery.toLowerCase()) ) {
                                 bool isSuperAdmin = snap['superAdmin'] ;

                                 return Column(
                                 children: [
                                   Container(
                                     decoration: const BoxDecoration(
                                       color: whiteColor,
                                       borderRadius: BorderRadius.only(
                                           topLeft: Radius.circular(10),
                                           topRight: Radius.circular(10)),
                                     ),
                                     child: Table(
                                       children: [
                                         TableRow(children: [
                                           TextWidget(
                                             text: "${snap['id']}$index",
                                             textColor: blackColor,
                                             fontsize: 14,
                                           ),
                                           TextWidget(
                                             text: snap['name'],
                                             textColor: blackColor,
                                             fontsize: 14,
                                           ),
                                           TextWidget(
                                             text: snap['email'],
                                             textColor: blackColor,
                                             fontsize: 14,
                                           ),
                                           TextWidget(
                                             text: snap['password'],
                                             textColor: blackColor,
                                             fontsize: 14,
                                           ),

                                           Padding(
                                             padding: EdgeInsets.only(
                                                 top: MySize.size15),
                                             child: Row(
                                               children: [
                                                isSuperAdmin?
                                                    Container():
                                                TextButton(
                                                   onPressed: () {
                                                     // Add your onPressed functionality here
                                                     showCustomCheckBoxDialog(context, true, snap['id'],snap['ClientsE'],snap['OrderE'],
                                                       snap['PaymentE'],snap['CategoryE'],);
                                                   },
                                                   child: const Text(
                                                     'Give Access',
                                                     style: TextStyle(
                                                       color: primaryColor,
                                                       decoration: TextDecoration
                                                           .underline,
                                                     ),
                                                   ),
                                                 ),

                                                isSuperAdmin? Container(): TextButton(
                                                   onPressed: () {
                                                     _showConfirmationDialog(context, snap['id']);
                                                     // Add your onPressed functionality here
                                                   },
                                                   child: const Text(
                                                     'Remove',
                                                     style: TextStyle(
                                                       color: primaryColor,
                                                       decoration: TextDecoration
                                                           .underline,
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
                             }else{
                               return Container();
                             }
                             },
                           );
                         })
                        ],
                      ),
                    ),
          Consumer<LandingViewProvider>(builder: (context, lp, child){
          return   Visibility(
          visible: lp.searchQuery.isEmpty,
          child:
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
          })
                  ],
                );
              } else {
                return const Center(child: Text('No Item Found'));
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }) ; }

  Future<void> showCustomCheckBoxDialog(BuildContext context, bool isEdit, docId, bool client, bool orders,
      bool payments, bool categories, ) async {
    final TextEditingController firstController = TextEditingController();
    final TextEditingController secondController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        if (isEdit) {
          // Set the checkbox values based on the received data
          Provider.of<AdminCheckBoxProvider>(context, listen: false).setAllValues(
            clients: client,
            orders: orders,
            payments: payments,
            categories: categories,
          );
        }
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Admin Access',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ..._buildCheckBoxList(context,  isEdit ,  client,  orders,
                       payments, categories ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton8(
                          onPressed: () => Navigator.of(context).pop(),
                          text: 'Cancel',
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          height: 40,
                          width: 100,
                        ),
                        const SizedBox(width: 10),
                        CustomButton8(
                          onPressed: () async {
                            if(isEdit){
                              final AdminCheckBoxProvider checkProvider = Provider.of<AdminCheckBoxProvider>(
                                  context, listen: false);
                              FirebaseFirestore.instance.collection('Admins').doc(docId).update({
                                'ClientsE': checkProvider.checkBoxValues['Clients'],
                                'PaymentE': checkProvider.checkBoxValues['Payments'],
                                'CategoryE': checkProvider.checkBoxValues['Categories'],
                                'OrderE': checkProvider.checkBoxValues['Orders'],
                              }).then((value) {
                                Utils.toastMessage('Updated');
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                Utils.toastMessage(error.toString());
                              });
                            }else{
                            Navigator.of(context).pop();
                            showAdminAddDialog(context);
                          }
                          },
                          text: 'Add',
                          height: 40,
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCheckBoxList(BuildContext context, bool edit,  bool client, bool orders,
      bool payments, categories,  ) {
    final checkBoxKeys = ['Clients', 'Orders', 'Payments', 'Categories', ];
    return checkBoxKeys.map((key) {
      return Row(
        children: [
          Consumer<AdminCheckBoxProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: () {
                  provider.updateCheckBox(key, !provider.checkBoxValues[key]!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: provider.checkBoxValues[key]! ? Colors.blue : Colors.grey,
                      width: 1.0,
                    ),
                    color: provider.checkBoxValues[key]! ? Colors.blue.shade100 : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: provider.checkBoxValues[key]!
                        ? const Icon(
                      Icons.check,
                      size: 10.0,
                      color: Colors.blue,
                    )
                        : Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 15),
          Text(key),
        ],
      );
    }).toList();
  }
  Future<void> _addAdmin(BuildContext context, String name, String email, String password) async {
    final loadingProvider = Provider.of<LoaderViewProvider>(context, listen: false);
    loadingProvider.changeShowLoaderValue(true);

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserCredential? userCredential;

    try {
      // Initialize a secondary Firebase app
      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );

      // Create the user with the secondary app's FirebaseAuth instance
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the AdminCheckBoxProvider for checkBox values
      final AdminCheckBoxProvider provider = Provider.of<AdminCheckBoxProvider>(
          context, listen: false);

      // Store admin details in Firestore
      await _firestore.collection('Admins').doc(userCredential.user?.uid).set({
        'email': email,
        'password': password,
        'superAdmin': false,
        'ClientsE': provider.checkBoxValues['Clients'],
        'PaymentE': provider.checkBoxValues['Payments'],
        'CategoryE': provider.checkBoxValues['Categories'],
        'OrderE': provider.checkBoxValues['Orders'],
        'name': name,
        'id': userCredential.user?.uid,
      }).then((value) {
        Navigator.pop(context);
        loadingProvider.changeShowLoaderValue(false);
        Utils.toastMessage('Admin Created');
      }).onError((error, stackTrace) {
        loadingProvider.changeShowLoaderValue(false);
        Utils.toastMessage(error.toString());
        print(error);
      });

    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.toastMessage(e.message ?? 'An error occurred');
      loadingProvider.changeShowLoaderValue(false);
    } finally {
      // Delete the secondary app instance
      if (Firebase.apps.any((app) => app.name == 'Secondary')) {
        await Firebase.app('Secondary').delete();
      }
    }
  }
  Future<void> showAdminAddDialog(BuildContext context,   ) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,

            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MySize.size400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(

                      'Add Admin',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField13(
                      hintText: 'Name',
                      keyboardType: TextInputType.text,
                      controller: nameController,
                    ),
                    const SizedBox(height: 10),

                    CustomTextField13(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField13(
                      hintText: 'Password',
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton8(
                          onPressed: () {
                            Navigator.of(context).pop();},
                          text: 'Cancel',
                          backgroundColor: whiteColor,
                          textColor: blackColor,

                          height: MySize.size40,
                          width: MySize.size100,
                        ),
                        SizedBox(width: MySize.size10),
                        CustomButton8(
                          onPressed: () async {
                            final loadingProvider = Provider.of<LoaderViewProvider>(context,listen: false);
                            await _addAdmin(context, nameController.text, emailController.text, passwordController.text);
                          },
                          text: 'Add',
                          height: MySize.size40,
                          width:  MySize.size100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteUser(String userId) async {
    final obj = Provider.of<LoaderViewProvider>(context, listen: false);
    obj.changeShowLoaderValue(true);
    // Step 1: Delete user document from Firestore collection
    await FirebaseFirestore.instance.collection('Admins').doc(userId)
        .delete()
        .then((value) {
      Navigator.pop(context);
      obj.changeShowLoaderValue(false);

      Utils.toastMessage('Admin Deleted');
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      obj.changeShowLoaderValue(false);
      Utils.toastMessage(error.toString());
    });

    // Step 2: Delete user from Firebase Authentication
    //   try {
    //     await FirebaseAuth.instance.userChanges(userId);
    //   } catch (e) {
    //     print('Error deleting user from Firebase Authentication: $e');
    //     // Handle any exceptions here, such as insufficient permissions.
    //     // You can also choose to rethrow the exception to propagate it.
    //   }
  // }
  }

  void _showConfirmationDialog(BuildContext context, String docId) {
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
              const Text(
                'Are you sure, you want to delete this Admin?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
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
                     deleteUser(docId);
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



class AdminCheckBoxProvider with ChangeNotifier {
  Map<String, bool> _checkBoxValues = {
    'Clients': false,
    'Orders': false,
    'Payments': false,
    'Categories': false,
    'Admins': false,
  };

  Map<String, bool> get checkBoxValues => _checkBoxValues;

  void updateCheckBox(String key, bool value) {
    _checkBoxValues[key] = value;
    notifyListeners();
  }
  void setAllValues({
    required bool clients,
    required bool orders,
    required bool payments,
    required bool categories,
  }) {
    _checkBoxValues = {
      'Clients': clients,
      'Orders': orders,
      'Payments': payments,
      'Categories': categories,
    };
    notifyListeners();
  }
}

