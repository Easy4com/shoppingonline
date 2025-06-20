import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shoppingonline/utility/app_constant.dart';
import 'package:shoppingonline/utility/app_controller.dart';
import 'package:shoppingonline/utility/app_dialog.dart';
import 'package:shoppingonline/utility/app_service.dart';
import 'package:shoppingonline/widgets/body_cart.dart';
import 'package:shoppingonline/widgets/body_order.dart';
import 'package:shoppingonline/widgets/body_profile.dart';
import 'package:shoppingonline/widgets/body_shopping.dart';
import 'package:shoppingonline/widgets/widget_button.dart';
import 'package:shoppingonline/widgets/widget_image_asset.dart';
import 'package:shoppingonline/widgets/widget_text.dart';
import 'package:shoppingonline/widgets/widget_text_rich.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  AppController appController = Get.put(AppController());

  var titles = <String>['Shopping', 'ตระกร้า', 'ออเตอร์', 'โปรไฟร์'];
  var iconDatas = <IconData>[
    Icons.storefront,
    Icons.shopping_cart_outlined,
    Icons.credit_card,
    Icons.person_outline
  ];
  var bodys = <Widget>[BodyShopping(), BodyCart(), BodyOrder(), BodyProfile()];

  List<BottomNavigationBarItem> items = [];

  @override
  void initState() {
    super.initState();

    AppService().findCurrentUserModels();

    for (var i = 0; i < bodys.length; i++) {
      items.add(
          BottomNavigationBarItem(icon: Icon(iconDatas[i]), label: titles[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: GFColors.WHITE,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(84),
              child: Column(
                children: [
                  SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetImageAsset(pathImage: 'images/logo.png', width: 72),
                      Text(
                        'Shopping Online',
                        style: AppConstant.h2Style(fontSize: 18),
                      ),
                      Spacer(),
                      appController.indexBody.value == 3
                          ? WidgetButton(
                              text: 'SignOut',
                              onPressed: () {
                                AppDialog().normalDialog(
                                    icon: WidgetImageAsset(
                                        pathImage: 'images/intro3.png'),
                                    title: WidgetText(
                                      text: 'Confirm SignOut',
                                      textStyle: AppConstant.h2Style(),
                                    ),
                                    content: WidgetTextRich(
                                        head: 'Confirm Signout : ',
                                        body: 'Tap Confirm Button'),
                                    firstAction: WidgetButton(type: GFButtonType.outline2x,
                                      text: 'Confirm',
                                      onPressed: () async {
                                        await FirebaseAuth.instance
                                            .signOut()
                                            .whenComplete(
                                          () {
                                            Get.delete();
                                            Get.offAllNamed('/signinsignup');
                                          },
                                        );
                                      },
                                    ));
                              },
                              type: GFButtonType.outline)
                          : SizedBox(),
                      SizedBox(width: 16),
                    ],
                  ),
                ],
              )),
          body: bodys[appController.indexBody.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appController.indexBody.value,
            type: BottomNavigationBarType.fixed,
            items: items,
            onTap: (value) {
              appController.indexBody.value = value;
            },
          ),
        ));
  }
}
