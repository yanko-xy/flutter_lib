// Copyright 2025 sheepzhao
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

final RegExp imgRep =
    RegExp(r'!\[([^\]]*)\]\(([^)]+)\)', multiLine: true, caseSensitive: true);

String parseImage(String text) {
  final match = imgRep.firstMatch(text);
  print("match: $text");
  if (match != null) {
    final altText = match.group(1); // 图片描述文本
    String? imageUrl = match.group(2); // 图片URL
    imageUrl = "https://5i5lab.oss-cn-hangzhou.aliyuncs.com$imageUrl";
    return '![$altText]($imageUrl)';
  }
  return text;
}
