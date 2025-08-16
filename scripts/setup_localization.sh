#!/bin/bash

# Localization Setup Script for Etiop Application
# This script helps set up the multilingual support system

echo "🚀 Setting up Multilingual Support for Etiop Application"
echo "========================================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter is installed"

# Navigate to project directory
cd "$(dirname "$0")/.."

echo "📁 Current directory: $(pwd)"

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

echo "✅ Found pubspec.yaml"

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

echo "✅ Dependencies installed"

# Generate localization files
echo "🌐 Generating localization files..."
flutter gen-l10n

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate localization files"
    echo "💡 Make sure you have the correct Flutter version and dependencies"
    exit 1
fi

echo "✅ Localization files generated"

# Check if generated files exist
if [ -d "lib/generated" ]; then
    echo "✅ Generated files found in lib/generated/"
    ls -la lib/generated/
else
    echo "⚠️  Generated files not found. This might be normal for some Flutter versions."
fi

# Clean and rebuild
echo "🧹 Cleaning and rebuilding..."
flutter clean
flutter pub get

echo "✅ Project cleaned and rebuilt"

echo ""
echo "🎉 Multilingual Support Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. ✅ Dependencies added to pubspec.yaml"
echo "2. ✅ Localization files created (app_en.arb, app_hi.arb)"
echo "3. ✅ Language provider created"
echo "4. ✅ Settings screens created"
echo "5. ✅ Main app configured for localization"
echo "6. ✅ Localization files generated"
echo ""
echo "To test the implementation:"
echo "1. Run the app: flutter run"
echo "2. Navigate to Settings → Language"
echo "3. Switch between English and Hindi"
echo "4. Verify text changes accordingly"
echo ""
echo "To add new localized strings:"
echo "1. Add to lib/l10n/app_en.arb"
echo "2. Add to lib/l10n/app_hi.arb"
echo "3. Run: flutter gen-l10n"
echo "4. Use in code: l10n.stringKey"
echo ""
echo "📚 Documentation: MULTILINGUAL_SETUP.md"
echo "🔧 Example implementation: lib/examples/localization_example.dart"
echo ""
echo "Happy coding! 🌍"
