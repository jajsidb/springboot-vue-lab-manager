# 实验室设备管理系统 - 启动手册

## 1. 环境准备 (Prerequisites)
确保您的电脑已安装以下软件：
- **JDK 17+**: 用于运行 Java 后端。
- **Maven 3.6+**: 用于构建 Java 项目。
- **Node.js 16+**: 用于运行 Vue 前端。
- **MySQL 8.0+**: 数据库服务。

## 2. 数据库配置 (Database Setup)
数据库配置文件位于：`lab-equipment-backend/src/main/resources/application.properties`

**默认配置信息**：
- **数据库名**: `lab_equipment_db`
- **用户名**: `root`
- **密码**: `123123` 
- **端口**: `3306`

**数据初始化**：
我们已经在项目根目录为您生成了 `data_init.sql` 脚本，包含建表语句和测试数据。
您可以使用以下命令一键导入（需在项目根目录 `ks` 下执行）：

```powershell
# 请将 '123123' 替换为您的真实 MySQL root 密码
mysql -u root -p123123 --default-character-set=utf8mb4 -e "source ./data_init.sql"
```

## 3. 启动后端服务 (Backend)
后端基于 Spring Boot 开发，运行在 8080 端口。

1. **打开终端**，进入后端目录：
   ```bash
   cd lab-equipment-backend
   ```
2. **启动服务**：
   ```bash
   mvn spring-boot:run
   ```
   *注意：首次运行需要下载依赖，请耐心等待。*
3. **验证启动**：
   当看到控制台输出 `Started LabEquipmentApplication in ... seconds` 时，表示启动成功。

## 4. 启动前端服务 (Frontend)
前端基于 Vue 3 + Vite 开发。

1. **打开新的终端**，进入前端目录：
   ```bash
   cd lab-equipment-management
   ```
2. **安装依赖** (如果尚未安装)：
   ```bash
   npm install
   ```
3. **启动开发服务器**：
   ```bash
   npm run dev
   ```
4. **访问系统**：
   点击终端显示的链接（通常是 http://localhost:5173 或 http://localhost:5174）。

## 5. 常用测试账号 (Test Accounts)
所有账号的默认密码均为：`password`

| 角色 | 用户名 | 权限描述 |
| :--- | :--- | :--- |
| **管理员** | `admin` | 系统管理，设备管理，借用审批 |
| **管理员** | `lab_manager` | 实验室经理 |
| **学生** | `student1` | 申请借用，查看设备 |
| **学生** | `zhangsan` | 已有借用记录和逾期记录的测试用户 |
| **学生** | `alice` | 活跃用户 |

## 6. 常见问题排查
- **后端端口被占用**：修改 `application.properties` 中的 `server.port`。
- **前端 API 请求失败**：请检查后端是否已启动，以及 `src/utils/request.ts` 中的 `BASE_URL` 是否指向正确的后端地址（默认为 `http://localhost:8080/api`）。
- **数据库连接错误**：请检查 MySQL 服务是否开启，以及 `application.properties` 中的密码是否正确。
