class UserCms {
  final int id;
  final String userId;
  final String system;
  final String status;
  final String branch;
  final String tel;
  final String uploadBy;
  final DateTime requestDate;
  final String type;
  final String responseNewpass;

  UserCms({
    required this.id,
    required this.userId,
    required this.system,
    required this.status,
    required this.branch,
    required this.tel,
    required this.uploadBy,
    required this.requestDate,
    required this.type,
    required this.responseNewpass,
  });

  factory UserCms.fromJson(Map<String, dynamic> json) {
    return UserCms(
      id: json['ID'],
      userId: json['USER_ID'],
      system: json['SYSTEM'],
      status: json['STATUS'],
      branch: json['BRANCH'],
      tel: json['TEL'] ?? '',
      uploadBy: json['UPLOAD_BY'],
      requestDate: DateTime.parse(json['REQUEST_DATE']),
      type: json['TYPE'],
      responseNewpass: json['REPONSE_NEWPASS'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'USER_ID': userId,
      'SYSTEM': system,
      'STATUS': status,
      'BRANCH': branch,
      'TEL': tel,
      'UPLOAD_BY': uploadBy,
      'REQUEST_DATE': requestDate.toIso8601String(),
      'TYPE': type,
      'REPONSE_NEWPASS': responseNewpass,
    };
  }
}