import 'package:amazon_clone_tutorial/application/user_provider.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/account/widget/below_app_bar.dart';
import 'package:amazon_clone_tutorial/features/account/widget/orders.dart';
import 'package:amazon_clone_tutorial/features/account/widget/top_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/amazon_in.png',
                width: 120,
                height: 45,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: const[
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Icon(
                      Icons.notifications_outlined,
                    ),
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children:const [
          BelowAppBar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 20),
          Orders(),
        ],
      ),
    );
  }
}
