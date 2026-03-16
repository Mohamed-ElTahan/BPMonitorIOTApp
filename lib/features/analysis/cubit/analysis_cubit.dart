import 'package:flutter_bloc/flutter_bloc.dart';
import 'analysis_state.dart';
import '../../history/model/patient_model.dart';
import '../logic/vitals_analyzer.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit() : super(AnalysisInitial());

  void analyzePatient(PatientModel patient) {
    emit(AnalysisLoading());
    try {
      final result = VitalsAnalyzer.analyze(
        patient.bloodPressure.systolic,
        patient.bloodPressure.diastolic,
        patient.oximeter.heartRate,
        patient.oximeter.spo2,
        creatinine: patient.creatinine,
        bun: patient.bun,
        alt: patient.alt,
        ast: patient.ast,
        glucose: patient.glucose,
      );
      emit(AnalysisLoaded(result));
    } catch (e) {
      emit(AnalysisError('Failed to analyze patient data: $e'));
    }
  }
}
