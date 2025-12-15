#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_DIR="/media/fi/NewVolume1/project01/UberKimi01/uberkimi02"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   UBER CLONE - QUICK START${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Kill existing processes
echo -e "${YELLOW}🔄 Cleaning up old processes...${NC}"
pkill -f "simple_server.js" 2>/dev/null
pkill -f "http.server 3010" 2>/dev/null
pkill -f "http.server 3011" 2>/dev/null
pkill -f "http.server 3012" 2>/dev/null
sleep 2

# Start backend
echo -e "${YELLOW}🖥️  Starting backend API server (Port 3000)...${NC}"
cd "$PROJECT_DIR/backend-services/rider-service"
node simple_server.js &
sleep 2

# Start frontend apps
echo -e "${YELLOW}📱 Starting Rider App (Port 3010)...${NC}"
cd "$PROJECT_DIR/flutter-apps/rider_app/build/web"
python3 -m http.server 3010 &
sleep 1

echo -e "${YELLOW}🚗 Starting Driver App (Port 3011)...${NC}"
cd "$PROJECT_DIR/flutter-apps/driver_app/build/web"
python3 -m http.server 3011 &
sleep 1

echo -e "${YELLOW}👨‍💼 Starting Admin App (Port 3012)...${NC}"
cd "$PROJECT_DIR/flutter-apps/admin_app/build/web"
python3 -m http.server 3012 &
sleep 2

# Verify services
echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ ALL SERVICES STARTED!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

echo -e "${GREEN}Backend API:${NC}"
echo -e "  URL: http://localhost:3000/api"
echo -e "  Health: http://localhost:3000/api/health\n"

echo -e "${GREEN}Rider App:${NC}"
echo -e "  URL: http://localhost:3010\n"

echo -e "${GREEN}Driver App:${NC}"
echo -e "  URL: http://localhost:3011\n"

echo -e "${GREEN}Admin App:${NC}"
echo -e "  URL: http://localhost:3012\n"

echo -e "${YELLOW}Demo Credentials:${NC}"
echo -e "  Rider Email: rider@demo.com"
echo -e "  Driver Email: driver@demo.com"
echo -e "  Admin Email: admin@demo.com\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Open your browser and go to http://localhost:3010${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
