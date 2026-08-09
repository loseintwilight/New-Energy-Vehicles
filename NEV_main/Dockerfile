# ============================================
# 阶段一：Maven 构建
# ============================================
FROM registry.cn-hangzhou.aliyuncs.com/library/maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

# 先复制根 POM 和模块 POM，利用 Docker 缓存层
COPY pom.xml .
COPY ruoyi-common/pom.xml ruoyi-common/
COPY ruoyi-system/pom.xml ruoyi-system/
COPY ruoyi-framework/pom.xml ruoyi-framework/
COPY ruoyi-quartz/pom.xml ruoyi-quartz/
COPY ruoyi-generator/pom.xml ruoyi-generator/
COPY ruoyi-admin/pom.xml ruoyi-admin/
COPY a-charging-serve/pom.xml a-charging-serve/
COPY a-chargeMini-serve/pom.xml a-chargeMini-serve/
COPY a-carbonStatistics/pom.xml a-carbonStatistics/
COPY a-maintenance-order/pom.xml a-maintenance-order/
COPY a-mine/pom.xml a-mine/
COPY a-buycar-server/pom.xml a-buycar-server/
COPY a-vehicle/pom.xml a-vehicle/
COPY a-vehicle-orders/pom.xml a-vehicle-orders/
COPY a-vehicle-review/pom.xml a-vehicle-review/

# 下载依赖（缓存层）
RUN mvn dependency:go-offline -B -q

# 复制全部源码
COPY . .

# 打包（跳过测试，激活 docker 配置）
RUN mvn clean package -DskipTests -B -q

# ============================================
# 阶段二：运行镜像
# ============================================
FROM registry.cn-hangzhou.aliyuncs.com/library/eclipse-temurin:17-jre-alpine

# 时区
RUN apk add --no-cache tzdata curl && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

# 从构建阶段复制 JAR
COPY --from=builder /build/ruoyi-admin/target/ruoyi-admin.jar app.jar

# 创建上传目录
RUN mkdir -p /home/nev/uploadPath

# JVM 参数
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -Duser.timezone=Asia/Shanghai"

EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT exec java $JAVA_OPTS -jar app.jar