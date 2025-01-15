import 'dart:typed_data';

import 'package:diego_lopez_driving_school_client/domain/repositories/operator_repository.dart';

class UploadFile {
  final OperatorRepository repository;

  UploadFile(this.repository);

  Future<String> call({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) {
    return repository.uploadFile(
      folderName: folderName,
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
