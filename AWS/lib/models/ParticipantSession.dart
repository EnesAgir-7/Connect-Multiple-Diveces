/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the ParticipantSession type in your schema. */
@immutable
class ParticipantSession extends Model {
  static const classType = const _ParticipantSessionModelType();
  final String id;
  final int? _SessionID;
  final String? _moderator;
  final String? _participant;
  final List<String>? _sets;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ParticipantSessionModelIdentifier get modelIdentifier {
      return ParticipantSessionModelIdentifier(
        id: id
      );
  }
  
  int get SessionID {
    try {
      return _SessionID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get moderator {
    try {
      return _moderator!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get participant {
    try {
      return _participant!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get sets {
    return _sets;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ParticipantSession._internal({required this.id, required SessionID, required moderator, required participant, sets, createdAt, updatedAt}): _SessionID = SessionID, _moderator = moderator, _participant = participant, _sets = sets, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ParticipantSession({String? id, required int SessionID, required String moderator, required String participant, List<String>? sets}) {
    return ParticipantSession._internal(
      id: id == null ? UUID.getUUID() : id,
      SessionID: SessionID,
      moderator: moderator,
      participant: participant,
      sets: sets != null ? List<String>.unmodifiable(sets) : sets);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParticipantSession &&
      id == other.id &&
      _SessionID == other._SessionID &&
      _moderator == other._moderator &&
      _participant == other._participant &&
      DeepCollectionEquality().equals(_sets, other._sets);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ParticipantSession {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("SessionID=" + (_SessionID != null ? _SessionID!.toString() : "null") + ", ");
    buffer.write("moderator=" + "$_moderator" + ", ");
    buffer.write("participant=" + "$_participant" + ", ");
    buffer.write("sets=" + (_sets != null ? _sets!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ParticipantSession copyWith({int? SessionID, String? moderator, String? participant, List<String>? sets}) {
    return ParticipantSession._internal(
      id: id,
      SessionID: SessionID ?? this.SessionID,
      moderator: moderator ?? this.moderator,
      participant: participant ?? this.participant,
      sets: sets ?? this.sets);
  }
  
  ParticipantSession.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _SessionID = (json['SessionID'] as num?)?.toInt(),
      _moderator = json['moderator'],
      _participant = json['participant'],
      _sets = json['sets']?.cast<String>(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'SessionID': _SessionID, 'moderator': _moderator, 'participant': _participant, 'sets': _sets, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'SessionID': _SessionID, 'moderator': _moderator, 'participant': _participant, 'sets': _sets, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<ParticipantSessionModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<ParticipantSessionModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField SESSIONID = QueryField(fieldName: "SessionID");
  static final QueryField MODERATOR = QueryField(fieldName: "moderator");
  static final QueryField PARTICIPANT = QueryField(fieldName: "participant");
  static final QueryField SETS = QueryField(fieldName: "sets");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ParticipantSession";
    modelSchemaDefinition.pluralName = "ParticipantSessions";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParticipantSession.SESSIONID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParticipantSession.MODERATOR,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParticipantSession.PARTICIPANT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParticipantSession.SETS,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ParticipantSessionModelType extends ModelType<ParticipantSession> {
  const _ParticipantSessionModelType();
  
  @override
  ParticipantSession fromJson(Map<String, dynamic> jsonData) {
    return ParticipantSession.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ParticipantSession';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ParticipantSession] in your schema.
 */
@immutable
class ParticipantSessionModelIdentifier implements ModelIdentifier<ParticipantSession> {
  final String id;

  /** Create an instance of ParticipantSessionModelIdentifier using [id] the primary key. */
  const ParticipantSessionModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'ParticipantSessionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ParticipantSessionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}