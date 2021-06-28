import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/controller/company_controller.dart';
import 'package:point_of_sale/modal/compay_modal.dart';
import 'dart:async';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
}

class GetCompanyList extends CompanyEvent {
  @override
  List<Object> get props => null;
}

abstract class CompanyState extends Equatable {
  const CompanyState();
}

class CompanyInitial extends CompanyState {
  const CompanyInitial();
  @override
  List<Object> get props => [];
}

class CompanyLoading extends CompanyState {
  const CompanyLoading();
  @override
  List<Object> get props => null;
}

class CompanyLoaded extends CompanyState {
  final List<Company> company;
  const CompanyLoaded(this.company);
  @override
  List<Object> get props => [company];
}

class CompanyError extends CompanyState {
  final String message;
  const CompanyError(this.message);
  @override
  List<Object> get props => [message];
}

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc(CompanyState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  CompanyState get initialState => CompanyInitial();

  @override
  Stream<CompanyState> mapEventToState(CompanyEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetCompanyList) {
      try {
        yield CompanyLoading();
        final comList = await CompanyController.eachCompany();
        yield CompanyLoaded(comList);
        if (comList.isEmpty) {
          yield CompanyError("Company is empty !");
        }
      } catch (_) {
        yield CompanyError("Failed to fetch data. is your device online?");
      }
    }
  }
}
