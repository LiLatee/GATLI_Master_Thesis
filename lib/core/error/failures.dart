import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class DefaultFailure extends Failure {
  const DefaultFailure({required this.message});

  final String message;
}
