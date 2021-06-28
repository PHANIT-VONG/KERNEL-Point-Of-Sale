import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/controller/display_currency_controller.dart';
import 'package:point_of_sale/modal/display_currency_modal.dart';
import 'dart:async';

abstract class DisCurrencyEvent extends Equatable {
  const DisCurrencyEvent();
}

class GetDisCurrency extends DisCurrencyEvent {
  @override
  List<Object> get props => null;
}

abstract class DisCurrencyState extends Equatable {
  const DisCurrencyState();
}

class DisCurrencyInitial extends DisCurrencyState {
  const DisCurrencyInitial();
  @override
  List<Object> get props => [];
}

class DisCurrencyLoading extends DisCurrencyState {
  const DisCurrencyLoading();
  @override
  List<Object> get props => null;
}

class DisCurrencyLoaded extends DisCurrencyState {
  final List<DisplayCurrency> disCurrency;
  const DisCurrencyLoaded(this.disCurrency);
  @override
  List<Object> get props => [disCurrency];
}

class DisCurrencyError extends DisCurrencyState {
  final String message;
  const DisCurrencyError(this.message);
  @override
  List<Object> get props => [message];
}

class DisCurrencyBloc extends Bloc<DisCurrencyEvent, DisCurrencyState> {
  DisCurrencyBloc(DisCurrencyState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  DisCurrencyState get initialState => DisCurrencyInitial();

  @override
  Stream<DisCurrencyState> mapEventToState(DisCurrencyEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetDisCurrency) {
      try {
        yield DisCurrencyLoading();
        final disCur = await DisplayCurrController.eachDisCurr();
        yield DisCurrencyLoaded(disCur);
        if (disCur.isEmpty) {
          yield DisCurrencyError("Price list is empty !");
        }
      } catch (_) {
        yield DisCurrencyError("Failed to fetch data. is your device online?");
      }
    }
  }
}
