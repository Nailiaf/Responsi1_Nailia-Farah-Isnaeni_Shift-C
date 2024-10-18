class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';
  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listKesehatanMental =
      baseUrl + 'api/kesehatan/kesehatan_mental';
  static const String createKesehatanMental =
      baseUrl + 'api/kesehatan/kesehatan_mental';
  static String updateKesehatanMental(int id) {
    return baseUrl +
        'api/kesehatan/kesehatan_mental/' +
        id.toString() +
        '/update';
  }

  static String showKesehatanMental(int id) {
    return baseUrl + 'api/kesehatan/kesehatan_mental' + id.toString();
  }

  static String deleteKesehatanMental(int id) {
    return baseUrl +
        'api/kesehatan/kesehatan_mental/' +
        id.toString() +
        '/delete';
  }
}
