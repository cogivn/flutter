# Domain-Driven Design Implementation Guide

This document provides a comprehensive guide for implementing modules following Domain-Driven Design (DDD) principles in Flutter applications. It includes code patterns, architecture guidelines, and implementation templates that can be adapted for any module.

## Table of Contents

### 1. [Architecture Overview](#architecture-overview)
- [Key Architectural Principles](#key-architectural-principles)
- [Module Development Rules](#module-development-rules)

### 2. [Domain Layer](#domain-layer)
- [2.1 Constants - Validation Keys Pattern](#1-constants---validation-keys-pattern)
- [2.2 Entities - Domain Entity Pattern](#2-entities---domain-entity-pattern)
- [2.3 Errors - Domain Error Types Pattern](#3-errors---domain-error-types-pattern)
- [2.4 Models - Request Model Pattern](#4-models---request-model-pattern)
- [2.5 Repositories - Repository Interface Pattern](#5-repositories---repository-interface-pattern)
- [2.6 Validators - Validation Rules Pattern](#6-validators---validation-rules-pattern)

### 3. [Application Layer](#application-layer)
- [3.1 Notifier and State Implementation Pattern](#1-notifier-and-state-implementation-pattern)
- [3.2 State Implementation Template](#state-implementation-template)

### 4. [Infrastructure Layer](#infrastructure-layer)
- [4.1 Repository Implementation Pattern](#1-repository-implementation-pattern)
- [4.2 Repository Mock Implementation Pattern](#2-repository-mock-implementation-pattern)
- [4.3 DTO Implementation Pattern](#3-dto-implementation-pattern)

### 5. [Presentation Layer](#presentation-layer)
- [5.1 Hooks for Form Management Pattern](#1-hooks-for-form-management-pattern)
- [5.2 Page Implementation Pattern](#2-page-implementation-pattern)
- [5.3 Body Widget Implementation Pattern](#3-body-widget-implementation-pattern)

### 6. [Module File Structure](#module-file-structure)
- [6.1 Standard Module Structure](#standard-module-structure)
- [6.2 File Placement Guidelines](#file-placement-guidelines)
- [6.3 Naming Conventions](#naming-conventions)
- [6.4 Localization Keys](#localization-keys)
- [6.5 Generated Files](#generated-files)

### 7. [Implementation Templates](#implementation-templates)
- [7.1 Quick Start Template for New Modules](#quick-start-template-for-new-modules)
- [7.2 Domain Layer Checklist](#domain-layer-checklist)
- [7.3 Application Layer Checklist](#application-layer-checklist)
- [7.4 Infrastructure Layer Checklist](#infrastructure-layer-checklist)
- [7.5 Presentation Layer Checklist](#presentation-layer-checklist)
- [7.6 Example Module Implementation](#example-module-implementation)

### 8. [Code Generation Guidelines](#code-generation-guidelines)
- [8.1 Freezed and Build Runner](#freezed-and-build-runner)
- [8.2 Required Dependencies](#required-dependencies)
- [8.3 File Generation Rules](#file-generation-rules)
- [8.4 Naming Convention Summary](#naming-convention-summary)
- [8.5 Localization Requirements](#localization-requirements)
- [8.6 Freezed Patterns for DDD Layers](#freezed-patterns-for-ddd-layers)
- [8.7 JSON Serialization Layer Rules](#json-serialization-layer-rules)

---

## Quick Reference for AI Agents

### Freezed Patterns for DDD Layers
### JSON Serialization Layer Rules

### MCP Rules Referenced in This Document
- **MCP-ddd-layer-isolation**: Each layer communicates only with layers immediately below it
- **MCP-ddd-dependency-rule**: Dependencies always point inward toward domain layer
- **MCP-ddd-separation**: UI, business logic, and infrastructure concerns are fully separated
- **MCP-ddd-domain-layer**: Use constants for validation keys, define clean domain entities, define domain-specific error types, implement domain validators for business rules
- **MCP-ddd-application-layer**: Keep notifier and state in same file, define state classes with freezed, use extensions for state transitions, use Riverpod v3 syntax (`NotifierProvider.autoDispose` and `Notifier`)
- **MCP-ddd-infrastructure-layer**: Implement repository interfaces from domain layer, use dependency injection, implement mock repositories for testing, use Freezed for DTOs
- **MCP-ddd-error-handling**: Use sealed classes for error hierarchies
- **MCP-ddd-validation**: Use static methods for pure validation functions
- **MCP-localization-usage**: Widget classes use `context.s.keyword`, non-widget classes use `S.current.keyword`, functions with BuildContext parameter use `context.s.keyword`

### Common Patterns by Purpose
- **Form Validation**: See [Validators Pattern](#6-validators---validation-rules-pattern)
- **Error Handling**: See [Error Types Pattern](#3-errors---domain-error-types-pattern)
- **State Management**: See [Notifier Pattern](#1-notifier-and-state-implementation-pattern)
- **API Integration**: See [Repository Implementation](#1-repository-implementation-pattern)
- **UI Forms**: See [Hooks Pattern](#1-hooks-for-form-management-pattern)
- **New Module Setup**: See [Quick Start Template](#quick-start-template-for-new-modules)
- **Localization Usage**: See [Localization Requirements](#localization-requirements)

### File Templates by Layer
- **Domain**: [Constants](#1-constants---validation-keys-pattern), [Entities](#2-entities---domain-entity-pattern), [Errors](#3-errors---domain-error-types-pattern), [Models](#4-models---request-model-pattern), [Repositories](#5-repositories---repository-interface-pattern), [Validators](#6-validators---validation-rules-pattern)
- **Application**: [Notifier](#1-notifier-and-state-implementation-pattern), [State](#state-implementation-template)
- **Infrastructure**: [Repository Impl](#1-repository-implementation-pattern), [Repository Mock](#2-repository-mock-implementation-pattern), [DTOs](#3-dto-implementation-pattern)
- **Presentation**: [Hooks](#1-hooks-for-form-management-pattern), [Pages](#2-page-implementation-pattern), [Widgets](#3-body-widget-implementation-pattern)

## Architecture Overview

All modules in this project follow a strict layered DDD architecture with four distinct layers, each with specific responsibilities:

```
{module_name}/
├── domain/        # Core business rules and entities
├── application/   # Use cases and state management
├── infrastructure/# Technical implementation details
└── presentation/  # User interface components
```

### Key Architectural Principles:

- **MCP-ddd-layer-isolation**: Each layer communicates only with layers immediately below it
- **MCP-ddd-dependency-rule**: Dependencies always point inward toward domain layer
- **MCP-ddd-separation**: UI, business logic, and infrastructure concerns are fully separated

### Module Development Rules:

1. **Every module MUST follow the exact same structure**
2. **File naming convention**: `{module_name}_{component_type}.dart`
3. **Class naming convention**: `{ModuleName}{ComponentType}`
4. **Generated files**: Always include `.freezed.dart` suffix (and `.g.dart` for DTOs with JSON serialization)
5. **Dependency injection**: Use `@injectable` and `@LazySingleton` annotations

## Domain Layer

The Domain Layer contains the core business logic, entities, and validation rules for each module. This layer is completely independent of external frameworks and represents the business domain.

### 1. Constants - Validation Keys Pattern

**Template**: `{module_name}_validation_keys.dart`

```dart
/// Constants used for validation in the {module name} flow
///
/// Follows MCP-ddd-domain-layer: Use constants for validation keys
class {ModuleName}ValidationKeys {
  // Private constructor to prevent instantiation
  {ModuleName}ValidationKeys._();

  /// Key for {field} field validation errors
  static const String {field} = '{field}';
  
  /// Key for {another_field} validation errors
  static const String {anotherField} = '{anotherField}';
}
```

**Example**: Change Plates Number Module
```dart
/// Constants used for validation in the change plates number flow
///
/// Follows MCP-ddd-domain-layer: Use constants for validation keys
class ChangePlatesNumberValidationKeys {
  // Private constructor to prevent instantiation
  ChangePlatesNumberValidationKeys._();

  /// Key for plate field validation errors
  static const String plate = 'plate';
  
  /// Key for max plates count validation errors
  static const String maxPlatesCount = 'maxPlatesCount';
}
```

### 2. Entities - Domain Entity Pattern

**Template**: `{module_name}.dart`

```dart
/// Domain entity representing {entity description}
///
/// This interface defines the properties required for {operation description}.
/// Follows MCP-ddd-domain-layer: Define clean domain entities
abstract interface class {ModuleName} {
  /// Unique identifier for this {entity} record
  int get id;
  
  /// {Property description}
  {Type} get {property};
  
  /// {Another property description}
  {Type} get {anotherProperty};
}
```

**Example**: Change Plates Number Module
```dart
/// Domain entity representing a user's plates number
///
/// This interface defines the properties required for a plates number change operation.
/// Follows MCP-ddd-domain-layer: Define clean domain entities
abstract interface class ChangePlatesNumber {
  /// Unique identifier for this plates number change record
  int get id;
  
  /// User's vehicle plates list
  List<String> get plates;
}
```

### 3. Errors - Domain Error Types Pattern

**Template**: `{module_name}_error.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../constants/{module_name}_validation_keys.dart';

part '{module_name}_error.freezed.dart';
part '{module_name}_error.g.dart';

/// Domain-specific error types for {Module Name} process
///
/// This sealed class defines a hierarchy of error types that can occur during
/// the {module purpose} process. It handles various failure scenarios including
/// API errors, database errors, validation errors, and unexpected errors.
///
/// Follows MCP-ddd-domain-layer: Define domain-specific error types
/// Follows MCP-ddd-error-handling: Use sealed classes for error hierarchies
@freezed
sealed class {ModuleName}Error with _${ModuleName}Error {
  const {ModuleName}Error._();

  /// Error related to API operations
  const factory {ModuleName}Error.api(ApiError error) = {ModuleName}ApiError;

  /// Error related to Database operations
  const factory {ModuleName}Error.db(String message) = {ModuleName}DbError;

  /// Unknown or unexpected errors
  const factory {ModuleName}Error.unknown(String message) = {ModuleName}UnknownError;

  /// Error when input validation fails
  const factory {ModuleName}Error.input(List<String> cases) = {ModuleName}InputError;

  /// Gets the user-friendly error message associated with this error
  String? getMessage(
    BuildContext context, {
    String? key,
    bool includeOtherIssues = false,
  }) {
    return switch (this) {
      {ModuleName}InputError(cases: final cases) => cases.contains(key)
          ? switch (key) {
              {ModuleName}ValidationKeys.{field} =>
                context.s.{module_name}_{field}_invalid,
              // Add more validation cases here
              _ => null,
            }
          : null,
      {ModuleName}ApiError(error: final error) =>
        includeOtherIssues ? error.message : null,
      {ModuleName}DbError(message: final message) =>
        includeOtherIssues ? message : null,
      {ModuleName}UnknownError(message: final message) =>
        includeOtherIssues ? message : null,
    };
  }
}
```

**Example**: Change Plates Number Module
```dart
/// Domain-specific error types for Change Plates Number process
@freezed
sealed class ChangePlatesNumberError with _$ChangePlatesNumberError {
  const ChangePlatesNumberError._();

  /// Error related to API operations
  const factory ChangePlatesNumberError.api(ApiError error) = ChangePlatesNumberApiError;

  /// Error related to Database operations  
  const factory ChangePlatesNumberError.db(String message) = ChangePlatesNumberDbError;

  /// Unknown or unexpected errors
  const factory ChangePlatesNumberError.unknown(String message) = ChangePlatesNumberUnknownError;

  /// Error when input validation fails
  const factory ChangePlatesNumberError.input(List<String> cases) = ChangePlatesNumberInputError;

  /// Gets the user-friendly error message associated with this error
  String? getMessage(
    BuildContext context, {
    String? key,
    bool includeOtherIssues = false,
  }) {
    return switch (this) {
      ChangePlatesNumberInputError(cases: final cases) => cases.contains(key)
          ? switch (key) {
              ChangePlatesNumberValidationKeys.plate =>
                context.s.change_plates_number_plate_invalid,
              ChangePlatesNumberValidationKeys.maxPlatesCount =>
                context.s.change_plates_number_max_plates_reached,
              _ => null,
            }
          : null,
      ChangePlatesNumberApiError(error: final error) =>
        includeOtherIssues ? error.message : null,
      ChangePlatesNumberDbError(message: final message) =>
        includeOtherIssues ? message : null,
      ChangePlatesNumberUnknownError(message: final message) =>
        includeOtherIssues ? message : null,
    };
  }
}
```

### 4. Models - Request Model Pattern

**Template**: `{module_name}_request.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{module_name}_request.freezed.dart';

/// Request model for {module purpose} operations
/// 
/// Follows MCP-ddd-domain-layer: Define immutable value objects for requests
@freezed
abstract class {ModuleName}Request with _${ModuleName}Request {
  const {ModuleName}Request._();

  /// Creates a {module} request with the required parameters
  const factory {ModuleName}Request({
    /// {Field description}
    @Default({defaultValue}) {Type} {field},
    
    /// {Another field description}
    {Type}? {anotherField},
  }) = _{ModuleName}Request;
}
```

**Example**: Change Plates Number Module
```dart
/// Request model for plates number change operations
@freezed
abstract class ChangePlatesNumberRequest with _$ChangePlatesNumberRequest {
  const ChangePlatesNumberRequest._();

  /// Creates a plates change request with the required parameters
  const factory ChangePlatesNumberRequest({
    /// List of plates to be updated
    @Default(<String>[]) List<String> plates,
  }) = _ChangePlatesNumberRequest;
}
```

### 5. Repositories - Repository Interface Pattern

**Template**: `{module_name}_repository.dart`

```dart
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/errors/api_error.dart';
import '../entities/{module_name}.dart';
import '../models/{module_name}_request.dart';

/// Repository interface for {module purpose} operations
/// 
/// This interface defines the contract for accessing and modifying {entity} data.
/// Follows MCP-ddd-domain-layer: Define repository interfaces in domain layer
abstract class {ModuleName}Repository {
  /// {Primary operation description}
  /// 
  /// [request] The {request description}
  /// [token] Optional token for cancelling the request
  Future<ResultDart<{ModuleName}, ApiError>> {primaryOperation}(
    {ModuleName}Request request, 
    {CancelToken? token}
  );

  /// Fetches the current {entity} information
  ///
  /// Returns the current {entity description}
  Future<{ModuleName}> getPreloadData();
  
  /// Additional operations as needed
  /// Future<List<{ModuleName}>> getAll();
  /// Future<{ModuleName}?> getById(int id);
}
```

**Example**: Change Plates Number Module
```dart
/// Repository interface for plates number change operations
abstract class ChangePlatesNumberRepository {
  /// Updates plates information
  Future<ResultDart<ChangePlatesNumber, ApiError>> update(
    ChangePlatesNumberRequest request, 
    {CancelToken? token}
  );

  /// Fetches the current plates information
  Future<ChangePlatesNumber> getPreloadData();
}
```

### 6. Validators - Validation Rules Pattern

**Template**: `{module_name}_validator.dart`

```dart
import '../constants/{module_name}_validation_keys.dart';

/// Context object that holds the data to be validated for {module} process
///
/// Follows MCP-ddd-domain-layer: Use context objects for validation data
class {ModuleName}ValidationContext {
  /// Creates a validation context for {module} form
  const {ModuleName}ValidationContext({
    required this.{field},
    required this.{anotherField},
  });

  /// {Field description}
  final {Type} {field};
  
  /// {Another field description}
  final {Type} {anotherField};
}

/// Validator for {module} form inputs
///
/// Follows MCP-ddd-domain-layer: Implement domain validators for business rules
/// Follows MCP-ddd-validation: Use static methods for pure validation functions
class {ModuleName}Validator {
  // Private constructor to prevent instantiation
  {ModuleName}Validator._();
  
  /// Validates if {field} is valid
  static bool is{Field}Valid({Type} {field}) {
    // Implement validation logic
    return {field}.{validationCondition};
  }
  
  /// Gets all validation error field keys
  static List<String> getErrorFields({ModuleName}ValidationContext context) {
    final List<String> errorFields = [];
    
    // Validate each field
    if (!is{Field}Valid(context.{field})) {
      errorFields.add({ModuleName}ValidationKeys.{field});
    }
    
    return errorFields;
  }
  
  /// Validates if the entire form is valid
  static bool is{ModuleName}FormValid({ModuleName}ValidationContext context) {
    return is{Field}Valid(context.{field}) && 
           // Add more validations as needed
           true;
  }
}
```

**Example**: Change Plates Number Module
```dart
/// Context object that holds the data to be validated for change plates number process
class ChangePlatesNumberValidationContext {
  const ChangePlatesNumberValidationContext({
    required this.plate,
    required this.currentPlates,
  });

  /// Plate to be validated
  final String plate;
  
  /// Current list of plates
  final List<String> currentPlates;
}

/// Validator for change plates number form inputs
class ChangePlatesNumberValidator {
  ChangePlatesNumberValidator._();
  
  /// Validates if plate is not empty
  static bool isPlateValid(String plate) {
    return plate.trim().isNotEmpty;
  }
  
  /// Validates if the maximum number of plates hasn't been reached
  static bool isMaxPlatesValid(List<String> currentPlates) {
    return currentPlates.length < 6;
  }
  
  /// Gets all validation error field keys
  static List<String> getErrorFields(ChangePlatesNumberValidationContext context) {
    final List<String> errorFields = [];
    
    // Validate plate
    if (!isPlateValid(context.plate)) {
      errorFields.add(ChangePlatesNumberValidationKeys.plate);
    }
    
    // Validate max plates count
    if (!isMaxPlatesValid(context.currentPlates)) {
      errorFields.add(ChangePlatesNumberValidationKeys.maxPlatesCount);
    }
    
    return errorFields;
  }
  
  /// Validates if the entire form is valid for adding a new plate
  static bool isChangePlatesNumberFormValid(ChangePlatesNumberValidationContext context) {
    return isPlateValid(context.plate) && isMaxPlatesValid(context.currentPlates);
  }
}
```

## Application Layer

The Application Layer contains the state management and business logic coordination for each module. This layer orchestrates domain operations and manages UI state.

### 1. Notifier and State Implementation Pattern

**Template**: `{module_name}_notifier.dart`

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/entities/{module_name}.dart';
import '../../domain/errors/{module_name}_error.dart';
import '../../domain/models/{module_name}_request.dart';
import '../../domain/repositories/{module_name}_repository.dart';
import '../../domain/validators/{module_name}_validator.dart';

part '{module_name}_state.dart';
part '{module_name}_notifier.freezed.dart';

final {moduleName}Provider =
    NotifierProvider.autoDispose<{ModuleName}Notifier, {ModuleName}State>(
  () => getIt<{ModuleName}Notifier>(),
);

// Follows MCP-ddd-application-layer: Keep notifier and state in same file
@injectable
class {ModuleName}Notifier extends Notifier<{ModuleName}State> {
  final {ModuleName}Repository _repository;
  final Set<CancelToken> _cancelTokens = {};

  {ModuleName}Notifier(this._repository);

  @override
  {ModuleName}State build() {
    ref.onDispose(() {
      logger.i('Disposing {ModuleName}Notifier');
      _cancelAllRequests();
    });
    return const {ModuleName}State();
  }

  /// Cancels all ongoing API requests to prevent memory leaks
  void _cancelAllRequests() {
    for (final token in _cancelTokens) {
      logger.d('[{ModuleName}Notifier] Cancelling request');
      token.cancel('Notifier was disposed');
    }
    _cancelTokens.clear();
  }

  /// Creates a new cancel token for API requests
  /// Multiple tokens can exist simultaneously for concurrent requests
  CancelToken _createCancelToken() {
    final cancelToken = CancelToken();
    _cancelTokens.add(cancelToken);
    logger.d('[{ModuleName}Notifier] Created new cancel token (total: ${_cancelTokens.length})');
    return cancelToken;
  }
  Future<void> {primaryOperation}() async {
    if (!_validateInput()) {
      return;
    }
    
    state = state.loading;

    // Create request from current input state
    final request = {ModuleName}Request(
      {field}: state.input.{field},
      // Add other fields as needed
    );

    // Send request to repository
    final result = await _repository.{primaryOperation}(
      request,
      token: _createCancelToken(),
    );

    // Handle the results
    state = result.fold(state.onSuccess, state.onApiError);
    
    // Clear input after successful operation (if needed)
    if (state.isSuccess) {
      state = state.onInput(const {ModuleName}Input());
    }
  }
}
```
#### State Implementation Template

**Template**: Part of `{module_name}_notifier.dart`

```dart
part of '{module_name}_notifier.dart';

// Follows MCP-ddd-application-layer: Define state classes with freezed
@freezed
sealed class {ModuleName}Status with _${ModuleName}Status {
  const factory {ModuleName}Status.initial() = {ModuleName}InitialStatus;
  const factory {ModuleName}Status.loading() = {ModuleName}LoadingStatus;
  const factory {ModuleName}Status.error({ModuleName}Error err) = {ModuleName}ErrorStatus;
  const factory {ModuleName}Status.input({ModuleName}Input data) = {ModuleName}InputStatus;
  const factory {ModuleName}Status.success() = {ModuleName}SuccessStatus;
  const factory {ModuleName}Status.loaded() = {ModuleName}LoadedStatus;
}

@freezed
abstract class {ModuleName}Input with _${ModuleName}Input {
  const {ModuleName}Input._();

  const factory {ModuleName}Input({
    @Default('') String {field},
    // Add other input fields as needed
  }) = _{ModuleName}Input;

  /// Returns a list of error field keys based on validation rules
  List<String> getErrorCase() {
    final context = {ModuleName}ValidationContext(
      {field}: {field},
      // Add other validation context fields
    );
    return {ModuleName}Validator.getErrorFields(context);
  }

  /// Determines if the form is valid
  bool isValid() {
    final context = {ModuleName}ValidationContext(
      {field}: {field},
      // Add other validation context fields
    );
    return {ModuleName}Validator.is{ModuleName}FormValid(context);
  }
}

@freezed
abstract class {ModuleName}State with _${ModuleName}State {
  const {ModuleName}State._();

  const factory {ModuleName}State({
    @Default({ModuleName}Status.initial()) {ModuleName}Status status,
    @Default({ModuleName}Input()) {ModuleName}Input input,
    {ModuleName}? data,
  }) = _{ModuleName}State;

  bool get isLoading => status is _LoadingStatus;
  bool get isSuccess => status is _SuccessStatus;
  bool get hasErrors => status is _ErrorStatus;
}

// Follows MCP-ddd-application-layer: Use extensions for state transitions
extension {ModuleName}StateX on {ModuleName}State {
  // State transition helpers
  {ModuleName}State get loading => copyWith(
        status: const {ModuleName}Status.loading(),
      );

  {ModuleName}State onSuccess({ModuleName} data) => copyWith(
        status: const {ModuleName}Status.success(),
        data: data,
      );

  {ModuleName}State onLoaded({ModuleName} data) => copyWith(
        status: const {ModuleName}Status.loaded(),
        data: data,
      );

  // Error handling
  {ModuleName}State onApiError(ApiError error) => onError(
        {ModuleName}Error.api(error),
      );

  {ModuleName}State onError({ModuleName}Error error) => copyWith(
        status: {ModuleName}Status.error(error),
      );

  {ModuleName}State onInput({ModuleName}Input input) => copyWith(
        status: {ModuleName}Status.input(input),
        input: input,
      );

  /// Returns field validation errors in the current state
  List<String> get validationErrors => input.getErrorCase();

  /// Checks if there's an error for a specific field
  bool hasErrorFor(String fieldKey) => validationErrors.contains(fieldKey);

  /// Transitions to error state for input validation errors
  {ModuleName}State onInputError(List<String> errorCases) => copyWith(
        status: {ModuleName}Status.error(
          {ModuleName}Error.input(errorCases),
        ),
      );

  /// Updates the state with validation errors
  {ModuleName}State onValidationErrors(List<String> errorCases) =>
      errorCases.isEmpty ? this : onInputError(errorCases);
}
```

## Cancel Token Management Pattern

### Resource Cleanup with ref.onDispose

**MANDATORY Pattern for All Notifiers Making API Calls**

Notifiers MUST implement concurrent cancel token support to prevent memory leaks and enable proper resource cleanup.

#### Key Requirements:

1. **Use Set Collection** for concurrent requests:
```dart
final Set<CancelToken> _cancelTokens = {};
```

2. **Implement ref.onDispose** for automatic cleanup:
```dart
@override
{ModuleName}State build() {
  ref.onDispose(() {
    logger.i('Disposing {ModuleName}Notifier');
    _cancelAllRequests();
  });
  return const {ModuleName}State();
}
```

3. **Implement _cancelAllRequests()** to iterate and cancel:
```dart
void _cancelAllRequests() {
  for (final token in _cancelTokens) {
    logger.d('[{ModuleName}Notifier] Cancelling request');
    token.cancel('Notifier was disposed');
  }
  _cancelTokens.clear();
}
```

4. **Implement _createCancelToken()** with logging:
```dart
CancelToken _createCancelToken() {
  final cancelToken = CancelToken();
  _cancelTokens.add(cancelToken);
  logger.d('[{ModuleName}Notifier] Created new cancel token (total: ${_cancelTokens.length})');
  return cancelToken;
}
```

5. **Use in all API calls**:
```dart
// In any method making API calls
final result = await _repository.operation(
  request: myRequest,
  token: _createCancelToken(),  // Pass new token from Set
);
```

#### Benefits:

| Feature | Benefit |
|---------|---------|
| **Concurrent Requests** | ✅ Multiple API calls simultaneously |
| **Memory Leak Prevention** | ✅ All tokens cleaned on disposal |
| **Debug Visibility** | ✅ Token count logging for monitoring |
| **Error Recovery** | ✅ Graceful cancellation on errors |
| **Resource Management** | ✅ Automatic cleanup via ref.onDispose |

#### Example Real Implementation:

See `/docs/project/CANCEL_TOKEN_MIGRATION_COMPLETION.md` for complete migration details and 26+ notifier examples.

---

## Infrastructure Layer

The Infrastructure Layer provides technical implementations of domain interfaces and handles external resources.

### 1. Repository Implementation Pattern

**Template**: `{module_name}_repository_impl.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/entities/{module_name}.dart';
import '../../domain/models/{module_name}_request.dart';
import '../../domain/repositories/{module_name}_repository.dart';
import '../dtos/{module_name}_dto.dart';

/// Implementation of the {ModuleName}Repository interface
///
/// Follows MCP-ddd-infrastructure-layer: Implement repository interfaces from domain layer
/// Follows MCP-ddd-infrastructure-layer: Use dependency injection for repository dependencies
@LazySingleton(
  as: {ModuleName}Repository,
  env: AppEnvironment.environments,
)
class {ModuleName}RepositoryImpl implements {ModuleName}Repository {
  final {DependencyName} _{dependency};

  /// Creates a new instance of {ModuleName}RepositoryImpl
  const {ModuleName}RepositoryImpl(this._{dependency});

  @override
  Future<ResultDart<{ModuleName}, ApiError>> {primaryOperation}(
    {ModuleName}Request request, {
    CancelToken? token,
  }) async {
    logger.i('[{ModuleName}Repository] {Operation description}: $request');

    try {
      // Implement the actual API call or business logic
      final result = await _{dependency}.{operationCall}(
        request.{field},
        token: token,
      );

      return result.map((data) {
        logger.i('[{ModuleName}Repository] {Operation} completed successfully');
        return {ModuleName}Dto(
          id: data.id,
          // Map other fields as needed
        );
      });
    } catch (e) {
      logger.e('[{ModuleName}Repository] Error in {operation}: $e');
      return Failure(ApiError.unknown(e.toString()));
    }
  }

  @override
  Future<{ModuleName}> getPreloadData() async {
    logger.i('[{ModuleName}Repository] Getting current {entity} information');
    
    try {
      // Implement preload data retrieval
      final data = await _{dependency}.{getCurrentDataCall}();
      
      return {ModuleName}Dto(
        id: data.id,
        // Map other fields as needed
      );
    } catch (e) {
      logger.e('[{ModuleName}Repository] Error getting preload data: $e');
      return const {ModuleName}Dto();
    }
  }
}
```

### 2. Repository Mock Implementation Pattern

**Template**: `{module_name}_repository_mock.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/entities/{module_name}.dart';
import '../../domain/models/{module_name}_request.dart';
import '../../domain/repositories/{module_name}_repository.dart';
import '../dtos/{module_name}_dto.dart';

/// Mock implementation of the {ModuleName}Repository interface for testing
///
/// Follows MCP-ddd-infrastructure-layer: Implement mock repositories for testing
@alpha
@LazySingleton(as: {ModuleName}Repository)
class {ModuleName}RepositoryMock implements {ModuleName}Repository {
  /// Mock data storage
  {Type} _current{Entity} = {defaultValue};

  {ModuleName}RepositoryMock();

  @override
  Future<ResultDart<{ModuleName}, ApiError>> {primaryOperation}(
    {ModuleName}Request request, {
    CancelToken? token,
  }) async {
    logger.i('[{ModuleName}RepositoryMock] {Operation description}: $request');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Update the mock data
    _current{Entity} = {updateLogic};

    logger.i('[{ModuleName}RepositoryMock] {Operation} completed successfully');
    
    // Return success with the updated data
    return Success(
      {ModuleName}Dto(
        id: 1,
        {field}: _current{Entity},
      ),
    );
  }

  @override
  Future<{ModuleName}> getPreloadData() async {
    logger.i('[{ModuleName}RepositoryMock] Getting current {entity} information');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return {ModuleName}Dto(
      id: 1,
      {field}: _current{Entity},
    );
  }
}
```

### 3. DTO Implementation Pattern

**Template**: `{module_name}_dto.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/{module_name}.dart';

part '{module_name}_dto.freezed.dart';
part '{module_name}_dto.g.dart';

/// DTO for {ModuleName} entity
///
/// Uses Freezed for immutability and JSON (de)serialization
/// Follows MCP-ddd-infrastructure-layer: Use Freezed for DTOs
@freezed
class {ModuleName}Dto with _${ModuleName}Dto implements {ModuleName} {
  const {ModuleName}Dto._();

  /// Creates a new {ModuleName}Dto
  const factory {ModuleName}Dto({
    @Default(-1) int id,
    @Default({defaultValue}) {Type} {field},
    // Add other fields as needed
  }) = _{ModuleName}Dto;

  /// Factory for JSON deserialization
  factory {ModuleName}Dto.fromJson(Map<String, dynamic> json) => _${ModuleName}DtoFromJson(json);
}
```

**Example**: Change Plates Number Module
```dart
/// DTO for ChangePlatesNumber entity
@freezed
class ChangePlatesNumberDto with _$ChangePlatesNumberDto implements ChangePlatesNumber {
  const ChangePlatesNumberDto._();

  /// Creates a new ChangePlatesNumberDto
  const factory ChangePlatesNumberDto({
    @Default(-1) int id,
    @Default(<String>[]) List<String> plates,
  }) = _ChangePlatesNumberDto;

  /// Factory for JSON deserialization
  factory ChangePlatesNumberDto.fromJson(Map<String, dynamic> json) => _$ChangePlatesNumberDtoFromJson(json);
}
```

## Presentation Layer

The Presentation Layer contains the UI components and form logic for each module.

### 1. Hooks for Form Management Pattern

**Template**: `{module_name}_hooks.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/{module_name}_notifier/{module_name}_notifier.dart';
import '../../domain/constants/{module_name}_validation_keys.dart';

/// Model class encapsulating all state and behavior for {ModuleName} form
///
/// This model is returned by the [use{ModuleName}Form] hook and contains everything
/// needed to render and interact with the {module} form UI.
class {ModuleName}FormModel {
  /// Creates a model containing all state for {module} form
  const {ModuleName}FormModel({
    required this.{field}Controller,
    required this.isFormValid,
    required this.isLoading,
    required this.onSubmit,
    required this.{field}Error,
    required this.on{Field}Changed,
    // Add other required fields
  });

  /// Controller for the {field} input field
  final TextEditingController {field}Controller;

  /// Whether the entire form is valid and submission should be allowed
  final bool isFormValid;

  /// Whether a submission is currently in progress
  final bool isLoading;

  /// Function to call when the form should be submitted
  final Future<void> Function() onSubmit;

  /// Error message for the {field} field, or null if no error
  final String? {field}Error;

  /// Callback to handle {field} changes
  final ValueChanged<String> on{Field}Changed;
  
  // Add other fields and methods as needed
}

/// Custom hook that manages {module} form state and validation
///
/// This hook centralizes all logic related to the {module} form, including:
/// - Form validation
/// - Error handling
/// - Form submission
/// - Controller management
///
/// @param ref Riverpod reference to access state providers
/// @return [{ModuleName}FormModel] containing all state and functions for the UI
{ModuleName}FormModel use{ModuleName}Form(WidgetRef ref) {
  // Watch state from providers to trigger rebuilds when they change
  final context = useContext();
  final state = ref.watch({moduleName}Provider);
  final notifier = ref.read({moduleName}Provider.notifier);

  // Create and manage text editing controllers
  final {field}Controller = useTextEditingController(text: state.input.{field});

  // Sync controllers with state when state changes externally
  useEffect(() {
    {field}Controller.text = state.input.{field};
    return null;
  }, [state.input.{field}]);

  // Return the model with all required properties
  return {ModuleName}FormModel(
    {field}Controller: {field}Controller,
    isFormValid: state.input.isValid(),
    isLoading: state.isLoading,
    onSubmit: notifier.{primaryOperation},
    on{Field}Changed: notifier.on{Field}Changed,
    {field}Error: ref.watch({moduleName}Provider.select((s) {
      return s.status.whenOrNull(
        error: (error) => error.getMessage(
          context,
          key: {ModuleName}ValidationKeys.{field},
        ),
      );
    })),
    // Add other properties as needed
  );
}
```

### 2. Page Implementation Pattern

**Template**: `{module_name}_page.dart`

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../hooks/{module_name}_hooks.dart';
import '../widgets/{module_name}_body.dart';

/// Page for {module description}
///
/// This page allows users to {module purpose}.
/// It uses hooks for state management and delegates rendering to [{ModuleName}Body].
@RoutePage()
class {ModuleName}Page extends HookConsumerWidget {
  /// Creates a page for {module description}
  const {ModuleName}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the form hook to manage state
    final formModel = use{ModuleName}Form(ref);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.{module_name}_title),
        centerTitle: true,
      ),
      body: {ModuleName}Body(
        formModel: formModel,
      ),
    );
  }
}
```

**Example**: Change Plates Number Module
```dart
/// Page for changing plates number
@RoutePage()
class ChangePlatesNumberPage extends HookConsumerWidget {
  /// Creates a page for managing vehicle plates
  const ChangePlatesNumberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the form hook to manage state
    final formModel = useChangePlatesNumberForm(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Plates'),
        centerTitle: true,
      ),
      body: ChangePlatesNumberBody(
        formModel: formModel,
      ),
    );
  }
}
```

### 3. Body Widget Implementation Pattern

**Template**: `{module_name}_body.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/app_button.dart';
import '../hooks/{module_name}_hooks.dart';
import '../../../../../common/widgets/list_title.dart';

/// Body widget for the {module} page
class {ModuleName}Body extends StatelessWidget {
  final {ModuleName}FormModel formModel;
  const {ModuleName}Body({Key? key, required this.formModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _{Field}Input(formModel: formModel),
          _{Action}Button(formModel: formModel),
          // Add other UI components as needed
        ],
      ),
    );
  }
}

/// Internal widget for {field} input field
class _{Field}Input extends StatelessWidget {
  final {ModuleName}FormModel formModel;
  const _{Field}Input({Key? key, required this.formModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTitle(
      label: context.s.{module_name}_{field},
      controller: formModel.{field}Controller,
      errorText: formModel.{field}Error,
      onChanged: formModel.on{Field}Changed,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
    );
  }
}

/// Internal widget for the {action} button
class _{Action}Button extends StatelessWidget {
  final {ModuleName}FormModel formModel;
  const _{Action}Button({Key? key, required this.formModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: AppButton(
        text: context.s.{module_name}_{action},
        onPressed: formModel.isFormValid && !formModel.isLoading 
            ? formModel.onSubmit 
            : null,
        isLoading: formModel.isLoading,
      ),
    );
  }
}
```

## Module File Structure

Every module in this project MUST follow this exact file structure. This structure ensures consistency across the application and makes it easier for developers to locate and understand the codebase.

### Standard Module Structure

```
lib/src/modules/{module_name}/
├── domain/                                    # Core business rules and entities
│   ├── constants/                             # Domain-specific constants
│   │   └── {module_name}_validation_keys.dart # Validation key constants
│   ├── entities/                              # Core domain entities
│   │   └── {module_name}.dart                 # Main entity interface
│   ├── errors/                                # Domain-specific error types
│   │   ├── {module_name}_error.dart           # Error hierarchy definition
│   │   ├── {module_name}_error.freezed.dart   # Generated code
│   │   └── {module_name}_error.g.dart         # Generated code
│   ├── models/                                # Value objects and models
│   │   ├── {module_name}_request.dart         # Request model
│   │   └── {module_name}_request.freezed.dart # Generated code
│   ├── repositories/                          # Repository interfaces
│   │   └── {module_name}_repository.dart      # Repository contract
│   └── validators/                            # Domain validation logic
│       └── {module_name}_validator.dart       # Validation rules
│
├── application/                               # Use cases and state management
│   └── {module_name}_notifier/                # State management
│       ├── {module_name}_notifier.dart        # Notifier and state
│       └── {module_name}_notifier.freezed.dart # Generated code
│
├── infrastructure/                            # Implementation details
│   ├── dtos/                                  # Data Transfer Objects
│   │   ├── {module_name}_dto.dart             # DTO implementation
│   │   ├── {module_name}_dto.freezed.dart     # Generated code
│   │   └── {module_name}_dto.g.dart           # Generated code
│   └── repositories/                          # Repository implementations
│       ├── {module_name}_repository_impl.dart # Real implementation
│       └── {module_name}_repository_mock.dart # Mock for testing
│
└── presentation/                              # User interface components
    ├── hooks/                                 # Custom hooks for state/UI logic
    │   └── {module_name}_hooks.dart           # Form state hooks
    ├── pages/                                 # Screens/pages
    │   └── {module_name}_page.dart            # Main page
    └── widgets/                               # UI components
        └── {module_name}_body.dart            # Main body widget
```

### File Placement Guidelines

1. **Domain Layer Files**
   - Place all core business logic in the `domain` folder
   - Entities go in `domain/entities/`
   - Error types go in `domain/errors/`
   - Models/Value objects go in `domain/models/`
   - Repository interfaces go in `domain/repositories/`
   - Validation logic goes in `domain/validators/`
   - Constants go in `domain/constants/`

2. **Application Layer Files**
   - Place all state management in `application/change_plates_number_notifier/`
   - Keep notifier and state classes in the same file
   - Generated files should be adjacent to their source files

3. **Infrastructure Layer Files**
   - Place all DTOs in `infrastructure/dtos/`
   - Repository implementations go in `infrastructure/repositories/`
   - Always implement both real and mock repository classes

4. **Presentation Layer Files**
   - UI components go in `presentation/widgets/`
   - Pages/screens go in `presentation/pages/`
   - Custom hooks go in `presentation/hooks/`

### Naming Conventions

- All files should follow `snake_case` naming convention
- All files should be prefixed with the module name (`change_plates_number_`)
- Generated files should use standard suffixes (`.freezed.dart` for Freezed classes, `.g.dart` for DTOs with JSON serialization only)
- Class names should follow `PascalCase` and match the module name:
  - `ChangePlatesNumberRepository`
  - `ChangePlatesNumberError`
  - `ChangePlatesNumberPage`
  - etc.

### Localization Keys

- All user-facing strings must be defined in the ARB files: `assets/l10n/intl_en.arb`, `assets/l10n/intl_zh_Hant.arb`, and `assets/l10n/intl_zh_Hans.arb`.
- Follow the naming convention: `<module>_<element>_<description>`, e.g., `change_plates_number_plate_invalid`, `change_plates_number_max_plates_reached`.
- If a localization key is missing, add it to all ARB files with the corresponding translations:
  ```json
  {
    "change_plates_number_plate_invalid": "Please enter a valid plate number",
    "change_plates_number_max_plates_reached": "Maximum 6 plates allowed"
  }
  ```
- After updating ARB files, re-run code generation:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

### Generated Files

- Always run `flutter pub run build_runner build --delete-conflicting-outputs` after modifying:
  - Freezed models 
  - Notifier classes
  - DTOs with JsonSerializable

## Implementation Templates

### Quick Start Template for New Modules

When creating a new module, follow these steps:

1. **Create Module Directory Structure**
   ```bash
   mkdir -p lib/src/modules/{module_name}/{domain,application,infrastructure,presentation}
   mkdir -p lib/src/modules/{module_name}/domain/{constants,entities,errors,models,repositories,validators}
   mkdir -p lib/src/modules/{module_name}/application/{module_name}_notifier
   mkdir -p lib/src/modules/{module_name}/infrastructure/{dtos,repositories}
   mkdir -p lib/src/modules/{module_name}/presentation/{hooks,pages,widgets}
   ```

2. **Create Files in Order (Domain → Application → Infrastructure → Presentation)**

### Domain Layer Checklist
- [ ] `{module_name}_validation_keys.dart` - Validation constants
- [ ] `{module_name}.dart` - Entity interface
- [ ] `{module_name}_error.dart` - Error hierarchy
- [ ] `{module_name}_request.dart` - Request model
- [ ] `{module_name}_repository.dart` - Repository interface
- [ ] `{module_name}_validator.dart` - Validation logic

### Application Layer Checklist
- [ ] `{module_name}_notifier.dart` - State management with Riverpod v3
- [ ] Use `NotifierProvider.autoDispose` for provider declaration (not `@ProviderFor`)
- [ ] Use `Notifier<State>` as base class (not `AutoDisposeNotifier`)
- [ ] Import `flutter_riverpod` (not `riverpod_annotation`)
- [ ] No `.g.dart` file for notifier (only `.freezed.dart` for state)
- [ ] State classes use proper Freezed patterns (sealed vs abstract)
- [ ] Use `sealed class` for union types with multiple factories (Status, Error)
- [ ] Use `abstract class` for single-factory data classes (State, Input)
- [ ] Ensure **NO** `fromJson` in state/input classes
- [ ] Include proper dependency injection with `@injectable`
- [ ] Implement validation logic and error handling

### Infrastructure Layer Checklist
- [ ] `{module_name}_dto.dart` - Data Transfer Object with JSON serialization
- [ ] `{module_name}_repository_impl.dart` - Real repository implementation
- [ ] `{module_name}_repository_mock.dart` - Mock repository implementation
- [ ] Ensure **YES** `fromJson` in DTO classes for API communication
- [ ] Include `.freezed.dart` generation for Freezed classes
- [ ] Include `.g.dart` generation for DTOs with JSON serialization only
- [ ] Use proper dependency injection annotations

### Presentation Layer Checklist
- [ ] `{module_name}_hooks.dart` - Form hooks
- [ ] `{module_name}_page.dart` - Page widget
- [ ] `{module_name}_body.dart` - Body widget

### Example Module Implementation

**Example Module**: `change_plates_number`
- **Purpose**: Allow users to manage their vehicle plates
- **Primary Operations**: Add plate, remove plate, update plates list
- **Domain Entity**: `ChangePlatesNumber` with `id` and `plates` properties
- **Main Validation**: Plate must not be empty, maximum 6 plates allowed
- **Repository Dependencies**: Uses `AuthRepository` for profile updates

**Key Files Created**:
1. `ChangePlatesNumberValidationKeys` - Contains `plate` and `maxPlatesCount` validation keys
2. `ChangePlatesNumber` - Entity interface with `id` and `plates` properties
3. `ChangePlatesNumberError` - Error hierarchy with API, DB, unknown, and input error types
4. `ChangePlatesNumberRequest` - Request model with `plates` field
5. `ChangePlatesNumberRepository` - Repository interface with `update` and `getPreloadData` methods
6. `ChangePlatesNumberValidator` - Validation logic for plate and max plates count
7. `ChangePlatesNumberNotifier` - State management with `addPlate` and `removePlate` operations
8. `ChangePlatesNumberDto` - DTO implementing the entity interface
9. `ChangePlatesNumberRepositoryImpl` - Real implementation using AuthRepository
10. `ChangePlatesNumberRepositoryMock` - Mock implementation for testing
11. `useChangePlatesNumberForm` - Form hook managing state and validation
12. `ChangePlatesNumberPage` - Page widget with app bar and body
13. `ChangePlatesNumberBody` - Body widget with input field and buttons

## Code Generation Guidelines

### Freezed and Build Runner

After creating or modifying any files with `@freezed` or `@injectable` annotations:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Required Dependencies

Make sure these dependencies are in your `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  injectable: ^2.3.2
  flutter_riverpod: ^2.4.9
  auto_route: ^7.8.4
  flutter_hooks: ^0.20.5
  hooks_riverpod: ^2.4.9
  result_dart: ^1.1.0
  dio: ^5.4.0

dev_dependencies:
  freezed: ^2.4.7
  build_runner: ^2.4.7
  injectable_generator: ^2.4.1
  auto_route_generator: ^7.3.2
```

### File Generation Rules

1. **Freezed Files** (`.freezed.dart`):
   - Generated for classes with `@freezed` annotation
   - Contains immutable class implementations
   - Required for: Error classes, Request models, DTOs, State classes

2. **JSON Serialization Files** (`.g.dart`):
   - Generated for classes with `@JsonSerializable` or Freezed with `fromJson`/`toJson`
   - Contains JSON serialization/deserialization code
   - Required for: DTOs only (not for Request models or Notifier classes)

3. **Injectable Files** (automatically handled by `get_it`):
   - Generated for classes with `@injectable` or `@LazySingleton`
   - Contains dependency injection registration
   - Required for: Repository implementations, Notifiers

### Naming Convention Summary

| Component | File Name | Class Name | Example |
|-----------|-----------|------------|---------|
| Entity | `{module_name}.dart` | `{ModuleName}` | `change_plates_number.dart` → `ChangePlatesNumber` |
| Error | `{module_name}_error.dart` | `{ModuleName}Error` | `change_plates_number_error.dart` → `ChangePlatesNumberError` |
| Request | `{module_name}_request.dart` | `{ModuleName}Request` | `change_plates_number_request.dart` → `ChangePlatesNumberRequest` |
| Repository | `{module_name}_repository.dart` | `{ModuleName}Repository` | `change_plates_number_repository.dart` → `ChangePlatesNumberRepository` |
| Validator | `{module_name}_validator.dart` | `{ModuleName}Validator` | `change_plates_number_validator.dart` → `ChangePlatesNumberValidator` |
| Notifier | `{module_name}_notifier.dart` | `{ModuleName}Notifier` | `change_plates_number_notifier.dart` → `ChangePlatesNumberNotifier` |
| DTO | `{module_name}_dto.dart` | `{ModuleName}Dto` | `change_plates_number_dto.dart` → `ChangePlatesNumberDto` |
| Page | `{module_name}_page.dart` | `{ModuleName}Page` | `change_plates_number_page.dart` → `ChangePlatesNumberPage` |
| Hooks | `{module_name}_hooks.dart` | `use{ModuleName}Form` | `change_plates_number_hooks.dart` → `useChangePlatesNumberForm` |

### Localization Requirements

All user-facing strings must be defined in ARB files:
- `assets/l10n/intl_en.arb` (English)
- `assets/l10n/intl_zh_Hans.arb` (Simplified Chinese)
- `assets/l10n/intl_zh_Hant.arb` (Traditional Chinese)

**Naming Convention**: `{module_name}_{element}_{description}`

Example for Change Plates Number:
```json
{
  "change_plates_number_title": "Vehicle Plates",
  "change_plates_number_plate": "Plate Number",
  "change_plates_number_add": "Add Plate",
  "change_plates_number_plate_invalid": "Please enter a valid plate number",
  "change_plates_number_max_plates_reached": "Maximum 6 plates allowed"
}
```

After updating ARB files, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Localization Usage Rules

**MCP-localization-usage**: Follow these strict rules for using localization keywords:

1. **Widget Classes (with BuildContext available)**
   - **Rule**: Use `context.s.keyword_name`
   - **Usage**: In any class that extends Widget or has access to BuildContext
   ```dart
   class MyPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text(context.s.change_plates_number_title)),
         body: Text(context.s.change_plates_number_description),
       );
     }
   }
   ```

2. **Non-Widget Classes (no BuildContext and cannot pass as parameter)**
   - **Rule**: Use `S.current.keyword_name`
   - **Usage**: In domain entities, error classes, validators, or any static context
   ```dart
   // Domain Error Classes
   sealed class ChangePlatesNumberError extends ApplicationError {
     const ChangePlatesNumberError();
     
     const factory ChangePlatesNumberError.plateInvalid() = _PlateInvalid;
     const factory ChangePlatesNumberError.maxPlatesReached() = _MaxPlatesReached;
     
     @override
     String get message => switch (this) {
       _PlateInvalid() => S.current.change_plates_number_plate_invalid,
       _MaxPlatesReached() => S.current.change_plates_number_max_plates_reached,
     };
   }
   ```

3. **Functions/Extensions (can accept BuildContext as parameter)**
   - **Rule**: Add `BuildContext context` parameter and use `context.s.keyword_name`
   - **Usage**: In application layer functions, extensions, utilities that can receive context
   ```dart
   // Application Layer - State Extension
   extension ChangePlatesNumberStateX on ChangePlatesNumberState {
     String getErrorMessage(BuildContext context) {
       return switch (error) {
         ChangePlatesNumberError.plateInvalid() => context.s.change_plates_number_plate_invalid,
         ChangePlatesNumberError.maxPlatesReached() => context.s.change_plates_number_max_plates_reached,
         null => '',
       };
     }
     
     String getStatusMessage(BuildContext context) {
       return switch (status) {
         ChangePlatesNumberStatus.loading => context.s.change_plates_number_loading,
         ChangePlatesNumberStatus.success => context.s.change_plates_number_success,
         ChangePlatesNumberStatus.idle => '',
       };
     }
   }
   ```

**Important Notes:**
- **Never mix** `S.current` and `context.s` usage within the same class
- **Always prefer** `context.s` when BuildContext is available or can be passed as parameter
- **Only use** `S.current` when absolutely no BuildContext access is possible
- **Domain error classes** should use `S.current` as they are context-independent
- **Presentation layer** should always use `context.s`

#### Complete Localization Examples by Layer

**Domain Layer Example** (Use `S.current`):
```dart
// domain/errors/change_plates_number_error.dart
sealed class ChangePlatesNumberError extends ApplicationError {
  const ChangePlatesNumberError();
  
  const factory ChangePlatesNumberError.plateInvalid() = _PlateInvalid;
  const factory ChangePlatesNumberError.maxPlatesReached() = _MaxPlatesReached;
  
  @override
  String get message => S.current.change_plates_number_plate_invalid;
}

// domain/validators/change_plates_number_validator.dart
class ChangePlatesNumberValidator {
  static ChangePlatesNumberError? validatePlateCount(List<String> plates) {
    if (plates.length > 6) {
      return const ChangePlatesNumberError.maxPlatesReached();
    }
    return null;
  }
}
```

**Application Layer Example** (Use `context.s` with BuildContext parameter):
```dart
// application/change_plates_number_notifier.dart
extension ChangePlatesNumberStateX on ChangePlatesNumberState {
  String getErrorMessage(BuildContext context) => switch (error) {
    ChangePlatesNumberError.plateInvalid() => context.s.change_plates_number_plate_invalid,
    ChangePlatesNumberError.maxPlatesReached() => context.s.change_plates_number_max_plates_reached,
    null => '',
  };
  
  String getStatusMessage(BuildContext context) => switch (status) {
    ChangePlatesNumberStatus.loading => context.s.change_plates_number_loading,
    ChangePlatesNumberStatus.success => context.s.change_plates_number_success,
    ChangePlatesNumberStatus.idle => '',
  };
}
```

**Presentation Layer Example** (Use `context.s` directly):
```dart
// presentation/pages/change_plates_number_page.dart
class ChangePlatesNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.change_plates_number_title),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(changePlatesNumberNotifierProvider);
          
          return Column(
            children: [
              if (state.error != null)
                Text(
                  state.getErrorMessage(context),
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                decoration: InputDecoration(
                  labelText: context.s.change_plates_number_plate,
                  hintText: context.s.change_plates_number_plate_hint,
                ),
              ),
              ElevatedButton(
                onPressed: () => _handleSubmit(context, ref),
                child: Text(context.s.change_plates_number_add),
              ),
            ],
          );
        },
      ),
    );
  }
}

// presentation/hooks/change_plates_number_hooks.dart
ChangePlatesNumberFormData useChangePlatesNumberForm() {
  return useMemoized(() => ChangePlatesNumberFormData(), []);
}

class ChangePlatesNumberFormData {
  String? validatePlate(String? value, BuildContext context) {
    if (value?.isEmpty ?? true) {
      return context.s.change_plates_number_plate_required;
    }
    if (!isValidPlateFormat(value!)) {
      return context.s.change_plates_number_plate_invalid;
    }
    return null;
  }
}
```

### Best Practices and Common Patterns

#### 1. Error Message Handling Pattern

```dart
// In domain layer errors - use S.current
sealed class ModuleError {
  String get message => switch (this) {
    ValidationError() => S.current.module_validation_error,
    NetworkError() => S.current.module_network_error,
  };
}

// In application layer extensions - accept BuildContext
extension ModuleStateX on ModuleState {
  String getErrorMessage(BuildContext context) => switch (error) {
    ValidationError() => context.s.module_validation_error,
    NetworkError() => context.s.module_network_error,
    null => '',
  };
}

// In presentation layer - use context.s directly
class ModulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.s.module_title);
  }
}
```

#### 2. Form Validation Pattern

```dart
// Domain validator using S.current for messages
class ModuleValidator {
  static String? validateField(String value) {
    if (value.isEmpty) {
      return S.current.module_field_required;
    }
    return null;
  }
}

// Application layer hook using context.s
ModuleFormModel useModuleForm(WidgetRef ref) {
  final context = useContext();
  final state = ref.watch(moduleProvider);
  
  return ModuleFormModel(
    fieldError: state.getFieldError(context, 'fieldKey'),
    // Other properties...
  );
}
```

#### 3. Internationalization Workflow

1. **Design Phase**: Plan all text content that needs localization
2. **Key Definition**: Create consistent key naming convention
3. **ARB Creation**: Add keys to all language ARB files simultaneously
4. **Code Generation**: Run build_runner to generate typed accessors
5. **Implementation**: Use appropriate access pattern based on layer
6. **Testing**: Verify all languages display correctly

#### Common Pitfalls to Avoid

❌ **Don't mix S.current and context.s in the same class**
```dart
class BadExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ Inconsistent usage
    final title = S.current.title;  
    final subtitle = context.s.subtitle;
    // ...
  }
}
```

✅ **Use consistent pattern within each layer**
```dart
class GoodExample extends StatelessWidget {
  @override  
  Widget build(BuildContext context) {
    // ✅ Consistent usage
    final title = context.s.title;
    final subtitle = context.s.subtitle;
    // ...
  }
}
```

❌ **Don't use context.s in domain layer**
```dart
// ❌ Wrong - domain layer cannot access BuildContext
class DomainError extends ApplicationError {
  @override
  String get message => context.s.error_message; // ❌ No context available
}
```

✅ **Use S.current in domain layer**
```dart
// ✅ Correct - use S.current in domain layer
class DomainError extends ApplicationError {
  @override
  String get message => S.current.error_message; // ✅ Correct
}
```

#### Testing Localized Content

```dart
// Test helper for localization
testWidgets('should display localized content', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('en'),
      home: MyWidget(),
    ),
  );
  
  expect(find.text('Expected English Text'), findsOneWidget);
});
```

This comprehensive localization guide ensures type-safe, maintainable multilingual support while respecting DDD architectural boundaries. All localized strings are centrally managed in ARB files, and each layer follows its specific access pattern for clean separation of concerns.

### Freezed Patterns for DDD Layers

**IMPORTANT: Correct Freezed Patterns for DDD Layers**

The project uses specific Freezed patterns based on data structure and layer responsibility:

#### ✅ **USE `sealed class`** for Union Types (Multiple Factories):

```dart
// ✅ CORRECT - Error types with multiple factory constructors
@freezed
sealed class {ModuleName}Error with _${ModuleName}Error {
  const factory {ModuleName}Error.api(ApiError error) = {ModuleName}ApiError;
  const factory {ModuleName}Error.validation(String message) = {ModuleName}ValidationError;
  const factory {ModuleName}Error.unknown(String message) = {ModuleName}UnknownError;
}

// ✅ CORRECT - Status enums with multiple factory constructors
@freezed
sealed class {ModuleName}Status with _${ModuleName}Status {
  const factory {ModuleName}Status.initial() = {ModuleName}Initial;
  const factory {ModuleName}Status.loading() = {ModuleName}Loading;
  const factory {ModuleName}Status.loaded() = {ModuleName}Loaded;
  const factory {ModuleName}Status.error() = {ModuleName}Error;
}
```

#### ✅ **USE `abstract class`** for Single Factory Data Classes:

```dart
// ✅ CORRECT - State data classes (single factory constructor)  
@freezed
abstract class {ModuleName}State with _${ModuleName}State {
  const factory {ModuleName}State({
    @Default({ModuleName}Status.initial()) {ModuleName}Status status,
    @Default({ModuleName}Input()) {ModuleName}Input input,
    {ModuleName}? data,
  }) = _{ModuleName}State;
}

// ✅ CORRECT - Input data classes (single factory constructor)
@freezed
abstract class {ModuleName}Input with _${ModuleName}Input {
  const factory {ModuleName}Input({
    @Default('') String field,
    // ...
  }) = _{ModuleName}Input;
}

// ✅ CORRECT - Request models (single factory constructor)
@freezed
abstract class {ModuleName}Request with _${ModuleName}Request {
  const factory {ModuleName}Request({
    required String field,
    // ...
  }) = _{ModuleName}Request;
}
```

#### ✅ **Required Import:**

```dart
import 'package:freezed_annotation/freezed_annotation.dart'; // For @freezed
```

### JSON Serialization Layer Rules

**IMPORTANT: JSON Rules by DDD Layer**

#### ❌ **Application Layer - NO `fromJson`:**

```dart
// ❌ Application layer state/input classes should NOT have fromJson
@freezed
abstract class {ModuleName}State with _${ModuleName}State {
  const factory {ModuleName}State({...}) = _{ModuleName}State;
  // ❌ DO NOT ADD: factory {ModuleName}State.fromJson(...)
}

@freezed
abstract class {ModuleName}Input with _${ModuleName}Input {
  const factory {ModuleName}Input({...}) = _{ModuleName}Input;
  // ❌ DO NOT ADD: factory {ModuleName}Input.fromJson(...)
}
```

#### ✅ **Infrastructure Layer - YES `fromJson`:**

```dart
// ✅ Infrastructure DTOs MUST have fromJson for API communication
@freezed
class {ModuleName}Dto with _${ModuleName}Dto implements {ModuleName} {
  const factory {ModuleName}Dto({...}) = _{ModuleName}Dto;
  
  // ✅ REQUIRED: DTOs need fromJson for API serialization
  factory {ModuleName}Dto.fromJson(Map<String, dynamic> json) => _${ModuleName}DtoFromJson(json);
}
```

#### **Layer-Specific JSON Rules Table:**

| Layer | Class Type | `fromJson` Required | Reason |
|:------|:-----------|:-------------------|:-------|
| **Application** | State classes | ❌ **NO** | Internal UI state, never serialized |
| **Application** | Input classes | ❌ **NO** | Form input state, never serialized |
| **Application** | Status classes | ❌ **NO** | UI status enums, never serialized |
| **Domain** | Entity interfaces | ❌ **NO** | Business contracts, not tied to JSON |
| **Domain** | Request classes | ❌ **NO** | Internal request objects, converted to DTOs |
| **Infrastructure** | DTO classes | ✅ **YES** | API communication, JSON serialization required |

---