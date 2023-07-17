String getErrorMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Erro de solicitação. Verifique os parâmetros enviados.';
    case 401:
      return 'Não autorizado. Verifique suas credenciais de autenticação.';
    case 403:
      return 'Acesso negado. Você não tem permissão para acessar este recurso.';
    case 404:
      return 'Recurso não encontrado. Verifique o URL da solicitação.';
    case 500:
      return 'Erro interno do servidor. Tente novamente mais tarde.';
    default:
      return 'Ocorreu um erro durante a solicitação.';
  }
}