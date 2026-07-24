import '../entities/user.dart';
import '../repositories/i_user_repository.dart';

class GetUser {
  final IUserRepository repository;

  GetUser(this.repository);

  Future<User?> call(String id) async {
    return repository.getUser(id);
  }
}
