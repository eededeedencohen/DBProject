
DECLARE
    v_request_type VARCHAR2(50) := 'books'; -- Task type
    v_request_description CLOB := 'Need more books for the children section'; -- Task description
    v_request_date DATE := SYSDATE; -- Task creation date
    v_request_librarian INT := 291563328; -- Librarian creating the task
    v_librarian_choice INT := 1;  -- 1 = manual assignment, 2 = automatic assignment, 3 = no assignment (waiting)
    v_librarian_id INT := 200885937;   -- Specific librarian ID for manual assignment (only relevant for choice 1)
    v_task_id INT; -- Will store the new task ID

BEGIN
    -- Create a new task
    create_new_task(v_request_type, v_request_description, v_request_date, v_request_librarian);

    -- Retrieve the ID of the newly created task
    SELECT MAX(request_id) INTO v_task_id FROM LibraryRequests;

    -- Handle assignment choice based on v_librarian_choice
    IF v_librarian_choice = 1 THEN
        -- Manual assignment of a librarian by ID
        assign_librarian_to_task(v_task_id, v_librarian_id);
        DBMS_OUTPUT.PUT_LINE('Task ' || v_task_id || ' manually assigned to librarian ID ' || v_librarian_id || '.');

    ELSIF v_librarian_choice = 2 THEN
        -- Automatic assignment to the least busy librarian
        assign_librarian_to_task(v_task_id, NULL);
        DBMS_OUTPUT.PUT_LINE('Task ' || v_task_id || ' automatically assigned to the least busy librarian.');

    ELSIF v_librarian_choice = 3 THEN
        -- Leave the task in "waiting" status with no librarian assigned
        DBMS_OUTPUT.PUT_LINE('Task ' || v_task_id || ' created with no librarian assignment (waiting status).');

    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid choice. Task was not assigned.');
    END IF;

END;
/

הרצת Main ראשונה - הפרמטר v_librarian_choice שווה ל-1
(כלומר הספרן שיוצר את המשימה הוא גם יציין את הספרן שישובץ אל המשימה) 

