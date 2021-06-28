import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/controller/branch_controller.dart';
import 'package:point_of_sale/modal/branch_modal.dart';
import 'dart:async';

abstract class BranchEvent extends Equatable {
  const BranchEvent();
}

class GetBranchList extends BranchEvent {
  @override
  List<Object> get props => null;
}

abstract class BranchState extends Equatable {
  const BranchState();
}

class BranchInitial extends BranchState {
  const BranchInitial();
  @override
  List<Object> get props => [];
}

class BranchLoading extends BranchState {
  const BranchLoading();
  @override
  List<Object> get props => null;
}

class BranchLoaded extends BranchState {
  final List<Branch> branch;
  const BranchLoaded(this.branch);
  @override
  List<Object> get props => [branch];
}

class BranchError extends BranchState {
  final String message;
  const BranchError(this.message);
  @override
  List<Object> get props => [message];
}

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc(BranchState initialState) : super(initialState);
  @override
  BranchState get initialState => BranchInitial();

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is GetBranchList) {
      try {
        yield BranchLoading();
        final branchList = await BranchController.eachBranch();
        yield BranchLoaded(branchList);
        if (branchList.isEmpty) {
          yield BranchError("Branch is empty !");
        }
      } catch (_) {
        yield BranchError("Failed to fetch data. is your device online?");
      }
    }
  }
}
