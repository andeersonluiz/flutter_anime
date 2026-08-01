# Case Study: Refatoração Assistida por Agentes de IA

> **Projeto**: Animes IO — App Flutter para explorar animes via API Kitsu  
> **Período**: Julho 2026  
> **Agente utilizado**: Antigravity (Google DeepMind)  
> **Branch legado**: [`legacy`](https://github.com/andeersonluiz/flutter_anime/tree/legacy)

---

## O Problema

O projeto foi criado em 2020 como um projeto de aprendizado. Com o tempo, acumulou dívida técnica significativa:

### Problemas Identificados (pelo Agente)

O agente analisou **51 arquivos** e identificou os seguintes problemas críticos:

| Problema | Impacto |
|---|---|
| Sem arquitetura definida — sem camadas claras | Código impossível de testar e escalar |
| **3 God Objects**: `anime_store.dart` (13KB), `animeInfo_page.dart` (27KB/571 linhas), `drawerSideBar_widget.dart` (13KB) | Manutenção impossível, zero testabilidade |
| **80% de duplicação** entre `animeInfo_page.dart` e `animeInfoFavorite_page.dart` | Bugs precisam ser corrigidos em dois lugares |
| Chamadas HTTP diretas em 7+ stores (sem repositório, sem abstração) | Sem possibilidade de cache, mock ou troca de fonte |
| **Zero tratamento de erros** — crashes silenciosos | App quebra sem feedback ao usuário |
| Sem null safety (Dart SDK `>=2.7.0 <3.0.0`) | Incompatível com Flutter moderno |
| `Future.delayed(Duration(seconds: 5))` hardcoded em 4 stores | UI travada por 5 segundos sem motivo |
| Estado de UI em stores de dados (`showPassword`, `iconFav: IconData`) | Violação de separação de responsabilidades |
| Chave de criptografia AES hardcoded no código | Vulnerabilidade de segurança |
| Zero testes (apenas widget_test.dart default) | Sem confiabilidade, refatoração arriscada |

---

## O Processo com Agentes

### Etapa 1: Análise Automática

O agente Antigravity foi instruído via `AGENTS.md` com contexto do projeto e regras de arquitetura. Ele então analisou toda a codebase de forma autônoma:

```
Agente → Analisou 51 arquivos em paralelo usando subagentes
       → Identificou padrões problemáticos (God Objects, N+1 queries, etc)
       → Gerou relatório detalhado por arquivo
```

**Decisão humana**: Revisei o relatório e confirmei as prioridades. Ajustei o escopo (removendo Facebook Login e AI features do app — não era o objetivo).

### Etapa 2: Planejamento

O agente propôs um plano de implementação em fases. Aqui houve **iteração humana importante**:

- **Proposta inicial do agente**: incluía AI Layer com Gemini, chat bot, etc.
- **Minha correção**: "O objetivo é mostrar o PROCESSO de uso de agentes, não adicionar IA no app"
- **Resultado**: plano focado em Clean Architecture + documentação do processo

Isso demonstra um ponto crucial: **saber quando rejeitar sugestões do agente** é tão importante quanto saber usá-las.

### Etapa 3: Execução Incremental

O agente executou a refatoração fase por fase:

1. **Fundação** — dependências modernas, error handling, networking
2. **Domain Layer** — entities, use cases, interfaces (código gerado pelo agente + revisão humana)
3. **Data Layer** — repositories, data sources (código gerado + validação de lógica)
4. **Presentation** — BLoCs, pages refatoradas (código gerado + ajustes de UX)
5. **CI/CD + Lint** — automação de qualidade
6. **Testes** — cobertura das regras de negócio críticas
7. **Documentação** — este arquivo

### Etapa 4: Validação

Cada fase foi validada com:
```bash
dart analyze --fatal-infos  # Zero warnings
flutter test               # Testes passando
flutter build apk --debug  # Build sem erros
```

---

## Métricas: Antes vs Depois

| Métrica | Antes (Legacy) | Depois (Refatorado) |
|---|---|---|
| Maior arquivo | 571 linhas (27KB) | 299 linhas |
| Total de arquivos | ~60 | ~120 (mais organizados) |
| God Objects | 3 | 0 |
| Duplicação de código | ~80% entre 2 telas | 0% |
| Chamadas HTTP fora da camada de dados | 7+ stores | 0 |
| Tratamento de erros | Nenhum | Failures tipadas em toda chamada |
| `Future.delayed` artificial | 4 stores | 0 |
| Cobertura de testes | 0% | 75,0% (1009/1345 linhas; 220 testes no baseline de 01/08/2026) |
| Null safety | ❌ Dart 2.7 | ✅ Dart 3.x |
| Responsividade | Valores hardcoded | Adaptativo |
| CI/CD | ❌ | ✅ GitHub Actions |
| Lint | Padrão Flutter | very_good_analysis |

---

## Onde o Agente Acertou

- **Análise de codebase**: identificou problemas que levariam horas para mapear manualmente
- **Geração de boilerplate**: código repetitivo de Clean Architecture (entities, use cases, blocs) gerado corretamente
- **Testes**: criou testes unitários com mocks a partir das interfaces de repositório
- **Documentação**: gerou estrutura de docs a partir do contexto fornecido

---

## Onde o Agente Errou / Precisou de Correção

- **Escopo excessivo**: propôs inicialmente integração com Gemini API desnecessária para o objetivo
- **Interpretação do objetivo**: confundiu "portfólio de uso de agentes" com "app com features de IA"
- **Correção**: ajuste iterativo via feedback no planejamento

---

## Lições Aprendidas

1. **Contexto é tudo** — o `AGENTS.md` com regras claras reduziu drasticamente erros do agente
2. **Humano no loop** — cada fase precisou de revisão. O agente é rápido, mas não substitui julgamento
3. **Iteração > Perfeição** — melhor corrigir o agente ao longo do processo do que tentar especificar tudo no início
4. **Rejeitar sugestões** é uma skill — saber o que NÃO implementar é tão importante quanto o que implementar
5. **Validação automática** — CI/CD e testes são essenciais quando se usa IA para gerar código

---

## Como Reproduzir

```bash
# Clone o repositório
git clone https://github.com/andeersonluiz/flutter_anime

# Ver código legado original
git checkout legacy

# Ver código refatorado
git checkout main

# Rodar app
flutter pub get
flutter run

# Rodar testes
flutter test --coverage

# Verificar qualidade
dart analyze --fatal-infos
```
