DROP DATABASE IF EXISTS slow_query_test;
SHOW DATABASES;
CREATE DATABASE IF NOT EXISTS slow_query_test DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE slow_query_test;

DROP TABLE IF EXISTS child;
DROP TABLE IF EXISTS parent;

CREATE TABLE IF NOT EXISTS child(
	child_id bigint(20) NOT NULL AUTO_INCREMENT COMMENT "子ID",
	size ENUM("SMALL", "MEDIUM", "LARGE") NOT NULL DEFAULT "MEDIUM" COMMENT "サイズ",
	register_date date NOT NULL COMMENT "登録日",
	remark_1 ENUM("A", "B", "C") COMMENT "備考1",
	remark_2 ENUM("X", "Y", "Z") NOT NULL COMMENT "備考2",
	child_original_message varchar(10) COMMENT "子のオリジナルメッセージ",
	createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "作成日時",
	updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "更新日時",
	PRIMARY KEY(child_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS parent(
	parent_id bigint(20) NOT NULL AUTO_INCREMENT COMMENT "親ID",
	size ENUM("SMALL", "MEDIUM", "LARGE") NOT NULL DEFAULT "MEDIUM" COMMENT "サイズ",
	register_date date NOT NULL COMMENT "登録日",
	remark varchar(1) NOT NULL COMMENT "備考",
	createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "作成日時",
	updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "更新日時",
	PRIMARY KEY(parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CALL insert_data(10000);

INSERT INTO parent (size, register_date, remark)
SELECT ch.size, ch.register_date, IF(ch.remark_1 IS NOT NULL, ch.remark_1, ch.remark_2)
FROM child ch
GROUP BY ch.size, ch.register_date, IF(ch.remark_1 IS NOT NULL, ch.remark_1, ch.remark_2);

# TRUNCATE TABLE parent;
# ALTER TABLE child DROP COLUMN parent_id;
ALTER TABLE child ADD COLUMN parent_id bigint NOT NULL COMMENT "親ID" AFTER child_id;
ALTER TABLE child ADD INDEX parent_id(parent_id);
# ALTER TABLE parent ADD UNIQUE INDEX mix_key(size, register_date, remark);

EXPLAIN UPDATE child c, parent p
SET c.parent_id = p.parent_id
WHERE c.size = p.size
AND c.register_date = p.register_date
AND IF(c.remark_1 IS NOT NULL, c.remark_1, c.remark_2) = p.remark;

ALTER TABLE parent DROP INDEX mix_key;
