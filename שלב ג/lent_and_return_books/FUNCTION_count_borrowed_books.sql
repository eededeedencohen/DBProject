CREATE OR REPLACE FUNCTION count_borrowed_books(v_student_id IN NUMBER)
RETURN NUMBER IS
    v_borrowed_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_borrowed_count
    FROM Lent
    WHERE Student_id = v_student_id
      AND Status = 'borrowed';

    RETURN v_borrowed_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No borrowed books found for the student.');
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while counting borrowed books: ' || SQLERRM);
        RETURN 0;
END;
