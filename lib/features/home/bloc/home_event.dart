import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ProductsEvent extends HomeEvent {}

class ProductSearchingEvent extends HomeEvent {
  final String query;

  const ProductSearchingEvent({required this.query});

  @override
  List<Object> get props => [query];
}
