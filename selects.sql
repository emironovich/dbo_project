--Вывести список всех яхт отсортировав по алфавиту.
SELECT * 
FROM yachts
ORDER BY name;

--Вывести все яхты одного класса.
SELECT *
FROM yachts
WHERE class_rang = 1

--Вывести всех клиентов, бравших в прокат одну и ту же яхту, сроки проката.


--Вывести все яхты, последняя проверка состояния которых, производилась за последнюю неделю.
SELECT *
FROM yachts
WHERE last_check != NULL AND DATEDIFF(day, last_check, CURRENT_TIMESTAMP) <= 7;

--Вывести всех клиентов, кто задерживал возвращение яхты.
SELECT id, name
FROM clients
JOIN contracts
ON id = client_id
WHERE actual_closing_date != NULL AND DATEDIFF(day, expected_closing_date, actual_closing_date) > 0;

--Вывести клиента с наибольшим суммарным сроком проката в «Синей птице».
SELECT client_id, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration
FROM contracts
GROUP BY client_id
ORDER BY duration

--Вывсети клиента, заплатившего наибольшее количество денег «Синей птице».
SELECT client_id, SUM(money_paid) AS all_money
FROM contracts
GROUP BY client_id
ORDER BY all_money

--Вывсести список клиентов, которые плохо следили за состоянием яхты. После возвращения ими яхт , проверка состояния яхт неудовлетворительной.
SELECT id, name
FROM clients
WHERE times_damaged != 0

--Вывести яхты в порядке убывания их популярности у прокатчиков. (Первой должна быть яхта, котрую брали в прокат чаще друших.)


--Вывести список клиентов и их любимых яхт. Для каждого клиента показать ту яхту, которую он брал в прокат чаще остальных. В случае, когда таких яхт несколько – сравнивать по сроку проката. Если и срок проката одинаков, вернуть обе яхты а разных строках.