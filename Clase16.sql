/*CLASE 16*/
CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);



-- 1

-- It throws an error because of the NOT NULL constraint we added on the email attribute when we created the table.

INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES 
(1056,'Patterson','Mary','x4611',NULL,'1',1002,'VP Sales');

-- 2

UPDATE employees set employeeNumber = employeeNumber - 20;

-- Esa querie funciona y actualiza todas las rows, porque el motor la ejecuta sequencialmente el update, por lo que aunque la distancia entre 2 ids es 20 el update ocurre primero en la fila del medio y por lo tanto nunca coliciona.

UPDATE employees set employeeNumber = employeeNumber + 20;

-- En este caso, cuando la fila del medio actualiza su valor, este es el mismo que la de la tercer fila por lo tanto tanto no puede hacer el update por el constraint de la primary key.


-- 3

ALTER TABLE employees
ADD age TINYINT UNSIGNED DEFAULT 69;

ALTER TABLE employees
   ADD CONSTRAINT age CHECK(age >= 16 AND age <= 70);


-- 5

ALTER TABLE employees
    ADD COLUMN lastUpdate DATETIME;


ALTER TABLE employees
    ADD COLUMN lastUpdateUser VARCHAR(255); 


CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
     SET NEW.lastUpdate=NOW();
     SET NEW.lastUpdateUser=CURRENT_USER;
END;


update employees set lastName = 'Phanny' where employeeNumber = 1076;



-- 6

-- ins_film Inserts a new film_text entry, with the same values as the added film.

BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
END

-- upd_film Updates the corresponding existing film_text entry for the updated film. 

BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
END

-- del_film Deletes the corresponding existing film_text entry for the deleted film. 

BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END
