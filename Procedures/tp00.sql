CREATE OR REPLACE PROCEDURE supprimer_employe(
    num_to_delete IN employees.employee_id%TYPE
) IS
    e_child_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_child_exists, -2292); -- ORA-02292: integrity constraint violated - child record found
    v_count NUMBER;
BEGIN
    -- Check if employee exists
    SELECT COUNT(*) INTO v_count
    FROM employees
    WHERE employee_id = num_to_delete;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || num_to_delete);
        RETURN;
    END IF;

    -- Try to delete employee
    DELETE FROM employees
    WHERE employee_id = num_to_delete;

    DBMS_OUTPUT.PUT_LINE('Employee with ID ' || num_to_delete || ' deleted successfully.');

EXCEPTION
    WHEN e_child_exists THEN
        DBMS_OUTPUT.PUT_LINE('Cannot delete employee ' || num_to_delete || 
                             ' because child records exist (foreign key constraint).');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END supprimer_employe;
/
