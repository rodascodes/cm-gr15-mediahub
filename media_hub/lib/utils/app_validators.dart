/**
 * Classe com validadores para formulários da aplicação.
 * Valida email, senha, username e confirmação de senha.
 */
class AppValidators {
  /**
   * Valida um endereço de email.
   * 
   * @param value O email a validar
   * @return Uma mensagem de erro ou null se válido
   */
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please insert your email';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please insert a valid email address';
    }
    return null;
  }

  /**
   * Valida uma senha com critérios de segurança.
   * Requer: mínimo 8 caracteres, letra maiúscula, minúscula, número e símbolo.
   * 
   * @param value A senha a validar
   * @return Uma mensagem de erro ou null se válida
   */
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain at least 1 uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain at least 1 lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain at least 1 number';
    }
    if (!value.contains(RegExp(r'[^a-zA-Z0-9]'))) {
      return 'Must contain at least 1 symbol (e.g., @, !, #)';
    }
    return null; 
  }

  /**
   * Valida a confirmação de senha.
   * Verifica que a confirmação é igual à senha original.
   * 
   * @param value A confirmação de senha
   * @param originalPassword A senha original
   * @return Uma mensagem de erro ou null se coincidirem
   */
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match!';
    }
    return null;
  }

  /**
   * Valida um nome de utilizador.
   * Requer: mínimo 3 caracteres.
   * 
   * @param value O username a validar
   * @return Uma mensagem de erro ou null se válido
   */
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please insert your username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  /**
   * Valida que uma senha não está vazia (validação simples para login).
   * 
   * @param value A senha a validar
   * @return Uma mensagem de erro ou null se válida
   */
  static String? validateNonEmptyPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}