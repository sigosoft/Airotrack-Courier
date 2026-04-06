import 'package:get/get.dart';
import '../models/user_profile.dart';

class HomeController extends GetxController {
  // Observable user profile state
  final userProfile = UserProfile(
    name: 'Jobin',
    date: '05 Jun 2023',
    time: '08:22:11 AM',
    userTypeOptions: ['Owner', 'Driver', 'Manager'],
    selectedUserType: 'Select User Type',
  ).obs;

  // Method to update user type
  void updateSelectedUserType(String? value) {
    if (value != null) {
      userProfile.update((val) {
        val?.selectedUserType = value;
      });
    }
  }
}
