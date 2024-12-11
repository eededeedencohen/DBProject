CREATE OR REPLACE PROCEDURE lend_books(
    v_book_ids IN SYS.ODCINUMBERLIST,
    v_student_id IN NUMBER,
    v_borrow_durations IN SYS.ODCINUMBERLIST
) IS
    v_total_books_borrowed NUMBER;
    v_i NUMBER := 1;
    v_success BOOLEAN;
BEGIN
    IF has_high_debt(v_student_id) THEN
        DBMS_OUTPUT.PUT_LINE('Student has debts exceeding 200 and cannot borrow books.');
        RETURN;
    END IF;

    v_total_books_borrowed := count_borrowed_books(v_student_id);

    WHILE v_i <= v_book_ids.COUNT AND v_total_books_borrowed < 10 LOOP
        IF v_borrow_durations(v_i) > 30 THEN
            DBMS_OUTPUT.PUT_LINE('Book ID ' || v_book_ids(v_i) || ' exceeds the 30-day limit.');
        ELSE
            v_success := lend_single_book(
                v_book_id => v_book_ids(v_i),
                v_student_id => v_student_id,
                v_return_due_date => SYSDATE + v_borrow_durations(v_i)
            );

            IF v_success THEN
                DBMS_OUTPUT.PUT_LINE('Book ID ' || v_book_ids(v_i) || ' successfully lent.');
                v_total_books_borrowed := v_total_books_borrowed + 1;
            END IF;
        END IF;
        v_i := v_i + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Books lent process completed.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while lending books: ' || SQLERRM);
END;


