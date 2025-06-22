Drop table board;

purge recyclebin;

CREATE TABLE board (
  num     NUMBER PRIMARY KEY,
  writer  VARCHAR2(50),
  title   VARCHAR2(100),
  content VARCHAR2(4000),
  regtime DATE,
  hits    NUMBER
);

SET SERVEROUTPUT ON;

DECLARE
  CURSOR name_cur IS
    SELECT saname FROM sawon WHERE ROWNUM <= 20;

  name_arr    DBMS_SQL.VARCHAR2_TABLE;
  idx         PLS_INTEGER := 0;
  total_count CONSTANT PLS_INTEGER := 255;
  name_count  PLS_INTEGER := 0;
BEGIN

  DELETE FROM board;

  FOR n IN name_cur LOOP
    name_arr(name_count) := n.saname;
    name_count := name_count + 1;
  END LOOP;

FOR i IN 0..total_count - 1 LOOP
  idx := MOD(i, name_count); 

	INSERT INTO board (
	  num,
	  writer,
	  title,
	  content,
	  regtime,
	  hits
	) VALUES (
	  255 - i,  -- 최신 글일수록 높은 번호
	  name_arr(idx),
	  name_arr(idx) || ' 가계부 작성했습니다.',
	  (i + 1) || '번째 가계부 작성했습니다.',
	  SYSDATE - i,
	  0
	);
END LOOP;


  COMMIT;
  DBMS_OUTPUT.PUT_LINE('총 ' || total_count || '개의 게시글이 생성되었습니다.');
END;
/

SELECT * FROM board ORDER BY num;
