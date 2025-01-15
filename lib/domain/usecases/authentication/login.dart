import 'package:diego_lopez_driving_school_client/domain/entities/user_entity.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.login(email, password);
  }
}
