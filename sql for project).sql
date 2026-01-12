CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(250) UNIQUE NOT NULL,
    password VARCHAR(250) NOT NULL,
    last_name VARCHAR(250) NOT NULL,
    first_name VARCHAR(250) NOT NULL,
    middle_name VARCHAR(250),
    phone VARCHAR(15),
    date_registration DATE DEFAULT CURRENT_DATE
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    description VARCHAR(250)
);

CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    country VARCHAR(250),
    year_appearance INT NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    brand_id INTEGER NOT NULL,
    article VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2),
    is_original BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);
 
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    address VARCHAR(250) NOT NULL
);

CREATE TABLE stock (
    product_id INTEGER NOT NULL,
    warehouse_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    PRIMARY KEY (product_id, warehouse_id)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    payment_method VARCHAR(250) NOT NULL,
    status VARCHAR(20) NOT NULL,
    sum NUMERIC(10, 2),
    date_payment TIMESTAMP DEFAULT NOW()
);

CREATE TABLE delivery (
    delivery_id SERIAL PRIMARY KEY,
    type_delivery VARCHAR(50) NOT NULL,
    address VARCHAR(250) NOT NULL,
    city VARCHAR(100),
    cost NUMERIC(10, 2) DEFAULT 0,
    expected_delivery_date DATE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    date_creation TIMESTAMP DEFAULT NOW(),
    status VARCHAR(30) NOT NULL,
    user_id INTEGER NOT NULL,
    payment_id INTEGER NOT NULL,
    delivery_id INTEGER NOT NULL,
    total_amount NUMERIC(10, 2) CHECK (total_amount > 0),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id),
    FOREIGN KEY (delivery_id) REFERENCES delivery(delivery_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER,
    price_per_unit NUMERIC(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO categories (name, description) VALUES
('MMA и единоборства', 'Экипировка для смешанных боевых искусств'),
('Фитнес', 'Товары для тренировок в зале и дома'),
('Бег', 'Обувь и аксессуары для бегунов'),
('Йога', 'Коврики, ремни и одежда для йоги'),
('Питание', 'Спортивное питание и добавки');

INSERT INTO brands (name, country, year_appearance) VALUES
('FightGear', 'США', 2005),
('PowerFit', 'Германия', 1998),
('RunPro', 'Япония', 2010),
('ZenFlex', 'Индия', 2015),
('NutriMax', 'Канада', 2009);

INSERT INTO products (category_id, brand_id, article, name, description, price, is_original) VALUES
(1, 1, 'FG-MMA-GLOVES', 'Перчатки MMA кожаные', 'Профессиональные перчатки для тренировок и спаррингов', 4500.00, TRUE),
(1, 1, 'FG-MMA-SHIN', 'Щитки для голени MMA', 'С защитой стопы, размер L', 3200.50, TRUE),
(2, 2, 'PF-DUMBBELL-10', 'Гантели 10 кг регулируемые', 'Набор резиновых гантелей для дома', 2800.00, TRUE),
(2, 2, 'PF-YOGA-MAT', 'Коврик для йоги нескользящий', 'Толщина 6 мм, длина 183 см', 890.99, FALSE),
(3, 3, 'RP-RUN-SHOES', 'Беговые кроссовки RunPro', 'Лёгкие, амортизация AirFlow', 6500.00, TRUE),
(4, 4, 'ZF-YOGA-BLOCK', 'Блок для йоги пробковый', 'Экологичный материал, высота 9 см', 650.00, TRUE),
(5, 5, 'NM-CREATINE-300G', 'Креатин моногидрат 300 г', 'Повышает силу и выносливость', 1200.00, TRUE),
(5, 5, 'NM-OMEGA3-60CAPS', 'Омега-3 рыбий жир 60 капсул', 'Для сердца и мозга', 950.50, TRUE);

INSERT INTO warehouses (name, address) VALUES
('Основной склад МСК', 'г. Москва, ул. Складская, д. 10'),
('Склад СПб', 'г. Санкт-Петербург, пр. Логистический, д. 5'),
('Региональный склад ЕКБ', 'г. Екатеринбург, ул. Промышленная, д. 22');

INSERT INTO stock (product_id, warehouse_id, quantity) VALUES
(1, 1, 15),  
(1, 2, 8),   
(2, 1, 12),
(3, 1, 20),
(3, 3, 7),
(4, 2, 30),
(5, 1, 25),
(6, 2, 18),
(7, 1, 50),  
(8, 1, 40);  

INSERT INTO users (email, password, last_name, first_name, middle_name, phone, date_registration) VALUES
('ivanov@example.com', 'hashed_password_1', 'Иванов', 'Иван', 'Иванович', '+79001112233', '2024-05-10'),
('petrov@example.com', 'hashed_password_2', 'Петров', 'Пётр', NULL, '+79004445566', '2024-07-22'),
('sidorova@example.com', 'hashed_password_3', 'Сидорова', 'Анна', 'Сергеевна', '+79007778899', '2024-11-05');

INSERT INTO payments (payment_method, status, sum) VALUES
('Карта Visa', 'paid', 7700.50),
('Карта Mir', 'paid', 1200.00),
('Apple Pay', 'paid', 950.50);

INSERT INTO delivery (type_delivery, address, city, cost, expected_delivery_date) VALUES
('courier', 'ул. Ленина, д. 15, кв. 42', 'Москва', 299.00, CURRENT_DATE + 2),
('pickup', 'Пункт выдачи Ozon, ТЦ "Атриум"', 'Москва', 0.00, CURRENT_DATE + 1),
('mail', 'пр. Невский, д. 100', 'Санкт-Петербург', 350.00, CURRENT_DATE + 3);

INSERT INTO orders (order_number, date_creation, status, user_id, payment_id, delivery_id, total_amount) VALUES
('MMA-2025-001', NOW(), 'delivered', 1, 1, 1, 7700.50),
('NM-2025-002', NOW() , 'shipped', 2, 2, 2, 1200.00),
('OMG-2025-003', NOW(), 'confirmed', 3, 3, 3, 950.50);

INSERT INTO order_items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 4500.00),  
(1, 2, 1, 3200.50),  
(2, 7, 1, 1200.00),  
(3, 8, 1, 950.50);   
UPDATE orders 
SET date_creation = '2025-12-10 10:00:00'
WHERE order_id = 1;

UPDATE orders 
SET date_creation = '2025-12-15 14:30:00'
WHERE order_id = 2;

UPDATE orders 
SET date_creation = '2026-01-05 09:15:00'
WHERE order_id = 3;

SELECT -- Задание 1
    SUM(o.total_amount) AS revenue_december_2025
FROM 
    orders o
JOIN 
    payments p ON o.payment_id = p.payment_id
WHERE 
     o.date_creation >= '2025-01-01'
    AND o.date_creation < '2026-01-01';

SELECT --Задание 2
    p.name AS product_name,
    w.name AS warehouse_name,
    s.quantity
FROM 
    stock s
JOIN 
    products p ON s.product_id = p.product_id
JOIN 
    warehouses w ON s.warehouse_id = w.warehouse_id
WHERE 
    s.quantity < 100;

SELECT --Задание 3
    o.order_number,
    p.name AS product_name,
    oi.quantity,
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    o.order_id = 1;  
