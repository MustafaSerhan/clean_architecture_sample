import 'package:clean_architecture_sample/core/network/networkInfo.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/inputConverter.dart';
import 'package:http/http.dart' as http;
import 'features/NumberTrivia/bloc/number_trivia_bloc.dart';
import 'features/NumberTrivia/data/datasources/numberTriviaLocalDataSource.dart';
import 'features/NumberTrivia/data/datasources/numberTriviaRemoteDataSource.dart';
import 'features/NumberTrivia/data/repo/numberTriviaRepositoryImpl.dart';
import 'features/NumberTrivia/domain/repo/NumberTriviaRepository.dart';
import 'features/NumberTrivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'features/NumberTrivia/domain/usecases/GetRandomNumberTrivia.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      converter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
