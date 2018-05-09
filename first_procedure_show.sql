SELECT * FROM classes;

EXECUTE increase_cost_per_month_by_percent 20;
EXECUTE increase_cost_per_day_by_percent 5;
EXECUTE increase_cost_per_day_overdue_by_percent 10;

SELECT * FROM classes;