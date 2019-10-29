import "dart:ffi";
import "package:ffi/ffi.dart";

import "bindings.dart";
import "constants.dart";
import "../common.dart";

checkObx(errorCode) {
  if (errorCode != OBXError.OBX_SUCCESS) throw ObjectBoxException(lastObxErrorString(errorCode));
}

Pointer<T> checkObxPtr<T extends NativeType>(Pointer<T> ptr, String msg) {
  if (ptr == null || ptr.address == 0) {
    final info = lastObxErrorString();
    throw ObjectBoxException(info.isEmpty ? msg : "$msg: $info");
  }
  return ptr;
}


String lastObxErrorString([int err = 0]) {
  int code = bindings.obx_last_error_code();
  String text = Utf8.fromUtf8(bindings.obx_last_error_message().cast<Utf8>());

  if (code == 0 && text.isEmpty) {
    return (err != 0) ? "code $err" : "unknown native error";
  }

  return code == 0 ? text : "$code $text";
}
