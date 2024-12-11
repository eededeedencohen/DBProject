CREATE OR REPLACE FUNCTION is_book_available(v_book_id IN NUMBER)
RETURN NUMBER IS
    v_available_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_available_count
    FROM BookStatuses
    WHERE Book_id = v_book_id
      AND Status = 'available';

    RETURN v_available_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No available records found for the book.');
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while checking book availability: ' || SQLERRM);
        RETURN 0;
END;

