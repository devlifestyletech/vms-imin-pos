import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imin/controllers/repassword_controller.dart';
import 'package:imin/controllers/screen_controller.dart';
import 'package:imin/models/item_model.dart';
import 'package:imin/views/screens/ChangePassword/change_password_screen.dart';
import 'package:imin/views/screens/EntranceProject/entrance_project_screen.dart';
import 'package:imin/views/screens/ExitProject/exit_project_screen.dart';
import 'package:imin/views/screens/Profile/profile_screen.dart';

class ExpansionPanelController extends GetxController {
  int selected = -1.obs; //attention
  int rememberSelected = -1.obs;
  Widget currentContent = EntranceProjectScreen();
  GlobalKey<ScaffoldState> keyDrawer = GlobalKey();

  final reController = Get.put(RePasswordController());
  final screenController = Get.put(ScreenController());

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      icon: Icons.timer,
      titleItem: 'เวลาเข้าโครงการ',
      currentContent: EntranceProjectScreen(),
      subItem: [],
      subItemSelect: [],
      onClick: [],
    ),
    ItemModel(
      icon: Icons.schedule,
      titleItem: 'เวลาออกจากโครงการ',
      currentContent: ExitProjectScreen(),
      subItem: [],
      onClick: [],
    ),
    ItemModel(
      icon: Icons.settings,
      titleItem: 'ตั้งค่า',
      currentContent: ProfileScreen(),
      subItem: ['ข้อมูลส่วนตัว', 'เปลี่ยนรหัสผ่าน'],
      subItemSelect: [true, false],
      onClick: [
        ProfileScreen(),
        ChangePasswordScreen(),
      ],
    ),
  ];
  List<ItemModel> itemDataM2Pro = <ItemModel>[
    ItemModel(
      icon: Icons.timer,
      titleItem: 'เวลาเข้าโครงการ',
      currentContent: EntranceProjectScreen(),
      subItem: [],
      subItemSelect: [],
      onClick: [],
    ),
    ItemModel(
      icon: Icons.schedule,
      titleItem: 'เวลาออกจากโครงการ',
      currentContent: ExitProjectScreen(),
      subItem: [],
      onClick: [],
    ),
  ];

  onExpansionChanged(bool v, int index) {
    if (rememberSelected == index && v == false) {
      if (screenController.DeviceCurrent == Device.iminM2Pro) {
        keyDrawer.currentState!.openEndDrawer();
        print('keyUpdate: $keyDrawer');
        update(['aVeryUniqueID']);
      } else {
        selected = -1;
      }
      // selected = -1;

      update(['aopbmsbbffdgkb']);
      return;
    }

    rememberSelected = index;
    itemData[index].expanded = v;
    currentContent = itemData[index].currentContent;

    // clear selected index 0
    if (itemData[index].subItemSelect.length > 0) {
      itemData[index].subItemSelect = [true, false];
    }

    selected = index;

    if (screenController.DeviceCurrent == Device.iminM2Pro) {
      keyDrawer.currentState!.openEndDrawer();
    }
    reController.clear();

    // update menu
    update(['aVeryUniqueID']); // and then here

    // update content
    update(['aopbmsbbffdgkb']); // and then here
  }

  updateSubItemSelector(int itemDataIndex, int subItemIndex) {
    for (int i = 0; i < itemData[itemDataIndex].subItem.length; i++) {
      if (subItemIndex == i) {
        itemData[itemDataIndex].subItemSelect[i] = true;
        currentContent = itemData[itemDataIndex].onClick[i];
      } else {
        itemData[itemDataIndex].subItemSelect[i] = false;
      }
    }
    if (screenController.DeviceCurrent == Device.iminM2Pro) {
      keyDrawer.currentState!.openEndDrawer();
    }
    reController.clear();

    // update menu
    update(['aVeryUniqueID']); // and then here

    // update content
    update(['aopbmsbbffdgkb']); // and then here

    // print('selected: $selected');
  }

  setDefaultValues() {
    selected = -1.obs; //attention
    rememberSelected = -1.obs;
    currentContent = EntranceProjectScreen();

    itemData = <ItemModel>[
      ItemModel(
        icon: Icons.timer,
        titleItem: 'เวลาเข้าโครงการ',
        currentContent: EntranceProjectScreen(),
        subItem: [],
        subItemSelect: [],
        onClick: [],
      ),
      ItemModel(
        icon: Icons.schedule,
        titleItem: 'เวลาออกจากโครงการ',
        currentContent: ExitProjectScreen(),
        subItem: [],
        onClick: [],
      ),
      ItemModel(
        icon: Icons.settings,
        titleItem: 'ตั้งค่า',
        currentContent: ProfileScreen(),
        subItem: ['ข้อมูลส่วนตัว', 'เปลี่ยนรหัสผ่าน'],
        subItemSelect: [true, false],
        onClick: [
          ProfileScreen(),
          ChangePasswordScreen(),
        ],
      ),
    ];

    // update menu
    update(['aVeryUniqueID']); // and then here

    // update content
    update(['aopbmsbbffdgkb']); // and then here
  }
}
