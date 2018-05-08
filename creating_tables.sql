CREATE TABLE classes (
	rang INT NOT NULL,
	name VARCHAR(70) PRIMARY KEY NOT NULL,
	size REAL,
	displacement REAL,
	cost_per_month MONEY NOT NULL,
	cost_per_day MONEY NOT NULL,
	cost_per_day_overdue MONEY NOT NULL
)

CREATE TABLE yachts(
	id INT PRIMARY KEY,
	name VARCHAR(70) NOT NULL,
	class_name VARCHAR(70) REFERENCES classes(name), --может лучше ввести номер для классов
	placment VARCHAR(42) NOT NULL,
	condition VARCHAR DEFAULT 'in order',
	last_check DATE
)

CREATE TABLE clients(
	id INT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(200) NOT NULL,
	phone_number NUMERIC(11) NOT NULL,
	bank_account NUMERIC(20),
	times_overdue_payment INT DEFAULT 0,
	times_damaged INT DEFAULT 0
)

CREATE TABLE contracts(
	number INT IDENTITY(1,1) PRIMARY KEY,
	yacht_id INT REFERENCES yachts(id),
	client_id INT REFERENCES clients(id),
	openning_date DATE NOT NULL,
	expected_closing_date DATE NOT NULL,
	payment_scheme CHAR(13),
	status CHAR(7),
	paid_until DATE,
	CHECK((payment_scheme IN ('upfront', 'half upfront', 'monthly')) AND (STATUS IN ('open', 'closed')))
)
