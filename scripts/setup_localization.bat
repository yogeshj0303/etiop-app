@echo off
REM Localization Setup Script for Etiop Application
REM This script helps set up the multilingual support system

echo 🚀 Setting up Multilingual Support for Etiop Application
echo ========================================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    pause
    exit /b 1
)

echo ✅ Flutter is installed

REM Navigate to project directory
cd /d "%~dp0.."

echo 📁 Current directory: %cd%

REM Check if pubspec.yaml exists
if not exist "pubspec.yaml" (
    echo ❌ pubspec.yaml not found. Please run this script from the project root.
    pause
    exit /b 1
)

echo ✅ Found pubspec.yaml

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

if %errorlevel% neq 0 (
    echo ❌ Failed to get dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed

REM Generate localization files
echo 🌐 Generating localization files...
flutter gen-l10n

if %errorlevel% neq 0 (
    echo ❌ Failed to generate localization files
    echo 💡 Make sure you have the correct Flutter version and dependencies
    pause
    exit /b 1
)

echo ✅ Localization files generated

REM Check if generated files exist
if exist "lib\generated" (
    echo ✅ Generated files found in lib\generated\
    dir lib\generated
) else (
    echo ⚠️  Generated files not found. This might be normal for some Flutter versions.
)

REM Clean and rebuild
echo 🧹 Cleaning and rebuilding...
flutter clean
flutter pub get

echo ✅ Project cleaned and rebuilt

echo.
echo 🎉 Multilingual Support Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. ✅ Dependencies added to pubspec.yaml
echo 2. ✅ Localization files created (app_en.arb, app_hi.arb)
echo 3. ✅ Language provider created
echo 4. ✅ Settings screens created
echo 5. ✅ Main app configured for localization
echo 6. ✅ Localization files generated
echo.
echo To test the implementation:
echo 1. Run the app: flutter run
echo 2. Navigate to Settings → Language
echo 3. Switch between English and Hindi
echo 4. Verify text changes accordingly
echo.
echo To add new localized strings:
echo 1. Add to lib\l10n\app_en.arb
echo 2. Add to lib\l10n\app_hi.arb
echo 3. Run: flutter gen-l10n
echo 4. Use in code: l10n.stringKey
echo.
echo 📚 Documentation: MULTILINGUAL_SETUP.md
echo 🔧 Example implementation: lib\examples\localization_example.dart
echo.
echo Happy coding! 🌍
pause
