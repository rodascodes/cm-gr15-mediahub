# MediaHub

Aplicação Flutter para descoberta e catalogação de conteúdo multimédia, com autenticação de utilizadores, navegação por tabs e integração com Firebase e TMDB.

Existe troca de temas em tempo real, com a função de não dar refresh à API sempre que a página troca de tema, através de implementação de `StatefulWidgets` e `AutomaticKeepAliveClientMixin`.

> Existe algum hardcode e code smells pontuais que não foi possível corrigir por imprevistos durante o desenvolvimento.

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
- **Coleção do utilizador** — lista personalizada de media com avaliações e datas
- **Página de detalhes** — sinopse, avaliações, comentários e notificações locais
- **Fórum** — discussões da comunidade e conteúdo mais comentado
- **Tema claro/escuro** — alternável em todos os ecrãs sem refresh à API
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
| Flutter Local Notifications | Notificações ao guardar avaliações e comentários |

---

## Estrutura do Projeto

```
lib/
├── main.dart                          # Entry point, inicialização Firebase e configuração de temas
├── main_scaffold.dart                 # Scaffold persistente com bottom nav bar
├── page_info.dart                     # Página de detalhes de um título de media
├── routes.dart                        # Definição de todas as rotas com GoRouter
│
├── config/
│   └── firebase_options.dart          # Configurações Firebase por plataforma (gerado pelo FlutterFire CLI)
│
├── services/
│   ├── auth_service.dart              # Lógica de autenticação — Firebase Auth
│   ├── notification_service.dart      # Serviço de notificações locais — Flutter Local Notifications
│   ├── tmdb_service.dart              # Serviço de comunicação com a API TMDB
│   └── user_services.dart             # Operações Firestore sobre dados do utilizador
│
├── utils/
│   ├── app_colors.dart                # Paleta de cores centralizada
│   ├── app_util_classes.dart          # Modelos de dados globais (AppUser, MediaStats, MediaType)
│   ├── app_validators.dart            # Validadores reutilizáveis para formulários
│   ├── mediacard.dart                 # Cards de media e modelo Media
│   └── text_fields.dart              # Componente reutilizável de campo de texto
│
├── views/
│   ├── forum_screen.dart              # Ecrã de fórum e discussões da comunidade
│   ├── home_screen.dart               # Ecrã Home — filmes e séries em tendência
│   ├── login.dart                     # Ecrã de login com validação de formulário
│   ├── media_collection_page.dart     # Página de coleção de media com header gradiente
│   ├── profile_screen.dart            # Ecrã de perfil do utilizador
│   ├── register.dart                  # Ecrã de registo com validação de formulário
│   ├── search_screen.dart             # Ecrã de pesquisa com filtros por categoria
│   └── user_list.dart                 # Lista de media do utilizador com estatísticas
│
└── widgets/
    └── bottom_navbar.dart             # Componente da barra de navegação inferior
```

---

## Instalação

**Pré-requisitos:** Flutter SDK instalado e configurado — [guia oficial](https://flutter.dev/docs/get-started/install)

```bash
# 1. Clonar o repositório
git clone https://github.com/rodascodes/cm-gr15-mediahub
cd cm-gr15-mediahub

# 2. Instalar dependências
flutter pub get

# 3. Executar
flutter run
```

Para um dispositivo específico:

```bash
flutter run -d <device-id>
# Para listar dispositivos disponíveis: flutter devices
```

Build de produção (Android):

```bash
flutter build apk --release
```

---

## Configuração

O projeto inclui configuração Firebase já integrada:
- `lib/config/firebase_options.dart` — opções por plataforma (gerado pelo FlutterFire CLI)
- `android/app/google-services.json` — configuração Android

A chave da API TMDB está definida em `lib/services/tmdb_service.dart`.

> A aplicação requer ligação à internet para carregar dados da TMDB e para login/registo.

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
Apresenta os filmes e séries em tendência do dia (via TMDB) em grelha. Usa `FutureBuilder` para gerir os estados de loading, erro e dados. Cada card navega para a página de detalhes do título. Implementa `AutomaticKeepAliveClientMixin` para evitar refetch à API ao trocar de tab ou de tema.

### Search
Campo de pesquisa com atualização em tempo real via `setState`. Botões de categoria filtram os resultados entre **All**, **Movies** e **Series**. Com pesquisa vazia, mostra os trending da categoria selecionada. Com texto, faz pesquisa na TMDB e filtra pelo tipo selecionado.

### Forum
Duas secções:
- **Mais Discutidos** — dados reais da TMDB ordenados por número de votos (`getMostDiscussed()`)
- **Tópicos Recentes** — dados mock com estrutura preparada para futura integração com Firestore

### Profile
Header com gradiente e estatísticas do utilizador. Inclui distribuição de categorias, histograma de ratings e lista de favoritos. Ao clicar numa categoria ou nos favoritos, navega para a `UserList` ou `MediaCollectionPage` com os dados correspondentes.

### Lista do Utilizador (`user_list.dart`)
Exibe a coleção de media guardada pelo utilizador, carregando os dados de `MediaStats` do Firestore e os detalhes (poster, título, tipo) via `TmdbService.getMediaListFromMediaStatsList()`. Cada item mostra poster, título, tipo, data de adição e avaliação. Ao tocar navega para a página de detalhes.

### Coleção de Media (`media_collection_page.dart`)
Página com header gradiente (roxo → rosa) que apresenta uma lista de items passados como parâmetro. Exibe poster, título, ano e rating de cada item. Usada para mostrar coleções específicas a partir do perfil.

### Detalhes de Media (`page_info.dart`)
Recebe um objeto `Media` via GoRouter (`state.extra`). Exibe header com gradiente, poster, sinopse, data de lançamento e nota média. Inclui seletor de classificação (1–10) e secção de comentários. Ao guardar avaliação ou comentário, persiste no Firestore e dispara uma notificação local via `NotificationService`.

---

## Arquitetura

### Navegação
A aplicação usa **GoRouter** com uma `ShellRoute` que mantém o `MainScaffold` (com a bottom nav bar) ativo para as rotas principais (`/home`, `/search`, `/forum`, `/profile`). As rotas de autenticação (`/login`, `/register`), a página de detalhes (`/info`), a lista do utilizador (`/user-list`) e a coleção de media (`/collection`) ficam fora da shell.

O router verifica automaticamente o estado de autenticação no arranque, redirecionando para `/login` ou `/home` conforme a sessão.

### Tema
O tema é gerido por um `ValueNotifier<ThemeMode>` global (`themeNotifier`) definido em `main.dart`. Qualquer ecrã pode alterá-lo chamando `themeNotifier.value = ThemeMode.dark/light`, e o `ValueListenableBuilder` na raiz da app propaga a mudança imediatamente a toda a árvore de widgets, sem causar refetch de dados graças ao `AutomaticKeepAliveClientMixin`.

### Notificações Locais
O `NotificationService` é inicializado no arranque da app e expõe o método estático `showNotification({title, body})`. Configura um canal Android (`mediahub_channel`) com prioridade alta. É chamado na `page_info.dart` ao guardar avaliações e comentários.

### Integração TMDB
O `TmdbService` centraliza todos os pedidos à API:
- `getTrending(type)` — filmes ou séries em tendência do dia
- `search(query)` — pesquisa multi por texto, filtra para `movie` e `tv`
- `getMostDiscussed()` — filmes ordenados por `vote_count.desc`, usados no fórum
- `getMediaListFromMediaStatsList(list)` — carrega detalhes de uma lista de `MediaStats` do utilizador

Todos os pedidos usam `language=pt-PT`.

### Modelos de Dados
- `Media` (em `utils/mediacard.dart`) — título da TMDB com id, título, tipo, rating, poster, sinopse e data
- `MediaStats` (em `utils/app_util_classes.dart`) — item na coleção do utilizador com score, favorito e data de adição
- `AppUser` — agrega dados de perfil e coleção de media organizada por `MediaType`

---

## Observações

- O `AuthService` verifica unicidade de username no Firestore antes de criar conta no Firebase Auth
- O `UserServices` lê o perfil e subcoleções de media de Cloud Firestore
- O `NotificationService` usa `DateTime.now().millisecond` como ID de notificação, garantindo IDs únicos por chamada
- A paleta de cores está centralizada em `AppColors` para facilitar alterações de tema
- Os validadores em `AppValidators` são reutilizados em login e registo com regras diferentes — o login apenas verifica que os campos não estão vazios, enquanto o registo exige complexidade total
- A `UserList` trata o caso de poster vazio com um ícone `image_not_supported` em vez de lançar erro