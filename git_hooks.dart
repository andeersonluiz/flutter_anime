// ignore_for_file: avoid_print

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

  // 2. Static Analysis (Erros de Compilação/Sintaxe)
  stdout.writeln('2/2 Executando análise estática (dart analyze)...');
  final analyzeResult = await Process.run(
    'dart',
    ['analyze', '--no-fatal-infos', '--no-fatal-warnings'],
    runInShell: true,
  );

  final stdoutText = analyzeResult.stdout.toString();
  if (stdoutText.contains(' error - ')) {
    stdout.writeln(
        '\n❌ [ERRO DE COMPILAÇÃO] Foram encontrados erros graves de compilação ou sintaxe no código!\n');
    stdout.writeln(stdoutText);
    stdout.writeln('👉 Corrija os erros acima antes de commitar.\n');
    return false;
  }
  stdout.writeln(
      '✅ Análise estática OK! Nenhum erro de compilação encontrado.\n');

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
