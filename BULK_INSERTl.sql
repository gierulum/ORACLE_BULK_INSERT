

--select * from aaa_testbulk_datatable 

--select count(id) from aaa_test_datatable 

create table aaa_test_datatable (
id number(10),
name_data varchar2(10),
data_note varchar2(200),
date_from date,
date_to date, 
text_1 varchar2(255));

create table aaa_testbulk_datatable (
id number(10),
name_data varchar2(10),
data_note varchar2(200),
date_from date,
date_to date, 
text_1 varchar2(255))


declare cursor mg is 
select 
1 + level id, 
'a'||level name_data,
'b'||level data_note,
sysdate date_from, 
sysdate date_to,
level * 35 note 
from dual
connect by level <= 10000
order by id;

begin 
  for x in mg loop
    insert into aaa_test_datatable (
            id, 
            name_data, 
            data_note, 
            date_from, 
            date_to, 
            text_1)
    values (x.id, 
            x.name_data,
            x.data_note, 
            x.date_from, 
            x.date_to, 
            x.note);
  end loop;
  commit;
end;

/

DECLARE 

    TYPE var_1    IS TABLE OF aaa_test_datatable.id%TYPE INDEX BY BINARY_INTEGER;
    TYPE var_2    IS TABLE OF aaa_test_datatable.name_data%TYPE INDEX BY BINARY_INTEGER;
    TYPE var_3    IS TABLE OF aaa_test_datatable.data_note%TYPE INDEX BY BINARY_INTEGER;
    TYPE var_4    IS TABLE OF aaa_test_datatable.date_from%TYPE INDEX BY BINARY_INTEGER;
    TYPE var_5    IS TABLE OF aaa_test_datatable.date_to%TYPE INDEX BY BINARY_INTEGER;
    TYPE var_6    IS TABLE OF aaa_test_datatable.text_1%TYPE INDEX BY BINARY_INTEGER;

    v_1 var_1;
    v_2 var_2;
    v_3 var_3;
    v_4 var_4;
    v_5 var_5;
    v_6 var_6;
    v_fetched    PLS_INTEGER := 0;
		v_bulk_num    NUMBER    := 300;
		C_BATCH CONSTANT PLS_INTEGER := v_bulk_num;


CURSOR GM IS
SELECT 
*
FROM 
aaa_test_datatable; 




		begin
			open gm;
				loop
					FETCH gm
						BULK COLLECT INTO v_1, v_2, v_3, v_4, v_5, v_6 LIMIT C_BATCH;
						IF v_1.COUNT > 0 THEN 
                    v_fetched := v_fetched + v_1.COUNT; 
                FORALL i IN v_1.FIRST .. v_1.LAST
    insert into aaa_testbulk_datatable  (
            id, 
            name_data, 
            data_note, 
            date_from, 
            date_to, 
            text_1)
    values (v_1(i), 
            v_2(i), 
            v_3(i), 
            v_4(i), 
            v_5(i), 
            v_6(i)
            );
						END IF;
						EXIT WHEN gm%NOTFOUND;
					END LOOP;
				CLOSE gm;
      commit;
			END;


select count(id) from aaa_testbulk_datatable
