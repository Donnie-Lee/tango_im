
class Trend {
  int id;
  List<String> images;
  String content;
  DateTime createTime;

  Trend.fromJson(Map<String, dynamic> map)
      : images = map['images'],
        content = map['content'],
        id = map['id'],
        createTime = DateTime.parse(map['createTime']);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['images'] = images;
    map['content'] = content;
    map['createTime'] = createTime;
    return map;
  }
}