我将为您构建基于 **Spring Boot** + **MySQL** 的后端服务，并对接现有的 Vue 前端。

### 📅 实施计划

#### 第一阶段：后端工程搭建 (lab-equipment-backend)
1.  **创建项目结构**：在 `c:\Users\Lenovo\Desktop\ks` 下创建 `lab-equipment-backend` 目录。
2.  **配置依赖 (pom.xml)**：引入 `Spring Web`, `Spring Data JPA`, `MySQL Driver`, `Lombok`。
3.  **数据库配置**：
    *   在 `application.properties` 中配置 MySQL 连接（默认假设 localhost:3306，用户名 root，密码 root，请在确认时告知实际密码）。
    *   配置 JPA 自动建表 (`hibernate.ddl-auto=update`)。

#### 第二阶段：后端核心代码实现
1.  **实体层 (Entity)**：
    *   `Device` (对应前端 Device)
    *   `BorrowRecord` (对应前端 BorrowRecord)
    *   `User` (新增用户表，支持登录)
2.  **持久层 (Repository)**：基于 `JpaRepository` 实现数据访问。
3.  **业务层 (Service)**：
    *   实现借用冲突检测逻辑（后端校验）。
    *   实现设备状态管理。
4.  **接口层 (Controller)**：
    *   `GET /api/devices` (查询设备)
    *   `POST /api/borrow/apply` (申请借用)
    *   `POST /api/borrow/return` (归还设备)
    *   `POST /api/auth/login` (简单的登录接口)

#### 第三阶段：前端对接改造 (lab-equipment-management)
1.  **安装 Axios**：用于发送 HTTP 请求。
2.  **配置跨域/代理**：修改 `vite.config.ts` 或后端添加 `@CrossOrigin`。
3.  **改造 Pinia Store**：
    *   `device.ts`: 将硬编码数据替换为 API 调用。
    *   `borrow.ts`: 借用、归还操作改为调用后端接口。
    *   `user.ts`: 对接登录接口。

### ❓ 确认事项
1.  您的本地 MySQL 数据库 **用户名** 和 **密码** 是什么？（我将默认设置为 `root/root`，后续您可自行修改）
2.  是否需要我为您生成初始化的 SQL 数据脚本？
