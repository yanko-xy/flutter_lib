import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

typedef ContentBuilder = String Function(String content);
typedef DataMapBuilder = Map<String, dynamic> Function();

class XYFillMarkdownController extends ChangeNotifier {
  final DataMapBuilder? dataMapBuilder;
  final bool needFillIndex;

  String _text = "";
  bool _selectable = false;
  final regex =
      RegExp(r'<a\b[^>]*>(.*?)<\/a>', dotAll: true); // 添加dotAll:true以匹配换行符
  final List<String> strList = [];
  final Map<String, dynamic> fillMap = <String, dynamic>{};

  String get textData => _text;
  bool get selectable => isAllShow();

  XYFillMarkdownController(
    String text, {
    this.dataMapBuilder,
    this.needFillIndex = false,
  }) {
    _text = text;
    if (needFillIndex) {
      _text = _addHrefToLinks(_text);
    }
    initFill();
  }

  // 初始化挖空
  void initFill() {
    // 预处理
    // _preProcess();

    // 正则表达式匹配所有 <a> 标签
    String text = _text;
    RegExpMatch? match = regex.firstMatch(text);

    while (match != null) {
      final attributes = match.group(0); // 提取属性
      if (attributes == null || attributes.isEmpty) {
        match = regex.firstMatch(text);
        continue;
      }
      var list = text.split(attributes);
      strList.add(list.removeAt(0));
      final isHidden = attributes.contains('hidden');
      final indexRegex =
          RegExp(r'<a\b[^>]*href\s*="\s*([^\s>]+)"', multiLine: true);
      String index = "0";
      final indexMatches = indexRegex.allMatches(attributes);
      for (final indexMatch in indexMatches) {
        index = indexMatch.group(1) ?? "0";
        break;
      }
      if (fillMap[index] == null) {
        fillMap[index] = <String, dynamic>{};
      }
      if (fillMap[index]["label"] == null) {
        fillMap[index]["label"] = [];
      }
      fillMap[index]["label"].add(attributes);
      fillMap[index]["hidden"] = isHidden;
      text = list.join("");
      match = regex.firstMatch(text);
    }

    strList.add(text);
  }

  // 添加属性
  String _addAttribute(String str, String attribute, String value) {
    str = str.replaceAllMapped(
      RegExp(r'<a\b([^>]*)>'),
      (match) {
        String attributes = match.group(1) ?? '';
        if (!attributes.contains('$attribute=')) {
          return '<a${attributes.isEmpty ? '' : ' '}$attribute="$value"$attributes>';
        } else {
          // 替换已存在的属性值
          return '<a${attributes.replaceAll(RegExp('$attribute="[^"]*"'), '$attribute="$value"')}>';
        }
      },
    );
    return str;
  }

  // 更新挖空
  void updateFill({String idx = "-1"}) {
    if (fillMap[idx] == null) return;
    List<String> newList = [];
    if (fillMap[idx]["hidden"]) {
      for (String item in fillMap[idx]["label"]) {
        item = _removeHidden(item);
        newList.add(item);
      }
      fillMap[idx]["hidden"] = false;
    } else {
      for (String item in fillMap[idx]["label"]) {
        item = _addHidden(item);
        newList.add(item);
      }
      fillMap[idx]["hidden"] = true;
    }
    fillMap[idx]["label"] = newList;

    _text = combination();
    notifyListeners();
  }

  // 更新内容
  void updateText({String? text, String idx = "-1", ContentBuilder? builder}) {
    if (fillMap[idx] == null) return;
    List<String> newList = [];
    for (String item in fillMap[idx]["label"]) {
      item = _updateContent(
        item: item,
        builder: builder,
      );

      newList.add(item);
    }
    fillMap[idx]["hidden"] = true;
    fillMap[idx]["label"] = newList;

    _text = combination();
    notifyListeners();
  }

  // 更新内容和属性
  void updateTextAndAttribute({
    String text = "",
    String idx = "-1",
    required String attribute,
    required String value,
  }) {
    if (fillMap[idx] == null) return;
    List<String> newList = [];
    for (String item in fillMap[idx]["label"]) {
      item = _updateContent(item: item, text: text);

      // 添加state属性
      item = _addAttribute(item, attribute, value);

      newList.add(item);
    }
    fillMap[idx]["hidden"] = true;
    fillMap[idx]["label"] = newList;

    _text = combination();
    notifyListeners();
  }

  // 更新内容
  String _updateContent(
      {required String item, String? text, ContentBuilder? builder}) {
    if (item.isEmpty) return item;

    return item.replaceAllMapped(
      RegExp(r'(<a[^>]*>)(.*?)(<\/a>)', dotAll: true), // 添加dotAll:true以匹配换行符
      (match) {
        String attributes = match.group(1) ?? '';
        String content = match.group(2) ?? '';
        String closing = match.group(3) ?? '';
        if (builder != null) {
          return '$attributes${builder(content)}$closing';
        }
        return '$attributes${text ?? content}$closing';
      },
    );
  }

  // 隐藏全部挖空
  hiddenAllFill() {
    for (String key in fillMap.keys) {
      List<String> newList = [];
      if (fillMap[key]["hidden"] == true) {
        continue;
      } else {
        for (String item in fillMap[key]["label"]) {
          item = _addHidden(item);
          newList.add(item);
        }
        fillMap[key]["hidden"] = true;
      }
      fillMap[key]["label"] = newList;
    }
    _text = combination();
    notifyListeners();
  }

  // 展示全部挖空
  showAllFill() {
    for (String key in fillMap.keys) {
      List<String> newList = [];
      if (!fillMap[key]["hidden"]) {
        continue;
      } else {
        for (String item in fillMap[key]["label"]) {
          item = _removeHidden(item);
          newList.add(item);
        }
        fillMap[key]["hidden"] = false;
      }
      fillMap[key]["label"] = newList;
    }
    _text = combination();
    notifyListeners();
  }

  _addHidden(String str) {
    if (str.isEmpty) return str;

    return str.replaceAllMapped(
      RegExp(r'(<a\b[^>]*)(?<!hidden)([^>]*>)'),
      (match) => '${match.group(1)} hidden${match.group(2)}', // 添加 hidden
    );
  }

  _removeHidden(String str) {
    if (str.isEmpty) return str;

    return str.replaceAllMapped(
      RegExp(r'(<a\b[^>]*)( hidden)([^>]*>)'),
      (match) => '${match.group(1)}${match.group(3)}', // 删除 hidden
    );
  }

  String getText() {
    return _text;
  }

  bool isAllHidden() {
    for (String key in fillMap.keys) {
      if (!fillMap[key]["hidden"]) {
        return false;
      }
    }
    return true;
  }

  bool isAllShow() {
    for (String key in fillMap.keys) {
      if (fillMap[key]["hidden"]) {
        return false;
      }
    }
    return true;
  }

  // 组合字符串
  String combination() {
    String str = "";
    int idx = -1;
    int labelIdx = 0;
    int strIdx = 0;
    List<dynamic> labels = [];
    while (true) {
      str += strList[strIdx++];
      while (labelIdx == labels.length) {
        var obj = fillMap[(++idx).toString()];
        while (obj == null) {
          obj = fillMap[(++idx).toString()];
          if (strIdx == strList.length) break;
        }
        labels = obj?["label"] ?? [];
        labelIdx = 0;
        if (strIdx == strList.length) break;
      }
      if (strIdx == strList.length) break;
      str += labels[labelIdx++] ?? "";
    }

    return str;
  }

  // 预处理
  // 将字符串中的a标签替换为\u{2006}
  void _preProcess() {
    // 使用正则表达式匹配a标签
    final RegExp exp =
        RegExp(r'<a[^>]*>(.*?)</a>', dotAll: true); // 添加dotAll:true以匹配换行符

    // 将字符串按a标签分割,保留a标签
    final List<String> parts = _text.split(exp);
    final matches = exp.allMatches(_text).map((m) {
      String tag = m.group(0)!;
      String content = m.group(1)!;
      // 在a标签内容中插入\u{2006}
      String processedContent = content.split('').join('\u{2006}');
      return tag.replaceAll(content, processedContent);
    }).toList();

    // 处理每个部分,在非a标签的字符间插入\u{2006}
    String result = '';
    for (int i = 0; i < parts.length; i++) {
      // 对非a标签部分的每个字符间插入\u{2006}
      String part = parts[i];
      result += part.split('').join('\u{2006}');
      // 如果还有a标签,添加到结果中
      if (i < matches.length) {
        result += matches[i];
      }
    }

    _text = result;
  }

  String _addHrefToLinks(String content) {
    int index = 0;

    // 匹配所有的 a 标签，不管是否已经有 href
    final regex = RegExp(r'<a[^>]*>');

    return content.replaceAllMapped(regex, (match) {
      String tag = match.group(0) ?? '';

      // 如果已经有 href，就替换它的值
      if (tag.contains('href=')) {
        return tag.replaceAllMapped(
            RegExp(r'href=["](.*?)["]'), (m) => 'href="$index"');
      }

      // 如果没有 href，就在 > 前添加 href
      final result = '${tag.substring(0, tag.length - 1)} href="$index">';
      index++;
      return result;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _text = "";
    strList.clear();
    fillMap.clear();
  }
}
