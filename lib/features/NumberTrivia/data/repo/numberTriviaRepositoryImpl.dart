import 'package:clean_architecture_sample/core/error/exception.dart';
import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/core/network/networkInfo.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/datasources/numberTriviaLocalDataSource.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/datasources/numberTriviaRemoteDataSource.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/repo/NumberTriviaRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTrivia> _getConcreteOrRandom();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _getConcreteOrRandom getConcredeOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRandomTrivia = await getConcredeOrRandom();
        localDataSource.cacheNumberTrivia(remoteRandomTrivia);
        return Right(remoteRandomTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
