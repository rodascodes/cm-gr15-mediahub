# MediaHub

Aplicação Flutter para descoberta e catalogação de conteúdo multimédia, com autenticação de utilizadores, navegação por tabs e integração com Firebase e TMDB.

---

## Índice

- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Ecrãs e Funcionamento](#ecrãs-e-funcionamento)
- [Arquitetura](#arquitetura)
- [Observações](#observações)

---

## Funcionalidades

- **Autenticação** — registo e login com email e password via Firebase Auth
- **Perfil e estatísticas** — dados do utilizador e histórico de media em Cloud Firestore
- **Descoberta de conteúdo** — pesquisa e listagem de filmes e séries via API TMDB
- **Página de detalhes** — sinopse, avaliações, comentários e notificações locais
- **Fórum** — discussões da comunidade e conteúdo mais comentado
- **Tema claro/escuro** — alternável em todos os ecrãs
- **Navegação por tabs** — Home, Search, Forum e Profile

---

## Tecnologias

| Tecnologia | Utilização |
|---|---|
| Flutter / Dart | Framework principal |
| Firebase Auth | Autenticação de utilizadores |
| Cloud Firestore | Base de dados de perfis e media |
| Firebase Core | Inicialização Firebase |
| TMDB API | Dados de filmes e séries |
| go_router | Gestão de navegação e rotas |
| HTTP | Pedidos à API REST da TMDB |
| Flutter Local Notifications | Notificações ao guardar avaliações |

---

## Estrutura do Projeto

```
lib/
├── main.dart                      # Entry point, inicialização Firebase e configuração de temas
├── main_scaffold.dart             # Scaffold persistente com bottom nav bar
├── bottom_navbar.dart             # Componente da barra de navegação inferior
├── routes.dart                    # Definição de todas as rotas com GoRouter
├── login.dart                     # Ecrã de login com validação de formulário
├── register.dart                  # Ecrã de registo com validação de formulário
├── page_info.dart                 # Página de detalhes de um título de media
├── firebase_options.dart          # Configurações Firebase por plataforma (gerado pelo FlutterFire CLI)
├── app_util_classes.dart          # Modelos de dados globais (AppUser, Media, MediaType)
│
├── bottom_nav/
│   ├── home_screen.dart           # Ecrã Home — filmes e séries em tendência
│   ├── search_screen.dart         # Ecrã de pesquisa com filtros por categoria
│   ├── forum_screen.dart          # Ecrã de fórum e discussões da comunidade
│   └── profile_screen.dart        # Ecrã de perfil do utilizador
│
├── services/
│   ├── auth_service.dart          # Lógica de autenticação — Firebase Auth
│   └── user_services.dart         # Operações Firestore sobre dados do utilizador
│
└── util/
    ├── app_colors.dart            # Paleta de cores centralizada
    ├── app_validators.dart        # Validadores reutilizáveis para formulários
    ├── text_fields.dart           # Componente reutilizável de campo de texto
    ├── mediacard.dart             # Cards de media e modelo Media
    └── tmdb_service.dart          # Serviço de comunicação com a API TMDB
```

---

## Instalação

```bash
# 1. Clonar o repositório
git clone https://github.com/rodascodes/cm-gr15-mediahub
cd cm-gr15-mediahub

# 2. Instalar dependências
flutter pub get

# 3. Executar
flutter run
```

Build de produção (Android):

```bash
flutter build apk --release
```

---

## Configuração

O projeto inclui configuração Firebase já integrada:
- `lib/firebase_options.dart` — opções por plataforma (gerado pelo FlutterFire CLI)
- `android/app/google-services.json` — configuração Android

A chave da API TMDB está definida em `lib/util/tmdb_service.dart`.

> A aplicação requer ligação à internet para carregar dados da TMDB e login/registo

### Estrutura do Firestore

```
users/
  {uid}/
    username:  string
    name:      string
    email:     string
    createdAt: timestamp
    movies/
      {movieId}/
        score:     number
        favorite:  boolean
        addedAt:   timestamp
```

---

## Ecrãs e Funcionamento

### Login / Registo
Formulários com validação em tempo real (`autovalidateMode: onUserInteraction`). Os validadores em `AppValidators` cobrem:
- Formato de email via regex
- Complexidade de password (mínimo 8 caracteres, maiúsculas, minúsculas, números e símbolos)
- Confirmação de password
- Username com mínimo de 3 caracteres

No registo, o `AuthService` verifica no Firestore se o username já existe antes de criar a conta no Firebase Auth.

### Home
Apresenta os filmes em tendência do dia (via TMDB) numa grelha 2×2. Usa `FutureBuilder` para gerir os estados de loading, erro e dados. Cada card navega para a página de detalhes do título.

### Search
Campo de pesquisa com atualização em tempo real via `setState`. Botões de categoria filtram os resultados entre **All**, **Movies** e **Series**. Com pesquisa vazia, mostra os trending da categoria selecionada. Com texto, faz pesquisa na TMDB e filtra pelo tipo selecionado.

### Forum
Duas secções:
- **Mais Discutidos** — dados reais da TMDB ordenados por número de votos (`getMostDiscussed()`)
- **Tópicos Recentes** — dados mock com estrutura preparada para futura integração com Firestore

### Profile
Header com gradiente e estatísticas do utilizador (ratings, média, tempo, percentil). Inclui distribuição de categorias (Movies, TV Shows, Books), histograma de ratings e lista de favoritos. Atualmente com dados mock, preparado para substituição por dados reais do Firestore via `UserServices`.

### Detalhes de Media
Recebe um objeto `Media` via GoRouter (`state.extra`). Exibe header com gradiente, poster, sinopse, data de lançamento e nota média. Inclui seletor de classificação (1–10), secção de comentários e input para adicionar novo comentário. Dispara notificação local ao guardar avaliação ou comentário.

---

## Arquitetura

### Navegação
A aplicação usa **GoRouter** com uma `ShellRoute` que mantém o `MainScaffold` (com a bottom nav bar) ativo para as rotas principais (`/home`, `/search`, `/forum`, `/profile`). As rotas de autenticação (`/login`, `/register`) e a página de detalhes (`/info`) ficam fora da shell.

O router verifica automaticamente o estado de autenticação no arranque, redirecionando para `/login` ou `/home` conforme a sessão.

### Tema
O tema é gerido por um `ValueNotifier<ThemeMode>` global (`themeNotifier`) definido em `main.dart`. Qualquer ecrã pode alterá-lo chamando `themeNotifier.value = ThemeMode.dark/light`, e o `ValueListenableBuilder` na raiz da app propaga a mudança imediatamente a toda a árvore de widgets.

### Integração TMDB
O `TmdbService` centraliza todos os pedidos à API:
- `getTrending(type)` — filmes ou séries em tendência do dia (`/movie` ou `/tv`)
- `search(query)` — pesquisa multi por texto, filtra resultados para `movie` e `tv`
- `getMostDiscussed()` — filmes ordenados por `vote_count.desc`, usados no fórum

Todos os pedidos usam `language=pt-PT`.

### Modelos de Dados
- `Media` (em `mediacard.dart`) — representa um título da TMDB com id, título, tipo, rating, poster, sinopse e data
- `Media` (em `app_util_classes.dart`) — representa um item na coleção do utilizador com score, favorito e data de adição
- `AppUser` — agrega dados de perfil e coleção de media organizada por `MediaType`

---

## Observações

- O `AuthService` verifica unicidade de username no Firestore antes de criar conta no Firebase Auth
- O `UserServices` lê o perfil e subcoleções de media de Cloud Firestore
- A paleta de cores está centralizada em `AppColors` para facilitar alterações de tema
- Os validadores em `AppValidators` são reutilizados em login e registo com regras diferentes (o login não exige complexidade de password, apenas campo não vazio)
- A bottom nav usa `context.push` em vez de `context.go` para permitir navegação para trás