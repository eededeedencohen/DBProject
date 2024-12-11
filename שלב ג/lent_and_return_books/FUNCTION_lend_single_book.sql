CREATE OR REPLACE FUNCTION lend_single_book(
    v_book_id IN NUMBER,
    v_student_id IN NUMBER,
    v_return_due_date IN DATE
) RETURN BOOLEAN IS
    v_available_copies NUMBER;
    v_borrowed_status_exists NUMBER := 0;
BEGIN
    IF has_borrowed_book(v_student_id, v_book_id) THEN
        DBMS_OUTPUT.PUT_LINE('Student has already borrowed the book with ID: ' || v_book_id);
        RETURN FALSE;
    END IF;

    v_available_copies := get_available_copies(v_book_id);

    IF v_available_copies = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No copies available for the book.');
        RETURN FALSE;
    END IF;

    IF v_available_copies = 1 THEN
        DELETE FROM BookStatuses
        WHERE Book_id = v_book_id AND Status = 'available';
    ELSE
        UPDATE BookStatuses
        SET Number_of_copies = Number_of_copies - 1
        WHERE Book_id = v_book_id AND Status = 'available';
    END IF;

    INSERT INTO Lent (Book_id, Student_id, Status, Fine_amount, Borrow_date, Return_date)
    VALUES (v_book_id, v_student_id, 'borrowed', 0, SYSDATE, v_return_due_date);

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while lending the book: ' || SQLERRM);
        RETURN FALSE;
END;
