#!/bin/bash
# Quick commands untuk MkDocs Documentation
# AI Interview Assessment System

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function show_menu() {
    echo "========================================"
    echo "MkDocs Documentation - Quick Commands"
    echo "========================================"
    echo ""
    echo "Available commands:"
    echo ""
    echo "  ./docs.sh install    - Install MkDocs dependencies"
    echo "  ./docs.sh serve      - Start local preview server"
    echo "  ./docs.sh build      - Build static documentation"
    echo "  ./docs.sh deploy     - Deploy to GitHub Pages"
    echo "  ./docs.sh clean      - Clean build artifacts"
    echo ""
    echo "Example: ./docs.sh serve"
}

function install_deps() {
    echo -e "${YELLOW}Installing MkDocs dependencies...${NC}"
    pip install -r docs-requirements.txt
    echo ""
    echo -e "${GREEN}✓ Installation complete!${NC}"
    echo "  Run './docs.sh serve' to start preview server"
}

function serve_docs() {
    echo -e "${YELLOW}Starting MkDocs preview server...${NC}"
    echo "  URL: http://127.0.0.1:8000"
    echo "  Press Ctrl+C to stop"
    echo ""
    mkdocs serve
}

function build_docs() {
    echo -e "${YELLOW}Building static documentation...${NC}"
    mkdocs build --strict --verbose
    echo ""
    echo -e "${GREEN}✓ Build complete!${NC}"
    echo "  Output: site/ directory"
}

function deploy_docs() {
    echo -e "${YELLOW}Deploying to GitHub Pages...${NC}"
    mkdocs gh-deploy --force
    echo ""
    echo -e "${GREEN}✓ Deployment complete!${NC}"
}

function clean_docs() {
    echo -e "${YELLOW}Cleaning build artifacts...${NC}"
    rm -rf site/
    echo ""
    echo -e "${GREEN}✓ Clean complete!${NC}"
}

# Main script
case "$1" in
    install)
        install_deps
        ;;
    serve)
        serve_docs
        ;;
    build)
        build_docs
        ;;
    deploy)
        deploy_docs
        ;;
    clean)
        clean_docs
        ;;
    *)
        show_menu
        ;;
esac
