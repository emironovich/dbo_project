CREATE TRIGGER checking_yacht_in_port ON contracts
INSTEAD OF INSERT AS
BEGIN
	IF(EXISTS (SELECT placement
			   FROM yachts
			   RIGHT JOIN inserted
			   ON yachts.id = inserted.yacht_id
			   WHERE placement <> 'in port'))
		RAISERROR('Needed yacht not in port', 16, 1);
	ELSE
		INSERT INTO contracts
		SELECT yacht_id, client_id, openning_date, expected_closing_date, payment_scheme, status, paid_until FROM inserted;
END