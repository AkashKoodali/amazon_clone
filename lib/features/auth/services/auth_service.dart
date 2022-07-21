import 'dart:convert';

import 'package:amazon_clone_tutorial/application/user_provider.dart';
import 'package:amazon_clone_tutorial/common/bottom_bar.dart';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';


import 'package:amazon_clone_tutorial/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //signup user
  void singnUpUser({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [],
      );
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      print(res.body);
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Account created! Login with the same credentials",
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //signin user
  void singnInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      print(res.body);
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen:false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
          Navigator.pushNamedAndRemoveUntil(
                                context,
                                BottomBar.routeName,
                                (route)=>false ,
                              );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http
          .post(Uri.parse("$uri/tokenIsValid"), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      });

      var responce = jsonDecode(tokenRes.body);
      
      if (responce == true) {
        //get user data
        http.Response userRes =
            await http.get(Uri.parse('$uri/'), 
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });

        var userProvider = Provider.of<UserProvider>(context,listen: false);
        userProvider.setUser(userRes.body);
      }
      
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
