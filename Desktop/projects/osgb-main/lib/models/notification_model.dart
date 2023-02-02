class NotificationModel {
  String? to;
  String? priority;
  CustomNotification? notification;

  NotificationModel({this.to, this.priority,required this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    priority = json['priority'];
    notification = json['notification'] != null
        ? CustomNotification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    data['priority'] = this.priority;
    if (notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class CustomNotification {
  String? title;
  String? body;
  String? sound;

  CustomNotification({this.title, this.body, this.sound});

  CustomNotification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['sound'] = sound;
    return data;
  }
}