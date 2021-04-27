part of 'doctor_bloc.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object> get props => [];
}

class FetchPatients extends DoctorEvent {}

class MarkPatientAsCompleted extends DoctorEvent {
  final String id;
  MarkPatientAsCompleted({required this.id});
}
