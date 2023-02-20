-- 1. Найти заказчиков и обслуживающих их заказы сотрудников таких, что и заказчики и сотрудники из города London, а доставка идёт компанией Speedy Express. Вывести компанию заказчика и ФИО сотрудника.
SELECT c.company_name AS customer, CONCAT(e.first_name, ' ', e.last_name) AS employee
FROM orders AS o 
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN employees AS e ON o.employee_id = e.employee_id
JOIN shippers AS s ON o.ship_via = s.shipper_id
WHERE c.city = 'London' AND e.city = 'London' AND s.company_name = 'Speedy Express';

-- 2. Найти активные (см. поле discontinued) продукты из категории Beverages и Seafood, которых в продаже менее 20 единиц. Вывести наименование продуктов, кол-во единиц в продаже, имя контакта поставщика и его телефонный номер.
SELECT product_name, units_in_stock, contact_name, phone
FROM products
JOIN categories ON products.category_id = categories.category_id
JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE category_name IN ('Beverages', 'Seafood') AND discontinued = 0 AND units_in_stock < 20
ORDER BY units_in_stock;

-- 3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id.
SELECT contact_name, order_id
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
WHERE order_id IS NULL;

-- 4. Переписать предыдущий запрос, использовав симметричный вид джойна (подсказка: речь о LEFT и RIGHT).
SELECT contact_name, order_id
FROM orders
RIGHT JOIN customers ON customers.customer_id = orders.customer_id
WHERE order_id IS NULL;