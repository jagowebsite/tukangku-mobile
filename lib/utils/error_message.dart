class ErrorMessage {
  static String statusCode(int? code) {
    String? message;
    if (code != null) {
      switch (code) {
        case 200:
          message = 'Berhasil ditambahkan';
          break;
        case 201:
          message = 'Berhasil diupdate';
          break;
        case 401:
          message = 'Silahkan login';
          break;
        default:
      }
    }

    return message ?? '';
  }
}
