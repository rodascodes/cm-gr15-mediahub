# media_hub

# MediaHub

Aplicação mobile desenvolvida em **Flutter** que funciona como um hub centralizado para descoberta e catalogação de conteúdo multimédia — filmes e séries. A aplicação integra a API pública da [TMDB (The Movie Database)](https://www.themoviedb.org/) para obter dados em tempo real e utiliza **Firebase** para autenticação e persistência de dados do utilizador.

---

## Índice

- [Funcionalidades](#funcionalidades)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Instalação e Execução](#instalação-e-execução)
- [Configuração do Firebase](#configuração-do-firebase)
- [Arquitetura e Funcionamento](#arquitetura-e-funcionamento)
- [Ecrãs da Aplicação](#ecrãs-da-aplicação)

---

## Funcionalidades

- **Autenticação**: Registo e login de utilizadores com Firebase Auth (email + password)
- **Home**: Listagem de filmes e séries em tendência via TMDB
- **Pesquisa**: Pesquisa em tempo real de filmes e séries com filtros por categoria (All / Movies / Series)
- **Página de Detalhes**: Informação detalhada de cada título — poster, descrição, data de lançamento, nota e comentários
- **Fórum**: Secção de discussão com os títulos mais debatidos (via TMDB) e tópicos recentes (dados mock)
- **Perfil**: Visualização das estatísticas do utilizador, categorias consumidas, distribuição de ratings e favoritos
- **Tema claro/escuro**: Toggle de tema disponível em todos os ecrãs principais
- **Navegação por tabs**: Bottom navigation bar com 4 secções (Home, Search, Forum, Profile)

---

## Tecnologias Utilizadas

| Tecnologia | Função |
|---|---|
| Flutter / Dart | Framework principal de desenvolvimento mobile |
| Firebase Auth | Autenticação de utilizadores |
| Cloud Firestore | Base de dados NoSQL para dados do utilizador |
| TMDB API | Fonte de dados de filmes e séries |
| GoRouter | Gestão de navegação e rotas |
| HTTP | Pedidos à API REST da TMDB |

---

## Estrutura do Projeto

```
lib/
├── main.dart                  # Entry point, configuração de temas e inicialização Firebase
├── main_scaffold.dart         # Scaffold principal com bottom nav persistente
├── bottom_navbar.dart         # Componente da barra de navegação inferior
├── routes.dart                # Definição de todas as rotas com GoRouter
├── login.dart                 # Ecrã de autenticação (login)
├── register.dart              # Ecrã de registo de conta
├── page_info.dart             # Página de detalhes de um título
├── firebase_options.dart      # Configurações do Firebase por plataforma
├── app_util_classes.dart      # Modelos de dados globais (AppUser, Media, MediaType)
│
├── bottom_nav/
│   ├── home_screen.dart       # Ecrã Home — trending
│   ├── search_screen.dart     # Ecrã de pesquisa com filtros
│   ├── forum_screen.dart      # Ecrã de fórum e discussões
│   └── profile_screen.dart    # Ecrã de perfil do utilizador
│
├── services/
│   ├── auth_service.dart      # Lógica de autenticação Firebase
│   └── user_services.dart     # Operações Firestore sobre dados do utilizador
│
└── util/
    ├── app_colors.dart        # Paleta de cores centralizada
    ├── app_validators.dart    # Validadores de formulários (email, password, username)
    ├── text_fields.dart       # Componente reutilizável de campo de texto
    ├── mediacard.dart         # Componentes de cards de media e modelos visuais
    └── tmdb_service.dart      # Serviço de comunicação com a API da TMDB
```

---

## Instalação e Execução

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão estável recomendada)
- [Dart SDK](https://dart.dev/get-dart) (incluído com o Flutter)
- Android Studio ou VS Code com extensões Flutter/Dart
- Emulador Android/iOS ou dispositivo físico
- Conta Firebase (ver secção abaixo)

### Passos

1. **Clonar o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd media_hub
   ```

2. **Instalar dependências**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase** (ver secção abaixo)

4. **Executar a aplicação**
   ```bash
   flutter run
   ```

   Para um dispositivo específico:
   ```bash
   flutter run -d <device-id>
   ```

   Para listar dispositivos disponíveis:
   ```bash
   flutter devices
   ```

5. **Build de produção (Android)**
   ```bash
   flutter build apk --release
   ```

---

## Configuração do Firebase

O ficheiro `lib/firebase_options.dart` é gerado automaticamente pelo FlutterFire CLI e contém as chaves de configuração do projeto Firebase. Para configurar num novo ambiente:

1. Instalar o FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Associar ao projeto Firebase:
   ```bash
   flutterfire configure
   ```

3. Ativar no Firebase Console:
   - **Authentication** → Email/Password
   - **Firestore Database** → criar base de dados em modo de teste

### Estrutura do Firestore

```
users/
  {uid}/
    username: string
    name: string
    email: string
    createdAt: timestamp
    movies/
      {movieId}/
        score: number
        favorite: boolean
        addedAt: timestamp
```

---

## Arquitetura e Funcionamento

### Navegação

A aplicação usa **GoRouter** com uma `ShellRoute` que mantém o `MainScaffold` (com a bottom nav bar) ativo para as rotas principais (`/home`, `/search`, `/forum`, `/profile`). As rotas de autenticação (`/login`, `/register`) e a página de detalhes (`/info`) ficam fora da shell.

O router verifica automaticamente se existe um utilizador autenticado no arranque, redirecionando para `/login` ou `/home` conforme o estado da sessão.

### Tema

O tema é gerido por um `ValueNotifier<ThemeMode>` global (`themeNotifier`) definido em `main.dart`. Qualquer ecrã pode alterar o tema chamando `themeNotifier.value = ThemeMode.dark/light`, e o `ValueListenableBuilder` na raiz da app propaga a mudança imediatamente.

### Integração TMDB

O `TmdbService` em `util/tmdb_service.dart` é responsável por todos os pedidos à API da TMDB:

- `getTrending(type)` — filmes ou séries em tendência do dia
- `search(query)` — pesquisa multi (filmes + séries) por texto
- `getMostDiscussed()` — filmes ordenados por número de votos (usado no fórum)

Todos os pedidos usam `language=pt-PT` para obter títulos e sinopses em português.

### Autenticação e Dados do Utilizador

- `AuthService` encapsula o Firebase Auth — registo, login, logout e acesso ao utilizador atual
- No registo, verifica unicidade do username no Firestore antes de criar a conta
- `UserServices` trata das operações CRUD sobre os dados do utilizador (coleções de media no Firestore)

---

## Ecrãs da Aplicação

### Login / Registo
Formulários com validação em tempo real (`autovalidateMode: onUserInteraction`). Os validadores em `AppValidators` cobrem: formato de email, complexidade de password (mínimo 8 caracteres, maiúsculas, minúsculas, números e símbolos), confirmação de password e tamanho mínimo de username.

### Home
Exibe os 4 filmes em tendência do dia numa grelha 2×2. Utiliza `FutureBuilder` para tratar os estados de loading, erro e dados.

### Search
Campo de pesquisa com atualização em tempo real via `setState`. Os botões de categoria filtram os resultados entre "All", "Movies" e "Series". Com pesquisa vazia, mostra os trending da categoria selecionada.

### Forum
Duas secções: "Mais Discutidos" (dados reais da TMDB via `getMostDiscussed()`) e "Tópicos Recentes" (dados mock com estrutura preparada para futura integração com Firestore).

### Página de Detalhes
Recebe um objeto `Media` via `GoRouter` (`state.extra`), exibe header com gradiente, poster, sinopse, data e rating. Inclui seletor de classificação (1–10) e secção de comentários (mock).

### Perfil
Header com gradiente e estatísticas do utilizador. Inclui distribuição de categorias, histograma de ratings e lista de favoritos. Atualmente com dados mock (`_MockupUser`), preparado para substituição por dados reais do Firestore.
