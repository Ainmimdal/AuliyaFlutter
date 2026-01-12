import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference childrenCollection =
      FirebaseFirestore.instance.collection('children');

  /// Stream of children for the current user
  Stream<List<ChildModel>> get children {
    return childrenCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_childListFromSnapshot);
  }

  List<ChildModel> _childListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ChildModel.fromJson(data, id: doc.id);
    }).toList();
  }

  /// Add a new child
  Future<String> addChild(ChildModel child) async {
    child.userId = uid;
    DocumentReference docRef = await childrenCollection.add(child.toJson());
    return docRef.id;
  }

  /// Update an existing child
  Future<void> updateChild(ChildModel child) async {
    if (child.id == null) {
      throw ArgumentError('Child must have an id to update');
    }
    await childrenCollection.doc(child.id).update(child.toJson());
  }

  /// Delete a child
  Future<void> deleteChild(String docId) async {
    await childrenCollection.doc(docId).delete();
  }

  /// Get a single child by document ID
  Future<ChildModel?> getChild(String docId) async {
    DocumentSnapshot doc = await childrenCollection.doc(docId).get();
    if (doc.exists) {
      return ChildModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    }
    return null;
  }

  /// Update child's score (level, star, hariankey)
  Future<void> updateChildScore(ChildModel child) async {
    if (child.id == null) return;
    await childrenCollection.doc(child.id).update({
      'level': child.level,
      'star': child.star,
      'hariankey': child.hariankey,
    });
  }

  /// Update child's harian list
  Future<void> updateChildHarian(ChildModel child) async {
    if (child.id == null) return;
    await childrenCollection.doc(child.id).update({
      'harian': child.harian.map((h) => h.toJson()).toList(),
    });
  }

  /// Update child's bonus list
  Future<void> updateChildBonus(ChildModel child) async {
    if (child.id == null) return;
    await childrenCollection.doc(child.id).update({
      'bonus': child.bonus.map((b) => b.toJson()).toList(),
    });
  }
}
