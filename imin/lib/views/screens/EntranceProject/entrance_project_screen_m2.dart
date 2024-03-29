import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imin/controllers/camera_controller.dart';
import 'package:imin/controllers/entrance_project_controller.dart';
import 'package:imin/controllers/entrance_project_controller_m2.dart';
import 'package:imin/controllers/expansion_panel_controller.dart';
import 'package:imin/controllers/upload_personal_controller.dart';
import 'package:imin/helpers/constance.dart';
import 'package:imin/views/screens/EntranceProject/printerBlue.dart';
// import 'package:imin/views/screens/EntranceProject/printerBlue.dart';
import 'package:imin/views/screens/EntranceProject/printer_screen.dart';
import 'package:imin/views/screens/EntranceProject/upload_personal_screen.dart';
import 'package:imin/views/screens/ExitProject/exit_project_d1_pro_screen.dart';
import 'package:imin/views/screens/ExitProject/exit_project_screen.dart';
import 'package:imin/views/widgets/round_button_icon.dart';
import 'package:imin/views/widgets/round_button_number.dart';
import 'package:imin/views/widgets/title_content.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class EntranceProjectScreenM2 extends StatefulWidget {
  EntranceProjectScreenM2({Key? key}) : super(key: key);

  @override
  _EntranceProjectScreenM2State createState() =>
      _EntranceProjectScreenM2State();
}

class _EntranceProjectScreenM2State extends State<EntranceProjectScreenM2> {
  final entranceController = Get.put(EntranceProjectControllerM2());
  final uploadPersonalController = Get.put(UploadPersonalController());
  final cameraController = Get.put(TakePictureController());

  syncFunction() async {
    // controller.getDataEntrance(); //Allist
    entranceController.getEntranceData(); // 3 list
  }

  @override
  void initState() {
    // syncFunction();
    super.initState();
  }

  TextEditingController findControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    entranceController.context = context;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TitleContent(
                    text: 'เวลาเข้าโครงการ',
                    fontSize: titleM2FontSize,
                  ),
                  // TextButton(onPressed: () {}, child: Text('ทดสอบปริ้น'))
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 0, right: 0),
                      width: size.width * 0.50,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        border: Border.all(color: textColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                        onChanged: (v) =>
                            entranceController.filterSearchResults(v),
                        style: TextStyle(fontSize: normalM2FontSize),
                        decoration: InputDecoration(
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 23, maxHeight: 20),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 20,
                          ),
                          border: OutlineInputBorder(),
                          hintText:
                              'ค้นหาเลขทะเบียนรถ, บ้านเลขที่, ชื่อนามสกุล',
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: purpleBlueColor),
                          ),
                        ),
                      ),
                    ),
                    // TextButton(
                    //     onPressed: () => controller.getDataEntrance(),
                    //     // onPressed: () => controller.getEntranceData(),
                    //     child: Text('pulldata')),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GetBuilder<ExpansionPanelController>(
                          builder: (c) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: redAlertColor,
                              // fixedSize: Size(105, 10),
                              side: BorderSide(
                                width: 1,
                                color: redAlertColor,
                              ),
                            ),
                            onPressed: () {
                              cameraController.imageUrl.value = "";
                              uploadPersonalController.initValue();
                              c.currentContent = UploadPersonalScreen();
                              // c.currentContent = PrinterScreen();
                              // c.currentContent = PrinterBlueScreen();
                              c.update(['aopbmsbbffdgkb']);
                            },
                            child: Text(
                              'เพิ่มผู้เข้าโครงการ',
                              style: TextStyle(
                                color: textColorContrast,
                                fontSize: normalM2FontSize,
                                fontFamily: fontRegular,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // table list
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  // vertical: size.height * 0.005
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: dividerTableColor),
                  child: GetBuilder<EntranceProjectControllerM2>(
                    id: 'update-enteance-data-row',
                    builder: (c) => Obx(
                      () => Row(
                        children: [
                          DataTable(
                            headingRowHeight: size.height * 0.07,
                            // horizontalMargin: 10,
                            showCheckboxColumn: false,
                            dividerThickness: 0.5,
                            columnSpacing:
                                (entranceController.hasDataValue.value == true)
                                    ? 26.5
                                    : 26.5,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => purpleBlueColor),
                            columns: c.createColumns(),
                            // columns: _createColumns(),
                            rows: c.dataRow,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // show nodata
              GetBuilder<EntranceProjectControllerM2>(
                id: 'update-enteance-data-row',
                builder: (c) => (c.dataRow.length <= 0)
                    ? Container(
                        color: themeBgColor,
                        height: size.height * 0.53,
                        width: size.width,
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          // vertical: size.height * 0.01
                        ),
                        child: Image.asset(
                          'assets/images/NodataTable.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
              // space
              Container(
                // color: themeBgColor,
                height: size.height * 0.02,
                width: size.width,
              ),
              // Button Group
              Obx(() => Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    padding: EdgeInsets.only(bottom: size.height * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RoundButtonIcon(
                          width: smallM2FontSize * 2,
                          height: smallM2FontSize * 2,
                          size: smallM2FontSize,
                          icon: Icons.arrow_back_ios_new,
                          onClick: () => entranceController.onClickBackPaging(),
                          // onClick: () {},
                        ),
                        for (int i = entranceController.startPaging.value - 1;
                            i <
                                (entranceController.totalPagingNumber.value <
                                        (entranceController.startPaging.value +
                                            entranceController
                                                .pagingRange.value)
                                    ? entranceController
                                                .totalPagingNumber.value ==
                                            1
                                        ? 1
                                        : entranceController
                                            .totalPagingNumber.value
                                    : (entranceController.startPaging.value +
                                        entranceController.pagingRange.value));
                            i++) ...[
                          RoundButtonNumber(
                            width: smallM2FontSize * 2,
                            height: smallM2FontSize * 2,
                            fontSize: smallM2FontSize,
                            index: (i + 1).toString(),
                            selectd:
                                entranceController.selectPaging.value == i + 1
                                    ? true
                                    : false,
                            onClick: () =>
                                entranceController.onClickPaging(i + 1),
                          ),
                        ],
                        RoundButtonIcon(
                          width: smallM2FontSize * 2,
                          height: smallM2FontSize * 2,
                          size: smallM2FontSize,
                          icon: Icons.arrow_forward_ios,
                          onClick: () => entranceController.onClickNextPaging(),
                          // onClick: () {},
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
