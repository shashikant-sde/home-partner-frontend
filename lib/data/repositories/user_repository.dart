import '../../domain/entities/user.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/local/user_local_ds.dart';
import '../datasources/remote/user_remote_ds.dart';

class UserRepository implements IUserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  UserRepository({required this.localDataSource, required this.remoteDataSource});

  @override
  Future<User?> getUser(String id) async {
    final localUser = await localDataSource.fetchUser(id);
    if (localUser != null) {
      return localUser;
    }
    return remoteDataSource.fetchUser(id);
  }
}
