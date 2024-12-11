DECLARE

    v_student_id NUMBER: = 271247496; -- Student ID
    v_book_ids SYS.ODCINUMBERLIST:= SYS.ODCINUMBERLIST(3313, 3015, 3016); -- List of Book IDS
    v_borrow_durations SYS.ODCINUMBERLIST:= SYS.ODCINUMBERLIST(15, 20, 35); -- Borrow durations in days for each book

BEGIN
-- Call the lend_books procedure

    lend_books(
        v_book_ids => v_book_ids,
        v_student_id => v_student_id,
        v_borrow_durations => v_borrow_durations
);
END;