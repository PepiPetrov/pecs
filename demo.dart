import 'dart:io';

void main() async {
  String cmd = 'cmd';
  String shell = 'powershell';
  String command = 'dir';

  if (await canExecute(cmd)) {
    final result = await Process.run(cmd, ['/c', command]);
    if (result.exitCode == 0) {
      final output = result.stdout.toString();
      print(output);
    } else {
      final errorMessage = result.stderr.toString();
      print('Error: $errorMessage');
    }
  } else if (await canExecute(shell)) {
    final result = await Process.run(shell, ['-Command', command]);
    if (result.exitCode == 0) {
      final output = result.stdout.toString();
      print(output);
    } else {
      final errorMessage = result.stderr.toString();
      print('Error: $errorMessage');
    }
  } else if (await canExecute('sh')) {
    final result = await Process.run('sh', ['-c', command]);
    if (result.exitCode == 0) {
      final output = result.stdout.toString();
      print(output);
    } else {
      final errorMessage = result.stderr.toString();
      print('Error: $errorMessage');
    }
  } else {
    print('Error: No supported shell found.');
  }
}

Future<bool> canExecute(String cmd) async {
  final result = await Process.run(cmd, ['--version']);
  return result.exitCode == 0;
}
