import '../../../domain/entities/user.dart';

class UserRemoteDataSource {
  Future<User?> fetchUser(String id) async {
    return User(id: id, name: 'Remote User', email: 'user@example.com');
  }
}
