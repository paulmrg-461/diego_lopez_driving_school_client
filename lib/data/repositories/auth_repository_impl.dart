import 'package:diego_lopez_driving_school_client/data/datasources/firebase_auth_data_source.dart';
import 'package:diego_lopez_driving_school_client/domain/entities/user_entity.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity?> login(String email, String password) =>
      dataSource.login(email, password);

  @override
  Future<UserEntity?> register(String email, String password) =>
      dataSource.register(email, password);

  @override
  Future<void> logout() => dataSource.logout();

  @override
  Future<UserEntity?> getCurrentUser() => dataSource.getCurrentUser();
}
