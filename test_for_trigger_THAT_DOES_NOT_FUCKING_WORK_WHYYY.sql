SELECT * FROM contracts;
SELECT * FROM yachts;
SELECT * FROM clients;

INSERT INTO contracts (yacht_id, client_id, openning_date, expected_closing_date, actual_closing_date, payment_scheme, paid_until)
VALUES (1039, '00-2107262', '2007-05-08', '2007-05-08', null, 'upfront', '2007-05-08');

UPDATE yachts
SET last_check = CURRENT_TIMESTAMP
WHERE id = 1039;

DELETE FROM contracts WHERE yacht_id = 1039;