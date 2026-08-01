# Segurança e publicação

## Rotação da assinatura Android

O repositório não versiona `android/key.properties` nem `android/app/upload-keystore.jks`.
Para gerar uma chave nova sem colocar credenciais no Git:

```powershell
$env:ANIMES_KEYSTORE_PASSWORD = '<senha forte>'
$env:ANIMES_KEY_PASSWORD = '<senha forte>'
$env:ANIMES_KEY_ALIAS = 'animesio-upload'
powershell -ExecutionPolicy Bypass -File tooling/rotate_keystore.ps1
```

Depois, atualize os secrets `KEYSTORE_BASE64`, `KEY_ALIAS`, `KEY_PASSWORD` e `STORE_PASSWORD` no GitHub Actions. Nunca publique os valores no repositório ou em logs.

## Histórico legado

O histórico anterior contém artefatos de assinatura que foram removidos da árvore atual. Antes de publicar novamente, faça a limpeza histórica em uma cópia/clone de backup e force-push somente após revisar os refs. Todos os colaboradores precisarão baixar o histórico novamente depois da reescrita.

## Firebase e identificador do app

O identificador foi atualizado para `io.github.andeersonluiz.animesio`. Registre esse package/bundle ID no Firebase, gere um novo `google-services.json` e atualize as credenciais OAuth/SHA antes de publicar uma build autenticada.
