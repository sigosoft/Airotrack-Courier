class UserProfile {
  String name;
  String date;
  String time;
  final List<String> userTypeOptions;
  String selectedUserType;

  UserProfile({
    required this.name,
    required this.date,
    required this.time,
    required this.userTypeOptions,
    required this.selectedUserType,
  });
}
