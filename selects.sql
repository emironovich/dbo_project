--������� ������ ���� ��� ������������ �� ��������.
SELECT * 
FROM yachts
ORDER BY name;

--������� ��� ���� ������ ������.
SELECT *
FROM yachts
WHERE class_rang = 1

--������� ���� ��������, ������� � ������ ���� � �� �� ����, ����� �������.
SELECT id, name, openning_date, actual_closing_date
FROM clients
JOIN contracts
ON id = client_id
WHERE yacht_id = 5181

--������� ��� ����, ��������� �������� ��������� �������, ������������� �� ��������� ������.
SELECT *
FROM yachts
WHERE last_check != NULL AND DATEDIFF(day, last_check, CURRENT_TIMESTAMP) <= 7;

--������� ���� ��������, ��� ���������� ����������� ����.
SELECT DISTINCT id, name
FROM clients
JOIN contracts
ON id = client_id
WHERE actual_closing_date IS NOT NULL AND DATEDIFF(day, expected_closing_date, actual_closing_date) > 0;

--������� ������� � ���������� ��������� ������ ������� � ������ �����.
SELECT TOP(1) client_id, name, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration
FROM contracts
JOIN clients
ON client_id = id
GROUP BY client_id, name
ORDER BY duration DESC

--������� �������, ������������ ���������� ���������� ����� ������ �����.
SELECT TOP(1) client_id, name, SUM(money_paid) AS all_money
FROM contracts
JOIN clients
ON client_id = id
GROUP BY client_id, name
ORDER BY all_money DESC

--�������� ������ ��������, ������� ����� ������� �� ���������� ����. ����� ����������� ��� ���, �������� ��������� ��� ��������������������.
SELECT id, name
FROM clients
WHERE times_damaged != 0

--������� ���� � ������� �������� �� ������������ � �����������. (������ ������ ���� ����, ������ ����� � ������ ���� ������.)
SELECT yacht_id, name, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration, COUNT(number) AS col
FROM contracts
JOIN yachts
ON yacht_id = id
GROUP BY yacht_id, name
ORDER BY col DESC, duration DESC

--������� ������ �������� � �� ������� ���. ��� ������� ������� �������� �� ����, ������� �� ���� � ������ ���� ���������. � ������, ����� ����� ��� ��������� � ���������� �� ����� �������. ���� � ���� ������� ��������, ������� ��� ���� � ������ �������.


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