import 'package:ecommerce/core/dependency_injection/locator.dart';

class Dependency {
  Dependency._();
  static GetIt injection = GetIt.instance;
  static dependencyServicesLocator() {
    injection.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(),
    );
    injection.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(),
    );
    injection.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(injection()),
    );
    //Auth Reponsitory
    injection.registerLazySingleton<AuthRepository>(() => AuthRepositoryMock());

    //Home Reponsitory
    injection.registerLazySingleton<HomeRepository>(() => HomeRepositoryMock());
  }
}
