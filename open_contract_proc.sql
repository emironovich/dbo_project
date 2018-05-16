CREATE PROCEDURE open_contract(@client_id VARCHAR(20), @yacht_id INT, @payment_scheme CHAR(13), @expected_closing_date DATE, @openning_date DATE) AS
BEGIN
	DECLARE @paid_until DATE;
	DECLARE @money_paid MONEY;
	DECLARE @prolongation INT = DATEDIFF(day, @openning_date, @expected_closing_date);
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
	IF(@payment_scheme = 'upfront') 
		BEGIN
		SET @paid_until = @expected_closing_date;
		SET @money_paid = (@prolongation / 30) * @per_month + (@prolongation % 30) * @per_day;
		END
	ELSE IF(@payment_scheme = 'monthly')
		BEGIN
		SET @paid_until = DATEADD(day, 30, CURRENT_TIMESTAMP);
		SET @money_paid = @per_month;
		END
	ELSE -- half upfront
		BEGIN
		SET @paid_until = @expected_closing_date;
		SET @money_paid = ((@prolongation / 30) * @per_month + (@prolongation % 30) * @per_day) / 2;
		END

	INSERT INTO contracts(yacht_id, client_id, openning_date, expected_closing_date, actual_closing_date, payment_scheme, paid_until, money_paid)
	VALUES (@yacht_id, @client_id, @openning_date, @expected_closing_date, null, @payment_scheme, @paid_until, @money_paid);
END