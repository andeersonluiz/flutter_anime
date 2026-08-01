# AGENTS.md — Contexto para Agentes de IA

Este arquivo fornece contexto estruturado para agentes de IA trabalhando neste projeto.
Seguindo o padrão da indústria para projetos "agent-native" (2025/2026).

---

## Visão Geral do Projeto

**Animes IO** é um app Flutter para explorar informações sobre animes usando a [API Kitsu](https://kitsu.docs.apiary.io).

- **Package**: `animes_io`
- **Flutter**: 3.38.5 / Dart 3.x
- **API**: Kitsu REST API (`https://kitsu.io/api/edge`)
- **Backend**: Firebase (Auth + Firestore)

---

## Arquitetura

Este projeto segue **Clean Architecture** com organização **feature-first**.

```
lib/
├── core/           # Infraestrutura compartilhada (DI, network, error, theme, router)
├── features/       # Features independentes (anime, character, category, auth, favorites, settings, episode)
│   └── <feature>/
│       ├── data/         # Repositórios, data sources, models
│       ├── domain/       # Entities, use cases, interfaces (Pure Dart)
│       └── presentation/ # BLoCs, pages, widgets
└── main.dart
```

### Camadas (de fora para dentro)

1. **Presentation** → BLoC (`flutter_bloc`) + Widgets Flutter
2. **Domain** → Use Cases + Entities + Repository Interfaces (sem dependências de framework)
3. **Data** → Repository Implementations + Data Sources (Dio, Hive, Firebase)
4. **Core** → DI (GetIt), Error Handling, Network, Theme, Router

---

## Regras que o Agente DEVE Seguir

### ❌ Nunca
- Fazer chamadas HTTP diretas em BLoCs, widgets ou páginas
- Importar `package:dio` ou `package:firebase_*` na camada domain
- Usar estado global (sem variáveis top-level mutáveis)
- Instanciar dependências com `new` — sempre usar GetIt (`sl<T>()`)
- Fazer chamadas de side-effect dentro de `build()` ou `Observer(builder:)`
- Usar `dynamic` como tipo — sempre tipar explicitamente
- Silenciar erros com `catch (e) {}` sem logar ou propagar

### ✅ Sempre
- Retornar `Either<Failure, T>` (dartz) nos repositórios e data sources
- Registrar BLoCs com `registerFactory` no GetIt (não singleton)
- Registrar Use Cases e Repositories com `registerLazySingleton`
- Usar `sealed class` para estados de BLoC (Dart 3)
- Usar `freezed` para entities e models
- Usar `json_serializable` para fromJson/toJson (não manual)
- Usar `GoRouter` para navegação (não `Navigator.push` direto)
- Seguir as regras de `very_good_analysis` (sem warnings)
- **EXECUTAR SEMPRE `dart format lib test integration_test git_hooks.dart` E `flutter analyze` APÓS QUALQUER MODIFICAÇÃO DE CÓDIGO** para garantir 0 erros de sintaxe, tipos, compilação ou linter. O CI repete essa formatação, análise estática, testes unitários com cobertura e acrescenta o E2E no emulador Android.
- **SEMPRE INCREMENTAR A VERSÃO NO `pubspec.yaml`** antes de realizar um `git push` final. A cada nova feature ou bugfix concluído, o *build number* (o número após o `+`) ou a versão semântica deve ser aumentada para refletir o novo build.
- **O `git_hooks.dart` DEVE SEMPRE REFLETIR AS MESMAS CHECAGENS LOCAIS FUNDAMENTAIS DO CI (`.github/workflows/ci.yml`)**: formatação de `lib`, `test`, `integration_test` e `git_hooks.dart`, análise com `--fatal-infos` e testes unitários com cobertura. O CI também executa o E2E no emulador Android e o build de release. NUNCA modifique ou enfraqueça as regras do `git_hooks.dart` para fazer um commit passar.

---

## Stack de Tecnologias

| Categoria | Pacote | Versão |
|---|---|---|
| State Management | `flutter_bloc` | ^8.x |
| DI | `get_it` + `injectable` | ^7.x |
| Networking | `dio` | ^5.x |
| Error Handling | `dartz` | ^0.10.x |
| Code Gen (models) | `freezed` + `json_serializable` | ^2.x |
| Cache Local | `hive_flutter` | ^1.x |
| Navegação | `go_router` | ^14.x |
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore` | latest |
| Auth Social | `google_sign_in` | ^6.x |
| Testes | `mocktail` + `bloc_test` | latest |
| Lint | `very_good_analysis` | ^6.x |

---

## Endpoints da API Kitsu

Base URL: `https://kitsu.io/api/edge`

| Endpoint | Uso |
|---|---|
| `GET /trending/anime` | Animes trending |
| `GET /anime?sort=-userCount` | Mais populares |
| `GET /anime?sort=-averageRating` | Melhor avaliados |
| `GET /anime?filter[status]=upcoming` | Em breve |
| `GET /anime/{id}` | Detalhes de um anime |
| `GET /anime/{id}/characters` | Personagens de um anime |
| `GET /anime/{id}/episodes` | Episódios de um anime |
| `GET /characters` | Lista de personagens |
| `GET /categories` | Lista de categorias |
| `GET /anime?filter[categories]={slug}` | Animes por categoria |
| `GET /anime?filter[text]={query}` | Busca de animes |

---

## Convenções de Código

- **Arquivos**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variáveis/métodos**: `camelCase`
- **Constantes**: `camelCase` (não SCREAMING_SNAKE)
- **BLoC Events**: verbo no infinitivo — `LoadTrendingAnimes`, `SearchAnimes`
- **BLoC States**: substantivo + status — `AnimeLoading`, `AnimeLoaded`, `AnimeError`
- **Use Cases**: classe com método `call()` — permite usar como função

---

## Estrutura de Testes

```
test/
├── features/
│   ├── anime/
│   │   ├── data/repositories/
│   │   ├── domain/usecases/
│   │   └── presentation/bloc/
│   ├── auth/domain/usecases/
│   ├── favorites/domain/usecases/
│   └── settings/presentation/bloc/
└── core/
    └── network/
```

---

## Contexto do Portfólio

Este projeto foi **refatorado usando agentes de IA (Antigravity)**. O processo está documentado em `docs/CASE_STUDY.md`. A branch `legacy` preserva o código original para comparação.
