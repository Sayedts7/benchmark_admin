import 'package:benchmark_estimate_admin_panel/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view_model/provider/loader_view_provider.dart';
import 'constants/MySize.dart';
import 'constants/colors.dart';
import 'constants/image_path.dart';
import 'custom_widgets/custom_button.dart';
import 'custom_widgets/custom_textfield.dart';


class CommonFunctions {
  static String? validateTextField(value, BuildContext context,String type) {
    if(type == 'email'){
      if (value == null || value.isEmpty) {
        return 'Enter your Email';
      } else if (value.isNotEmpty) {
        String emailOfuser1 = value.toString();
        // final RegExp _emailRegExp = RegExp(
        //   r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
        // );
        String pattern = r'\w+@\w+\.\w+';
        if (RegExp(pattern).hasMatch(emailOfuser1) == false) {
          return 'Enter a valid email';
        }
      }
      return null;
    }
    else if(type == 'password'){
      if (value == null || value.isEmpty) {
        return 'Enter password';
      } else if(value.toString().length < 6) {
        return 'Password too short';
      }

    }
    else if(type == 'name'){
      if (value == null || value.isEmpty) {
        return 'Enter your name';
      } else {
        return null;
      }
    }
    else if(type == 'userName'){
      if (value == null || value.isEmpty) {
        return 'Enter  Username';
      } else {
        return null;
      }
    }

    else if(type == 'phone'){
      if (value == null || value.isEmpty) {
        return 'Enter your phone number';
      } else {
        return null;
      }
    }
    else if(type =='project name'){
      if (value == null || value.isEmpty) {
        return 'Enter your project name';
      } else {
        return null;
      }
    }
    else if(type =='date'){
      if (value == null || value.isEmpty) {
        return 'Enter a date';
      } else {
        return null;
      }
    }

  }
// static void loginFailedDialog(BuildContext context, String error, VoidCallback onTap){
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title:  Text(AppLocale.signInFailed.getString(context)),
//         content: Text(error),
//         actions: [
//           TextButton(
//             child:  Text(AppLocale.ok.getString(context)),
//             onPressed: onTap,
//           ),
//         ],
//       );
//     },
//   );
// }

  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('No Internet'),
        content:
        Text('Please Check your internet connection'),
        actions: [
          ElevatedButton(
            child:  Text('Ok'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

 static Future<void> showAssigneeAddDialog(
      BuildContext context,
      ) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: whiteColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      'Add Assignee',
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton8(
                          onPressed: () {
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
                          onPressed: () async {
                            var id = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            final loadingProvider =
                            Provider.of<LoaderViewProvider>(context,
                                listen: false);
                            loadingProvider.changeShowLoaderValue(true);
                            FirebaseFirestore.instance
                                .collection('Assignees')
                                .doc(id)
                                .set({
                              'name': nameController.text,
                              'email': emailController.text,
                              'id': id
                            }).then((value) {
                              Navigator.pop(context);
                              Utils.toastMessage('Added');
                              loadingProvider.changeShowLoaderValue(false);
                            }).onError((error, stackTrace) {
                              loadingProvider.changeShowLoaderValue(false);
                              Utils.toastMessage(error.toString());
                            });
                          },
                          text: 'Add',
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
  }

  static void showConfirmationDialog(
      BuildContext context,
      String developerEmail,
      String projectDetails,
      String docId,
      String name,
      List<dynamic> fileUrls) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Assignment'),
          content: Text(
              'Are you sure you want to assign this project to $developerEmail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String subject = 'New Project Assignment';
                final String body =
                    'You have been assigned a new project.\n\nDetails: $projectDetails\n\nAttachments: ${fileUrls.join('\n')}';
                sendEmail(developerEmail, subject, body, fileUrls);
                Navigator.of(context).pop();
                _showConfirmationDialog(context, docId, developerEmail, name);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

 static Future<void> sendEmail(
      String to, String subject, String body, List<dynamic> attachments) async {
    final String email = Uri.encodeComponent(to);
    final String emailSubject = Uri.encodeComponent(subject);
    final String emailBody = Uri.encodeComponent(body);

    final String emailUrl =
        'mailto:$email?subject=$emailSubject&body=$emailBody';

    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

 static void _showConfirmationDialog(
      BuildContext context, String docId, String email, String name) {
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
                'Have you Assigned the project?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomButton8(
                    width: 100,
                    height: 40,
                    backgroundColor: whiteColor,
                    textColor: blackColor,
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    text: 'No',
                  ),
                  CustomButton8(
                    width: 100,
                    height: 40,
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Projects')
                          .doc(docId)
                          .update({
                        'assigned': true,
                        'assignedTo': email,
                        'assigneeName': name,
                      }).then((value) {
                        Utils.toastMessage('Project Assigned');
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        Utils.toastMessage(error.toString());
                        print(error);
                        Navigator.pop(context);
                      });
                    },
                    text: 'Yes',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> checkProjectsAndCreateNotifications() async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();

    QuerySnapshot projectsSnapshot = await firestore
        .collection('Projects')
        .where('notificationSent', isEqualTo: false)
        . where('status', isNotEqualTo: 'Completed')
        .where('paid', isEqualTo: true)
        .get();

    WriteBatch batch = firestore.batch();

    for (var doc in projectsSnapshot.docs) {
      Map<String, dynamic> project = doc.data() as Map<String, dynamic>;
      DateTime startDate = (project['startDate'] as Timestamp).toDate();
      DateTime deadLine = (project['deadLine'] as Timestamp).toDate();

      Duration totalDuration = deadLine.difference(startDate);
      Duration elapsedDuration = now.difference(startDate);
      double completionPercentage = elapsedDuration.inMilliseconds / totalDuration.inMilliseconds * 100;

      if (completionPercentage >= 80) {
        // Create a new notification
        DocumentReference newNotificationRef = firestore.collection('Notifications').doc();
        batch.set(newNotificationRef, {
          'title': 'Project Nearing Deadline',
          'message': 'Project ${doc.id} deadline is almost over, Remember to complete it by then',
          'date': Timestamp.now(),
          'read': false,
          'toId': 'admin',
          'projectId': doc.id
        });

        // Mark the project as notified
        batch.update(doc.reference, {'notificationSent': true});
      }
    }

    // Commit the batch
    await batch.commit();
  }


}