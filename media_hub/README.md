# Media Hub

## Visão geral

Media Hub é um aplicativo Flutter para descoberta de mídia com autenticação, navegação por abas e integração com Firebase e TMDB.

O app oferece:
- Autenticação com email e password via Firebase Auth.
- Perfis de usuário e estatísticas em Cloud Firestore.
- Busca e listagem de filmes e séries usando a API do TMDB.
- Tela de detalhes de mídia com avaliações e comentários.
- Fórum de discussões com conteúdo de mídia mais comentado.
- Tema claro/escuro alternável em todas as telas.
- Navegação inferior entre Home, Search, Forum e Profile.

## Funcionalidades

### Autenticação
- Registro de novo usuário com nome de usuário, nome, email e senha.
- Login com email e senha.
- Logout direto pela aba de perfil.

### Tela Home
- Exibe conteúdos "Trending" combinando filmes e séries.
- Cartões de mídia que levam à página de detalhes.
- Toggle de tema claro/escuro.

### Tela Search
- Busca por filmes e séries usando TMDB.
- Filtragem por categoria: All, Movies, Series.
- Exibe resultados em grid responsivo.

### Tela Forum
- Exibe lista de tópicos recentes de comunidade com dados mock.
- Mostra mídia mais discutida via TMDB.
- Navegação para página de detalhes a partir de cards.

### Tela Profile
- Carrega dados do usuário de Firestore.
- Exibe estatísticas de avaliações e categorias de mídia.
- Mostra favoritos e informações da conta.
- Logout do usuário.

### Página de detalhes de mídia
- Visualiza título, sinopse, imagem e nota média.
- Permite adicionar comentários locais.
- Salva avaliações do usuário em Firestore.
- Dispara notificações locais ao salvar nota ou comentário.

## Tecnologias

- Flutter
- Dart
- Firebase Auth
- Cloud Firestore
- Firebase Core
- Flutter Local Notifications
- go_router
- HTTP
- TMDB API

## Instalação

1. Instale o Flutter e configure o SDK: https://flutter.dev/docs/get-started/install
   
2. Instale as dependências:
   ```bash
   flutter pub get
   ```

## Execução

1. Conecte um dispositivo físico ou inicie um emulador/simulador.
2. Execute o app:
   ```bash
   flutter run
   ```

> Se quiser executar em uma plataforma específica, use `flutter run -d <device-id>`.

## Configuração adicional

- O projeto já contém configuração Firebase local em `lib/firebase_options.dart` e `android/app/google-services.json`.
- A API TMDB é usada em `lib/util/tmdb_service.dart` com chave embutida.
- O app requer conexão com a internet para carregar dados do TMDB.

## Observações

- O `AuthService` salva usuários no Firebase e verifica nomes de usuário únicos.
- O `UserServices` lê dados do perfil e estatísticas de mídia de `Cloud Firestore`.
- A navegação principal usa `GoRouter` com rotas para `/home`, `/search`, `/forum`, `/profile`, `/login`, `/register` e `/info`.

