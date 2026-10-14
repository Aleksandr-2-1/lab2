PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS departments (
    department_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    location TEXT
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    position TEXT NOT NULL,
    phone TEXT,
    email TEXT UNIQUE,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    inventory_number TEXT NOT NULL UNIQUE,
    serial_number TEXT UNIQUE,
    name TEXT NOT NULL,
    manufacturer TEXT,
    model TEXT,
    acquisition_date TEXT,
    cost REAL CHECK (cost IS NULL OR cost >= 0),
    technical_condition TEXT NOT NULL DEFAULT 'Исправно'
        CHECK (technical_condition IN ('Исправно', 'Требует ремонта', 'В ремонте', 'Списано')),
    department_id INTEGER NOT NULL,
    responsible_employee_id INTEGER,
    notes TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (responsible_employee_id) REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS movements (
    movement_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    from_department_id INTEGER,
    to_department_id INTEGER NOT NULL,
    responsible_employee_id INTEGER NOT NULL,
    moved_at TEXT NOT NULL,
    reason TEXT NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (from_department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (to_department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (responsible_employee_id) REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS repairs (
    repair_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    reported_by_employee_id INTEGER NOT NULL,
    opened_at TEXT NOT NULL,
    description TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Открыта'
        CHECK (status IN ('Открыта', 'Выполняется', 'Завершена')),
    closed_at TEXT,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (reported_by_employee_id) REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO departments (name, location) VALUES
('Бухгалтерия', 'Кабинет 101'),
('ИТ-отдел', 'Кабинет 204'),
('Отдел кадров', 'Кабинет 115');

INSERT INTO employees (full_name, position, phone, email, department_id) VALUES
('Иванов Иван Иванович', 'Бухгалтер', '+7-900-000-00-01', 'ivanov@example.com', 1),
('Петров Пётр Сергеевич', 'Системный администратор', '+7-900-000-00-02', 'petrov@example.com', 2),
('Сидорова Анна Олеговна', 'Специалист отдела кадров', '+7-900-000-00-03', 'sidorova@example.com', 3);

INSERT INTO equipment
(inventory_number, serial_number, name, manufacturer, model, acquisition_date, cost, technical_condition, department_id, responsible_employee_id, notes)
VALUES
('INV-0001', 'SN-PC-1001', 'Компьютер', 'Lenovo', 'ThinkCentre M70', '2024-02-12', 65000, 'Исправно', 1, 1, 'Рабочее место бухгалтера'),
('INV-0002', 'SN-NB-2002', 'Ноутбук', 'HP', 'ProBook 450', '2023-09-20', 78000, 'Требует ремонта', 2, 2, 'Проверить систему охлаждения'),
('INV-0003', 'SN-PR-3003', 'Принтер', 'Canon', 'i-SENSYS LBP', '2024-05-06', 24000, 'Исправно', 3, 3, 'Сетевой принтер отдела');

INSERT INTO movements
(equipment_id, from_department_id, to_department_id, responsible_employee_id, moved_at, reason)
VALUES
(1, NULL, 1, 1, '2024-02-12', 'Первичная постановка на учёт'),
(2, 1, 2, 2, '2024-03-01', 'Передача в ИТ-отдел'),
(3, NULL, 3, 3, '2024-05-06', 'Первичная постановка на учёт');

INSERT INTO repairs
(equipment_id, reported_by_employee_id, opened_at, description, status, closed_at)
VALUES
(2, 2, '2024-10-03', 'Перегрев ноутбука при работе', 'Открыта', NULL),
(1, 1, '2024-07-14', 'Плановая диагностика', 'Завершена', '2024-07-15'),
(3, 3, '2024-08-22', 'Проверка подачи бумаги', 'Завершена', '2024-08-22');
