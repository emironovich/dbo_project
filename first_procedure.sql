CREATE PROCEDURE increase_cost_per_month_by_percent (@percent INT) AS
BEGIN
	DECLARE my_cur CURSOR FOR 
	SELECT cost_per_month
	FROM classes
	FOR UPDATE OF cost_per_month;

	OPEN my_cur;
	DECLARE @cur_cost MONEY;

	FETCH NEXT FROM my_cur 
	INTO @cur_cost;

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE classes SET cost_per_month = @cur_cost * (1 + @percent * 0.01) WHERE CURRENT OF my_cur;
		FETCH NEXT FROM my_cur 
		INTO @cur_cost;
	END

	CLOSE my_cur;
	DEALLOCATE my_cur;
END

CREATE PROCEDURE increase_cost_per_day_by_percent (@percent INT) AS
BEGIN
	DECLARE my_cur CURSOR FOR 
	SELECT cost_per_day
	FROM classes
	FOR UPDATE OF cost_per_day;

	OPEN my_cur;
	DECLARE @cur_cost MONEY;

	FETCH NEXT FROM my_cur 
	INTO @cur_cost;

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE classes SET cost_per_day = @cur_cost * (1 + @percent * 0.01) WHERE CURRENT OF my_cur;
		FETCH NEXT FROM my_cur 
		INTO @cur_cost;
	END

	CLOSE my_cur;
	DEALLOCATE my_cur;
END

CREATE PROCEDURE increase_cost_per_day_overdue_by_percent (@percent INT) AS
BEGIN
	DECLARE my_cur CURSOR FOR 
	SELECT cost_per_day_overdue
	FROM classes
	FOR UPDATE OF cost_per_day_overdue;

	OPEN my_cur;
	DECLARE @cur_cost MONEY;

	FETCH NEXT FROM my_cur 
	INTO @cur_cost;

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE classes SET cost_per_day_overdue = @cur_cost * (1 + @percent * 0.01) WHERE CURRENT OF my_cur;
		FETCH NEXT FROM my_cur 
		INTO @cur_cost;
	END

	CLOSE my_cur;
	DEALLOCATE my_cur;
END