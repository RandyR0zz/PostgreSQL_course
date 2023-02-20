CREATE OR REPLACE FUNCTION should_increase_salary(
	cur_salary numeric,
	max_salary numeric DEFAULT 80, 
	min_salary numeric DEFAULT 30,
	increase_rate numeric DEFAULT 0.2
	) RETURNS bool AS $$
DECLARE
	new_salary numeric;
BEGIN
	IF min_salary > max_salary THEN
		RAISE 'Min salary should be exceed than max! Min salary: %, Max salary: %', min_salary, max_salary;
	ELSIF min_salary < 0 OR max_salary < 0 THEN
		RAISE 'Min salary or max salary should be exceed than zero! Min salary: %, Max salary: %', min_salary, max_salary;
	ELSIF increase_rate < 0.05 THEN
		RAISE 'Increase rate should be more then 5 percent! Increase rate: %', increase_rate;
	END IF;
	
	IF cur_salary >= max_salary or cur_salary >= min_salary THEN 		
		RETURN false;
	END IF;
	
	IF cur_salary < min_salary THEN
		new_salary = cur_salary + (cur_salary * increase_rate);
	END IF;
	
	IF new_salary > max_salary THEN
		RETURN false;
	ELSE
		RETURN true;
	END IF;	
END;
$$ LANGUAGE plpgsql;

SELECT should_increase_salary(79, 10, 80, 0.2);
SELECT should_increase_salary(79, 10, -1, 0.2);
SELECT should_increase_salary(79, 10, 10, 0.04);