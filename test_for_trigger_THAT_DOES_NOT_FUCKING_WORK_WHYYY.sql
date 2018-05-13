SELECT * FROM contracts;
SELECT * FROM yachts;
SELECT * FROM clients;

INSERT INTO contracts (yacht_id, client_id, openning_date, expected_closing_date, actual_closing_date, payment_scheme, paid_until)
VALUES (1039, '00-2107262', '2018-05-13', '2018-05-20', null, 'upfront', '2018-05-20');

UPDATE yachts
SET  placement = 'in port'
WHERE id = 1039;

UPDATE yachts
SET  last_check = '2017-05-14'
WHERE id = 3071;

DELETE FROM contracts WHERE yacht_id = 2596;