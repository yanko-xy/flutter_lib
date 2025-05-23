import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_wrap_sidebar_item.dart';

enum TDSideBarStyle {
  normal,
  outline,
}

class SideItemProps {
  int index;
  int value;
  bool? disabled;
  IconData? icon;
  String? label;
  TDBadge? badge;
  TextStyle? textStyle;

  SideItemProps(
      {required this.value,
      required this.index,
      this.disabled,
      this.icon,
      this.label,
      this.badge,
      this.textStyle});
}

class TDSideBar extends StatefulWidget {
  const TDSideBar({
    Key? key,
    this.value,
    this.defaultValue,
    this.selectedColor,
    this.unSelectedColor,
    this.children = const [],
    this.onChanged,
    this.onSelected,
    this.height,
    this.controller,
    this.contentPadding,
    this.selectedTextStyle,
    this.style = TDSideBarStyle.normal,
    this.loading,
    this.loadingWidget,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.backgroundColor,
  }) : super(key: key);

  /// 选项值
  final int? value;

  /// 默认值
  final int? defaultValue;

  /// 单项
  final List<TDSideBarItem> children;

  /// 选中值发生变化（Controller控制）
  final ValueChanged<int>? onChanged;

  /// 选中值发生变化（点击事件）
  final ValueChanged<int>? onSelected;

  /// 选中值后颜色
  final Color? selectedColor;

  /// 未选中值后颜色
  final Color? unSelectedColor;

  /// 选中样式
  final TextStyle? selectedTextStyle;

  /// 样式
  final TDSideBarStyle style;

  /// 高度
  final double? height;

  /// 自定义文本框内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 控制器
  final TDSideBarController? controller;

  /// 加载效果
  final bool? loading;

  /// 自定义加载动画
  final Widget? loadingWidget;

  /// 选择的背景颜色
  final Color? selectedBgColor;

  /// 未选择的背景颜色
  final Color? unSelectedBgColor;

  /// 背景色
  final Color? backgroundColor;

  @override
  State<TDSideBar> createState() => _TDSideBarState();
}

class _TDSideBarState extends State<TDSideBar> {
  late List<SideItemProps> displayChildren;
  late int? currentValue;
  late int? currentIndex;
  final _scrollerController = ScrollController();
  final GlobalKey globalKey = GlobalKey();
  final double itemHeight = 56.0;
  bool _loading = false;

  // 查找某值对应项
  SideItemProps findSideItem(int value) {
    return displayChildren.where((element) => element.value == value).first;
  }

  // 选中某值
  void selectValue(int value, {bool needScroll = false}) {
    SideItemProps? item;
    for (var element in displayChildren) {
      if (element.value == value) {
        item = element;
      }
    }

    if (needScroll && item != null) {
      try {
        var height = globalKey.currentContext!.size!.height;
        var offset = _scrollerController.offset;
        var distance = item.index * itemHeight - offset;
        if (distance + itemHeight > height) {
          _scrollerController.animateTo(offset + itemHeight,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn);
        } else if (distance < 0) {
          _scrollerController.animateTo(offset - itemHeight,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn);
        }
      } catch (e) {
        print(e);
      }
    }

    if (item != null) {
      onSelect(item, isController: true);
    }
  }

  @override
  void didUpdateWidget(covariant TDSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children) {
      getDisplayChildren();
      setState(() {});
    }

    if (widget.value != currentIndex) {
      print(widget.value);
      setState(() {
        currentIndex = widget.value;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _loading = widget.loading ?? widget.controller?.loading ?? false;
    // controller注册事件
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        print(widget.controller!.currentValue);
        selectValue(widget.controller!.currentValue, needScroll: true);
        _loading = widget.controller!.loading;
        getDisplayChildren();
        setState(() {});
      });
    }

    displayChildren = widget.children
        .asMap()
        .entries
        .map((entry) => SideItemProps(
            index: entry.key,
            disabled: entry.value.disabled,
            value: entry.value.value,
            icon: entry.value.icon,
            label: entry.value.label,
            textStyle: entry.value.textStyle,
            badge: entry.value.badge))
        .toList();

    currentValue = widget.value ??
        widget.defaultValue ??
        (displayChildren.isNotEmpty ? displayChildren[0].value : null);
    if (currentValue != null) {
      try {
        final item = findSideItem(currentValue!);
        currentIndex = item.index;
      } catch (e) {
        currentIndex = null;
        currentValue = null;
      }
    } else {
      currentIndex = null;
    }
  }

  void getDisplayChildren() {
    if (widget.controller != null && widget.controller!.children.isNotEmpty) {
      displayChildren = widget.controller!.children
          .asMap()
          .entries
          .map((entry) => SideItemProps(
              index: entry.key,
              disabled: entry.value.disabled,
              value: entry.value.value,
              icon: entry.value.icon,
              label: entry.value.label,
              textStyle: entry.value.textStyle,
              badge: entry.value.badge))
          .toList();
    } else if (widget.children.isNotEmpty) {
      displayChildren = widget.children
          .asMap()
          .entries
          .map((entry) => SideItemProps(
              index: entry.key,
              disabled: entry.value.disabled,
              value: entry.value.value,
              icon: entry.value.icon,
              label: entry.value.label,
              textStyle: entry.value.textStyle,
              badge: entry.value.badge))
          .toList();
    } else {
      displayChildren = [];
    }
  }

  // 选中某项
  void onSelect(SideItemProps item, {isController = false}) {
    if (currentIndex != item.index) {
      if (isController) {
        if (widget.onChanged != null) {
          widget.onChanged!(item.value);
        }
      } else {
        if (widget.onSelected != null) {
          widget.onSelected!(item.value);
        }
      }

      setState(() {
        currentIndex = item.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      widget.controller?.loading = true;
      if (widget.loadingWidget != null) {
        return widget.loadingWidget!;
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Align(
          child:
              TDLoading(icon: TDLoadingIcon.circle, size: TDLoadingSize.large),
        ),
      );
    }
    return ConstrainedBox(
        key: globalKey,
        constraints: BoxConstraints(
            minWidth: 76,
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top),
        child: Container(
            color: widget.backgroundColor ?? Colors.black,
            height: widget.height ?? MediaQuery.of(context).size.height,
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: displayChildren.length,
                    controller: _scrollerController,
                    itemBuilder: (BuildContext context, int index) {
                      var ele = displayChildren[index];

                      return TDWrapSideBarItem(
                        style: widget.style,
                        value: ele.value,
                        icon: ele.icon,
                        disabled: ele.disabled ?? false,
                        label: ele.label ?? '',
                        badge: ele.badge,
                        textStyle: ele.textStyle,
                        selected: currentIndex == ele.index,
                        selectedColor: widget.selectedColor,
                        unSelectedColor: widget.unSelectedColor,
                        selectedTextStyle: widget.selectedTextStyle,
                        contentPadding: widget.contentPadding,
                        topAdjacent: currentIndex != null &&
                            currentIndex! + 1 == ele.index,
                        bottomAdjacent: currentIndex != null &&
                            currentIndex! - 1 == ele.index,
                        selectedBgColor: widget.selectedBgColor,
                        unSelectedBgColor: widget.unSelectedBgColor,
                        onTap: () {
                          if (!(ele.disabled ?? false)) {
                            onSelect(ele, isController: false);
                          }
                        },
                      );
                    }))));
  }
}
