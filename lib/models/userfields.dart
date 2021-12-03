class UserFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String email = 'email';
  static final String issue = 'issue';
  static final String uid = 'uid';
  static final String createdAt = 'createdAt';

  static List<String> getFields() => [id, name, email, issue, uid, createdAt];
}

class ReportModel {
  int id;
  String name;
  String email;
  String issue;
  String uid;
  String createdAt;

  ReportModel(
      {this.createdAt, this.email, this.id, this.issue, this.name, this.uid});

  Map<String, dynamic> toJson() => {
        UserFields.id: id,
        UserFields.createdAt: createdAt,
        UserFields.email: email,
        UserFields.issue: issue,
        UserFields.uid: uid,
        UserFields.name: name
      };

  ReportModel copy({
    int id,
    String name,
    String email,
    String issue,
    String uid,
    String createdAt,
  }) =>
      ReportModel(
          id: id ?? this.id,
          name: name ?? this.name,
          email: email ?? this.email,
          createdAt: createdAt ?? this.createdAt,
          issue: issue ?? this.issue,
          uid: uid ?? this.uid);
}
