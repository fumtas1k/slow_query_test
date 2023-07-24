# スロークエリログ設定
# SHOW variables LIKE "%query%";
# set global slow_query_log = 1;
# set long_query_time = 1;

# データベースを削除
# DROP DATABASE IF EXISTS slow_query_test;
SHOW DATABASES;

# データベースがなかったら作成
# CREATE DATABASE IF NOT EXISTS slow_query_test DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE slow_query_test;

# テーブル削除
# DROP TABLE IF EXISTS children;
# DROP TABLE IF EXISTS parents;

# 子テーブル作成
CREATE TABLE IF NOT EXISTS children(
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

# 親テーブル作成
CREATE TABLE IF NOT EXISTS parents(
	parent_id bigint(20) NOT NULL AUTO_INCREMENT COMMENT "親ID",
	size ENUM("SMALL", "MEDIUM", "LARGE") NOT NULL DEFAULT "MEDIUM" COMMENT "サイズ",
	register_date date NOT NULL COMMENT "登録日",
	remark varchar(1) NOT NULL COMMENT "備考",
	createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "作成日時",
	updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "更新日時",
	PRIMARY KEY(parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

# データ投入
CALL insert_data(50000);
SELECT COUNT(*) FROM children;

# 子テーブルから親テーブルにデータ投入
INSERT INTO parents (size, register_date, remark)
SELECT ch.size, ch.register_date, IF(ch.remark_1 IS NOT NULL, ch.remark_1, ch.remark_2)
FROM children ch
GROUP BY ch.size, ch.register_date, IF(ch.remark_1 IS NOT NULL, ch.remark_1, ch.remark_2);

SELECT COUNT(*) FROM parents;

# 親テーブルのデータ削除
# TRUNCATE TABLE parents;

# 子テーブルに親ID作成
ALTER TABLE children ADD COLUMN parent_id bigint NOT NULL COMMENT "親ID" AFTER child_id;
ALTER TABLE children ADD INDEX parent_id(parent_id);

# 親テーブルに複合キー作成
ALTER TABLE parents ADD UNIQUE INDEX mix_key(size, register_date, remark);

# 子テーブルに親テーブルから親ID取ってきて追加
EXPLAIN UPDATE children c, parents p
SET c.parent_id = p.parent_id
WHERE c.size = p.size
AND c.register_date = p.register_date
AND IF(c.remark_1 IS NOT NULL, c.remark_1, c.remark_2) = p.remark;

# 親テーブルの複合キー削除
ALTER TABLE parents DROP INDEX mix_key;

# 子の親ID削除
ALTER TABLE children DROP COLUMN parent_id;
