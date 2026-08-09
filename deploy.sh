#!/bin/bash
# ============================================
# NEV 项目一键部署脚本
# 用法: ./deploy.sh [build|start|stop|restart|logs|clean]
# ============================================
set -e

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查 Docker 环境
check_docker() {
    if ! command -v docker &>/dev/null; then
        err "请先安装 Docker: https://docs.docker.com/engine/install/"
        exit 1
    fi
    if ! docker compose version &>/dev/null; then
        err "请安装 Docker Compose v2: https://docs.docker.com/compose/install/"
        exit 1
    fi
    log "Docker 环境检查通过"
}

# 构建前端
build_frontend() {
    log "构建 PC 管理端..."
    cd NEV_main/ruoyi-ui
    npm install --silent && npm run build:prod
    cd ../..
    log "PC 管理端构建完成 → NEV_main/ruoyi-ui/dist/"
}

# 构建并启动全部服务
build_and_start() {
    check_docker

    # 构建前端
    if [ ! -d "NEV_main/ruoyi-ui/dist" ]; then
        build_frontend
    else
        warn "PC 管理端已存在，跳过构建（如需重新构建请先删除 dist 目录）"
    fi

    log "启动所有服务..."
    docker compose up -d --build

    log "等待服务就绪..."
    sleep 10

    # 检查服务状态
    docker compose ps

    echo ""
    echo "============================================"
    echo -e "  ${GREEN}部署完成！${NC}"
    echo ""
    echo "  PC管理端:   http://localhost"
    echo "  H5移动端:   http://localhost/h5/"
    echo "  后端API:    http://localhost:8080"
    echo "  Swagger:    http://localhost:8080/swagger-ui.html"
    echo "  MinIO控制台: http://localhost:9001"
    echo "    (账号: minioadmin / 密码: minioadmin)"
    echo "============================================"
}

# 查看日志
show_logs() {
    local svc=${1:-}
    if [ -n "$svc" ]; then
        docker compose logs -f "$svc"
    else
        docker compose logs -f
    fi
}

case "${1:-}" in
    build)
        check_docker
        build_frontend
        ;;
    start)
        check_docker
        log "启动服务..."
        docker compose up -d
        docker compose ps
        ;;
    stop)
        log "停止服务..."
        docker compose stop
        ;;
    restart)
        check_docker
        log "重启服务..."
        docker compose restart
        docker compose ps
        ;;
    logs)
        show_logs "$2"
        ;;
    clean)
        warn "此操作将删除所有容器、数据卷和镜像！"
        read -p "确认？(yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            docker compose down -v --rmi all
            log "清理完成"
        else
            log "已取消"
        fi
        ;;
    *)
        build_and_start
        ;;
esac