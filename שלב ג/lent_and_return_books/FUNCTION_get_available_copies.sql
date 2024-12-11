
CREATE OR REPLACE FUNCTION get_available_copies(v_book_id IN NUMBER)
RETURN NUMBER IS
    v_total_copies NUMBER;
BEGIN
    SELECT SUM(Number_of_copies)
    INTO v_total_copies
    FROM BookStatuses
    WHERE Book_id = v_book_id
      AND Status = 'available';

    RETURN NVL(v_total_copies, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No available copies found for the book.');
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while retrieving available copies: ' || SQLERRM);
        RETURN 0;
END;

