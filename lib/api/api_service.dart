import "../models/user.dart";

class ApiService {
  Future<User?> login(String username, String password) async {
    print('Attempting to log in with username: $username');
    if (username.isNotEmpty && password.isNotEmpty) {
      return User(username: username);
    } else {
      return null;
    }
  }

  Future<bool> register(String username, String password) async {
    print('Attempting to register with username: $username');
    if (username.isNotEmpty && password.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
