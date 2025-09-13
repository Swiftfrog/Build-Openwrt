当然可以！以下是为您的 **`p115nano302` Docker 镜像** 量身定制的完整、专业、用户友好的 `README.md`，整合了您项目的全部功能、使用方式、安全设计和最佳实践，适合发布到 GitHub 或 Docker Hub。

---

# 🚀 p115nano302 —— 轻量级 115 网盘 HTTP 代理服务（Docker 版）

> **无需依赖 `pycryptodome` 和 `p115client`，仅需 Python 3.12+，一键部署，支持 SHA1 / Pickcode / ID / Name 查询，安全签名、多用户 Cookies 管理**

[![Docker Image](https://img.shields.io/docker/image-size/chenyanggao/p115nano302?label=Docker%20Image)](https://hub.docker.com/r/chenyanggao/p115nano302)
[![Python Version](https://img.shields.io/badge/Python-3.12%2B-blue)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-GPL--3.0-red)](https://www.gnu.org/licenses/gpl-3.0.txt)

<p align="center">
  <img src="https://cdn.pixabay.com/photo/2015/08/21/00/21/library-898333_1280.jpg" alt="115 Network Disk" width="600"/>
</p>

---

## ✅ 功能亮点

| 功能 | 说明 |
|------|------|
| 🔍 **多方式查询** | 支持通过 `id`、`pickcode`、`sha1`、`name` 四种方式查找文件（按此优先级） |
| 📁 **路径式查询** | 直接访问 `/SHA1/文件名.mp4` 或 `/pickcode/中文名称.mkv`，自动识别并提取关键信息 |
| 🔐 **请求签名** | 可启用 `token` 签名验证，防止未授权访问（`sign` 参数自动生成） |
| 🔄 **动态更新 Cookies** | 通过密码保护接口，远程批量更新多个账户的登录凭据 |
| 💾 **缓存优化** | 自动缓存文件 ID、下载链接，减少重复请求，提升响应速度 |
| 🌐 **WebDAV 兼容** | 适合作为 AList、Clouddrive 的后端数据源，替代传统网盘挂载 |
| 🐳 **轻量 Docker 部署** | 基于 `python:3.12-slim`，镜像小巧，启动快速，无额外依赖 |

---

## 📦 安装与部署（Docker 推荐方式）

### 1. 拉取镜像

```bash
docker pull chenyanggao/p115nano302
```

> 如需自行构建，请将本项目克隆后执行：
> ```bash
> docker build -t p115nano302 .
> ```

### 2. 准备你的 115 Cookies

将你的登录 Cookie 写入文件（推荐格式）：

```txt
# 115-cookies.txt
UID=xxx; CID=xxx; SEID=xxx; KID=xxx
UID=yyy; CID=yyy; SEID=yyy; KID=yyy
```

> ⚠️ 注意：每行一个 Cookie，必须包含 `UID=...`，否则会被忽略。  
> 可从浏览器开发者工具 → Application → Cookies 获取。

### 3. 启动容器

#### ✅ 最简启动（单用户）
```bash
docker run -d \
  --name p115nano302 \
  -p 8000:8000 \
  -v $(pwd)/115-cookies.txt:/cookies \
  chenyanggao/p115nano302 \
  -cp /cookies
```

#### ✅ 启用签名验证（推荐生产环境）
```bash
docker run -d \
  --name p115nano302 \
  -p 8000:8000 \
  -v $(pwd)/115-cookies.txt:/cookies \
  chenyanggao/p115nano302 \
  -cp /cookies \
  -t "your-super-secret-token-here"
```

#### ✅ 启用后台管理接口（修改 Cookies）
```bash
docker run -d \
  --name p115nano302 \
  -p 8000:8000 \
  -v $(pwd)/115-cookies.txt:/cookies \
  chenyanggao/p115nano302 \
  -cp /cookies \
  -p "myadminpassword123"
```

#### ✅ 启用缓存下载链接（提升体验）
```bash
docker run -d \
  --name p115nano302 \
  -p 8000:8000 \
  -v $(pwd)/115-cookies.txt:/cookies \
  chenyanggao/p115nano302 \
  -cp /cookies \
  -cu
```

---

## 🔧 使用示例

### 📌 查询文件（所有方式均支持）

| 方式 | URL 示例 | 说明 |
|------|----------|------|
| **SHA1** | `http://localhost:8000/E7FAA0BE343AF2DA8915F2B694295C8E4C91E691` | 直接用哈希值查 |
| **SHA1 + 文件名** | `http://localhost:8000/E7FAA0BE.../刺客伍六七.mp4` | 自动识别 SHA1，忽略路径后缀 ✅ |
| **Pickcode** | `http://localhost:8000/ecjq9ichcb40lzlvx` | 自动转换为 ID |
| **File ID** | `http://localhost:8000/2691590992858971545` | 直接返回下载链接 |
| **文件名** | `http://localhost:8000/刺客伍六七-S00E01-第1集.mp4` | 按名称搜索（支持中文） |
| **带参数** | `http://localhost:8000?sha1=E7FAA0BE...&name=xxx` | 查询参数兼容 |

> ✅ 所有方式最终都会返回 **302 重定向到真实下载链接**，可直接被播放器、AList、Clouddrive 使用。

### 🔐 使用签名验证（防蹭车）

若启动时指定了 `-t yourtoken`，则所有请求必须携带 `sign` 参数：

```bash
curl "http://localhost:8000/E7FAA0BE343AF2DA8915F2B694295C8E4C91E691?sign=$(echo -n '302@115-yourtoken-0-E7FAA0BE343AF2DA8915F2B694295C8E4C91E691' | sha1sum | cut -d' ' -f1)"
```

> `sign = sha1("302@115-{token}-{t}-{value}")`  
> `t=0` 表示永不过期，`value` 为实际查询值（如 SHA1、ID、name）

### 🛠️ 动态更新 Cookies（管理员接口）

#### 查看当前所有 Cookies：
```bash
curl "http://localhost:8000/<cookies?password=myadminpassword123"
```

#### 更新 Cookies（JSON 格式）：
```bash
curl -X POST \
  "http://localhost:8000/<cookies?password=myadminpassword123" \
  -H "Content-Type: application/json" \
  -d '{"cookies": "UID=xxx; CID=xxx; SEID=xxx\nUID=yyy; CID=yyy; SEID=yyy"}'
```

> 支持四种格式：字符串（`\n` 分隔）、数组、对象 `{cookies: ...}`、纯数组 `["cookie1", "cookie2"]`

---

## 📁 项目结构建议（Docker 部署）

```bash
~/p115nano302/
├── 115-cookies.txt          # 你的 115 登录凭据
├── docker-compose.yml       # （可选）编排文件
└── README.md                # 你正在看的这个文件
```

### ✅ 推荐 `docker-compose.yml`（一键启停）

```yaml
version: '3.8'
services:
  p115nano302:
    image: chenyanggao/p115nano302
    container_name: p115nano302
    ports:
      - "8000:8000"
    volumes:
      - ./115-cookies.txt:/cookies
    restart: unless-stopped
    command:
      - "-cp"
      - "/cookies"
      - "-t"
      - "your-super-secret-token"
      - "-p"
      - "your-admin-password"
      - "-cu"
```

启动：
```bash
docker-compose up -d
```

停止：
```bash
docker-compose down
```

---

## 📚 高级配置

| 参数 | 说明 |
|------|------|
| `-c COOKIES` | 直接传入 Cookie 字符串（优先级高于 `-cp`） |
| `-cp COOKIES_PATH` | 指定 Cookie 文件路径，默认 `/cookies` |
| `-p PASSWORD` | 设置管理密码，启用 `/⟨cookies⟩` 接口 |
| `-t TOKEN` | 启用签名验证，防止未授权访问 |
| `-cu` | 缓存下载链接，显著提升重复请求速度 |
| `-H HOST` | 绑定主机地址，默认 `0.0.0.0` |
| `-P PORT` | 监听端口，默认 `8000` |
| `-d` | 开启调试日志（输出详细请求信息） |
| `-uc CONFIG_PATH` | 加载 Uvicorn 配置文件（JSON/YAML/TOML） |

> 所有参数均支持 `--help` 查看帮助文档。

---

## 🤝 与其他工具集成

### ✅ 与 [AList](https://github.com/Xhofe/alist) 集成

在 AList 中添加 WebDAV 源：

- **URL**: `http://<你的服务器IP>:8000`
- **用户名**: 留空
- **密码**: 留空
- **根目录**: `/`（自动识别文件）

> ✅ 支持直接播放视频、预览图片，完美替代传统网盘挂载！

### ✅ 与 [Clouddrive](https://www.clouddrive2.com/) 集成

同样作为 WebDAV 源添加，即可实现“本地文件夹”映射 115 网盘内容。

---

## 📜 许可证

本项目采用 **GNU General Public License v3.0** 协议开源，欢迎贡献与改进。

🔗 [查看许可证全文](https://www.gnu.org/licenses/gpl-3.0.txt)

---

## ❤️ 致谢

- 由 [@ChenyangGao](https://chenyanggao.github.io) 开发维护
- 项目主页：[https://github.com/ChenyangGao/p115client](https://github.com/ChenyangGao/p115client)
- 感谢社区对 115 API 的逆向研究与探索

---

## 🚨 注意事项

- 本程序**不存储任何账号密码**，仅使用 Cookie 进行身份认证。
- 请勿将 Cookie 泄露给他人，避免账号被盗。
- 若遇到 `errno=20021` 错误，表示文件名含特殊后缀（如 `.exe`），系统会自动重试去除后缀，属正常行为。
- 建议配合 Nginx 反向代理 + HTTPS 使用，提升安全性。

---

> 🎯 **一句话总结：**  
> **把你的 115 网盘变成一个标准的 WebDAV 服务，从此告别客户端，全家桶播放器都能直连！**

---

✅ **立即部署，享受无感云盘体验！**  
👉 `docker pull chenyanggao/p115nano302 && docker run -p 8000:8000 chenyanggao/p115nano302 -cp /cookies`

---

如需我帮您生成 **GitHub 仓库封面图**、**Docker Hub 描述** 或 **一键部署脚本 `deploy-p115nano302.sh`**，也可以告诉我，我立刻为您准备！
