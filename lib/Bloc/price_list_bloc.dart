import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/controller/price_list_controller.dart';
import 'dart:async';

import 'package:point_of_sale/modal/price_list_modal.dart';

abstract class PriceListEvent extends Equatable {
  const PriceListEvent();
}

class GetPriceList extends PriceListEvent {
  @override
  List<Object> get props => null;
}

abstract class PriceListState extends Equatable {
  const PriceListState();
}

class PriceListInitial extends PriceListState {
  const PriceListInitial();
  @override
  List<Object> get props => [];
}

class PriceListLoading extends PriceListState {
  const PriceListLoading();
  @override
  List<Object> get props => null;
}

class PriceListLoaded extends PriceListState {
  final List<PriceList> priceList;
  const PriceListLoaded(this.priceList);
  @override
  List<Object> get props => [priceList];
}

class PriceListError extends PriceListState {
  final String message;
  const PriceListError(this.message);
  @override
  List<Object> get props => [message];
}

class PriceListBloc extends Bloc<PriceListEvent, PriceListState> {
  PriceListBloc(PriceListState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  PriceListState get initialState => PriceListInitial();

  @override
  Stream<PriceListState> mapEventToState(PriceListEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetPriceList) {
      try {
        yield PriceListLoading();
        final priceList = await PriceListController.eachPriceList();
        yield PriceListLoaded(priceList);
        if (priceList.isEmpty) {
          yield PriceListError("Price list is empty !");
        }
      } catch (_) {
        yield PriceListError("Failed to fetch data. is your device online?");
      }
    }
  }
}
