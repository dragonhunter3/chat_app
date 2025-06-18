// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

// import 'package:flutter/foundation.dart';

class GroupModel {
  String? groupName;
  String? groupid;
  List<String>? userid;
  GroupModel({
    this.groupName,
    this.groupid,
    this.userid,
  });

  GroupModel copyWith({
    String? groupName,
    String? groupid,
    List<String>? userid,
  }) {
    return GroupModel(
      groupName: groupName ?? this.groupName,
      groupid: groupid ?? this.groupid,
      userid: userid ?? this.userid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupName': groupName,
      'groupid': groupid,
      'userid': userid,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupName: map['groupName'] != null ? map['groupName'] as String : null,
      groupid: map['groupid'] != null ? map['groupid'] as String : null,
      userid: map['userid'] != null
          ? List<String>.from((map['userid'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GroupModel(groupName: $groupName, groupid: $groupid, userid: $userid)';

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.groupName == groupName &&
        other.groupid == groupid &&
        listEquals(other.userid, userid);
  }

  @override
  int get hashCode => groupName.hashCode ^ groupid.hashCode ^ userid.hashCode;
}
