
select * from aaa_test_datatable


/
--NORMAL STATEMENT:
DECLARE 
V_STARTTIME PLS_INTEGER := DBMS_UTILITY.GET_TIME;
V_ENDTIME PLS_INTEGER;

CURSOR MG IS 
select * 
from aaa_test_datatable;

BEGIN 
  FOR X IN MG LOOP
    INSERT INTO aaa_testbulk_datatable(
            ID, 
            NAME_DATA, 
            DATA_NOTE, 
            DATE_FROM, 
            DATE_TO, 
            TEXT_1)
    VALUES (X.ID, 
            X.NAME_DATA, 
            X.DATA_NOTE, 
            X.DATE_FROM, 
            X.DATE_TO, 
            X.TEXT_1);
  END LOOP;
  V_ENDTIME := DBMS_UTILITY.GET_TIME - V_STARTTIME;  
  DBMS_OUTPUT.PUT_LINE('INSERTET ' || V_TAB_ID.COUNT || ' ROWS IN '||ROUND(v_endtime/100,6));
END;
--DBMS: INSERTET 0 ROWS IN 1,06
/
DECLARE 
--TYPE TAB_TESTBULK IS TABLE OF aaa_test_datatable.ID%TYPE INDEX BY PLS_INTEGER;
TYPE TAB_TESTBULK IS TABLE OF aaa_test_datatable%ROWTYPE INDEX BY BINARY_INTEGER;
V_TAB_ROWS TAB_TESTBULK;
V_STARTTIME PLS_INTEGER := DBMS_UTILITY.GET_TIME;
V_ENDTIME PLS_INTEGER;

CURSOR MGIE IS
SELECT * 
FROM aaa_test_datatable;

BEGIN 
  OPEN MGIE;
  LOOP
  EXIT WHEN MGIE%NOTFOUND;
  FETCH MGIE BULK COLLECT INTO V_TAB_ROWS LIMIT 500;

    --BULK COLLECT  INSERT:
    FOR X IN 1.. V_TAB_ROWS.COUNT LOOP
        INSERT INTO aaa_testbulk_datatable VALUES V_TAB_ROWS(X);
    END LOOP;

    --FORALL INSERT:  
    FORALL X IN V_TAB_ROWS.FIRST.. V_TAB_ROWS.LAST 
    INSERT INTO aaa_testbulk_datatable VALUES V_TAB_ROWS(X);
  
  END LOOP;  
  CLOSE MGIE;
  
  V_ENDTIME := DBMS_UTILITY.GET_TIME - V_STARTTIME;  
  DBMS_OUTPUT.PUT_LINE('INSERTED ' || V_TAB_ROWS.COUNT || ' ROWS IN '||ROUND(v_endtime/100,6));
END;

/

SELECT COUNT(ID) FROM aaa_testbulk_datatable 


