import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/image_path.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/custom_textfield.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../../view_model/firebase/auth_services.dart';
import '../../login_view.dart';

class Header extends StatefulWidget {
  final String title;
  final String subtitle;

  const Header({super.key, required this.title, required this.subtitle});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  OverlayEntry? _overlayEntry;
  bool _isNotificationOpen = false;

  void _toggleNotifications() {
    if (_isNotificationOpen) {
      _closeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      _isNotificationOpen = true;
    });
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    setState(() {
      _isNotificationOpen = false;
    });
  }


    OverlayEntry _createOverlayEntry() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      return OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: _closeOverlay,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx + size.width - 450, // Increased width
                top: offset.dy + size.height + 10,
                width: 400, // Increased width
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 500,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Notifications',
                                style: AppTextStylesInter.label12600B,
                              ),
                              TextButton(
                                onPressed: () {
                                  // Mark all as read functionality
                                  _markAllNotificationsAsRead();
                                },
                                child: Text(
                                  'Mark all as read',
                                  style: AppTextStylesInter.label14400BTC.copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Notifications')
                                .where('toId', isEqualTo: 'admin')
                                .orderBy('date', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data!.docs.isEmpty){
                                  return const Center(child: Text('No notifications'));

                                }
                                return ListView.separated(
                                  itemCount: snapshot.data!.docs.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    var notification = snapshot.data!.docs[index];
                                    bool isUnread = !(notification['read'] ?? false);
                                    return ListTile(
                                      tileColor: isUnread ? appColor.withOpacity(0.5) : null,
                                      leading: CircleAvatar(
                                        backgroundColor: appColor.withOpacity(0.2),
                                        child: Icon(Icons.notifications, color: isUnread ? primaryColor : appColor),
                                      ),
                                      title: Text(
                                        notification['title'] ?? '',
                                        style: AppTextStylesInter.label13500B,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            notification['message'] ?? '',
                                            style: AppTextStylesInter.label14400BTC,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notification['date'] != null
                                                ? _formatDate((notification['date'] as Timestamp).toDate())
                                                : '',
                                            style: AppTextStylesInter.label12400BTC.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        _toggleNotifications();

                                        final landingProvider = Provider.of<LandingViewProvider>(context, listen:  false);

                                        landingProvider.getDocId(notification['projectId']);
                                        print(notification['title']);
                                        if(notification['title'] == 'New Message'){
                                          landingProvider.getClientUid(notification['fromId']);
                                        landingProvider.updateIndex(8);
                                        }else{
                                          landingProvider.updateIndex(7);
                                        }

                                      },
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Icon(Icons.error));
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else {
                                return const Center(child: Text('No notifications'));
                              }
                            },
                          ),
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


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE').format(date)} ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, y h:mm a').format(date);
    }
  }
  void _markAllNotificationsAsRead() {
    FirebaseFirestore.instance
        .collection('Notifications')
        .where('toId', isEqualTo: 'admin')
        .where('read', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }
      return batch.commit();
    }).then((_) {
      // Optional: Show a snackbar or some other feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    }).catchError((error) {
      // Handle any errors
      print('Error marking notifications as read: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark notifications as read')),
      );
    });
  }
  // final LandingPageController landingPageController =
  // Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    final landingProvider =
    Provider.of<LandingViewProvider>(context, listen: false);
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MySize.size32, vertical: MySize.size16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: AppTextStylesInter.label24700B),
                Text(widget.subtitle, style: AppTextStylesInter.label12400BTC),
              ],
            ),
            const Spacer(),
            Expanded(
              child: SizedBox(
                height: MySize.size65,
                width: MySize.size270,
                child: Consumer<LandingViewProvider>(
                  builder: (context, value, child){
                    return  CustomTextField13(
                      onChanged: (val){
                       value.updateSearchQuery(val);
                      },
                      fillColor: Colors.white,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(MySize.size8),
                        child: SvgPicture.asset(
                          search,
                          height: MySize.size20,
                        ),
                      ),
                      hintText: 'Search Anything...',
                    );
                  },

                ),
              ),
            ),
            SizedBox(width: MySize.size20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Notifications')
                  .where('toId', isEqualTo: 'admin')
                  .where('read', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                return GestureDetector(
                  onTap: _toggleNotifications,
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -15, end: -12),
                    showBadge: unreadCount > 0,
                    badgeContent: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.red,
                      padding: EdgeInsets.all(5),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: bodyTextColor,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: MySize.size20),
            Image.asset(avatar),
            SizedBox(width: MySize.size20),
            PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: (String value) {
                if (value == 'logout') {
                  // Handle logout action here
                  _showLogoutDialog(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),          ],
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
                onPressed: ()async{
                  // String? token = await FirestoreService().getTokenFromUserCollection(FirebaseAuth.instance.currentUser!.uid);
                  //  NotificationServices().sendNotification(
                  //    token!,
                  //      context, 'Quote Received', 'You have received a quote for your project');

                  AuthServices().signOut().then((value){
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context)=> const LoginView()), (route) => false);
                    // Navigator.of(context).pop(); // Close the dialog
                  }).onError((error, stackTrace) {
                    Utils.toastMessage(error.toString());
                    Navigator.pop(context);
                  });
                },

            ),
          ],
        );
      },
    );
  }
}