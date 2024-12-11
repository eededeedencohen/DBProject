
CREATE OR REPLACE PROCEDURE assign_librarian_to_task(
    v_task_id INT,
    v_librarian_id INT -- For automatic assignment, leave NULL 
) IS
    v_chosen_librarian INT;
    v_librarian_exists INT;
BEGIN
    -- Check if the task ID is valid
    IF v_task_id IS NULL OR v_task_id <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid task ID.');
        RETURN;
    END IF;

    -- Check existence of the librarian in the system
    IF v_librarian_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_librarian_exists 
        FROM Librarians 
        WHERE Librarian_id = v_librarian_id;

        IF v_librarian_exists = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Assigned librarian does not exist in the system.');
            RETURN;
        END IF;

        v_chosen_librarian := v_librarian_id;
    ELSE
        -- Automatic assignment of the least busy librarian
        v_chosen_librarian := get_least_busy_librarian;
        IF v_chosen_librarian IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Error: Unable to assign a librarian.');
            RETURN;
        END IF;
    END IF;
 
    -- Update the task to 'in progress' status
    UPDATE LibraryRequests
    SET request_status = 'in progress'
    WHERE request_id = v_task_id;

    -- Insert the assignment into the RequestAssignments table
    INSERT INTO RequestAssignments (request_id, assigned_librarian)
    VALUES (v_task_id, v_chosen_librarian);

    DBMS_OUTPUT.PUT_LINE('Librarian ID ' || v_chosen_librarian || ' assigned to task ' || v_task_id || '.');
END;
