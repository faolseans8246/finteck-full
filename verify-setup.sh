#!/bin/bash

# FinTech Platform Docker Setup Verification Script
# This script verifies all Docker configuration is in place

set -e

echo "========================================"
echo "🔍 FinTech Platform Docker Setup Verification"
echo "========================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} $1"
        return 0
    else
        echo -e "${RED}❌${NC} $1 (TOPILMADI)"
        return 1
    fi
}

# Function to check directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅${NC} $1/"
        return 0
    else
        echo -e "${RED}❌${NC} $1/ (TOPILMADI)"
        return 1
    fi
}

# Counter for checks
total_checks=0
passed_checks=0

# 1. Docker Installation Check
echo -e "${BLUE}📦 Docker Instolatsiyasi${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
total_checks=$((total_checks+1))
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅${NC} Docker o'rnatilgan: $(docker --version)"
    passed_checks=$((passed_checks+1))
else
    echo -e "${RED}❌${NC} Docker o'rnatilmagan"
fi

total_checks=$((total_checks+1))
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✅${NC} Docker Compose o'rnatilgan: $(docker-compose --version)"
    passed_checks=$((passed_checks+1))
else
    echo -e "${RED}❌${NC} Docker Compose o'rnatilmagan"
fi
echo ""

# 2. Docker Configuration Files
echo -e "${BLUE}🐳 Docker Konfiguratsiya Fayllar${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for file in "docker-compose.yml" "Main_Back_End/Dockerfile" "browser-platform/Dockerfile" "browser-platform/nginx.conf" "Main_Back_End/.dockerignore" "browser-platform/.dockerignore"; do
    total_checks=$((total_checks+1))
    if check_file "$file"; then
        passed_checks=$((passed_checks+1))
    fi
done
echo ""

# 3. Startup Scripts
echo -e "${BLUE}🚀 Startup Vositalari${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for file in "start.sh" "start.bat" "QUICKSTART.md" "DOCKER_README.md" ".env.example" ".gitignore"; do
    total_checks=$((total_checks+1))
    if check_file "$file"; then
        passed_checks=$((passed_checks+1))
    fi
done
echo ""

# 4. Application Structure
echo -e "${BLUE}📁 Dastur Struktura${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
dirs=(
    "Main_Back_End"
    "browser-platform"
    "web-site-browser"
)
for dir in "${dirs[@]}"; do
    total_checks=$((total_checks+1))
    if check_dir "$dir"; then
        passed_checks=$((passed_checks+1))
    fi
done
echo ""

# 5. Modified Configuration Files
echo -e "${BLUE}⚙️ O'zgartirilgan Konfiguratsiyalar${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
files=(
    "browser-platform/src/services/api.js"
    "Main_Back_End/src/main/resources/application-dev.yml"
)
for file in "${files[@]}"; do
    total_checks=$((total_checks+1))
    if check_file "$file"; then
        passed_checks=$((passed_checks+1))
    fi
done
echo ""

# 6. Docker Compose Validation
echo -e "${BLUE}✔️ Docker Compose Validation${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
total_checks=$((total_checks+1))
if docker-compose config > /dev/null 2>&1; then
    echo -e "${GREEN}✅${NC} Docker Compose konfiguratsiyasi to'g'ri"
    passed_checks=$((passed_checks+1))
else
    echo -e "${RED}❌${NC} Docker Compose konfiguratsiyasida xato"
fi
echo ""

# 7. Summary
echo "========================================"
echo -e "${BLUE}📊 Natija${NC}"
echo "========================================"
echo -e "Jami tekshiruv:  ${BLUE}$total_checks${NC}"
echo -e "Muvaffaqiyatli: ${GREEN}$passed_checks${NC}"
echo -e "Muvaffaqiyatsiz: ${RED}$((total_checks - passed_checks))${NC}"
echo ""

# Success percentage
percentage=$((passed_checks * 100 / total_checks))
echo -e "Muvaffaqiyat darajasi: ${BLUE}${percentage}%${NC}"
echo ""

if [ $passed_checks -eq $total_checks ]; then
    echo -e "${GREEN}✅ Barcha tekshiruv muvaffaqiyatli o'tdi!${NC}"
    echo ""
    echo "🚀 Ishga tushirish uchun quyidagini bajaring:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  Variant 1 (Linux/macOS):"
    echo "    chmod +x start.sh"
    echo "    ./start.sh start"
    echo ""
    echo "  Variant 2 (Windows):"
    echo "    start.bat start"
    echo ""
    echo "  Variant 3 (Barcha Platformalar):"
    echo "    docker-compose up --build"
    echo ""
    echo "Brauzerda oching:"
    echo "  Frontend:  http://localhost:3000"
    echo "  Backend:   http://localhost:2027"
    echo "  Swagger:   http://localhost:2027/swagger-ui.html"
    echo ""
else
    echo -e "${YELLOW}⚠️  Ba'zi tekshiruv muvaffaqiyatli bo'lmadi!${NC}"
    echo -e "${YELLOW}Yuqoridagi xatolarni tekshiring va qayta bajaring.${NC}"
    echo ""
fi

echo "========================================"
