import 'package:diego_lopez_driving_school_client/domain/entities/operator.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/operator_repository.dart';

class GetOperators {
  final OperatorRepository repository;

  GetOperators(this.repository);

  Future<List<Operator>> call() {
    return repository.getOperators();
  }
}
