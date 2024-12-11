CREATE OR REPLACE PROCEDURE return_single_book(
    v_book_id IN NUMBER,
    v_student_id IN NUMBER,
    v_condition IN VARCHAR2
) IS
    v_return_date DATE;
    v_fine NUMBER;
BEGIN
    -- Check if the student has borrowed the book
    IF NOT has_borrowed_book(v_student_id, v_book_id) THEN
        DBMS_OUTPUT.PUT_LINE('Student ID ' || v_student_id || ' has not borrowed Book ID ' || v_book_id || '.');
        RETURN;
    END IF;

    -- Retrieve the return date from the Lent table
    SELECT Return_date INTO v_return_date
    FROM Lent
    WHERE Book_id = v_book_id AND Student_id = v_student_id AND Status = 'borrowed';

    -- Calculate the fine for the returned book
    v_fine := calculate_fine(v_condition, v_return_date);
    DBMS_OUTPUT.PUT_LINE('Fine calculated for Book ID ' || v_book_id || ': ' || v_fine);

    -- Update the Lent table with the return information
    UPDATE Lent
    SET Status = CASE v_condition
                    WHEN 'good' THEN 'returned'
                    WHEN 'damaged' THEN 'damaged'
                    WHEN 'lost' THEN 'lost'
                 END,
        Fine_amount = v_fine,
        Return_date = SYSDATE
    WHERE Book_id = v_book_id AND Student_id = v_student_id AND Status = 'borrowed';

    -- Update BookStatuses based on the book's condition
    CASE v_condition
        WHEN 'good' THEN
            UPDATE BookStatuses
            SET Number_of_copies = Number_of_copies + 1
            WHERE Book_id = v_book_id AND Status = 'available';
        WHEN 'damaged' THEN
            UPDATE BookStatuses
            SET Number_of_copies = Number_of_copies + 1
            WHERE Book_id = v_book_id AND Status = 'damaged';
        WHEN 'lost' THEN
            UPDATE BookStatuses
            SET Number_of_copies = Number_of_copies + 1
            WHERE Book_id = v_book_id AND Status = 'lost';
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid condition specified for the book. Update not performed.');
            RETURN;
    END CASE;

    -- Handle cases where the book's status record doesn't exist
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO BookStatuses (Book_id, Status, Number_of_copies)
        VALUES (v_book_id, v_condition, 1);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Book ID ' || v_book_id || ' successfully returned by Student ID ' || v_student_id || '.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while returning Book ID ' || v_book_id || ': ' || SQLERRM);
END;
