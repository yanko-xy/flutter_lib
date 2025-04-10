import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class XYTextSelectionToolbar extends AdaptiveTextSelectionToolbar {
  const XYTextSelectionToolbar(
      {super.key, required super.children, required super.anchors});

  XYTextSelectionToolbar.selectableRegion({
    super.key,
    required super.selectableRegionState,
  }) : super.selectableRegion();

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if ((children != null && children!.isEmpty) ||
        (buttonItems != null && buttonItems!.isEmpty)) {
      return const SizedBox.shrink();
    }

    List<Widget> resultChildren = <Widget>[];
    for (int i = 0; i < buttonItems!.length; i++) {
      final ContextMenuButtonItem buttonItem = buttonItems![i];
      resultChildren.add(SelectionToolBarButton(
        width: 100,
        height: 50,
        icon: (i == 0)
            ? const Icon(
                Icons.copy,
                color: Colors.white,
                size: 14,
              )
            : const Icon(
                Icons.select_all,
                color: Colors.white,
                size: 16,
              ),
        title: getButtonLabelString(context, buttonItem),
        onPressed: buttonItem.onPressed!,
      ));
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoTextSelectionToolbar(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor == null
              ? anchors.primaryAnchor
              : anchors.secondaryAnchor!,
          children: resultChildren,
        );
      case TargetPlatform.android:
        return TextSelectionToolbar(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor == null
              ? anchors.primaryAnchor
              : anchors.secondaryAnchor!,
          children: resultChildren,
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return DesktopTextSelectionToolbar(
          anchor: anchors.primaryAnchor,
          children: resultChildren,
        );
      case TargetPlatform.macOS:
        return CupertinoDesktopTextSelectionToolbar(
          anchor: anchors.primaryAnchor,
          children: resultChildren,
        );
    }
  }

  /// Returns the default button label String for the button of the given
  /// [ContextMenuButtonType] on any platform.
  static String getButtonLabelString(
      BuildContext context, ContextMenuButtonItem buttonItem) {
    if (buttonItem.label != null) {
      return buttonItem.label!;
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        assert(debugCheckHasMaterialLocalizations(context));
        switch (buttonItem.type) {
          case ContextMenuButtonType.cut:
            return "剪切";
          case ContextMenuButtonType.copy:
            return "复制";
          case ContextMenuButtonType.paste:
            return "粘贴";
          case ContextMenuButtonType.selectAll:
            return "选择全部";
          case ContextMenuButtonType.custom:
            return '';
          case ContextMenuButtonType.delete:
          // TODO: Handle this case.
          case ContextMenuButtonType.lookUp:
          // TODO: Handle this case.
          case ContextMenuButtonType.searchWeb:
          // TODO: Handle this case.
          case ContextMenuButtonType.share:
          // TODO: Handle this case.
          case ContextMenuButtonType.liveTextInput:
          // TODO: Handle this case.
          default:
            return "";
        }
    }
  }
}

class SelectionToolBarButton extends StatelessWidget {
  const SelectionToolBarButton({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final double width;
  final double height;
  final Icon icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: Colors.black87,
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
