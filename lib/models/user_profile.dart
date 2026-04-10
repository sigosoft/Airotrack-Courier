class UserProfile {
  final String name;
  final String date;
  final String time;
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
