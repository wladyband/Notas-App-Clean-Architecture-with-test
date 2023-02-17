enum SignFailure { notFound, unauthorized, unknown, network }

enum Headers {
  APPLICATION_JSON('application/json'),
  CONTENT_TYPE('content-type'),
  ACCEPT('accept'),
  AUTHORIZATION('authorization'),
  TOKEN('newRequestToken');

  final String value;
  const Headers(this.value);
}
