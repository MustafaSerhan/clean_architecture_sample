import 'package:clean_architecture_sample/core/network/networkInfo.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main(){
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp((){
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group("isConnected", (){
    test("should forward the call to DataConnectionChecker.hasconnection", () async {
      //Arrange
      final tHasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
      .thenAnswer((_)  => tHasConnectionFuture);
      //Act
      final result = networkInfo.isConnected;
      //Assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });

  });
}