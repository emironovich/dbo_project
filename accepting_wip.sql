CREATE PROCEDURE accept_payment (@contract_number INT, @paying_to_date DATE, @curr_date DATE) AS
BEGIN
	DECLARE @paid_until DATE = (SELECT paid_until
							    FROM contracts
							    WHERE number = @contract_number)
	IF(DATEDIFF(day, @curr_date, @paid_until) < 0)
		BEGIN
		DECLARE @client_id INT = (SELECT client_id
								  FROM contracts
								  WHERE number = @contract_number)
		UPDATE clients
		SET times_payment_overdue = times_payment_overdue + 1
		WHERE id = @client_id;
		END

	DECLARE @money MONEY
	DECLARE @closing DATE = (SELECT expected_closing_date
							 FROM contracts
							 WHERE number = @contract_number)
	DECLARE @yacht_id INT = (SELECT yacht_id
							 FROM contracts
							 WHERE number = @contract_number)
	DECLARE @to_closing INT = DATEDIFF(day, @curr_date, @closing);
	DECLARE @from_closing INT = DATEDIFF(day, @closing, @paid_until);
	DECLARE @per_month MONEY = (SELECT cost_per_month
								FROM classes
								WHERE rang = (SELECT class_rang
											  FROM yachts
											  WHERE id = @yacht_id));
	DECLARE @per_day MONEY = (SELECT cost_per_day
								FROM classes
								WHERE rang = (SELECT class_rang
											  FROM yachts
											  WHERE id = @yacht_id));
	DECLARE @per_day_overdue MONEY = (SELECT cost_per_day_overdue
								FROM classes
								WHERE rang = (SELECT class_rang
											  FROM yachts
											  WHERE id = @yacht_id));
	SET @money = (@to_closing / 30) * @per_month + (@to_closing % 30) * @per_day
	SET @money = @money + @from_closing * @per_day_overdue

	UPDATE contracts 
	SET paid_until = @paying_to_date, money_paid = money_paid + @money
	WHERE number = @contract_number;

	SELECT @money 
	SELECT ' was taken as payment'
END