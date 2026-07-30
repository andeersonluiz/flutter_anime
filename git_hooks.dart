import 'dart:io';
import 'package:git_hooks/git_hooks.dart';

void main(List<String> arguments) {
  final Map<Git, UserBackFun> params = {
    Git.preCommit: preCommit,
    Git.prePush: prePush,
  };
  GitHooks.call(arguments, params);
}

Future<bool> preCommit() async {
  stdout.writeln('\n---------------------------------------------------');
  stdout.writeln(
      '🔎 [Git Hook Pre-Commit] Verificando Formatação e Análise Estática...');
  stdout.writeln('---------------------------------------------------\n');

  // 1. Verify Formatting
  stdout.writeln('1/2 Checando formatação (dart format)...');
  final formatResult = await Process.run(
    'dart',
    [
      'format',
      '--output=none',
      '--set-exit-if-changed',
      'lib',
      'test',
      'git_hooks.dart'
    ],
    runInShell: true,
  );

  if (formatResult.exitCode != 0) {
    stdout.writeln('\n❌ [ERRO DE FORMATAÇÃO] Existem arquivos desalinhados!');
    stdout.writeln(
        '👉 Execute o comando "dart format lib test git_hooks.dart" no seu terminal para corrigir antes de commitar.\n');
    return false;
  }
  stdout.writeln('✅ Formatação OK!\n');

  // 2. Static Analysis with fatal infos (idêntico ao CI)
  stdout.writeln(
      '2/2 Executando análise estática (dart analyze --fatal-infos)...');
  final analyzeResult = await Process.run(
    'dart',
    ['analyze', '--fatal-infos'],
    runInShell: true,
  );

  if (analyzeResult.exitCode != 0) {
    stdout.writeln(
        '\n❌ [ERRO DE ANÁLISE ESTÁTICA] Foram encontrados avisos/erros no código!\n');
    stdout.writeln(analyzeResult.stdout);
    stdout.writeln('👉 Corrija os avisos acima antes de commitar.\n');
    return false;
  }
  stdout.writeln('✅ Análise estática OK! Nenhum aviso encontrado.\n');

  return true;
}

Future<bool> prePush() async {
  stdout.writeln('\n---------------------------------------------------');
  stdout.writeln(
      '🧪 [Git Hook Pre-Push] Executando Suíte de Testes Automatizada...');
  stdout.writeln('---------------------------------------------------\n');

  final testResult = await Process.run(
    'flutter',
    ['test'],
    runInShell: true,
  );

  if (testResult.exitCode != 0) {
    stdout.writeln(
        '\n❌ [TESTES FALHARAM] O push foi CANCELADO porque existem testes falhando!\n');
    stdout.writeln(testResult.stdout);
    stdout.writeln(
        '👉 Execute "flutter test" localmente e corrija as falhas antes de subir pro GitHub.\n');
    return false;
  }

  stdout
      .writeln('✅ Todos os testes passaram com sucesso! Autorizando push...\n');
  return true;
}
