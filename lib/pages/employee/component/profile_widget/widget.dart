import 'package:ams/pages/employee/component/controller.dart';
import 'package:ams/services/constants/color.dart';
import 'package:ams/services/constants/constant.dart';
import 'package:ams/services/utils/helpers.dart';
import 'package:ams/services/widgets/extension.dart';
import 'package:ams/services/widgets/richtext.dart';
import 'package:ams/services/widgets/waiting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../models/emp_models.dart';

userImage({required String? picture, required BuildContext context}) {
  return SizedBox(
    width: myWidth(context, 4),
    height: myHeight(context, 2.2),
    child: picture!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: picture,
            placeholder: (context, url) => const MWaiting(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
          )
        : Image.asset('assets/images/cat_upload.png'),
  );
}


class MobileFirstRow extends StatelessWidget {
  const MobileFirstRow({
    super.key,
    required this.model,
    required this.controller,
  });

  final EmpListModel model;
  final EmployeeCon controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userImage(context: context, picture: model.picture),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Personal  Information".toLabel(bold: true, fontsize: 20),
            const Divider(),
            "Staff ID: ${model.staffID}".toSelectLabel().vPadding6,
            "Name: ${model.surname}, ${model.middlename} ${model.surname}"
                .toSelectLabel(bold: true)
                .vPadding6,
            "Gender: ${model.gender}".toSelectLabel().vPadding6,
            "Date of Birth: ${DateTime.parse(model.dob!).dateFormatString()}"
                .toSelectLabel()
                .vPadding6,
            "Email: ${model.email}".toSelectLabel().vPadding6,
            "Contact: ${model.contact}".toSelectLabel().vPadding6,
            "National ID: ${model.nid}".toSelectLabel().vPadding6,
            "Emergency Person: ${model.emergencyName}"
                .toSelectLabel()
                .vPadding6,
            "Emergency Contact: ${model.eContact}".toSelectLabel().vPadding6,
            "Residence: ${model.residence!}".toSelectLabel().vPadding6
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Other  Information".toLabel(bold: true, fontsize: 20),
            const Divider(),
            "Hired Date: ${DateTime.parse(model.hiredDate!).dateFormatString()}"
                .toSelectLabel()
                .vPadding6,
            "Bank: ${model.bank}".toSelectLabel().vPadding3,
            "Bank Accounts: ${model.accountNo}".toSelectLabel().vPadding6,
            "SSNIT ID: ${model.ssnit}".toSelectLabel().vPadding6,
            "Position: ${model.position}".toSelectLabel().vPadding6,
            "Shop: ${model.branch}".toSelectLabel().vPadding6,
            "Working Hours: ${model.hour}".toSelectLabel().vPadding6,
            MyRichText2(
                    load: controller.getData.value,
                    mainColor: Utils.isLightTheme.value ? Colors.black : light,
                    subColor: model.active == 1 ? Colors.green : Colors.red,
                    mainText: "Status ",
                    subText: model.active == 1 ? "Active" : "Inactive")
                .vPadding6,
            DateTime.parse(model.resigned).isBefore(DateTime.now())
                ? "Resigned Date: ${DateTime.parse(model.resigned).dateFormatString()}"
                    .toSelectLabel()
                    .vPadding6
                : Container(),
          ],
        )
      ],
    );
  }
}


class FirstRow extends StatelessWidget {
  const FirstRow({
    super.key,
    required this.model,
    required this.controller,
  });

  final EmpListModel model;
  final EmployeeCon controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         userImage(context: context, picture: model.picture),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Personal  Information".toLabel(bold: true, fontsize: 20),
            const Divider(),
            "Staff ID: ${model.staffID}".toSelectLabel().vPadding6,
            "Name: ${model.surname}, ${model.middlename} ${model.firstname}"
                .toSelectLabel(bold: true)
                .vPadding6,
            "Gender: ${model.gender}".toSelectLabel().vPadding6,
            "Date of Birth: ${DateTime.parse(model.dob!).dateFormatString()}"
                .toSelectLabel()
                .vPadding6,
            "Email: ${model.email}".toSelectLabel().vPadding6,
            "Contact: ${model.contact}".toSelectLabel().vPadding6,
            "National ID: ${model.nid}".toSelectLabel().vPadding6,
            "Emergency Person: ${model.emergencyName}"
                .toSelectLabel()
                .vPadding6,
            "Emergency Contact: ${model.eContact}".toSelectLabel().vPadding6,
            "Residence: ${model.residence!}".toSelectLabel().vPadding6
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Other  Information".toLabel(bold: true, fontsize: 20),
            const Divider(),
            "Hired Date: ${DateTime.parse(model.hiredDate!).dateFormatString()}"
                .toSelectLabel()
                .vPadding6,
            "Bank: ${model.bank}".toSelectLabel().vPadding3,
            "Bank Accounts: ${model.accountNo}".toSelectLabel().vPadding6,
            "SSNIT ID: ${model.ssnit}".toSelectLabel().vPadding6,
            "Position: ${model.position}".toSelectLabel().vPadding6,
            "Shop: ${model.branch}".toSelectLabel().vPadding6,
            "Working Hours: ${model.hour}".toSelectLabel().vPadding6,
            MyRichText2(
                    load: controller.getData.value,
                    mainColor: Utils.isLightTheme.value ? Colors.black : light,
                    subColor: model.active == 1 ? Colors.green : Colors.red,
                    mainText: "Status ",
                    subText: model.active == 1 ? "Active" : "Inactive")
                .vPadding6,
            DateTime.parse(model.resigned).isBefore(DateTime.now())
                ? "Resigned Date: ${DateTime.parse(model.resigned).dateFormatString()}"
                    .toSelectLabel()
                    .vPadding6
                : Container(),
          ],
        )
      ],
    );
  }
}

class ProfileTable extends GetView<EmployeeCon> {
  const ProfileTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(
        () => !controller.getData.value
            ? DataTable2(
                columnSpacing: 12,
                horizontalMargin: 10,
                smRatio: 0.75,
                lmRatio: 1.5,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12),
                sortColumnIndex: controller.sortNameIndex.value,
                sortAscending: controller.sortNameAscending.value,
                columns: [
                  DataColumn2(
                    size: ColumnSize.S,
                    numeric: true,
                    label: '##'.toLabel(bold: true),
                    // numeric: true,
                  ),
                  DataColumn2(
                    // fixedWidth: 100,
                    label: "Start Date".toLabel(bold: true),
                  ),
                  DataColumn2(
                    label: "End Date".toLabel(bold: true),
                  ),
                  DataColumn2(
                    label: "Days".toLabel(bold: true),
                  ),
                  DataColumn2(
                    label: "Hours".toLabel(bold: true),
                  ),
                  DataColumn2(
                    label: "Type".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.per.sort(
                            (item1, item2) => item1.type.compareTo(item2.type));
                      } else {
                        controller.per.sort(
                            (item1, item2) => item2.type.compareTo(item1.type));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                ],
                rows: List.generate(
                  controller.per.length,
                  (index) => DataRow(
                    color: index.isEven
                        ? MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(31, 167, 162, 162))
                        : null,
                    cells: [
                      DataCell((index + 1).toString().toAutoLabel()),
                      DataCell(controller.per[index].sdate.toAutoLabel()),
                      DataCell(controller.per[index].eDate.toAutoLabel()),
                      DataCell(controller.per[index].days.toAutoLabel()),
                      DataCell(controller.per[index].hours.toAutoLabel()),
                      DataCell(controller.per[index].type.toAutoLabel()),
                    ],
                  ),
                ),
              )
            : const MWaiting(),
      ),
    ).card;
  }
}
