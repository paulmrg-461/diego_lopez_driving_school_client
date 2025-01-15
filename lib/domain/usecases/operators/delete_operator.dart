// domain/usecases/delete_operator.dart

import 'package:diego_lopez_driving_school_client/domain/repositories/operator_repository.dart';

class DeleteOperator {
  final OperatorRepository repository;

  DeleteOperator(this.repository);

  Future<void> call(String id) {
    return repository.deleteOperator(id);
  }
}
