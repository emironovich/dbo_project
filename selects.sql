--Вывести список всех яхт отсортировав по алфавиту.
SELECT * 
FROM yachts
ORDER BY name;

--Вывести все яхты одного класса.
SELECT *
FROM yachts
WHERE class_rang = 1

--Вывести всех клиентов, бравших в прокат одну и ту же яхту, сроки проката.
SELECT id, name, openning_date, actual_closing_date
FROM clients
JOIN contracts
ON id = client_id
WHERE yacht_id = 5181

--Вывести все яхты, последняя проверка состояния которых, производилась за последнюю неделю.
SELECT *
FROM yachts
WHERE last_check != NULL AND DATEDIFF(day, last_check, CURRENT_TIMESTAMP) <= 7;

--Вывести всех клиентов, кто задерживал возвращение яхты.
SELECT DISTINCT id, name
FROM clients
JOIN contracts
ON id = client_id
WHERE actual_closing_date IS NOT NULL AND DATEDIFF(day, expected_closing_date, actual_closing_date) > 0;

--Вывести клиента с наибольшим суммарным сроком проката в «Синей птице».
SELECT TOP(1) client_id, name, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration
FROM contracts
JOIN clients
ON client_id = id
GROUP BY client_id, name
ORDER BY duration DESC

--Вывсети клиента, заплатившего наибольшее количество денег «Синей птице».
SELECT TOP(1) client_id, name, SUM(money_paid) AS all_money
FROM contracts
JOIN clients
ON client_id = id
GROUP BY client_id, name
ORDER BY all_money DESC

--Вывсести список клиентов, которые плохо следили за состоянием яхты. После возвращения ими яхт, проверка состояния яхт неудовлетворительной.
SELECT id, name
FROM clients
WHERE times_damaged != 0

--Вывести яхты в порядке убывания их популярности у прокатчиков. (Первой должна быть яхта, котрую брали в прокат чаще друших.)
SELECT yacht_id, name, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration, COUNT(number) AS col
FROM contracts
JOIN yachts
ON yacht_id = id
GROUP BY yacht_id, name
ORDER BY col DESC, duration DESC

--Вывести список клиентов и их любимых яхт. Для каждого клиента показать ту яхту, которую он брал в прокат чаще остальных. В случае, когда таких яхт несколько – сравнивать по сроку проката. Если и срок проката одинаков, вернуть обе яхты а разных строках.


SELECT fifth.client_id, fifth.yacht_id, fifth.duration
FROM
(SELECT contracts.client_id, contracts.yacht_id, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration
	FROM contracts
	JOIN 
		(SELECT fst.client_id, fst.yacht_id, fst.times 
		FROM (SELECT client_id, yacht_id, COUNT(*) AS times
			  FROM contracts
			  GROUP BY client_id, yacht_id) AS fst

		JOIN (SELECT t.client_id, MAX(t.times) AS max_times
			  FROM (SELECT client_id, yacht_id, COUNT(*) AS times
					FROM contracts
					GROUP BY client_id, yacht_id) AS t
			  GROUP BY t.client_id) AS snd
		 ON fst.client_id = snd.client_id AND max_times = times) AS thrd
	ON contracts.client_id = thrd.client_id AND contracts.yacht_id = thrd.yacht_id
	GROUP BY contracts.client_id, contracts.yacht_id) AS fifth
JOIN (SELECT frth.client_id, MAX(duration) AS duration
	FROM (SELECT contracts.client_id, contracts.yacht_id, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration
		FROM contracts
		JOIN 
			(SELECT fst.client_id, fst.yacht_id, fst.times 
			FROM (SELECT client_id, yacht_id, COUNT(*) AS times
				  FROM contracts
				  GROUP BY client_id, yacht_id) AS fst

			JOIN (SELECT t.client_id, MAX(t.times) AS max_times
				  FROM (SELECT client_id, yacht_id, COUNT(*) AS times
						FROM contracts
						GROUP BY client_id, yacht_id) AS t
				  GROUP BY t.client_id) AS snd
			 ON fst.client_id = snd.client_id AND max_times = times) AS thrd
		ON contracts.client_id = thrd.client_id AND contracts.yacht_id = thrd.yacht_id
		GROUP BY contracts.client_id, contracts.yacht_id) AS frth
	GROUP BY frth.client_id) AS six
ON fifth.client_id = six.client_id AND fifth.duration = six.duration