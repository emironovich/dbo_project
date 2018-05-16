--������� ������ ���� ��� ������������ �� ��������.
SELECT * 
FROM yachts
ORDER BY name;

--������� ��� ���� ������ ������.
SELECT *
FROM yachts
WHERE class_rang = 1

--������� ���� ��������, ������� � ������ ���� � �� �� ����, ����� �������.


--������� ��� ����, ��������� �������� ��������� �������, ������������� �� ��������� ������.
SELECT *
FROM yachts
WHERE last_check != NULL AND DATEDIFF(day, last_check, CURRENT_TIMESTAMP) <= 7;

--������� ���� ��������, ��� ���������� ����������� ����.
SELECT id, name
FROM clients
JOIN contracts
ON id = client_id
WHERE actual_closing_date != NULL AND DATEDIFF(day, expected_closing_date, actual_closing_date) > 0;

--������� ������� � ���������� ��������� ������ ������� � ������ �����.
SELECT client_id, SUM(DATEDIFF(day, openning_date, actual_closing_date)) AS duration
FROM contracts
GROUP BY client_id
ORDER BY duration

--������� �������, ������������ ���������� ���������� ����� ������ �����.
SELECT client_id, SUM(money_paid) AS all_money
FROM contracts
GROUP BY client_id
ORDER BY all_money

--�������� ������ ��������, ������� ����� ������� �� ���������� ����. ����� ����������� ��� ��� , �������� ��������� ��� ��������������������.
SELECT id, name
FROM clients
WHERE times_damaged != 0

--������� ���� � ������� �������� �� ������������ � �����������. (������ ������ ���� ����, ������ ����� � ������ ���� ������.)


--������� ������ �������� � �� ������� ���. ��� ������� ������� �������� �� ����, ������� �� ���� � ������ ���� ���������. � ������, ����� ����� ��� ��������� � ���������� �� ����� �������. ���� � ���� ������� ��������, ������� ��� ���� � ������ �������.