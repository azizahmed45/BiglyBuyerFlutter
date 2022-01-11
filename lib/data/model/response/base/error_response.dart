/// errors : [{"code":"l_name","message":"The last name field is required."},{"code":"password","message":"The password field is required."}]

class ErrorResponse {
  List<Errors> _errors;

  List<Errors> get errors => _errors;

  ErrorResponse({List<Errors> errors}) {
    _errors = errors;
  }

  ErrorResponse.fromJson(dynamic json) {
    if (json["errors"] != null) {
      _errors = [];
      json["errors"].forEach((v) {
        _errors.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_errors != null) {
      map["errors"] = _errors.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// code : "l_name"
/// message : "The last name field is required."

class Errors {
  String _code;
  String _message;

  String get code => _code;

  String get message => _message;

  Errors({String code, String message}) {
    _code = code;
    _message = message;
  }

  Errors.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    return map;
  }
}

class FormError {
  final Map<String, List> _errors;

  FormError(Map<String, dynamic> response) :
        _errors = Map<String, List>.from(response['errors'] ?? response['error'] ?? {});

  /// contains the failed input keys in the exception object
  List<String> get keys => _errors.keys.toList();

  String get firstErrorKey => keys.first;

  String get firstErrorMessage => errorsByKey(firstErrorKey)?.first;

  List<String> get firstErrorMessages => errorsByKey(firstErrorKey);

  List<String> errorsByKey(String key) => _errors[key]?.cast<String>();

  @override
  String toString() {
    /// String buffer that will contains the error messages in string
    final buffer = StringBuffer();

    /// to extract failure message and build String object
    /// that will contain the full failure message
    ///
    for (int felidIndex = 0; felidIndex < keys.length; felidIndex++) {
      final currentFelid = keys[felidIndex];
      final errorBuffer = StringBuffer();
      errorBuffer.write(currentFelid);

      /// extract currentFelid messages
      for (int i = 0; i < _errors[currentFelid].length; i++) {
        final currentMessage = _errors[currentFelid];

        /// whether  is last msg in this key or not
        final isLastMsg = i == _errors.keys.length;

        /// append the message
        errorBuffer
            .write('$currentFelid $currentMessage${isLastMsg ? '\n' : ''}');
      }

      /// append the message
      buffer.write('$errorBuffer\n');
    }

    /// covert the buffer to string
    return buffer.toString();
  }
}
