-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS lab_equipment_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lab_equipment_db;

-- 禁用外键检查以避免插入顺序问题
SET FOREIGN_KEY_CHECKS = 0;

-- 自动建表（确保表存在）
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255),
    role VARCHAR(255) NOT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS devices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    image TEXT,
    status VARCHAR(255),
    type VARCHAR(255),
    max_duration INT,
    description TEXT,
    create_time DATETIME
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS borrow_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255),
    device_id BIGINT,
    device_name VARCHAR(255),
    start_time DATETIME,
    end_time DATETIME,
    purpose VARCHAR(255),
    contact_info VARCHAR(255),
    status VARCHAR(255),
    create_time DATETIME
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ==========================================
-- 1. 用户表 (users) 数据初始化
-- ==========================================
TRUNCATE TABLE users;

-- 管理员账号 (密码均为 password)
INSERT INTO users (username, password, role) VALUES 
('admin', 'password', 'admin'),
('lab_manager', 'password', 'admin');

-- 学生账号 (密码均为 password)
INSERT INTO users (username, password, role) VALUES 
('student1', 'password', 'student'),
('zhangsan', 'password', 'student'),
('lisi', 'password', 'student'),
('wangwu', 'password', 'student'),
('zhaoliu', 'password', 'student'),
('alice', 'password', 'student'),
('bob', 'password', 'student'),
('charlie', 'password', 'student'),
('david', 'password', 'student'),
('eve', 'password', 'student');

-- ==========================================
-- 2. 设备表 (devices) 数据初始化
-- ==========================================
TRUNCATE TABLE devices;

-- 光学仪器 (Optical)
INSERT INTO devices (name, image, status, type, max_duration, description, create_time) VALUES 
('奥林巴斯显微镜 CX23', 'https://images.unsplash.com/photo-1518152006812-edab29b069ac?q=80&w=300&auto=format&fit=crop', 'available', 'optical', 7, '生物教学级显微镜，LED光源，40x-1000x放大倍率', NOW()),
('蔡司共聚焦显微镜', 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=300&auto=format&fit=crop', 'borrowed', 'optical', 3, '高分辨率激光共聚焦显微镜，用于细胞生物学研究', NOW()),
('尼康体视显微镜 SMZ', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=300&auto=format&fit=crop', 'available', 'optical', 5, '大视野体视显微镜，适用于解剖和电路板检查', NOW()),
('紫外分光光度计', 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?q=80&w=300&auto=format&fit=crop', 'available', 'optical', 2, '双光束紫外可见分光光度计，波长范围190-1100nm', NOW()),
('激光干涉仪', 'https://images.unsplash.com/photo-1581093450021-4a7360e9a6b5?q=80&w=300&auto=format&fit=crop', 'available', 'optical', 1, '高精度表面形貌测量仪', NOW());

-- 电子设备 (Electronic)
INSERT INTO devices (name, image, status, type, max_duration, description, create_time) VALUES 
('泰克示波器 TBS1102', 'https://images.unsplash.com/photo-1581093458791-9f302e6d8359?q=80&w=300&auto=format&fit=crop', 'available', 'electronic', 5, '100MHz带宽，2通道数字存储示波器', NOW()),
('安捷伦频谱分析仪', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=300&auto=format&fit=crop', 'borrowed', 'electronic', 3, '9kHz-3GHz 频谱分析仪，用于射频信号分析', NOW()),
('福禄克数字万用表', 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?q=80&w=300&auto=format&fit=crop', 'available', 'electronic', 14, '真有效值数字万用表，工业级精度', NOW()),
('函数信号发生器', 'https://images.unsplash.com/photo-1581092335397-9583eb92d232?q=80&w=300&auto=format&fit=crop', 'available', 'electronic', 5, '20MHz双通道任意波形发生器', NOW()),
('直流稳压电源', 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?q=80&w=300&auto=format&fit=crop', 'available', 'electronic', 7, '30V/5A 可编程直流电源', NOW()),
('FPGA开发板', 'https://images.unsplash.com/photo-1600439614353-174ad0ee3b25?q=80&w=300&auto=format&fit=crop', 'borrowed', 'electronic', 14, 'Xilinx Artix-7 开发套件', NOW());

-- 耗材 (Consumable)
INSERT INTO devices (name, image, status, type, max_duration, description, create_time) VALUES 
('移液枪套装', 'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=300&auto=format&fit=crop', 'available', 'consumable', 30, 'Eppendorf 移液枪套装 (0.5-10ul, 10-100ul, 100-1000ul)', NOW()),
('玻璃烧杯组', 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?q=80&w=300&auto=format&fit=crop', 'available', 'consumable', 30, '50ml, 100ml, 250ml, 500ml 烧杯组合', NOW()),
('试管架与试管', 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=300&auto=format&fit=crop', 'available', 'consumable', 30, '不锈钢试管架含50支玻璃试管', NOW());

-- 其他 (Other)
INSERT INTO devices (name, image, status, type, max_duration, description, create_time) VALUES 
('离心机', 'https://images.unsplash.com/photo-1576086213369-97a306d36557?q=80&w=300&auto=format&fit=crop', 'available', 'other', 3, '台式高速冷冻离心机，最高转速15000rpm', NOW()),
('恒温培养箱', 'https://images.unsplash.com/photo-1581093450021-4a7360e9a6b5?q=80&w=300&auto=format&fit=crop', 'borrowed', 'other', 7, '二氧化碳培养箱，用于细胞培养', NOW()),
('3D打印机', 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?q=80&w=300&auto=format&fit=crop', 'available', 'other', 5, 'FDM 桌面级3D打印机，打印尺寸200x200x200mm', NOW());

-- ==========================================
-- 3. 借用记录表 (borrow_records) 数据初始化
-- ==========================================
TRUNCATE TABLE borrow_records;

-- 历史记录 (已归还)
INSERT INTO borrow_records (user_name, device_id, device_name, start_time, end_time, purpose, contact_info, status, create_time) VALUES 
('zhangsan', 1, '奥林巴斯显微镜 CX23', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY), '生物实验课观察切片', '13800138000', 'returned', DATE_SUB(NOW(), INTERVAL 11 DAY)),
('lisi', 6, '泰克示波器 TBS1102', DATE_SUB(NOW(), INTERVAL 15 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY), '电路原理实验', '13900139000', 'returned', DATE_SUB(NOW(), INTERVAL 16 DAY)),
('wangwu', 14, '离心机', DATE_SUB(NOW(), INTERVAL 20 DAY), DATE_SUB(NOW(), INTERVAL 19 DAY), '分离样品', '13700137000', 'returned', DATE_SUB(NOW(), INTERVAL 21 DAY));

-- 当前正在借用 (Approved) - 对应上面设备状态为 'borrowed' 的设备
INSERT INTO borrow_records (user_name, device_id, device_name, start_time, end_time, purpose, contact_info, status, create_time) VALUES 
('zhaoliu', 2, '蔡司共聚焦显微镜', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), '研究生课题研究', '13600136000', 'approved', DATE_SUB(NOW(), INTERVAL 2 DAY)),
('alice', 7, '安捷伦频谱分析仪', NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), '射频模块调试', '13500135000', 'approved', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
('bob', 15, '恒温培养箱', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY), '细菌培养实验', '13400134000', 'approved', DATE_SUB(NOW(), INTERVAL 3 DAY)),
('eve', 11, 'FPGA开发板', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY), '毕业设计硬件开发', '13300133000', 'approved', DATE_SUB(NOW(), INTERVAL 6 DAY));

-- 待审批记录 (Pending)
INSERT INTO borrow_records (user_name, device_id, device_name, start_time, end_time, purpose, contact_info, status, create_time) VALUES 
('charlie', 3, '尼康体视显微镜 SMZ', DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 3 DAY), '昆虫标本制作', '13200132000', 'pending', NOW()),
('david', 8, '福禄克数字万用表', DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY), '家电维修兴趣小组活动', '13100131000', 'pending', NOW());

-- 归还待确认 (Return Pending)
INSERT INTO borrow_records (user_name, device_id, device_name, start_time, end_time, purpose, contact_info, status, create_time) VALUES 
('student1', 4, '紫外分光光度计', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW(), '化学分析实验', '13000130000', 'return_pending', DATE_SUB(NOW(), INTERVAL 3 DAY));

-- 已拒绝记录 (Rejected)
INSERT INTO borrow_records (user_name, device_id, device_name, start_time, end_time, purpose, contact_info, status, create_time) VALUES 
('zhangsan', 2, '蔡司共聚焦显微镜', DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 6 DAY), '个人兴趣', '13800138000', 'rejected', NOW());

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;
