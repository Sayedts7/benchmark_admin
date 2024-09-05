import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/image_path.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate_admin_panel/utils/utils.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/firebase_functions.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/loader_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../utils/common_function.dart';
import '../../utils/constants/colors.dart';
import '../../utils/custom_widgets/custom_textfield.dart';
import '../../view_model/firebase/push_notifications.dart';
import '../../view_model/provider/file_picker_provider.dart';
import '../../view_model/provider/landing_view_provider.dart';

class MeetClientView extends StatelessWidget {
  MeetClientView({super.key});
  void _onMenuItemSelected(String value) {
    // Handle menu item selection here
    switch (value) {
      case 'Attach files':
        print('Attach files selected');
        break;
      case 'Refund amount':
        print('Refund amount selected');
        break;
    }
  }

  TextEditingController textController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  void showSubcategoriesDialog(BuildContext context, List<dynamic> subcategories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Subcategories'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0, // Space between chips horizontally
              runSpacing: 8.0, // Space between rows of chips
              children: subcategories.map<Widget>((subcategory) {
                return Chip(
                  label: Text(subcategory.toString(),
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
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    final fileProvider =
        Provider.of<FilePickerProvider>(context, listen: false);
    final landingProvider =
        Provider.of<LandingViewProvider>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Projects')
            .doc(landingProvider.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var snap = snapshot.data!;
            return SizedBox(
              height: MySize.size600,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ReusableContainer3(
                            // height: 250,
                            width: MySize.size1000,
                            bgColor: bgColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(avatar),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            snap['customerName'],
                                            style: AppTextStylesInter
                                                .label14600Black,
                                          ),
                                        ],
                                      ),
                                      // Text('Dec 27, 2022   8:00 AM', style: AppTextStylesInter.label14600Color,)
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: MySize.size40),
                                    child: Text(
                                      snap['message'],
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: MySize.size15),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: snap['status'] ==
                                                    'Requirements Submitted'
                                                ? Colors.grey.withOpacity(0.2)
                                                : snap['status'] == 'Completed'
                                                    ? greenLight
                                                    : snap['status'] ==
                                                            'Project Started'
                                                        ? blueLight
                                                        : yellowLight,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: snap['status'] ==
                                                      'Requirements Submitted'
                                                  ? Colors.grey
                                                  : snap['status'] ==
                                                          'Completed'
                                                      ? greenDark
                                                      : snap['status'] ==
                                                              'Project Started'
                                                          ? blueDark
                                                          : yellowDark,
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              snap['status'],
                                              style: TextStyle(
                                                fontSize: MySize.size14,
                                                color: snap['status'] ==
                                                        'Requirements Submitted'
                                                    ? Colors.grey
                                                    : snap['status'] ==
                                                            'Completed'
                                                        ? greenDark
                                                        : snap['status'] ==
                                                                'Project Started'
                                                            ? blueDark
                                                            : yellowDark,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        snap['price'] == ''
                                            ? 'N/A'
                                            : '\$ ${snap['price']}',
                                        style: AppTextStylesInter.label16600B,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                        //

                        ReusableContainer3(
                          width: MySize.size1000,
                          bgColor: bgColor,
                          child: Padding(
                            padding: EdgeInsets.all(MySize.size20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Categories',
                                  style: AppTextStylesInter.label14600Black,
                                ),
                                SizedBox(height: MySize.size15,),
                                SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8.0, // Space between chips horizontally
                                    runSpacing: 8.0, // Space between rows of chips
                                    children: snap['category'].keys.map<Widget>((categoryName) {
                                      List<dynamic> subcategories = snap['category'][categoryName];

                                      return GestureDetector(
                                        onTap: () => showSubcategoriesDialog(context, subcategories),
                                        child: Chip(
                                          label: Text(categoryName,
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

                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ReusableContainer3(
                            width: MySize.size1000,
                            bgColor: bgColor,
                            child: Padding(
                              padding: EdgeInsets.all(MySize.size20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Yor Reply',
                                    style: AppTextStylesInter.label14600Black,
                                  ),
                                  SizedBox(
                                    height: MySize.size20,
                                  ),
                                  CustomTextField13(
                                    controller: textController,
                                    hintText: 'Write Your Reply Here',
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: MySize.size20,
                                  ),
                                  Visibility(
                                    visible: snap['price'] == '' ? true : false,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField13(
                                            controller: priceController,
                                            hintText: 'Write the price Here',
                                            maxLines: 1,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 400,
                                        //   child: const CustomTextField13(
                                        //     hintText: 'Write deadline Here',
                                        //     maxLines: 2,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Consumer<FilePickerProvider>(
                          builder: (context, fp, child) {
                            return Wrap(
                              children: fileProvider.webFiles.map((file) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(uFile),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MySize.size80,
                                            child: Text(
                                              file.name,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: InkWell(
                                        onTap: () {
                                          fileProvider.removeWebFile(file);
                                        },
                                        child: SvgPicture.asset(
                                          close,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                        SizedBox(
                          width: MySize.size1000,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<String>(
                                onSelected: _onMenuItemSelected,
                                itemBuilder: (BuildContext context) {
                                  return {'Attach files', 'Refund amount'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      onTap: choice == 'Attach files'
                                          ? () {
                                              print(choice);
                                              fileProvider.pickFiles();
                                            }
                                          : () {},
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                                icon: const Icon(Icons.more_vert),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CustomButton8(
                                text: 'Chat',
                                onPressed: () {

                                  landingProvider.getClientUid(snap['userId']);
                                  landingProvider.updateIndex(8);

                                  // print(fileProvider.webFiles.length);
                                },
                                width: 150,
                                height: 50,
                                backgroundColor: whiteColor,
                                textColor: blackColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CustomButton8(
                                text: snap['price'] == ''
                                    ? 'Submit Quote'
                                    : 'Submit Project',
                                width: 150,
                                height: 50,
                                onPressed: () async {
                                  final loadingProvider = Provider.of<LoaderViewProvider>(context, listen: false);
                                  loadingProvider.changeShowLoaderValue(true);
                                  String? fcmToken = await FirestoreService().getTokenFromUserCollection(snap['userId']);

                                  if (snap['price'] == '') {
                                    if (textController.text.isEmpty) {
                                      Utils.toastMessage('Please enter a reply');
                                      loadingProvider.changeShowLoaderValue(false);
                                    } else if (priceController.text.isEmpty) {
                                      Utils.toastMessage('Please enter a price');
                                      loadingProvider.changeShowLoaderValue(false);
                                    }
                                    else if (!RegExp(r'^\d+$').hasMatch(priceController.text)) {
                                      Utils.toastMessage('Please enter a valid integer price');
                                      loadingProvider.changeShowLoaderValue(false);
                                    }
                                    else {
                                      FirebaseFirestore.instance
                                          .collection('Projects')
                                          .doc(snap['id'])
                                          .update({
                                        'adminMessage': textController.text,
                                        'price': priceController.text,
                                        'notificationSent': false,
                                        'status': 'Quote Submitted',
                                      }).then((value) async {
                                        await FirestoreService().setNotifications(
                                            snap['userId'],
                                            'Quote Received',
                                            'You have received a quote for your project',
                                            snap['id']);
                                        if (fcmToken != null) {
                                          await NotificationServices().sendNotification(
                                              fcmToken,
                                              context,
                                              'Quote Received',
                                              'You have received a quote for your project');
                                        }
                                        Utils.toastMessage('Quote Sent');
                                        textController.clear();
                                        priceController.clear();
                                        loadingProvider.changeShowLoaderValue(false);
                                      }).onError((error, stackTrace) {
                                        Utils.toastMessage(error.toString());
                                        loadingProvider.changeShowLoaderValue(false);
                                      });
                                    }
                                  } else {
                                    if (snap['paid']) {
                                      if (textController.text.isEmpty) {
                                        Utils.toastMessage('Please enter a reply');
                                        loadingProvider.changeShowLoaderValue(false);
                                      } else if (fileProvider.webFiles.isEmpty) {
                                        Utils.toastMessage('Please select a file');
                                        loadingProvider.changeShowLoaderValue(false);
                                      } else {
                                        List<Map<String, String>> fileData = [];

                                        if (fileProvider.webFiles.isNotEmpty) {
                                          try {
                                            int totalFiles = fileProvider.webFiles.length;
                                            int uploadedFiles = 0;

                                            // Show the progress dialog
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ValueListenableBuilder<double>(
                                                        valueListenable: fileProvider.uploadProgress,
                                                        builder: (context, progress, child) {
                                                          return Column(
                                                            children: [
                                                              CircularProgressIndicator(value: progress / 100),
                                                              const SizedBox(height: 20),
                                                              Text('${progress.toStringAsFixed(2)}% uploaded'),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );

                                            if (kIsWeb) {
                                              var randomId = DateTime.now().millisecondsSinceEpoch.toString();
                                              // For web
                                              for (var file in fileProvider.webFiles) {
                                                String fileName = file.name;
                                                var ref = FirebaseStorage.instance.ref().child('adminFiles/$randomId/$fileName');
                                                UploadTask uploadTask = ref.putData(file.bytes!);

                                                uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                                                  double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                                                  fileProvider.uploadProgress.value = progress;
                                                });

                                                TaskSnapshot snapshot = await uploadTask;
                                                String downloadUrl = await snapshot.ref.getDownloadURL();
                                                fileData.add({
                                                  'name': fileName,
                                                  'url': downloadUrl,
                                                });

                                                uploadedFiles++;
                                                fileProvider.uploadProgress.value = (uploadedFiles / totalFiles) * 100;
                                              }
                                            }

                                            // Save project details along with file data in Firestore
                                            FirebaseFirestore.instance
                                                .collection('Projects')
                                                .doc(snap['id'])
                                                .update({
                                              'adminMessageOnComplete': textController.text,
                                              'adminComplete': true,
                                              'adminFileData': fileData,
                                            });

                                            await FirestoreService().setNotifications(
                                                snap['userId'],
                                                'Project Delivered',
                                                'Your Project has been completed',
                                                snap['id']);
                                            if (fcmToken != null) {
                                              await NotificationServices().sendNotification(
                                                  fcmToken,
                                                  context,
                                                  'Project Delivered',
                                                  'Your Project has been completed');
                                            }

                                            loadingProvider.changeShowLoaderValue(false);
                                            Utils.toastMessage('Completed');

                                            Navigator.of(context).pop(); // Close the dialog
                                            fileProvider.clearAll();
                                          } catch (error) {
                                            Navigator.of(context).pop(); // Close the dialog in case of error
                                            Utils.toastMessage(error.toString());
                                          }
                                        }
                                      }
                                    } else {
                                      Utils.toastMessage('The user has not paid yet');
                                      loadingProvider.changeShowLoaderValue(false);
                                    }
                                  }
                                },                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ReusableContainer2(
                            height: 800, // here 800
                            width: MySize.size240,
                            bgColor: bgColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Files',
                                    style: AppTextStylesInter.label14600Black,
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snap['fileUrls'].length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: MySize.size15),
                                              child: InkWell(
                                                onTap: () {
                                                  CommonFunctions.launchURL(
                                                      snap['fileUrls'][index]);
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 200,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor
                                                              .withOpacity(
                                                                  0.25),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child:
                                                              SvgPicture.asset(
                                                                  file),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child: Text(
                                                              snap['fileUrls']
                                                                  [index],
                                                              style: TextStyle(
                                                                fontSize: MySize
                                                                    .size12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            '50KB',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  MySize.size12,
                                                              color:
                                                                  bodyTextColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  Visibility(
                                    visible: (snap['assigned'] == false ? true : false)  &&( snap['price'] == '' ? false : true),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Divider(
                                            color: secondaryColor,
                                            thickness: 2,
                                          ),
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Assign Task',
                                              style: AppTextStylesInter
                                                  .label14600Black,
                                            ),
                                            // IconButton(
                                            //     onPressed: () {
                                            //       CommonFunctions
                                            //           .showAssigneeAddDialog(
                                            //               context);
                                            //     },
                                            //     icon: const Icon(Icons.add))
                                          ],
                                        ),
                                        SizedBox(
                                          height: MySize.size15,
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: SizedBox(
                                            height: MySize.size40,
                                            width: double.infinity,
                                            child: CustomTextField13(
                                              fillColor: whiteColor,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.all(
                                                    MySize.size10),
                                                child: SvgPicture.asset(
                                                  search,
                                                ),
                                              ),
                                              hintText: 'Search Anything...',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 260,
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Assignees')
                                                  .snapshots(),
                                              builder: (context, snapshot2) {
                                                if (snapshot2.hasError) {
                                                  return const Icon(
                                                      Icons.error);
                                                } else if (snapshot2
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (snapshot2.hasData) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            CommonFunctions
                                                                .showAssigneeAddDialog(
                                                                context);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon((Icons.add)),
                                                              SizedBox(width: 5,),
                                                              Text('Add New'),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                          itemCount: snapshot2
                                                              .data!.docs.length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const AlwaysScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            var snap2 = snapshot2
                                                                .data!.docs[index];
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  CommonFunctions.showConfirmationDialog(
                                                                      context,
                                                                      snap2[
                                                                          'email'],
                                                                      snap[
                                                                          'message'],
                                                                      snap.id,
                                                                      snap2['name'],
                                                                      snap[
                                                                          'fileUrls']);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Image.asset(
                                                                        avatar),
                                                                    SizedBox(
                                                                      width: MySize
                                                                          .size10,
                                                                    ),
                                                                    Text(
                                                                      snap2['name'],
                                                                      style: AppTextStylesInter
                                                                          .label14600Black,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),

                                                    ],
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: snap['assigned'] == true ? true : false  ,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Divider(
                                            color: secondaryColor,
                                            thickness: 2,
                                          ),
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Task assigned to:',
                                              style: AppTextStylesInter
                                                  .label14600Black,
                                            ),
                                            // IconButton(
                                            //     onPressed: () {
                                            //       CommonFunctions
                                            //           .showAssigneeAddDialog(
                                            //               context);
                                            //     },
                                            //     icon: const Icon(Icons.add))
                                          ],
                                        ),

                                        // SizedBox(
                                        //   height: 60,
                                        //   child: SizedBox(
                                        //     height: MySize.size40,
                                        //     width: double.infinity,
                                        //     child: CustomTextField13(
                                        //       fillColor: whiteColor,
                                        //       prefixIcon: Padding(
                                        //         padding: EdgeInsets.all(
                                        //             MySize.size10),
                                        //         child: SvgPicture.asset(
                                        //           search,
                                        //         ),
                                        //       ),
                                        //       hintText: 'Search Anything...',
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 100,
                                          child:Row(
                                            children: [
                                              Image.asset(
                                                  avatar),
                                              SizedBox(
                                                width: MySize
                                                    .size10,
                                              ),
                                              Text(
                                                snap['assigneeName'],
                                                style: AppTextStylesInter
                                                    .label14600Black,
                                              ),
                                              Spacer(),
                                              IconButton(
                                                onPressed: (){
                                                  UnAssignProject(snap['id']);
                                                },
                                                icon: Icon(Icons.close),
                                                tooltip: "UnAssign",

                                              )
                                            ],
                                          ),   ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
  Future<void> UnAssignProject(String projectId,  ) async {
    try {
      // Get a reference to the Firestore collection "Projects"
      CollectionReference projects = FirebaseFirestore.instance.collection('Projects');

      // Update the fields in the document with ID projectId
      await projects.doc(projectId).update({
        'assigned': false,
        'assignedTo': '',
        'assigneeName':''
      });
      Utils.toastMessage('Project UnAssigned');
      print('Project updated successfully');
    } catch (e) {
      Utils.toastMessage(e.toString());
      print('Error updating project: $e');
    }
  }

}
