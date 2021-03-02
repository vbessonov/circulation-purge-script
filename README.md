# circulation-purge-script
SQL script helping to resolve the OPDS purging issue currently present in Circulation Manager.

How to use the script:
1. Clone the repository:
```
git clone https://github.com/vbessonov/circulation-purge-script.git
```
2. Open the script in your favourite editor:
```
vi circulation-purge-script/circulation-purge-script.sql
```
3. Replace `v_data_source_name` with the name of the data source you want to purge.
4. Create a dump of the database:
```
pg_dump dbname > outfile
```
5. Run the script:
```
psql -f circulation-purge-script/circulation-purge-script.sql
```
**NOTE:** You _might_ want to use `--single-transaction` option to wrap all the commands in transaction:
```
psql --single-transaction -f circulation-purge-script/circulation-purge-script.sql
```
