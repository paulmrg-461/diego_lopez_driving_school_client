import 'package:diego_lopez_driving_school_client/domain/entities/user_entity.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUser();
  }
}
