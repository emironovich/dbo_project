CREATE TABLE classes (
	rang INT NOT NULL,
	name CHAR(42) PRIMARY KEY NOT NULL,
	size REAL,
	displacment REAL,
	cost_per_day MONEY NOT NULL,
	cost_per_month MONEY
)

CREATE TABLE yachts(
	id INT PRIMARY KEY,
	class_name CHAR(42) REFERENCES classes(name), --может лучше ввести номер для классов
	placment CHAR(42) NOT NULL,
	condition CHAR(42) DEFAULT 'in order',
	last_check DATE
)

CREATE TABLE clients(
	id INT PRIMARY KEY,
	name CHAR(42) NOT NULL,
	adress CHAR(42) NOT NULL,
	phone_number NUMERIC(11) NOT NULL,
	bank_account NUMERIC(20),
	next_payment_due DATE,
	times_overdue INT DEFAULT 0,
	times_damaged INT DEFAULT 0
)

CREATE TABLE contracts(
	number INT IDENTITY(1,1) PRIMARY KEY, -- может какой-нибудь вычисляемый столбец
	yacht_id INT REFERENCES yachts(id),
	client_id INT REFERENCES clients(id),
	beginning DATE NOT NULL,
	ending DATE NOT NULL,  
	payment_scheme CHAR(13),
	CHECK(payment_scheme IN ('upfront', 'half upfront', 'monthly'))
)

CREATE TABLE payments(
	contract_number INT REFERENCES contracts(number),
	date DATE NOT NULL
)