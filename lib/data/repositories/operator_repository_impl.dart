// data/repositories/operator_repository_impl.dart

import 'dart:typed_data';

import 'package:diego_lopez_driving_school_client/data/datasources/firebase_storage_data_source.dart';
import 'package:diego_lopez_driving_school_client/data/datasources/operator_data_source.dart';
import 'package:diego_lopez_driving_school_client/data/models/operator_model.dart';
import 'package:diego_lopez_driving_school_client/domain/entities/operator.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/operator_repository.dart';

class OperatorRepositoryImpl implements OperatorRepository {
  final OperatorDataSource dataSource;
  final FirebaseStorageDataSource storageDataSource;

  OperatorRepositoryImpl({
    required this.dataSource,
    required this.storageDataSource,
  });

  @override
  Future<void> createOperator(Operator operator) async {
    final operatorModel = OperatorModel.fromEntity(operator);
    await dataSource.createOperator(operatorModel);
  }

  @override
  Future<List<Operator>> getOperators() async {
    final operatorModels = await dataSource.getOperators();
    return operatorModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateOperator(Operator operator) async {
    final operatorModel = OperatorModel.fromEntity(operator);
    await dataSource.updateOperator(operatorModel);
  }

  @override
  Future<void> deleteOperator(String id) {
    return dataSource.deleteOperator(id);
  }

  @override
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) {
    return storageDataSource.uploadFile(
      folderName: folderName,
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
