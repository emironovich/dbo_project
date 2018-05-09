CREATE TRIGGER checking_yacht_for_placing_and_condition ON contracts
INSTEAD OF INSERT AS
BEGIN
	IF((SELECT COUNT(*) FROM inserted) > 1)
		RAISERROR('Please, create contracts one by one', 15, 1);
	ELSE IF(EXISTS (SELECT placement
			   FROM yachts
			   RIGHT JOIN inserted
			   ON yachts.id = inserted.yacht_id
			   WHERE placement <> 'in port'))
		RAISERROR('Needed yacht not in port', 16, 1);
	ELSE IF ((DATEDIFF(
					month,
					(SELECT last_check 
						FROM yachts 
						JOIN inserted 
						ON inserted.yacht_id = yachts.id),
					 CURRENT_TIMESTAMP)
				>= 1) 
			  OR
			  (DATEDIFF(
					day,
					(SELECT actual_closing_date 
						FROM contracts 
						WHERE number = (SELECT MAX(contracts.number) 
										FROM contracts 
										JOIN inserted 
										ON contracts.yacht_id = inserted.yacht_id)), 
					(SELECT last_check 
						FROM yachts 
						JOIN inserted 
						ON inserted.yacht_id = yachts.id))
				 <0))
		RAISERROR('Yacht needs checking', 15, 1);
	ELSE
		INSERT INTO contracts (contracts.yacht_id, contracts.client_id, contracts.openning_date, contracts.expected_closing_date, contracts.actual_closing_date, contracts.payment_scheme, contracts.paid_until)
		SELECT				   inserted.yacht_id, inserted.client_id, inserted.openning_date, inserted.expected_closing_date, inserted.actual_closing_date, inserted.payment_scheme, inserted.paid_until FROM inserted;

		UPDATE yachts
		SET placement = 'with client id('+ (SELECT client_id FROM inserted) + ')'
		WHERE id = (SELECT yacht_id FROM inserted)
END;

DISABLE TRIGGER checking_yacht_for_placing_and_condition ON contracts;
ENABLE TRIGGER checking_yacht_for_placing_and_condition ON contracts;
DROP TRIGGER checking_yacht_for_placing_and_condition;