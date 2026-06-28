import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';

class AlumnoService {
  // Patrón Singleton
  static final AlumnoService instance = AlumnoService._internal();
  AlumnoService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _coleccion = 'alumnos';

  // CREATE
  Future<void> registrarAlumno(Alumno alumno) async {
    await _firestore.collection(_coleccion).add(alumno.toMap());
  }

  // READ
  Stream<List<Alumno>> getAlumnosStream() {
    return _firestore.collection(_coleccion).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Alumno.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // UPDATE
  Future<void> actualizarAlumno(Alumno alumno) async {
    if (alumno.id == null) return;
    await _firestore
        .collection(_coleccion)
        .doc(alumno.id)
        .update(alumno.toMap());
  }

  // DELETE
  Future<void> eliminarAlumno(String id) async {
    await _firestore.collection(_coleccion).doc(id).delete();
  }
}
