CREATE OR REPLACE FUNCTION has_borrowed_book(
    v_student_id IN NUMBER,
    v_book_id IN NUMBER
) RETURN BOOLEAN IS
    v_borrowed_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_borrowed_count
    FROM Lent
    WHERE Student_id = v_student_id
      AND Book_id = v_book_id
      AND Status = 'borrowed';

    RETURN v_borrowed_count > 0;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student has not borrowed the specified book.');
        RETURN FALSE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while checking borrowed book status: ' || SQLERRM);
        RETURN FALSE;
END;
