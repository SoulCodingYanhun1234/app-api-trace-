# Trace Enterprise API v3

后端已重构为 **NestJS + Fastify + Prisma + Redis + BullMQ**。

## 主要变化

- `apps/api-koa-backup`：旧 Koa/Knex 后端备份。
- `apps/api`：新的 NestJS 后端。
- `prisma/schema.prisma`：业务表、RBAC、风控、上传文件、日志等模型。
- `src/worker.ts`：BullMQ Worker 入口，用于异步生成防伪码和写入查询日志。
- 保留原前端接口路径：`/api/auth`、`/api/products`、`/api/codes`、`/api/query` 等。

## 启动

```bash
docker compose up -d mysql redis

cd apps/api
cp .env.example .env
npm install
npm run db:push
npm run dev
```

另开一个终端启动队列 Worker：

```bash
cd apps/api
npm run worker
```

## 常用命令

```bash
npm run dev        # API 开发模式
npm run build      # 编译
npm run start      # 启动编译产物
npm run db:push    # 推送 Prisma schema 并恢复初始数据
npm run db:seed    # 恢复超级管理员、角色、权限和系统默认配置
npm run db:migrate:deploy # 生产安全迁移、历史基线兼容与 seed
npm run db:clear   # 清空所有业务表并恢复初始数据（保留 Prisma 迁移记录）
npm run admin:check # 检查管理员状态，不输出密码 hash
npm run migrate    # Prisma migration dev
npm run worker     # 启动 BullMQ worker
```

生产环境首次执行 seed 前，必须配置 `SUPER_ADMIN_PASSWORD`。密码至少
12 位，并包含大小写字母、数字、符号中的至少三类；公开默认值和示例占位值会被拒绝。

需要重置管理员密码时，不要把密码写进脚本或命令行参数。临时设置以下环境变量后执行：

```bash
ADMIN_RESET_USERNAME=admin
ADMIN_RESET_PASSWORD=your-new-strong-password
ADMIN_RESET_CONFIRM=RESET:admin
npm run admin:reset-password
```

## 清空并恢复数据库

开发或测试环境可直接执行：

```bash
npm run db:clear
```

该命令会清空当前 `DATABASE_URL` 所指 MySQL 数据库中的所有业务表，保留 `_prisma_migrations`，重置可重置的自增值，然后执行现有 Prisma seed，恢复超级管理员、角色、权限和系统默认配置。它不会删除上传目录中的物理文件，也不会清空 Redis。

生产环境必须显式确认：

```bash
DB_CLEAR_CONFIRM=CLEAR_ALL_DATA npm run db:clear
```

可通过 `DB_CLEAR_TIMEOUT_MS` 调整清理事务超时，默认 `300000` 毫秒。执行前应停止 API 与 Worker，避免清理过程中继续写入数据。

在 npm workspace/monorepo 中，应从仓库根目录安装依赖；`db:clear` 会直接使用已生成的 `@prisma/client`，不会因为 Prisma CLI 被提升到根目录而误报缺失。请勿用 `--ignore-scripts`，否则安装时不会生成 Prisma Client。

## Swagger

默认地址：

```text
http://localhost:3000/api/docs
```

生产环境建议设置：

```env
SWAGGER_ENABLED=false
```

## UAPI 公网位置

公网位置统一使用 `https://uapis.cn/api/v1/network/myip?source=commercial`。服务端调用会从 `UAPI_API_KEY`（兼容 `UAPI_KEY`）读取 APIKey，并发送 `Authorization: Bearer <APIKey>`；未配置时不会请求该接口。

## 高并发扫码查询链路

```text
/query
  -> Redis IP/code 限流
  -> Redis 查询结果缓存
  -> Prisma 查询码和产品
  -> BullMQ 异步写 query_logs 和更新 query_count
  -> 快速返回查询结果
```

## 异步生成防伪码

兼容旧接口：

```text
POST /api/codes/generate
```

新增异步接口：

```text
POST /api/codes/generate-async
```

异步接口会把任务投递到 `code-generation` 队列，由 `npm run worker` 消费。


## 消费者验证页 / 旧二维码兼容

- 新生成的二维码地址会指向前端验证页：`/verify/{code}`。
- 旧版二维码如果仍是 `/api/query?code={code}`，浏览器扫码访问时会自动 302 跳转到 `/verify/{code}`，避免直接显示 JSON。
- API 客户端如果请求 `GET /api/query` 且 `Accept` 包含 `application/json`，仍返回 JSON。
- 公开配置接口：`GET /api/settings/public/query-panel`，读取后台「面板设置 → 前台查询面板可视化设置」。
- 如前后端不同域部署，请配置 `FRONTEND_BASE_URL=https://你的前端域名`；验证页路径可通过 `VERIFY_PAGE_PATH=/verify` 调整。

### 历史短码与签名码切换

生产环境启用签名码后，数据库中已经发行的历史短码可继续通过精确哈希匹配验真：

```env
ANTI_FAKE_ALLOW_REGISTERED_LEGACY_CODES=true
```

该开关只兼容“已登记”的历史码，不会接受数据库中不存在的任意短码，也不会放行签名无效的 `AF1.*` 编码。完成库存旧码清退后可设为 `false`，再执行严格切换。

消费者页面不再把浏览器直连第三方 IP 服务得到的位置作为防窜授权依据。授权区域判断统一使用 API 侧可信代理链/GeoIP 证据，避免码级防窜已关闭时仍触发额外定位请求。

## 宝塔 / 生产部署修复

如果启动时报以下错误，说明线上依赖或 Prisma Client 没有完整生成：

```text
Cannot find package .../node_modules/bullmq/index.js
Cannot find module '.prisma/client/default'
```

推荐重新安装：

```bash
cd /www/wwwroot/backend
rm -rf node_modules
npm cache verify
npm ci --omit=dev
npm run db:generate
npm run doctor
npm run start:prod
```

本包已内置保护：

- `postinstall` 会自动执行 `prisma generate`
- `npm start` / `npm run start:prod` 会在启动前检查 Prisma Client，缺失时自动生成
- `npm run doctor` 会检查 BullMQ、Nest BullMQ、Prisma Client 是否可加载

如果看到 `npm warn Unknown global config "--init.module"`，这是服务器 npm 全局配置警告，不影响本项目启动。可清理：

```bash
npm config delete init.module --location=global || true
```

Redis 必须可连接：

```env
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_DB=0
REDIS_PASSWORD=
```

PM2 示例，推荐跑 npm script，不要直接跑 `dist/main.js`：

```bash
pm2 delete trace-api || true
pm2 start npm --name trace-api -- run start:prod
pm2 save
```

队列 Worker：

```bash
pm2 delete trace-worker || true
pm2 start npm --name trace-worker -- run worker
pm2 save
```

## 本次业务增强

- 新增 `product_regions` 产品地区模型，用于“产品 -> 省市 -> 仓库/代理商 -> 扫描枪分类”的映射。
- 扫码业务台返回完整链路：产品地区 -> 溯源 -> 装箱 -> 发货。
- 分类装箱时按产品、批次、地区解析扫码内容，并同步产品地区扫码记录。
- 发货流程继续联动箱状态和溯源节点。
- 模块关联文档：`docs/MODULE_RELATIONS.md`。
- 扫描枪使用说明：`docs/SCANNER_GUIDE.md`，前端独立页面 `/scanner-guide`。

上线新增表后执行：

```bash
npm run db:push
npm run db:generate
npm run doctor
npm run start:prod
```

## 双域名登录策略

同一份前端构建产物可同时部署到两个域名：

- `https://workpanel.0office.top`：未登录访问后台路由时直接跳转 `/login`，不要求 `entry`。
- `https://qr.0office.top`：公开的 `/verify/{code}`、`/v/{code}` 保持可访问；后台登录必须先访问 `https://qr.0office.top/login?entry=配置的密钥`。

前端通过 `VITE_ADMIN_DIRECT_LOGIN_HOSTS` 与 `VITE_ADMIN_ENTRY_REQUIRED_HOSTS` 判断页面入口；后端通过 `ADMIN_DIRECT_LOGIN_HOSTS`、`ADMIN_ENTRY_REQUIRED_HOSTS` 和请求的 `Origin/Host` 再次校验，不能只靠前端绕过。

登录会话采用 7 天滑动空闲期：连续 7 天没有操作才退出；有鼠标、键盘、触摸、重新聚焦等活动时会刷新会话。刷新令牌仍需保持 `JWT_REFRESH_EXPIRES_IN=7d`，每次有效活动刷新后重新获得 7 天有效期。

## AI 功能开关

在后端 `.env` 中设置：

```env
AI_FEATURE_ENABLED=true
```

设置为 `false`、`0`、`off` 或 `no` 后，AI 溯源研判与 AI 自动巡检/补链接口返回 404，Swagger 中也不再展示这些接口。普通溯源、防窜、装箱和发货业务不受影响。修改后重启 API 服务。
