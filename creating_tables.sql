CREATE TABLE classes (
	rang INT PRIMARY KEY,
	size REAL NOT NULL,
	displacement REAL NOT NULL,
	cost_per_month MONEY NOT NULL,
	cost_per_day MONEY NOT NULL,
	cost_per_day_overdue MONEY NOT NULL
)

CREATE TABLE yachts(
	id INT PRIMARY KEY,
	name VARCHAR(70) NOT NULL,
	class_rang INT NOT NULL REFERENCES classes(rang) ON UPDATE CASCADE,
	placement VARCHAR(42) NOT NULL DEFAULT 'in port',
	condition VARCHAR(50) DEFAULT 'in order',
	last_check DATE
)

CREATE TABLE clients(
	id VARCHAR(20) PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(200) NOT NULL,
	phone_number NUMERIC(11) NOT NULL,
	bank_account VARCHAR(30),
	times_damaged INT DEFAULT 0,
	times_payment_overdue INT DEFAULT 0
)

CREATE TABLE contracts(
	number INT IDENTITY(1,1) PRIMARY KEY,
	yacht_id INT REFERENCES yachts(id) ON DELETE NO ACTION ON UPDATE CASCADE,
	client_id VARCHAR(20) REFERENCES clients(id) ON DELETE NO ACTION ON UPDATE CASCADE,
	openning_date DATE NOT NULL,
	expected_closing_date DATE NOT NULL,
	actual_closing_date DATE,
	payment_scheme CHAR(13),
	paid_until DATE,
	money_paid MONEY DEFAULT 0,
	CHECK(payment_scheme IN ('upfront', 'half upfront', 'monthly'))
)

DROP TABLE clients;