SELECT * FROM classes;
SELECT * FROM yachts;
SELECT * FROM clients;
SELECT * FROM contracts;

EXEC open_contract '02-9872315', 5181, '2017-09-12', '2017-09-09'
EXEC close_contract 24, '2017-09-12'

EXEC accept_payment 22, '2016-08-20'

UPDATE yachts
SET condition = 'damaged'
WHERE id = 5181

UPDATE yachts
SET placement = 'in port'
WHERE id = 3937

UPDATE contracts 
	SET yacht_id = 5097
	WHERE number = 23;

SELECT * FROM expected_payments('2019-01-01')

UPDATE classes
SET cost_per_month = 3640000, cost_per_day = 66711, cost_per_day_overdue = 80000
WHERE rang = 1

DELETE FROM contracts
WHERE number = 19
