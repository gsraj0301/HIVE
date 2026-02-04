#!/bin/bash

# HIVE Quick Start Script
# For GUVI + HCL Hackathon 2026

echo "======================================"
echo "   HIVE - Scam Detection System"
echo "   Quick Start for Hackathon"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Start Backend
echo -e "${BLUE}[1/3] Starting Backend Server...${NC}"
cd backend/
python3 -m pip install Flask Flask-CORS -q 2>/dev/null
nohup python3 app.py > server.log 2>&1 &
sleep 3
echo -e "${GREEN}✓ Backend running on http://localhost:5000${NC}"
echo ""

# Step 2: Build Flutter Web
echo -e "${BLUE}[2/3] Building Flutter Web App...${NC}"
cd ../flutter_hive/
# Assuming flutter is in PATH or use full path
flutter pub get > /dev/null 2>&1
flutter build web --release > /dev/null 2>&1
echo -e "${GREEN}✓ Web app built successfully${NC}"
echo ""

# Step 3: Start Web Server
echo -e "${BLUE}[3/3] Starting Web Server...${NC}"
cd build/web
python3 -m http.server 8000 > /dev/null 2>&1 &
sleep 2
echo -e "${GREEN}✓ Web server running on http://localhost:8000${NC}"
echo ""

echo "======================================"
echo -e "${GREEN}HIVE is ready!${NC}"
echo "======================================"
echo ""
echo "📱 Open in browser: http://localhost:8000"
echo ""
echo "API Endpoints (for testing):"
echo "  POST /api/analyze-call"
echo "  GET  /api/scammers"
echo "  GET  /api/intelligence-report"
echo ""
echo "To stop servers:"
echo "  pkill -f 'app.py'"
echo "  pkill -f 'http.server'"
echo ""
