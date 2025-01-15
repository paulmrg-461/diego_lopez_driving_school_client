import 'package:diego_lopez_driving_school_client/domain/entities/operator.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/operator_repository.dart';

class UpdateOperator {
  final OperatorRepository repository;

  UpdateOperator(this.repository);

  Future<void> call(Operator operator) {
    return repository.updateOperator(operator);
  }
}
