import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imin/controllers/exit_project_controller.dart';
import 'package:imin/helpers/constance.dart';
import 'package:imin/views/widgets/popup_item.dart';
import 'package:imin/views/widgets/title_content.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExitProjectScreen extends StatefulWidget {
  ExitProjectScreen({Key? key}) : super(key: key);

  @override
  _ExitProjectScreenState createState() => _ExitProjectScreenState();
}

class _ExitProjectScreenState extends State<ExitProjectScreen> {
  final exitController = Get.put(ExitProjectController());

  @override
  void initState() {
    super.initState();
  }

  TextEditingController findControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    exitController.context = context;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleContent(text: 'เวลาออกจากโครงการ'),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, bottom: 15, left: 40, right: 15),
                    width: size.width * 0.33,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Obx(
                                () => Text(
                                  // 'ช่วงวัน : 1 มิถุนายน 2564 - 1 กรกฎาคม 2564',
                                  'ช่วงวัน : ' + exitController.startEndRange.value,
                                  style: TextStyle(
                                    fontFamily: fontRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            offset: Offset(80, size.height * 0.06),
                            icon: Icon(Icons.expand_more, color: Colors.black),
                            itemBuilder: (_) {
                              return [
                                PopupItem(
                                  child: Container(
                                    width: size.width * 0.8,
                                    child: SfDateRangePicker(
                                      showActionButtons: true,
                                      // enableMultiView: true,
                                      // viewSpacing: 20,
                                      // era: EraMode.BUDDHIST_YEAR,
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                      view: DateRangePickerView.month,
                                      selectionShape:
                                          DateRangePickerSelectionShape
                                              .rectangle,
                                      selectionTextStyle: TextStyle(
                                        fontFamily: fontRegular,
                                        color: Colors.white,
                                      ),
                                      todayHighlightColor: purpleBlueColor,
                                      headerStyle: DateRangePickerHeaderStyle(
                                        textAlign: TextAlign.center,
                                        textStyle: TextStyle(
                                          fontFamily: fontRegular,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),

                                      monthViewSettings:
                                          DateRangePickerMonthViewSettings(
                                        viewHeaderStyle:
                                            DateRangePickerViewHeaderStyle(
                                          textStyle: TextStyle(
                                            fontFamily: fontRegular,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      rangeTextStyle: TextStyle(
                                          fontFamily: fontRegular,
                                          color: Colors.black),
                                      selectionColor: purpleBlueColor,
                                      startRangeSelectionColor: purpleBlueColor,
                                      endRangeSelectionColor: purpleBlueColor,
                                      // rangeSelectionColor: Colors.purpleAccent,

                                      monthCellStyle:
                                          DateRangePickerMonthCellStyle(
                                        textStyle: TextStyle(
                                            fontFamily: fontRegular,
                                            color: Colors.black),
                                        todayTextStyle: TextStyle(
                                          fontFamily: fontRegular,
                                          color: Colors.black,
                                        ),
                                      ),
                                      yearCellStyle:
                                          DateRangePickerYearCellStyle(
                                        textStyle: TextStyle(
                                          fontFamily: fontRegular,
                                          color: Colors.black,
                                        ),
                                      ),

                                      confirmText: 'ตกลง',
                                      onSubmit: (v) =>
                                          exitController.submitSelectRangeTime(),
                                      cancelText: 'ยกเลิก',
                                      onCancel: () => Get.back(),
                                      onSelectionChanged: (v) =>
                                          exitController.cleanAndCreateDummy(
                                              v.value.startDate,
                                              v.value.endDate),
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.3,
                    height: size.height * 0.05,
                    child: TextFormField(
                      initialValue: exitController.searchValue.value,
                      onChanged: exitController.searchOnchange,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        border: OutlineInputBorder(),
                        hintText: 'ค้นหาเลขทะเบียนรถ, บ้านเลขที่, ชื่อนามสกุล',
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textColor)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: purpleBlueColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: size.width,
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
                margin: EdgeInsets.only(
                  left: size.width * 0.03,
                  right: size.width * 0.03,
                  top: size.height * 0.01,
                  bottom: size.height * 0.02,
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: dividerTableColor),
                  child: GetBuilder<ExitProjectController>(
                    id: 'update-exit-data-row',
                    builder: (c) => DataTable(
                      showCheckboxColumn: false,
                      dividerThickness: 0.5,
                      columnSpacing: 30,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => purpleBlueColor),
                      columns: c.createColumns(),
                      rows: c.dataRow,
                    ),
                  ),
                ),
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
                          icon: Icons.arrow_back_ios_new,
                          onClick: () => exitController.onClickBackPaging(),
                        ),
                        for (int i = exitController.startPaging.value - 1;
                            i <
                                (exitController.totalPagingNumber.value <
                                        (exitController.startPaging.value +
                                            exitController.pagingRange.value)
                                    ? exitController.totalPagingNumber.value == 1
                                        ? 1
                                        : exitController.totalPagingNumber.value
                                    : (exitController.startPaging.value +
                                        exitController.pagingRange.value));
                            i++) ...[
                          RoundButtonNumber(
                            index: (i + 1).toString(),
                            selectd: exitController.selectPaging.value == (i + 1)
                                ? true
                                : false,
                            onClick: () => exitController.onClickPaging((i + 1)),
                          ),
                        ],
                        RoundButtonIcon(
                          icon: Icons.arrow_forward_ios,
                          onClick: () => exitController.onClickNextPaging(),
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

class Point extends StatelessWidget {
  const Point({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "•••",
      textAlign: TextAlign.end,
      style: TextStyle(
        fontFamily: fontRobotoRegular,
        color: Colors.grey.shade700,
        fontSize: 26,
      ),
    );
  }
}

class RoundButtonNumber extends StatelessWidget {
  const RoundButtonNumber({
    Key? key,
    required this.index,
    required this.selectd,
    required this.onClick,
  }) : super(key: key);

  final String index;
  final bool selectd;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: selectd ? hilightTextColor : textColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            index,
            style: TextStyle(
              fontFamily: fontRobotoRegular,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectd ? hilightTextColor : textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class RoundButtonIcon extends StatelessWidget {
  const RoundButtonIcon({
    Key? key,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  final IconData icon;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: textColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
