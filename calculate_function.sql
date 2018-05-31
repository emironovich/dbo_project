CREATE FUNCTION calculate_discount (@client_id VARCHAR(20))
RETURNS MONEY
AS
BEGIN
	DECLARE @coefficient FLOAT = 0.01;
	DECLARE @discount MONEY = 0;
	DECLARE @times_damaged INT = (SELECT times_damaged
								  FROM clients
								  WHERE id = @client_id);
	DECLARE @times_payment_overdue INT = (SELECT times_payment_overdue
										  FROM clients
										  WHERE id = @client_id);
	IF(@times_damaged = 0 AND @times_payment_overdue = 0)
	BEGIN
		DECLARE @money MONEY = (SELECT SUM(money_paid)
								FROM contracts
								WHERE client_id = @client_id);
		SET @discount = @coefficient * @money;
	END
	RETURN @discount;
END