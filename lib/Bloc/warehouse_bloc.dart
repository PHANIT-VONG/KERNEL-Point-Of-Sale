import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/controller/warehouse_controller.dart';
import 'dart:async';

import 'package:point_of_sale/modal/warehouse_modal.dart';

abstract class WarehouseEvent extends Equatable {
  const WarehouseEvent();
}

class GetWarehouse extends WarehouseEvent {
  @override
  List<Object> get props => null;
}

abstract class WarehouseState extends Equatable {
  const WarehouseState();
}

class WarehouseInitial extends WarehouseState {
  const WarehouseInitial();
  @override
  List<Object> get props => [];
}

class WarehouseLoading extends WarehouseState {
  const WarehouseLoading();
  @override
  List<Object> get props => null;
}

class WarehouseLoaded extends WarehouseState {
  final List<Warehouse> warehouse;
  const WarehouseLoaded(this.warehouse);
  @override
  List<Object> get props => [warehouse];
}

class WarehouseError extends WarehouseState {
  final String message;
  const WarehouseError(this.message);
  @override
  List<Object> get props => [message];
}

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  WarehouseBloc(WarehouseState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  WarehouseState get initialState => WarehouseInitial();

  @override
  Stream<WarehouseState> mapEventToState(WarehouseEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetWarehouse) {
      try {
        yield WarehouseLoading();
        final ware = await WarehouseController.eachWarehouse();
        yield WarehouseLoaded(ware);
        if (ware.isEmpty) {
          yield WarehouseError("Warehouse is empty !");
        }
      } catch (_) {
        yield WarehouseError("Failed to fetch data. is your device online?");
      }
    }
  }
}
