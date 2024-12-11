CREATE OR REPLACE PROCEDURE return_books(
    v_student_id IN NUMBER,
    v_book_ids IN SYS.ODCINUMBERLIST,
    v_conditions IN SYS.ODCIVARCHAR2LIST
) IS
BEGIN
    -- Validate input: number of books must match the number of conditions
    IF v_book_ids.COUNT != v_conditions.COUNT THEN
        DBMS_OUTPUT.PUT_LINE('Mismatch between the number of books and conditions. Please ensure they match.');
        RETURN;
    END IF;

    -- Iterate through the list of books and their conditions
    FOR i IN 1..v_book_ids.COUNT LOOP
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Processing return for Book ID: ' || v_book_ids(i) || ', Condition: ' || v_conditions(i));

            -- Call the single book return procedure
            return_single_book(v_book_ids(i), v_student_id, v_conditions(i));

            DBMS_OUTPUT.PUT_LINE('Book ID ' || v_book_ids(i) || ' successfully processed.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Issue occurred while processing Book ID ' || v_book_ids(i) || ': ' || SQLERRM);
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('All books processed for Student ID ' || v_student_id || '.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while returning books for Student ID ' || v_student_id || ': ' || SQLERRM);
END;


