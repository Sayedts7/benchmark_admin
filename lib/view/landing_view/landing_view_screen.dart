import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/image_path.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/textStyles.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/loader_view.dart';
import 'package:benchmark_estimate_admin_panel/view/admins/admin_view.dart';
import 'package:benchmark_estimate_admin_panel/view/clients/clients_view.dart';
import 'package:benchmark_estimate_admin_panel/view/landing_view/components/header.dart';
import 'package:benchmark_estimate_admin_panel/view/landing_view/components/side_bar.dart';
import 'package:benchmark_estimate_admin_panel/view/meet_with_client/meet_with_client_view.dart';
import 'package:benchmark_estimate_admin_panel/view/orders/orders_view.dart';
import 'package:benchmark_estimate_admin_panel/view/overview/overview_screen.dart';
import 'package:benchmark_estimate_admin_panel/view/payments/payment_view.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/push_notifications.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../add_category/add_category_view.dart';
import '../add_category/subCategories_view.dart';
import '../chat/chat_view.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    NotificationServices().sendPushMessage('tokenReceiver', 'body', 'title');
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xffF8FAFC),
          body: Consumer<LandingViewProvider>(
            builder: (context, lvp, child){
              // lvp.checkProjectsAndCreateNotifications();
              return Row(
                children: [
                  const SideBar(),
                  // VerticalDivider(),
                  MySize.screenWidth < 1400
                      ? Expanded(
                    child: SizedBox(
                      height: 1100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 1200,
                          child: Column(
                            children: [
                              Header(
                                  title:
                                  lvp.index == 1 ? 'Overview':
                                  lvp.index == 2? 'Payments':
                                  lvp.index == 3? 'Clients':
                                  lvp.index == 4 ? 'Admin':
                                  lvp.index == 5 ? 'Categories':
                                  lvp.index == 6 ? 'Orders':
                                  '',
                                subtitle: lvp.index == 1 ? 'Detailed information about your store':
                                lvp.index == 2 ? 'Detailed information about your payments':
                                lvp.index == 3 ? 'Detailed information about your Clients':
                                lvp.index == 4 ?  'Detailed information about Admins':
                                lvp.index == 5?  'Detailed information about your Categories':
                                lvp.index == 6?  'Detailed information about your Orders':
                                '',),
                              lvp.index == 1? const Overview():
                              lvp.index == 2 ? const PaymentView():
                              lvp.index == 3 ? const ClientsView():
                              lvp.index == 4? const AdminView():
                              lvp.index == 5? const CategoryView():
                              lvp.index == 6 ? const OrdersView():
                              lvp.index == 7? MeetClientView():
                              lvp.index == 8? AdminChatScreen():
                              lvp.index == 9? const SubCategoryView():
                              lvp.index == 10? const OrdersView():
                              Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : Expanded(
                      child: Column(
                        children: [
                          Header(
                              title:
                              lvp.index == 1 ? 'Overview':
                              lvp.index == 2? 'Payments':
                              lvp.index == 3? 'Clients':
                              lvp.index == 4 ? 'Admin':
                              lvp.index == 5 ? 'Categories':
                              lvp.index == 6 ? 'Orders':
                              '',

                            subtitle: lvp.index == 1 ? 'Detailed information about your store':
                            lvp.index == 2 ? 'Detailed information about your payments':
                            lvp.index == 3 ? 'Detailed information about your Clients':
                            lvp.index == 4 ?  'Detailed information about Admins':
                            lvp.index == 5?  'Detailed information about your Categories':
                            lvp.index == 6?  'Detailed information about your Orders': '',
                          ),
                          lvp.index == 1? const Overview():
                          lvp.index == 2 ? const PaymentView():
                          lvp.index == 3 ? const ClientsView():
                          lvp.index == 4? const AdminView():
                              lvp.index == 5? const CategoryView():
                              lvp.index == 6 ? const OrdersView():
                              lvp.index == 7? MeetClientView():
                              lvp.index == 8? AdminChatScreen():
                              lvp.index == 9? const SubCategoryView():
                              lvp.index == 10? const OrdersView():

                              Container(),
                        ],
                      ))
                ],
              );
            },

          ),
        ),
        const LoaderView()
      ],
    );
  }
}
