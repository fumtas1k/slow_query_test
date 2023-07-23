# slow_query_test

| 列名 | ＃ | データ・タイプ | NOT NULL | オートインクリメント | キー | デフォルト | 追加情報 | コメント |
| - | - | - | - | - | - | - | - | - |
|child_id| 1 | bigint | true | true | PRI | [NULL] | auto_increment | 子ID |
|parent_id| 2 | bigint | true | false | MUL | [NULL] | | 親ID |
|size | 3 | enum('SMALL','MEDIUM','LARGE') | true | false | [NULL] | 'MEDIUM' | | サイズ |
|register_date | 4 | date | true | false | [NULL] | [NULL] | | 登録日 |
|remark_1 | 5 | enum('A','B','C') | false | false | [NULL] | [NULL] | | 備考1 |
|remark_2 | 6 | enum('X','Y','Z') | true | false | [NULL] | [NULL] | | 備考2 |
|child_original_message | 7 | varchar(10) | false | false | [NULL] | [NULL] | | 子のオリジナルメッセージ |
|createdAt | 8 | datetime | true | false | [NULL] | CURRENT_TIMESTAMP | DEFAULT_GENERATED | 作成日時 |
|updatedAt | 9 | datetime	true | false | [NULL] | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP | | 更新日時 |

| 列名 | ＃ | データ・タイプ | NOT NULL | オートインクリメント | キー | デフォルト | 追加情報 | コメント |
| - | - | - | - | - | - | - | - | - |
| parent_id | 1 | bigint | true | true | PRI | [NULL] | auto_increment | 親ID |
| size | 2 | enum('SMALL','MEDIUM','LARGE') | true | false | [NULL] | 'MEDIUM' | | サイズ |
| register_date | 3 | date | true | false | [NULL] | [NULL] | | 登録日 |
| remark | 4 | varchar(1) | true | false | [NULL] | [NULL] | | 備考 |
| createdAt | 5 | datetime | true | false | [NULL] | CURRENT_TIMESTAMP | DEFAULT_GENERATED | 作成日時 |
| updatedAt | 6 | datetime | true | false | [NULL] | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP | 更新日時 |
