import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/controller/customer_controller.dart';
import 'package:point_of_sale/modal/customer_modal.dart';
import 'dart:async';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
}

class GetCustomerList extends CustomerEvent {
  @override
  List<Object> get props => null;
}

abstract class CustomerState extends Equatable {
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  const CustomerInitial();
  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
  @override
  List<Object> get props => null;
}

class CustomerLoaded extends CustomerState {
  final List<Customer> customer;
  const CustomerLoaded(this.customer);
  @override
  List<Object> get props => [customer];
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);
  @override
  List<Object> get props => [message];
}

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc(CustomerState initialState) : super(initialState);

  @override
  // ignore: override_on_non_overriding_member
  CustomerState get initialState => CustomerInitial();

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetCustomerList) {
      try {
        yield CustomerLoading();
        final cusList = await CustomerController.eachCustomer();
        yield CustomerLoaded(cusList);
        if (cusList.isEmpty) {
          yield CustomerError("Customer is empty !");
        }
      } catch (_) {
        yield CustomerError("Failed to fetch data. is your device online?");
      }
    }
  }
}
