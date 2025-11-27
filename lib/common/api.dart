class Api {
  bool sandBox = false;
  String apiNode = 'https://app-node.facturalo.com.ec:3005';
  String apiPHP = 'https://app-php.facturalo.com.ec';
  String apiSistema =
      'https://facturalo.com.ec/sistema';

  Api() {
    valid();
  }

  void valid() {
    if (sandBox) {
      apiNode = 'http://192.168.1.14:3000';
      apiPHP = 'http://192.168.1.14:4436';
      apiSistema = 'https://staging-facturacion.contamatic.ec/factumatic';
    }
  }
}
