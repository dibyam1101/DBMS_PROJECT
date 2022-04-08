part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class Loading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderItemModel> orders;
  OrdersLoaded({required this.orders});
  @override
  List<Object> get props => [orders];
}
