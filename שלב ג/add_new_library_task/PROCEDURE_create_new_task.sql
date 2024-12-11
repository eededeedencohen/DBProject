
CREATE OR REPLACE PROCEDURE create_new_task(
    v_request_type VARCHAR2,
    v_request_description CLOB,
    v_request_date DATE,
    v_request_librarian INT -- ID of the librarian creating the task
) IS
    v_new_request_id INT;
    v_creator_exists INT;
BEGIN
    -- Check if the input parameters are valid
    IF v_request_type IS NULL OR LENGTH(v_request_type) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Request type cannot be null or empty.');
        RETURN;
    END IF;

    IF v_request_description IS NULL OR LENGTH(v_request_description) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Request description cannot be null or empty.');
        RETURN;
    END IF;

    IF v_request_librarian IS NULL OR v_request_librarian <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid librarian ID.');
        RETURN;
    END IF;

    -- Check if the creating librarian exists in the system
    SELECT COUNT(*) INTO v_creator_exists 
    FROM Librarians 
    WHERE Librarian_id = v_request_librarian;

    IF v_creator_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Creating librarian does not exist in the system.');
        RETURN;
    END IF;

    -- Calculate the new request ID by finding the maximum and adding 1
    SELECT NVL(MAX(request_id), 0) + 1 INTO v_new_request_id FROM LibraryRequests;

    -- Insert a new task into the LibraryRequests table with the calculated request ID
    INSERT INTO LibraryRequests (request_id, request_type, request_description, request_date, request_status, request_librarian)
    VALUES (v_new_request_id, v_request_type, v_request_description, v_request_date, 'waiting', v_request_librarian);

    DBMS_OUTPUT.PUT_LINE('New task created with ID: ' || v_new_request_id);
END;

