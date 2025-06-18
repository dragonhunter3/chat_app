// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userId;
  String? profilepicture;
  String? registrationDateTime;
  String? phoneNumber;
  UserModel({
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userId,
    this.profilepicture,
    this.registrationDateTime,
    this.phoneNumber,
  });

  UserModel copyWith({
    String? userName,
    String? userEmail,
    String? userPassword,
    String? userId,
    String? profilepicture,
    String? registrationDateTime,
    String? phoneNumber,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPassword: userPassword ?? this.userPassword,
      userId: userId ?? this.userId,
      profilepicture: profilepicture ?? this.profilepicture,
      registrationDateTime: registrationDateTime ?? this.registrationDateTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userId': userId,
      'profilepicture': profilepicture,
      'registrationDateTime': registrationDateTime,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] != null ? map['userName'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      userPassword:
          map['userPassword'] != null ? map['userPassword'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      profilepicture: map['profilepicture'] != null
          ? map['profilepicture'] as String
          : null,
      registrationDateTime: map['registrationDateTime'] != null
          ? map['registrationDateTime'] as String
          : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userName: $userName, userEmail: $userEmail, userPassword: $userPassword, userId: $userId, profilepicture: $profilepicture, registrationDateTime: $registrationDateTime, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.userEmail == userEmail &&
        other.userPassword == userPassword &&
        other.userId == userId &&
        other.profilepicture == profilepicture &&
        other.registrationDateTime == registrationDateTime &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
        userEmail.hashCode ^
        userPassword.hashCode ^
        userId.hashCode ^
        profilepicture.hashCode ^
        registrationDateTime.hashCode ^
        phoneNumber.hashCode;
  }
}
