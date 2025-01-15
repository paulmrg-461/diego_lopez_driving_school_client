import 'package:diego_lopez_driving_school_client/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String email, String password);
  Future<UserEntity?> register(String email, String password);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
