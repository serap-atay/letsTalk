import 'package:get_it/get_it.dart';
import 'package:letstalk/data/repository/userRepository.dart';
import 'package:letstalk/data/services/firebaseAuthService.dart';
import 'package:letstalk/data/services/firebaseDbService.dart';
import 'package:letstalk/data/services/firebaseStroreageService.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirebaseDbService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
}
