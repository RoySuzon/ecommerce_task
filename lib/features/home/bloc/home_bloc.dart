import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/domain/usecases/home_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/home/bloc/home_event.dart';
import 'package:ecommerce/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUseCase repo;
  List<Product> finalProducts = [];
  HomeBloc(this.repo) : super(HomeInitial()) {
    on<ProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result = await repo.call();
      result.fold((failure) => emit(ProductsFaild(failure: failure)), (
        products,
      ) {
        emit(ProductsLoaded(products: finalProducts = products));
      });
    });
    on<ProductSearchingEvent>((event, emit) async {
      emit(ProductsLoading());
      List<Product> products = finalProducts
          .where(
              (e) => e.name!.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(ProductsLoaded(products: products));
    });
  }
}
