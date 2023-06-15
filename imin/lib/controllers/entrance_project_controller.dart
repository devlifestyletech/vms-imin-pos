import 'dart:async';
import 'dart:developer';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:imin/controllers/camera_qr_controller.dart';
import 'package:imin/controllers/login_controller.dart';
import 'package:imin/controllers/screen_controller.dart';
import 'package:imin/functions/dialog_gate.dart';
import 'package:imin/helpers/configs.dart';
import 'package:imin/helpers/constance.dart';
import 'package:imin/models/blacklist_model.dart';
import 'package:imin/models/visitor_model.dart';
import 'package:imin/models/whitelist_model.dart';
import 'package:imin/services/checkin_service.dart';
import 'package:imin/services/gate_service.dart';
import 'package:imin/services/get_enteance_project_blacklist_service.dart';
import 'package:imin/services/get_enteance_project_service.dart';
import 'package:imin/services/get_enteance_project_visitor_service.dart';
import 'package:imin/services/get_enteance_project_whitelist_service.dart';
import 'package:imin/views/widgets/round_button_outline.dart';
import 'package:intl/intl.dart';

class EntranceProjectController extends GetxController {
  var loginController = Get.put(LoginController());
  final screenController = Get.put(ScreenController());
  // final scanQrController = Get.put(ScanQrController());

  var context;
  var dataEntrance = [].obs;
  var visitorList = <VisitorModel>[].obs;
  var whitelistList = <WhitelistModel>[].obs;
  var blacklistList = <BlacklistModel>[].obs;
  var dataRow = <DataRow>[];
  var searchValue = '';
  var hasDataValue = false.obs;

  String token = "";

  var startPaging = 1.obs;
  var selectPaging = 1.obs;
  var pagingRange = 4.obs;
  var displayRowNumber = 9.obs;
  var totalPagingNumber = 1.obs;
  var totalValue = ''.obs;

  @override
  void onInit() {
    token = loginController.dataProfile.token;

    getEntranceData();

    super.onInit();
  }

// search
  void filterSearchResults(String query) {
    print('d1Pro');
    searchValue = query;
    List<String> dummySearchList = [];
    // dummySearchList.addAll(whitelistList);

    var listToShow = [];
    if (query.isNotEmpty) {
      // print('filterSearchResults : ${whitelistList}');
      query = query.toLowerCase();
      // print('query: ${query}');
      List result = [];
      visitorList.forEach((p) {
        // print('valuelicensePlateV: ${valuelicensePlate}');
        log('check data visitor : ${p.qrGenId.toString().toLowerCase()}');
        var licensePlate = p.licensePlate.toString().toLowerCase();
        var homeNumber = p.homeNumber.toString().toLowerCase();
        var fullName = p.firstname.toString().toLowerCase() +
            ' ' +
            p.lastname.toString().toLowerCase();
        if (homeNumber.contains(query) ||
            licensePlate.contains(query) ||
            fullName.contains(query)) {
          result.add(p);
        }
      });
      whitelistList.forEach((p) {
        // print('p.licensePlateW: ${p.licensePlate}');
        // log(p);
        // print(data['location']['lon']);
        log('check data whitelist : ${p.firstname.toString().toLowerCase()}');
        var licensePlate = p.licensePlate.toString().toLowerCase();
        var homeNumber = p.homeNumber.toString().toLowerCase();
        var fullName = p.firstname.toString().toLowerCase() +
            ' ' +
            p.lastname.toString().toLowerCase();
        if (homeNumber.contains(query) ||
            licensePlate.contains(query) ||
            fullName.contains(query)) {
          result.add(p);
        }
      });
      blacklistList.forEach((p) {
        // print('p.licensePlateB: ${p.licensePlate}');
        var licensePlate = p.licensePlate.toString().toLowerCase();
        var homeNumber = p.homeNumber.toString().toLowerCase();
        var fullName = p.firstname.toString().toLowerCase() +
            ' ' +
            p.lastname.toString().toLowerCase();
        if (homeNumber.contains(query) ||
            licensePlate.contains(query) ||
            fullName.contains(query)) {
          result.add(p);
        }
      });
      createRowSearch(result);
      return;
    } else {
      if (visitorList.length > 0 ||
          whitelistList.length > 0 ||
          blacklistList.length > 0) {
        hasDataValue.value = true;
      } else {
        hasDataValue.value = false;
      }
      dataRow.clear();
      visitorList.forEach((item) => dataRow.add(createDataRow(item)));
      whitelistList.forEach((item) => dataRow.add(createDataRow(item)));
      blacklistList.forEach((item) => dataRow.add(createDataRow(item)));
      dataRow = mapToPaging();
      update(['update-enteance-data-row']);
    }
  }

  // QR reader query
  void qrReaderSearchResults(String query) {
    print('d1Pro');
    // searchValue = query;

    if (query.isNotEmpty) {
      // print('filterSearchResults : ${whitelistList}');
      query = query.toLowerCase();
      // query = ('W10831672964359836394').toLowerCase();
      // print('query: ${query}');
      List result = [];
      visitorList.forEach((p) {
        var qrGenId = p.qrGenId.toString().toLowerCase();
        if (qrGenId == (query)) {
          result.add(p);
        }
      });
      whitelistList.forEach((p) {
        var qrGenId = p.qrGenId.toString().toLowerCase();
        if (qrGenId == (query)) {
          result.add(p);
        }
      });
      if (result.length == 1) {
        return showDialogFunction(result[0]);
      } else if (result.length == 1) {
        EasyLoading.showError('ไม่พบข้อมูล(${result.length})');
      } else {
        EasyLoading.showError('ไม่พบข้อมูล');
      }

      return;
    } else {
      return;
    }
  }

  void showDialogFunction(value) {
    log('checkValue : ${value.firstname}');
    if (value.firstname.isNotEmpty) {
      return showDialogDetails(value).show(context);
    } else {
      return showDialogCard(value).show(context);
    }
  }
  ///////////////////////

  void createRowSearch(List AllListData) {
    if (AllListData.length > 0) {
      hasDataValue.value = true;
    } else {
      hasDataValue.value = false;
    }
    // print('hasDataValue.value: ${hasDataValue.value}');
    dataRow.clear();
    AllListData.forEach((item) => dataRow.add(createDataRow(item)));
    dataRow = mapToPaging();
    update(['update-enteance-data-row']);
  }

//3 List
  getEntranceData() async {
    EasyLoading.show(status: 'โหลดข้อมูล ...');

    // var jSon = await getEntranceProjectApi(token);
    var jSonVisitor = await getEntranceProjectVisitorApi(token);
    var jSonWhitelist = await getEntranceProjectWhitelistApi(token);
    var jSonBlacklist = await getEntranceProjectBlacklistApi(token);
    visitorList.clear();
    whitelistList.clear();
    blacklistList.clear();
    // print('json: ${jSon}');

    jSonVisitor.forEach((item) => visitorList.add(VisitorModel.fromJson(item)));
    if (jSonWhitelist != false) {
      jSonWhitelist
          .forEach((item) => whitelistList.add(WhitelistModel.fromJson(item)));
    }

    jSonBlacklist
        .forEach((item) => blacklistList.add(BlacklistModel.fromJson(item)));

    // createRows(visitorList, whitelistList, blacklistList);
    filterSearchResults(searchValue);
    EasyLoading.dismiss();
  }

  /// create row not use
  void createRows(
      List visitorListData, List whitelistListData, List blackListData) {
    dataRow.clear();

    whitelistListData.forEach((item) => dataRow.add(createDataRow(item)));
    visitorListData.forEach((item) => dataRow.add(createDataRow(item)));
    blackListData.forEach((item) => dataRow.add(createDataRow(item)));

    update(['update-enteance-data-row']);
    EasyLoading.dismiss();
  }

//////////// get to table
  DataRow createDataRow(item) {
    return DataRow(
      onSelectChanged: (state) => item.firstname == null
          ? showDialogCard(item).show(context)
          : showDialogDetails(item).show(context),
      cells: [
        DataCell(Center(
          child: Text(item.idCard != null && item.idCard != ""
              ? '${item.idCard}'
              : '-'),
        )),
        DataCell(Center(
            child: Text(item.licensePlate == '' || item.licensePlate == null
                ? '-'
                : item.licensePlate))),
        DataCell(Container(
            width: 120,
            child: Text(item.firstname == null
                ? "-"
                : "${item.firstname} ${item.lastname}"))),
        DataCell(Center(child: Text(item.homeNumber))),
        DataCell(Container(
            width: 138,
            child: Text(item.listStatus == 'visitor'
                ? 'นัดหมายเข้าโครงการ'
                : item.listStatus == 'whitelist'
                    ? 'รับเชิญพิเศษ'
                    : 'ไม่มีสิทธิ์เข้าโครงการ'))),
        DataCell(Container(
          width: 77,
          child: Center(
            child: Text((item.listStatus == 'visitor')
                ? item.inviteDate
                : (item.listStatus == 'whitelist')
                    ? '-'
                    : '-'),
          ),
        )),
        DataCell(
          Container(
            width: 108,
            child: Text((item.listStatus == 'visitor')
                ? (item.datetimeIn != null)
                    ? (item.datetimeOut != null)
                        ? 'ออกจากโครงการ'
                        : 'อยู่ในโครงการ'
                    : 'รอดำเนินการ'
                : (item.listStatus == 'whitelist')
                    ? (item.datetimeIn != null)
                        ? (item.datetimeOut != null)
                            ? 'รอดำเนินการ'
                            : 'อยู่ในโครงการ'
                        : 'รอดำเนินการ'
                    : '-'),
          ),
        ),
      ],
    );
  }

////////// dialog detail when clck
  EasyDialog showDialogCard(dynamic item) {
    return EasyDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      width: 400,
      height: (item.listStatus == 'visitor')
          ? (item.datetimeIn != null)
              ? (item.datetimeOut != null)
                  ? 500
                  : 500
              : 550
          : (item.listStatus == 'whitelist')
              ? (item.datetimeIn != null)
                  ? (item.datetimeOut != null)
                      ? 550
                      : 500
                  : 550
              : 500,
      closeButton: false,
      contentList: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ข้อมูลเพิ่มเติม',
              style: TextStyle(
                fontFamily: fontRegular,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Divider(color: dividerColor),
        FadeInImage(
          height: (screenController.DeviceCurrent == Device.iminM2Pro)
              ? context.height * normalM2FontSize * 0.035
              : 250,
          placeholder: AssetImage('assets/images/id-card-image.png'),
          image: NetworkImage(
            ipServerIminService + '/card/' + item.qrGenId + '/',
            headers: <String, String>{
              'Authorization': 'Bearer ${loginController.dataProfile.token}'
            },
            scale: 1.2,
          ),
        ),
        // Image.network(
        //   ipServerIminService + '/card/' + item.qrGenId + '/',
        //   scale: 1.2,
        //   // height: context.height * 0.25,
        //   headers: <String, String>{
        //     'Authorization': 'Bearer ${loginController.dataProfile.token}'
        //   },
        // ),
        SizedBox(height: 20),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDetial('เลขทะเบียนรถ'),
                textDetial('บ้านเลขที่'),
                textDetial('ระดับ'),
                textDetial('วันที่นัด'),
                textDetial('สถานะ'),
              ],
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDetial(item.licensePlate == '' || item.licensePlate == null
                    ? '-'
                    : item.licensePlate),
                textDetial(item.homeNumber == '' || item.homeNumber == null
                    ? '-'
                    : item.homeNumber),
                textDetial((item.listStatus == 'visitor'
                    ? 'นัดหมายเข้าโครงการ'
                    : item.listStatus == 'whitelist'
                        ? 'รับเชิญพิเศษ'
                        : 'ไม่มีสิทธิ์เข้าโครงการ')),
                textDetial((item.listStatus == 'visitor')
                    ? '${item.inviteDate}'
                    : (item.listStatus == 'whitelist')
                        ? '-'
                        : '-'),
                textDetial(
                  (item.listStatus == 'visitor')
                      ? (item.datetimeIn != null)
                          ? (item.datetimeOut != null)
                              ? 'ออกจากโครงการ'
                              : 'อยู่ในโครงการ'
                          : 'รอดำเนินการ'
                      : (item.listStatus == 'whitelist')
                          ? (item.datetimeIn != null)
                              ? (item.datetimeOut != null)
                                  ? 'รอดำเนินการ'
                                  : 'อยู่ในโครงการ'
                              : 'รอดำเนินการ'
                          : '-',
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        if (item.listStatus == 'visitor' &&
            item.datetimeIn == null &&
            item.datetimeOut == null) ...[
          RoundButtonOutline(
            title: 'เข้าโครงการ',
            press: () {
              checkDataList(item);
            },
          ),
        ]
      ],
    );
  }

  EasyDialog showDialogDetails(dynamic item) {
    return EasyDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      width: 400,
      height: (item.listStatus == 'visitor')
          ? (item.datetimeIn != null)
              ? (item.datetimeOut != null)
                  ? 300
                  : 300
              : 350
          : (item.listStatus == 'whitelist')
              ? (item.datetimeIn != null)
                  ? (item.datetimeOut != null)
                      ? 350
                      : 300
                  : 350
              : 300,
      closeButton: false,
      contentListAlignment: CrossAxisAlignment.center,
      contentList: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ข้อมูลเพิ่มเติม',
              style: TextStyle(
                fontFamily: fontRegular,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => Get.back(),
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Divider(color: dividerColor),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDetial('เลขบัตรประจำตัวประชาชน'),
                textDetial('เลขทะเบียนรถ'),
                textDetial('ชื่อ - นามสกุล'),
                textDetial('บ้านเลขที่'),
                textDetial('ระดับ'),
                textDetial('วันที่นัด'),
                textDetial('สถานะ'),
              ],
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDetial(item.idCard == '' || item.idCard == null
                    ? '-'
                    : item.idCard),
                textDetial(item.licensePlate == '' || item.licensePlate == null
                    ? '-'
                    : item.licensePlate),
                textDetial(item.firstname == null
                    ? "-"
                    : "${item.firstname} ${item.lastname}"),
                textDetial(item.homeNumber == '' || item.homeNumber == null
                    ? '-'
                    : item.homeNumber),
                textDetial((item.listStatus == 'visitor'
                    ? 'นัดหมายเข้าโครงการ'
                    : item.listStatus == 'whitelist'
                        ? 'รับเชิญพิเศษ'
                        : 'ไม่มีสิทธิ์เข้าโครงการ')),
                textDetial((item.listStatus == 'visitor')
                    ? item.inviteDate
                    : (item.listStatus == 'whitelist')
                        ? '-'
                        : '-'),
                textDetial(
                  (item.listStatus == 'visitor')
                      ? (item.datetimeIn != null)
                          ? (item.datetimeOut != null)
                              ? 'ออกจากโครงการ'
                              : 'อยู่ในโครงการ'
                          : 'รอดำเนินการ'
                      : (item.listStatus == 'whitelist')
                          ? (item.datetimeIn != null)
                              ? (item.datetimeOut != null)
                                  ? 'รอดำเนินการ'
                                  : 'อยู่ในโครงการ'
                              : 'รอดำเนินการ'
                          : '-',
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        if (item.listStatus == 'visitor' &&
            item.datetimeIn == null &&
            item.datetimeOut == null) ...[
          RoundButtonOutline(
            title: 'เข้าโครงการ',
            press: () {
              checkDataList(item);
            },
          ),
        ] else if (item.listStatus == 'whitelist' &&
            (item.datetimeIn == null ||
                (item.datetimeIn != null && item.datetimeOut != null))) ...[
          RoundButtonOutline(
            title: 'เข้าโครงการ',
            press: () {
              checkDataList(item);
            },
          ),
        ]
      ],
    );
  }

//////////////
  /// user entrance to project
  checkDataList(item) async {
    // print('data: ${item.listStatus}');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    if (item.listStatus == 'visitor') {
      var checkResponse = await checkInApi(
          item.listStatus,
          '${item.visitorId}',
          '${item.homeId}',
          formattedDate,
          token,
          item.firstname ?? '',
          item.lastname ?? '',
          item.licensePlate ?? '',
          item.qrGenId ?? '');
      if (checkResponse == true) {
        // EasyLoading.showSuccess('สำเร็จ');

        Get.back();
        showDialogOpenGate(item).show(context);
        Timer(Duration(seconds: 3), () => Get.back());

        // ----------- gate ------------------
        gateController(gateBarrierOpenUrl);
        Future.delayed(
            Duration(seconds: 8), () => gateController(gateBarrierCloseUrl));
        // ----------- gate ------------------

        return;
      }
    } else if (item.listStatus == 'whitelist') {
      var checkResponse = await checkInApi(
          item.listStatus,
          '${item.whitelistId}',
          '${item.homeId}',
          formattedDate,
          token,
          item.firstname ?? '',
          item.lastname ?? '',
          item.licensePlate ?? '',
          item.qrGenId ?? '');
      if (checkResponse == true) {
        // EasyLoading.showSuccess('สำเร็จ');

        Get.back();
        showDialogOpenGate(item).show(context);
        Timer(Duration(seconds: 3), () => Get.back());

        // ----------- gate ------------------
        gateController(gateBarrierOpenUrl);
        Future.delayed(
            Duration(seconds: 8), () => gateController(gateBarrierCloseUrl));
        // ----------- gate ------------------

        return;
      }
    }
  }

  ///
  Padding textDetial(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: fontRegular,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// create column table
  List<DataColumn> createColumns() {
    List headerItems = [
      'เลขประจำตัวประชาชน',
      'เลขทะเบียนรถ',
      'ชื่อ - นามสกุล',
      'บ้านเลขที่',
      'ระดับ',
      'วันที่นัดหมาย',
      'สถานะ',
    ];

    return headerItems
        .map((item) => DataColumn(
                label: Text(
              item,
              style: TextStyle(
                  fontFamily: fontRegular,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
              textAlign: TextAlign.center,
            )))
        .toList();
  }

  ////////////////////////////
  /////allList (not use)
  getDataEntrance() async {
    try {
      EasyLoading.show(status: 'โหลดข้อมูล ...');

      dataEntrance = await getEntranceProjectApi(token);
      List<dynamic> values = <dynamic>[];
      values = dataEntrance;
      Map<String, dynamic> map = dataEntrance[0];
      // print('/${dataEntrance[0]['license_plate']}/');
    } catch (e) {
      print('error:${e}');
    }
  }

  // all List (not use)
  DataRow createDataRowAllList(item) {
    return DataRow(
      onSelectChanged: (state) => print('พห 5418'),
      cells: [
        DataCell(Text(item['id_card'] != null && item['id_card'] != ""
            ? '${item['id_card']}'
            : '-')),
        DataCell(
            // Text('${item['license_plate'] ?? "-"}')),
            Text(item['license_plate'] != null
                ? '${item['license_plate']}'
                : '-')),
        DataCell(Text('${item['firstname'] ?? "-"} ${item['lastname'] ?? ""}')),
        DataCell(Text('${item['home_number'] ?? "-"}')),
        DataCell(Text(item['visitor_id'] != null
            ? 'นัดหมายเข้าโครงการ'
            : item['whitelist_id'] != null
                ? 'รับเชิญพิเศษ'
                : 'ไม่มีสิทธิ์เข้าโครงการ')),
        DataCell(Text((item['visitor_id'] != null)
            ? item['invite_date']
            : (item['whitelist_id'] != null)
                ? '-'
                : '-')),
        DataCell(Text((item['visitor_id'] != null)
            ? (item['datetime_in'] != null)
                ? (item['datetime_out'] != null)
                    ? 'ออกจากโครงการ'
                    : 'อยู่ในโครงการ'
                : 'รอดำเนินการ'
            : (item['whitelist_id'] != null)
                ? (item['datetime_in'] != null)
                    ? (item['datetime_out'] != null)
                        ? 'รอดำเนินการ'
                        : 'อยู่ในโครงการ'
                    : 'รอดำเนินการ'
                : '-')),
      ],
    );
  }

//
/////////////////////////// onclick
  mapToPaging() {
    List<DataRow> newDataRow = [];
    totalPagingNumber.value =
        ((dataRow.length / displayRowNumber.value)).ceil();

    int calEnd = selectPaging.value * displayRowNumber.value;
    int startRow = calEnd - displayRowNumber.value;
    int endRow = calEnd > dataRow.length ? dataRow.length : calEnd;

    // print("dataRow: ${dataRow.length}");
    // print("displayRowNumber: ${displayRowNumber.value}");
    // print("totalPagingNumber: $totalPagingNumber");
    // print(
    //     "totalPagingNumberReal: ${(dataRow.length / displayRowNumber.value)}");
    // print("selectPaging: $pagingRange");
    // print("startRow: $startRow");
    // print("endRow: $endRow");
    // print("calEnd: $calEnd");

    for (int i = startRow; i < endRow; i++) {
      newDataRow.add(dataRow[i]);
      // print("dataRow${i}: ${dataRow[i]}");
    }

    return newDataRow;
  }

  onClickPaging(int index) {
    selectPaging.value = index;
    filterSearchResults(searchValue);
  }

  onClickBackPaging() {
    if (startPaging.value == 1) return;
    startPaging.value -= 1;
  }

  onClickNextPaging() {
    if (totalPagingNumber.value < startPaging.value + pagingRange.value) return;

    startPaging.value += 1;
  }

  ///
}
