import 'dart:io';

void main() async {
  print('🔧 Flutter Localization Null Safety Fixer');
  print('==========================================');
  
  // Get the current directory
  final currentDir = Directory.current;
  final libDir = Directory('${currentDir.path}/lib');
  
  if (!await libDir.exists()) {
    print('❌ lib directory not found. Please run this script from your Flutter project root.');
    return;
  }
  
  print('📁 Scanning lib directory for null check operator issues...');
  
  // Find all Dart files
  final dartFiles = await _findDartFiles(libDir);
  print('📄 Found ${dartFiles.length} Dart files');
  
  int totalFixed = 0;
  
  for (final file in dartFiles) {
    final fixed = await _fixFile(file);
    if (fixed > 0) {
      print('✅ Fixed $fixed issues in ${file.path.split('/').last}');
      totalFixed += fixed;
    }
  }
  
  print('\n🎉 Fixing complete!');
  print('📊 Total issues fixed: $totalFixed');
  print('\n💡 Next steps:');
  print('   1. Run "flutter analyze" to check for any remaining issues');
  print('   2. Test your app to ensure it runs without crashes');
  print('   3. Consider adding proper error boundaries for better user experience');
}

Future<List<File>> _findDartFiles(Directory dir) async {
  final List<File> files = [];
  
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }
  
  return files;
}

Future<int> _fixFile(File file) async {
  final content = await file.readAsString();
  int fixed = 0;
  
  // Pattern to find AppLocalizations.of(context)! usage
  final pattern = RegExp(r'AppLocalizations\.of\(context\)!');
  final matches = pattern.allMatches(content);
  
  if (matches.isEmpty) {
    return 0;
  }
  
  String newContent = content;
  
  // Replace all instances
  for (final match in matches) {
    newContent = newContent.replaceFirst(
      'AppLocalizations.of(context)!',
      'AppLocalizations.of(context)',
    );
    fixed++;
  }
  
  // Also fix ModalRoute.of(context)! usage
  final modalRoutePattern = RegExp(r'ModalRoute\.of\(context\)!');
  final modalRouteMatches = modalRoutePattern.allMatches(newContent);
  
  for (final match in modalRouteMatches) {
    newContent = newContent.replaceFirst(
      'ModalRoute.of(context)!',
      'ModalRoute.of(context)',
    );
    fixed++;
  }
  
  if (fixed > 0) {
    await file.writeAsString(newContent);
  }
  
  return fixed;
}
