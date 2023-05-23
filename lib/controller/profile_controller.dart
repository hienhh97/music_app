import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:music_app/models/account.dart';
import 'package:music_app/repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _userRepo = Get.put(UserRepository());

  //Controller

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

  getUserData() {
    final email = FirebaseAuth.instance.currentUser?.email.toString();
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue!");
    }
  }
}
