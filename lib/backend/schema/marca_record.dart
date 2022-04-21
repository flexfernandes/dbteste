import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'marca_record.g.dart';

abstract class MarcaRecord implements Built<MarcaRecord, MarcaRecordBuilder> {
  static Serializer<MarcaRecord> get serializer => _$marcaRecordSerializer;

  @nullable
  int get codigo;

  @nullable
  String get nome;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(MarcaRecordBuilder builder) => builder
    ..codigo = 0
    ..nome = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('marca');

  static Stream<MarcaRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<MarcaRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  MarcaRecord._();
  factory MarcaRecord([void Function(MarcaRecordBuilder) updates]) =
      _$MarcaRecord;

  static MarcaRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createMarcaRecordData({
  int codigo,
  String nome,
}) =>
    serializers.toFirestore(
        MarcaRecord.serializer,
        MarcaRecord((m) => m
          ..codigo = codigo
          ..nome = nome));
