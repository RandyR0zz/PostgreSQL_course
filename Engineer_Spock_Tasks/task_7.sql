-- 1. Создать таблицу exam с полями:

-- - идентификатора экзамена - автоинкрементируемый, уникальный, запрещает NULL;
-- - наименования экзамена;
-- - даты экзамена;

CREATE TABLE exams
(
	exam_id serial UNIQUE NOT NULL,
	exam_name varchar(64),
	exam_date date
);

-- 2. Удалить ограничение уникальности с поля идентификатора

ALTER TABLE exams
DROP CONSTRAINT exams_exam_id_key;

-- 3. Добавить ограничение первичного ключа на поле идентификатора

ALTER TABLE exams
ADD CONSTRAINT exams_exam_id_pk PRIMARY KEY(exam_id);

-- 4. Создать таблицу person с полями:

-- - идентификатора личности (простой int, первичный ключ);
-- - имя;
-- - фамилия;

CREATE TABLE person
(
	person_id int,
	first_name varchar(64),
	last_name varchar(64),
	
	CONSTRAINT person_person_id_pk PRIMARY KEY(person_id)
);

-- 5. Создать таблицу паспорта с полями:

-- - идентификатора паспорта (простой int, первичный ключ);
-- - серийный номер (простой int, запрещает NULL);
-- - регистрация;
-- - ссылка на идентификатор личности (внешний ключ);

CREATE TABLE passport
(
	passport_id int,
	serial_num int NOT NULL,
	registration varchar(128),
	person_id int,
	
	CONSTRAINT passport_passport_id_pk PRIMARY KEY(passport_id),
	CONSTRAINT person_passport_fk FOREIGN KEY(person_id) REFERENCES person(person_id)
);

-- 6. Добавить колонку веса в таблицу book (создавали ранее) с ограничением, проверяющим вес (больше 0 но меньше 100)

CREATE TABLE book
(
	book_id int NOT NULL,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,
	
	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

ALTER TABLE book
ADD COLUMN weight int CONSTRAINT CHK_book_weight CHECK (weight > 0 AND weight < 100);

-- 7. Убедиться в том, что ограничение на вес работает (попробуйте вставить невалидное значение)

INSERT INTO book
VALUES (1, 'War and Peace', 123456789, 1, 105);

-- 8. Создать таблицу student с полями:

-- - идентификатора (автоинкремент);
-- - полное имя;
-- - курс (по умолчанию 1);

CREATE TABLE student
(
	student_id serial,
	full_name text,
	course int DEFAULT '1'
);

-- 9. Вставить запись в таблицу студентов и убедиться, что ограничение на вставку значения по умолчанию работает

INSERT INTO student (full_name)
VALUES ('Herman Palishchuk');

SELECT *
FROM student;

-- 10. Удалить ограничение "по умолчанию" из таблицы студентов

ALTER TABLE student
ALTER COLUMN course DROP DEFAULT;

-- 11. Подключиться к БД northwind и добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)

ALTER TABLE products
ADD CONSTRAINT CHK_product_price CHECK(unit_price > 0);

ALTER TABLE products
DROP CONSTRAINT CHK_product_price;

-- 12. "Навесить" автоинкрементируемый счётчик на поле product_id таблицы products (БД northwind). Счётчик должен начинаться с числа следующего за максимальным значением по этому столбцу.

SELECT MAX(product_id)
FROM products;

CREATE SEQUENCE IF NOT EXISTS products_product_id_seq
START WITH 78 OWNED BY products.product_id;

ALTER TABLE products
ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq');

-- 13. Произвести вставку в products (не вставляя идентификатор явно) и убедиться, что автоинкремент работает. Вставку сделать так, чтобы в результате команды вернулось значение, сгенерированное в качестве идентификатора.

INSERT INTO products(product_name, supplier_id, category_id, quantity_per_unit, 
					 unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
VALUES ('prod', 1, 1, 10, 20, 20, 10, 1, 0)
RETURNING product_id;

DELETE FROM products
WHERE product_id = 78;

SELECT *
FROM products;