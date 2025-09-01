CREATE OR REPLACE PROCEDURE comm_employe(
    num       IN employees.employee_id%TYPE,
    tauxcomm  IN NUMBER
) AS
    v_comm employees.commission_pct%TYPE;
BEGIN
    -- Get current commission
    SELECT commission_pct
    INTO v_comm
    FROM employees
    WHERE employee_id = num;

    -- Check if commission is null or zero
    IF v_comm IS NULL OR v_comm = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Commission est nulle !');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Commission actuelle = ' || TO_CHAR(v_comm));

        -- Update commission with increase
        UPDATE employees
        SET commission_pct = v_comm * (1 + tauxcomm)
        WHERE employee_id = num;

        COMMIT;

        -- Confirm update
        SELECT commission_pct
        INTO v_comm
        FROM employees
        WHERE employee_id = num;

        DBMS_OUTPUT.PUT_LINE('Nouvelle commission = ' || TO_CHAR(v_comm));
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun employé trouvé avec l''ID ' || num);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
END comm_employe;
/
