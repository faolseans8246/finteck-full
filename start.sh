#!/bin/bash

# FinTech Platform Docker Startup Script
# Bash script to manage Docker containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker o'rnatilmagan. https://docs.docker.com/install/ ga o'ting"
        exit 1
    fi
    print_success "Docker topildi: $(docker --version)"
}

# Function to check if Docker Compose is installed
check_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose o'rnatilmagan"
        exit 1
    fi
    print_success "Docker Compose topildi: $(docker-compose --version)"
}

# Function to start containers
start_containers() {
    print_info "Konteynerlar ishga tushirilmoqda..."
    docker-compose up --build -d
    
    if [ $? -eq 0 ]; then
        print_success "Konteynerlar muvaffaqiyatli ishga tushdi!"
        print_info "Platformalar:"
        echo "  Frontend:   http://localhost:3000"
        echo "  Backend:    http://localhost:2027"
        echo "  Swagger:    http://localhost:2027/swagger-ui.html"
        echo "  Database:   localhost:5432"
    else
        print_error "Konteynerlar ishga tushmadi"
        exit 1
    fi
}

# Function to stop containers
stop_containers() {
    print_info "Konteynerlar to'xtatilyapti..."
    docker-compose down
    
    if [ $? -eq 0 ]; then
        print_success "Konteynerlar muvaffaqiyatli to'xtatildi"
    else
        print_error "Konteynerlarni to'xtatishda xato"
        exit 1
    fi
}

# Function to restart containers
restart_containers() {
    print_info "Konteynerlar qayta boshlanyapti..."
    docker-compose restart
    
    if [ $? -eq 0 ]; then
        print_success "Konteynerlar muvaffaqiyatli qayta boshlandi"
    else
        print_error "Konteynerlarni qayta boshlashda xato"
        exit 1
    fi
}

# Function to show logs
show_logs() {
    print_info "Loglar ko'rsatilmoqda (-f bilan real-time kuzatish)..."
    docker-compose logs -f
}

# Function to show specific service logs
show_service_logs() {
    local service=$1
    print_info "$service ning loglari:"
    docker-compose logs -f $service
}

# Function to clean up everything
clean_up() {
    print_warning "Barcha konteynerlar va ma'lumotlar o'chiriladi..."
    read -p "Ishonchingiz komilmi? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v
        docker system prune -a -f
        print_success "Tozalash yakunlandi"
    else
        print_info "Tozalash bekor qilindi"
    fi
}

# Function to show status
show_status() {
    print_info "Konteynerlar holati:"
    docker-compose ps
}

# Function to show help
show_help() {
    echo -e "${BLUE}FinTech Platform Docker Manager${NC}"
    echo ""
    echo "Qo'llanish: $0 [komanda]"
    echo ""
    echo "Buyruqlar:"
    echo "  start       - Konteynerlarni ishga tushirish"
    echo "  stop        - Konteynerlarni to'xtatish"
    echo "  restart     - Konteynerlarni qayta boshlash"
    echo "  logs        - Barcha loglarni ko'rish"
    echo "  logs-backend    - Frontend loglarini ko'rish"
    echo "  logs-frontend   - Backend loglarini ko'rish"
    echo "  status      - Konteynerlar holatini ko'rish"
    echo "  clean       - Barcha ma'lumotlarni o'chirish"
    echo "  help        - Bu ko'rsatmani ko'rish"
    echo ""
}

# Main command handler
main() {
    # Check if Docker and Docker Compose are installed
    check_docker
    check_compose
    
    case "${1:-help}" in
        start)
            start_containers
            ;;
        stop)
            stop_containers
            ;;
        restart)
            restart_containers
            ;;
        logs)
            show_logs
            ;;
        logs-backend)
            show_service_logs "backend"
            ;;
        logs-frontend)
            show_service_logs "frontend"
            ;;
        status)
            show_status
            ;;
        clean)
            clean_up
            ;;
        help)
            show_help
            ;;
        *)
            print_error "Noma'lum komanda: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
