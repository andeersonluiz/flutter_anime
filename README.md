<div align="center">

# 🎌 Animes IO

**Aplicação Flutter para exploração de animes, refatorada com Clean Architecture, BLoC e testes automatizados.**

[![CI](https://github.com/andeersonluiz/flutter_anime/actions/workflows/ci.yml/badge.svg)](https://github.com/andeersonluiz/flutter_anime/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.38.5-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)
![State](https://img.shields.io/badge/State-flutter__bloc-blueviolet)

</div>

---

## 📌 Sobre o Projeto

O **Animes IO** é um aplicativo mobile em Flutter que consome a [API Kitsu](https://kitsu.docs.apiary.io) para apresentar catálogo de animes, episódios, personagens, categorias e gestão de favoritos integrados ao Firebase.

O projeto passou por um processo completo de refatoração para modernização de código, transição de estado legado (MobX com acoplamento) para **Flutter BLoC**, implementação de **Clean Architecture (Feature-First)** e suporte a testes unitários com `mocktail`.

📖 **[Estudo de Caso & Metodologia de Refatoração →](docs/CASE_STUDY.md)**

---

## 🏗️ Arquitetura do Projeto

O projeto adota **Clean Architecture** dividida em camadas bem definidas e organizadas por *features*:

```
lib/
├── core/                   # Infraestrutura compartilhada (DI, Network, Erros, Tema, Router)
└── features/               # Organização Feature-First
    ├── anime/              # Catálogo, busca e detalhes de animes
    │   ├── data/           # Repositórios, Data Sources (Kitsu API + Hive Cache)
    │   ├── domain/         # Entities e Use Cases (Pure Dart)
    │   └── presentation/   # BLoCs, Pages e Widgets
    ├── character/          # Personagens
    ├── category/           # Categorias
    ├── auth/               # Autenticação Firebase (Email, Google & Guest)
    ├── favorites/          # Gerenciamento de Favoritos (Firestore)
    ├── settings/           # Configurações de Tema e Idioma
    └── episode/            # Lista de episódios
```

📐 **[Documentação de Arquitetura →](docs/ARCHITECTURE.md)**

---

## 📊 Métricas de Evolução (Antes vs Depois)

| Métrica | 🔴 Versão Legada (`branch: legacy`) | ✅ Versão Refatorada (`branch: main / refactor`) |
|---|---|---|
| Arquitetura | Sem padrão definido (código acoplado) | Clean Architecture + Feature-First |
| Gerenciamento de Estado | MobX (God Stores) | Flutter BLoC (Sealed States & Events) |
| Duplicação de código | ~80% de duplicação em telas principais | 0% (Widgets e Pages desacoplados) |
| Testes Unitários | 0% de cobertura | Cobertura em BLoCs, Repositórios e Data Sources |
| Caching | Inexistente (requisições repetidas) | Hive Cache local com expiração temporizada |
| Null Safety | Dart SDK legado | Dart 3.x Null Safe |

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK `3.38.5` ou superior
- Dart `3.x`

### Passos para execução

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/andeersonluiz/flutter_anime.git
   cd flutter_anime
   ```

2. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```

3. **Gerar arquivos de geração de código (se necessário):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Executar a aplicação:**
   ```bash
   flutter run
   ```

5. **Executar a suíte de testes:**
   ```bash
   flutter test
   ```

---

## 🔑 Funcionalidades Principais

- 📺 **Exploração de Animes**: Categorias por Trending, Mais Populares, Top Rated e Em Exibição.
- 🔍 **Busca Inteligente**: Pesquisa por texto em tempo real com *debounce*.
- 👤 **Personagens & Episódios**: Detalhamento completo com relacionamentos.
- ❤️ **Favoritos Sincronizados**: Armazenamento no Cloud Firestore para usuários autenticados.
- 🔐 **Autenticação**: Suporte a Login via Email/Senha, Google Sign-In e Acesso Anônimo (Convidado).
- 🎨 **Personalização**: Suporte a Tema Claro/Escuro (Dark Mode) e alteração de avatar/background.
- 🌐 **Internacionalização**: Suporte a Português e Inglês.
- 📦 **Offline Cache**: Armazenamento local das listas para rápida resposta e economia de dados.

---

<div align="center">
  <sub>Desenvolvido com Flutter • Consome a API pública do <a href="https://kitsu.docs.apiary.io">Kitsu</a></sub>
</div>
