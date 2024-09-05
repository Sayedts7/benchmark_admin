import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_textfield.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import '../../utils/constants/image_path.dart';
import '../../utils/custom_widgets/text_widget.dart';
import '../../utils/utils.dart';
import '../../view_model/provider/category_tag_provider.dart';
import '../../view_model/provider/loader_view_provider.dart';
import '../../view_model/provider/pagination_provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  // var selectedPageNumber = 3;
  final List<String> items = [
    '10 Items',
    '20 Items',
    '30 Items',
    '40 Items',
  ];
  String? selectedValue = '10 Items';

  @override
  Widget build(BuildContext context) {
    return Consumer<PaginationProvider>(builder: (context, provider, child) {
      return ReusableContainer(
        height: 600,
        width: double.infinity,
        bgColor: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: _fetchDocsForPage(provider.selectedPageNumber,
                provider.itemsPerPage, provider.lastDocumentId),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomButton8(
                            text: 'Add category',
                            onPressed: () {
                              showCustomDialog(context, false, '', '');
                            },
                            width: MySize.size150,
                            height: MySize.size45,
                          )
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
                                      text: "Category Name",
                                      textColor: const Color(0xff94A3B8),
                                      fontsize: 14,
                                    ),
                                    // TextWidget(
                                    //   text: "Sub Categories",
                                    //   textColor: const Color(0xff94A3B8),
                                    //   fontsize: 14,
                                    // ),
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
                                  List<dynamic> subCategories =
                                      snap['subCategory'] ?? [];
                                  String name = snap['categoryName'];
                                  if(name.toLowerCase().contains(value.searchQuery.toLowerCase())){
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
                                                  text: snap['id'],
                                                  textColor: blackColor,
                                                  fontsize: 14,
                                                ),
                                                TextWidget(
                                                  text: snap['categoryName'],
                                                  textColor: blackColor,
                                                  fontsize: 14,
                                                ),
                                                // Padding(
                                                //   padding: EdgeInsets.only(
                                                //       top: MySize.size15),
                                                //   child: SizedBox(
                                                //     width: 100,
                                                //
                                                //     child: SingleChildScrollView(
                                                //       scrollDirection: Axis.horizontal,
                                                //       child: Row(
                                                //         children: subCategories.map((subCategory) {
                                                //           return Padding(
                                                //             padding: const EdgeInsets.symmetric(horizontal: 3),
                                                //             child: Chip(
                                                //               label: Text(
                                                //                 subCategory.toString(),
                                                //                 style: const TextStyle(fontSize: 16, color: primaryColor),
                                                //               ),
                                                //               backgroundColor: primaryColor.withOpacity(0.2),
                                                //               shape: RoundedRectangleBorder(
                                                //                 borderRadius: BorderRadius.circular(29),
                                                //                 side: const BorderSide(color: Color(0xFF3B6FD4), width: 1),
                                                //               ),
                                                //               deleteIcon: Icon(
                                                //                 Icons.close,
                                                //                 color: primaryColor,
                                                //                 size: MySize.size15,
                                                //               ),
                                                //             ),
                                                //           );
                                                //         }).toList(),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),

                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: MySize.size15),
                                                  child: Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          final lPP = Provider.of<
                                                              LandingViewProvider>(
                                                              context,
                                                              listen: false);
                                                          final tagProvider = Provider
                                                              .of<CategoryTagProvider>(
                                                              context,
                                                              listen: false);

                                                          // Add your onPressed functionality here
                                                          for (var cat in snap[
                                                          'subCategory']) {
                                                            tagProvider
                                                                .addTag(cat);
                                                          }
                                                          tagProvider.savCategoryName(
                                                              snap[
                                                              'categoryName'],
                                                              snap['id']);
                                                          lPP.updateIndex(9);

                                                          // Add your onPressed functionality here
                                                        },
                                                        child: const Text(
                                                          'View',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            decoration:
                                                            TextDecoration
                                                                .underline,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          final tagProvider = Provider
                                                              .of<CategoryTagProvider>(
                                                              context,
                                                              listen: false);

                                                          // Add your onPressed functionality here
                                                          for (var cat in snap[
                                                          'subCategory']) {
                                                            tagProvider
                                                                .addTag(cat);
                                                          }
                                                          print(tagProvider.tag);
                                                          // tagProvider.tag.addAll( snap['subCategory']);
                                                          showCustomDialog(
                                                              context,
                                                              true,
                                                              snap[
                                                              'categoryName'],
                                                              snap['id']);
                                                        },
                                                        child: const Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            decoration:
                                                            TextDecoration
                                                                .underline,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          _showConfirmationDialog(
                                                              context,
                                                              snap['id']);
                                                          // Add your onPressed functionality here
                                                        },
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            decoration:
                                                            TextDecoration
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
                            }),
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
                              const Text('Show Rows',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item,
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ))
                                      .toList(),
                                  value: '${provider.itemsPerPage} Items',
                                  onChanged: (String? value) {
                                    int items = int.parse(
                                        value!.replaceRange(3, 8, ''));
                                    provider.setItemsPerPage(items);
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    height: 48,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                          width: 1),
                                    ),
                                  ),
                                  menuItemStyleData:
                                      const MenuItemStyleData(height: 48),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    NumberPagination(
                                      onPageChanged: (int pageNumber) {
                                        provider.setLastDocumentId(
                                            snapshot.data!.docs.last['id']);

                                        provider
                                            .setSelectedPageNumber(pageNumber);
                                      },
                                      pageTotal: (provider.totalDocuments /
                                              provider.itemsPerPage)
                                          .ceil(),
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
    });
  }

  Future<void> showCustomDialog(
      BuildContext context, bool editing, String cat, String docId) async {
    final TextEditingController firstController = TextEditingController();
    final TextEditingController secondController = TextEditingController();
    if (editing == true) {
      firstController.text = cat;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<CategoryTagProvider>(
          builder: (context, tagProvider, child) {
            return Dialog(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                        Text(
                          editing == true ? 'Edit Category' : 'Add Category',
                          style: const TextStyle(
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
                          hintText: 'Category',
                          controller: firstController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField13(
                          hintText: 'Sub Category',
                          controller: secondController,
                          sufixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                             if(secondController.text.isNotEmpty){
                               tagProvider.addTag(secondController.text);
                               secondController.clear();
                             }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                               onTap:  (){
                                 someFunction(context);
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: primaryColor,
                                  strokeWidth: 1,
                                  dashPattern: [5, 2],
                                  radius: const Radius.circular(10),
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      color: appColor,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Upload CVS',
                                            style: AppTextStylesInter.label14700P,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Tooltip(
                                message: 'You can add a cvs file here. The file should contain the names of all Sub Categories separated by comas(,)\n'
                                    'e.g. Sub category 1, Sub category 2, Sub category 3',
                                child: Icon(Icons.info)),
                          ],
                        ),
                        SizedBox(height: MySize.size10,),
                        SizedBox(
                          height: tagProvider.tag.length < 5 ? 100 : 200,
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: tagProvider.tags.map((tag) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(
                                          fontSize: 16, color: primaryColor),
                                    ),
                                    backgroundColor:
                                        primaryColor.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29),
                                      side: const BorderSide(
                                          color: Color(0xFF3B6FD4), width: 1),
                                    ),
                                    deleteIcon: Icon(
                                      Icons.close,
                                      color: primaryColor,
                                      size: MySize.size15,
                                    ),
                                    onDeleted: () => tagProvider.removeTag(tag),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton8(
                              onPressed: () {
                                tagProvider.tag.clear();
                                Navigator.of(context).pop();
                              },
                              text: 'Cancel',
                              backgroundColor: whiteColor,
                              textColor: blackColor,
                              height: MySize.size40,
                              width: MySize.size100,
                            ),
                            SizedBox(width: MySize.size10),
                            CustomButton8(
                              onPressed: () {
                                final obj = Provider.of<LoaderViewProvider>(
                                    context,
                                    listen: false);

                                // Add your action for 'Add' button here
                                if (editing) {
                                  obj.changeShowLoaderValue(true);
                                  FirebaseFirestore.instance
                                      .collection('Categories')
                                      .doc(docId)
                                      .update({
                                    'categoryName': firstController.text,
                                    'subCategory': tagProvider.tag
                                  }).then((value) {
                                    obj.changeShowLoaderValue(false);
                                    Utils.toastMessage('Category Updated');
                                    tagProvider.tag.clear();
                                  }).onError((error, stackTrace) {
                                    Utils.toastMessage(error.toString());
                                    print(error);
                                    obj.changeShowLoaderValue(false);
                                    tagProvider.tag.clear();
                                  });
                                } else {
                                  var id = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  obj.changeShowLoaderValue(true);
                                  FirebaseFirestore.instance
                                      .collection('Categories')
                                      .doc(id)
                                      .set({
                                    'id': id,
                                    'categoryName': firstController.text,
                                    'subCategory': tagProvider.tag
                                  }).then((value) {
                                    obj.changeShowLoaderValue(false);
                                    Utils.toastMessage('Category Added');
                                    tagProvider.tag.clear();
                                  }).onError((error, stackTrace) {
                                    Utils.toastMessage(error.toString());
                                    print(error);

                                    obj.changeShowLoaderValue(false);
                                    tagProvider.tag.clear();
                                  });
                                }

                                Navigator.of(context).pop();
                              },
                              text: editing == true ? 'Update' : 'Add',
                              height: MySize.size40,
                              width: MySize.size100,
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
      },
    );
  }

  Stream<QuerySnapshot> _fetchDocsForPage(
      int pageNumber, int itemsPerPage, String? lastDocumentId) {
    print(lastDocumentId);
    Query query =
        FirebaseFirestore.instance.collection('Categories').orderBy('id', descending: true);

    if (lastDocumentId != null && pageNumber > 1) {
      query = query.startAfter([lastDocumentId]);
    }

    return query.limit(itemsPerPage).snapshots();
  }

  int totalDocuments = 0;

  @override
  void initState() {
    super.initState();
    // Example: Fetch total documents and update the provider
    _fetchTotalDocuments();
  }

  Future<void> _fetchTotalDocuments() async {
    totalDocuments = await getTotalDocuments();
    Provider.of<PaginationProvider>(context, listen: false)
        .setTotalDocuments(totalDocuments);

    // You can set this total to a provider if needed
    // _paginationProvider.setTotalDocuments(totalDocuments);
  }

  Future<int> getTotalDocuments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Categories') // Replace 'User' with your collection name
        .get();

    return querySnapshot.size;
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
              Image.asset(
                projectCreated,
                height: 150,
              ), // Replace with your image asset
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
                'Are you sure, you want to delete this category?',
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
                    text: 'Cancel',
                  ),
                  CustomButton8(
                    width: 120,
                    height: 40,
                    onPressed: () {
                      final obj = Provider.of<LoaderViewProvider>(context,
                          listen: false);
                      obj.changeShowLoaderValue(true);
                      FirebaseFirestore.instance
                          .collection('Categories')
                          .doc(docId)
                          .delete()
                          .then((value) {
                        Navigator.pop(context);
                        obj.changeShowLoaderValue(false);
                        Utils.toastMessage('Deleted');
                      }).onError((error, stackTrace) {
                        Utils.toastMessage(error.toString());
                        obj.changeShowLoaderValue(false);
                      });
                    },
                    text: 'Confirm',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }




  Future<void> someFunction(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String content = String.fromCharCodes(file.bytes!);

      // Split the content by commas and trim each subcategory
      List<String> subcategories = content
          .split(',')
          .map((subcategory) => subcategory.trim())
          .where((subcategory) => subcategory.isNotEmpty)
          .toList();

      // Add subcategories to the provider
      final tagProvider = Provider.of<CategoryTagProvider>(context, listen: false);
      for (String subcategory in subcategories) {
        if (!tagProvider.tags.contains(subcategory)) {
          tagProvider.addTag(subcategory);
        }
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${subcategories.length} subcategories added from file')),
      );
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }}
