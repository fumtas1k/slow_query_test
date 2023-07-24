DELIMITER $$
CREATE PROCEDURE slow_query_test.insert_data(IN n INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i < n DO
		SET i = i + 1;
		INSERT INTO slow_query_test.children (size, register_date, remark_1, remark_2, child_original_message) VALUES
			(
				ELT(CEIL(RAND() * 3), "SMALL", "MEDIUM", "LARGE"),
				DATE_ADD("2021-01-01", INTERVAL 730 * RAND() DAY),
				ELT(CEIL(RAND() * 4), "A", "B", "C", NULL),
				ELT(CEIL(RAND() * 3), "X", "Y", "Z"),
				SUBSTRING(MD5(RAND()), 1, 10)
			);
	END WHILE;
END;
$$
DELIMITER;
