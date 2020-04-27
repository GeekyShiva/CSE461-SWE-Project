import 'package:taxi_app/models/user.dart';

class UserController {
  static User getUser() {
    return User(
        name: "Raghav Mittal",
        mobileNumber: "+911234567890",
        photoUrl:
            "https://avatars0.githubusercontent.com/u/31070108?s=460&v=4");
  }
}
