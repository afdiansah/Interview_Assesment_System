@echo off
REM Quick commands untuk MkDocs Documentation
REM AI Interview Assessment System

echo ========================================
echo MkDocs Documentation - Quick Commands
echo ========================================
echo.

if "%1"=="" goto menu
if "%1"=="install" goto install
if "%1"=="serve" goto serve
if "%1"=="build" goto build
if "%1"=="deploy" goto deploy
if "%1"=="clean" goto clean
goto menu

:menu
echo Available commands:
echo.
echo   docs install    - Install MkDocs dependencies
echo   docs serve      - Start local preview server
echo   docs build      - Build static documentation
echo   docs deploy     - Deploy to GitHub Pages
echo   docs clean      - Clean build artifacts
echo.
echo Example: docs serve
goto end

:install
echo Installing MkDocs dependencies...
pip install -r docs-requirements.txt
echo.
echo ✓ Installation complete!
echo   Run 'docs serve' to start preview server
goto end

:serve
echo Starting MkDocs preview server...
echo   URL: http://127.0.0.1:8000
echo   Press Ctrl+C to stop
echo.
mkdocs serve
goto end

:build
echo Building static documentation...
mkdocs build --strict --verbose
echo.
echo ✓ Build complete!
echo   Output: site/ directory
goto end

:deploy
echo Deploying to GitHub Pages...
mkdocs gh-deploy --force
echo.
echo ✓ Deployment complete!
goto end

:clean
echo Cleaning build artifacts...
if exist site rmdir /s /q site
echo.
echo ✓ Clean complete!
goto end

:end
