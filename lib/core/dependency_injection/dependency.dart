import 'package:ecommerce/core/dependency_injection/locator.dart';
import 'package:ecommerce/features/cart/data/repository/cart_local_data_source_impl.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_local_data_source.dart';
import 'package:flutter/foundation.dart'; // For kReleaseMode

class Dependency {
  Dependency._();

  static GetIt injection = GetIt.instance;

  static void dependencyServicesLocator() {
    injection.registerLazySingleton<TokenServices>(
      () => SecureStorageService(),
    );
    injection.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(),
    );
    injection.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(injection()),
    );

    if (kReleaseMode) {
      // Register production implementations
      injection.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImp(),
      );
      injection.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImp(),
      );
    } else {
      // Register mock implementations for testing
      injection.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryMock(),
      );
      injection.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryMock(),
      );
    }
  }
}
