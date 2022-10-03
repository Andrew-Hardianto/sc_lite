const bool isProduction = bool.fromEnvironment('dart.vm.product');

const configDev = {
  'keycloakLoginUrl':
      'https://keycloak-dev.gitsolutions.id/auth/realms/GIT/protocol/openid-connect/token',
  'googleMapsAPIKey': 'AIzaSyBylcbhGHIgdSw-WCgExoB2wQp-fFy4Oco',
  'resetPasswordApi': 'https://api-master-dev.gitsolutions.id'
};

const confidProd = {
  'keycloakLoginUrl':
      'https://keycloak.starconnect.id/auth/realms/GIT/protocol/openid-connect/token',
  'googleMapsAPIKey': 'AIzaSyAQlSiJZaDaYKQEUfSbtVay6fG21hmtX8I',
  'resetPasswordApi': 'https://apimaster.starconnect.id'
};

const environment = isProduction ? confidProd : configDev;
