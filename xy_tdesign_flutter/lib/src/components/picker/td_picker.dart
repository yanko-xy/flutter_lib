import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDPicker {
  /// 显示时间选择器
  static void showDatePicker(context,
      {required String title,
      required DatePickerCallback? onConfirm,
      DatePickerCallback? onCancel,
      bool useYear = true,
      bool useMonth = true,
      bool useDay = true,
      bool useHour = false,
      bool useMinute = false,
      bool useSecond = false,
      bool useWeekDay = false,
      Color? barrierColor,
      List<int> dateStart = const [1970, 1, 1],
      List<int>? dateEnd,
      List<int>? initialDate,
      String? rightText,
      String? leftText,
      TextStyle? leftTextStyle,
      TextStyle? centerTextStyle,
      TextStyle? rightTextStyle,
      Color? titleDividerColor,
      Duration duration = const Duration(milliseconds: 100),
      double pickerHeight = 200,
      bool isTimeUnit = true,
      Function(int wheelIndex, int index)? onSelectedItemChanged,
      int pickerItemCount = 5}) {
    if (dateEnd == null || initialDate == null) {
      var now = DateTime.now();
      // 如果未指定结束时间，则取当前时间
      dateEnd ??= [now.year, now.month, now.day];
      initialDate ??= [now.year, now.month, now.day];
    }
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor:
            barrierColor ?? TDTheme.of(context).fontGyColor2.withOpacity(0.6),
        enableDrag: false,
        builder: (context) {
          return TDDatePicker(
              title: title,
              onConfirm: onConfirm,
              onCancel: onCancel,
              rightText: rightText,
              leftText: leftText,
              leftTextStyle: leftTextStyle,
              centerTextStyle: centerTextStyle,
              rightTextStyle: rightTextStyle,
              titleDividerColor: titleDividerColor,
              isTimeUnit: isTimeUnit,
              model: DatePickerModel(
                useYear: useYear,
                useMonth: useMonth,
                useDay: useDay,
                useWeekDay: useWeekDay,
                useHour: useHour,
                useMinute: useMinute,
                useSecond: useSecond,
                dateStart: dateStart,
                dateEnd: dateEnd!,
                dateInitial: initialDate,
              ),
              pickerHeight: pickerHeight,
              pickerItemCount: pickerItemCount,
              onSelectedItemChanged: onSelectedItemChanged);
        });
  }

  /// 显示多级选择器
  static void showMultiPicker(context,
      {String? title,
      required MultiPickerCallback? onConfirm,
      MultiPickerCallback? onCancel,
      required List<List<String>> data,
      List<int>? initialIndexes,
      Duration duration = const Duration(milliseconds: 100),
      Color? barrierColor,
      Color? backgroundColor,
      double pickerHeight = 200,
      String? rightText,
      String? leftText,
      TextStyle? leftTextStyle,
      TextStyle? centerTextStyle,
      TextStyle? rightTextStyle,
      Color? titleDividerColor,
      Color? activeBackgroundColor,
      double? topPadding,
      double? topRadius,
      int pickerItemCount = 5}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor:
            barrierColor ?? TDTheme.of(context).fontGyColor2.withOpacity(0.6),
        builder: (context) {
          return TDMultiPicker(
            title: title,
            onConfirm: onConfirm,
            onCancel: onCancel,
            data: data,
            rightText: rightText,
            leftText: leftText,
            leftTextStyle: leftTextStyle,
            centerTextStyle: centerTextStyle,
            rightTextStyle: rightTextStyle,
            initialIndexes: initialIndexes,
            backgroundColor: backgroundColor,
            pickerHeight: pickerHeight,
            pickerItemCount: pickerItemCount,
            titleDividerColor: titleDividerColor,
            activeBackgroundColor: activeBackgroundColor,
            topRadius: topRadius,
            topPadding: topPadding,
          );
        }).then((value) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  /// 显示多级联动选择器
  static void showMultiLinkedPicker(context,
      {String? title,
      required MultiPickerCallback? onConfirm,
      MultiPickerCallback? onCancel,
      required Map data,
      required int columnNum,
      required List initialData,
      Duration duration = const Duration(milliseconds: 100),
      Color? barrierColor,
      String? rightText,
      String? leftText,
      double? topRadius,
      Color? backgroundColor,
      Color? activeBackgroundColor,
      TextStyle? leftTextStyle,
      TextStyle? centerTextStyle,
      TextStyle? rightTextStyle,
      double pickerHeight = 200,
      Color? titleDividerColor,
      double? topPadding,
      int pickerItemCount = 5}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor:
            barrierColor ?? TDTheme.of(context).fontGyColor2.withOpacity(0.6),
        builder: (context) {
          return TDMultiLinkedPicker(
            title: title,
            onConfirm: onConfirm,
            onCancel: onCancel,
            data: data,
            rightText: rightText,
            leftText: leftText,
            leftTextStyle: leftTextStyle,
            centerTextStyle: centerTextStyle,
            rightTextStyle: rightTextStyle,
            topRadius: topRadius,
            backgroundColor: backgroundColor,
            activeBackgroundColor: activeBackgroundColor,
            pickerHeight: pickerHeight,
            pickerItemCount: pickerItemCount,
            columnNum: columnNum,
            selectedData: initialData,
            titleDividerColor: titleDividerColor,
            topPadding: topPadding,
          );
        }).then((value) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
