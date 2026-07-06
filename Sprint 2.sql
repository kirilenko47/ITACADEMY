# Exercici 1

SELECT *
FROM company;

SELECT *
FROM transaction;

# Exercici 2

SELECT DISTINCT c.country
FROM company c 
JOIN transaction t 
ON c.id = t.company_id
ORDER BY c.country DESC;

SELECT COUNT(DISTINCT c.country) AS TOTAL_PAISOS
FROM company c 
JOIN transaction t 
ON c.id = t.company_id;

SELECT company_name, avg(amount)
FROM transaction t 
JOIN company c
on t.company_id = c.id
GROUP BY company_id
ORDER BY avg(amount) desc
LIMIT 1;

# Exercici 3

# Mostra totes les transaccions realitzades per empreses d'Alemanya

SELECT *
FROM transaction
WHERE company_id IN (
SELECT id
FROM company
WHERE country = 'Germany'
);

# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions

SELECT c.company_name
FROM company c
WHERE c.id IN (
    SELECT t.company_id
    FROM transaction t
    GROUP BY t.company_id
    HAVING AVG(t.amount) > (
        SELECT AVG(amount) 
        FROM transaction
    )
);

# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses

SELECT company_id, company_name
FROM company
WHERE company_id NOT IN (
    SELECT business_id
    FROM transaction
    WHERE business_id IS NOT NULL
);


# Ejercicio 4

CREATE TABLE credit_card (
    id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(5),
    cvv VARCHAR(5),
    expiring_date VARCHAR(20)
    );
    
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

# Ejercicio 5

SELECT *
from credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

# Ejercicio 6
# En la taula "transaction" ingressa una nova transacció amb la següent informació:

INSERT INTO company (id, company_name, phone, email, country, website) 
VALUES (
    'b-9999', 
    'ghost company', 
    '000000000', 
    'ghost@email.com', 
    'Ghost Country', 
    'www.ghost.com'
);

INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) 
VALUES (
    'CcU-9999', 
    'ES0000000000000000000000', 
    '0000000000000000', 
    '0000', 
    '000', 
    '12/99'
);

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES (
    '108B1D1D-5B23-A76C-55EF-C568E49A99DD', 
    'CcU-9999', 
    'b-9999', 
    9999, 
    829.999, 
    -117.999, 
    111.11, 
    0
);

SELECT *
FROM transaction
WHERE credit_card_id = 'CcU-9999';

# Ejercicio 7
# Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM credit_card;

# Ejercicio 8

CREATE DATABASE IF NOT EXISTS star_schema_db;
USE star_schema_db;

CREATE TABLE user (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(100),
    birth_date VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    address VARCHAR(100),
    signup_date VARCHAR(20),
    user_segment VARCHAR(50),
    income_band VARCHAR(50),
    region VARCHAR(50)
);



CREATE TABLE company (
    company_id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50),
    website VARCHAR(100),
    merchant_category VARCHAR(50),
    merchant_price_position VARCHAR(50)
);

CREATE TABLE credit_card (
    id VARCHAR(15) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(5),
    cvv VARCHAR(4),
    track1 VARCHAR(100),
    track2 VARCHAR(100),
    expiring_date VARCHAR(10),
    card_type VARCHAR(20),
    card_renewal_flag INT
);

CREATE TABLE transaction (
    id VARCHAR(50) PRIMARY KEY,
    card_id VARCHAR(15),
    business_id VARCHAR(50),
    user_id INT,
    timestamp VARCHAR(25),
    amount DECIMAL(10, 2),
    declined INT,
    product_ids VARCHAR(50),
    lat DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    discount_amount DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    shipping_amount DECIMAL(10, 2),
    channel VARCHAR(20),
    campaign_id VARCHAR(50),
    device_type VARCHAR(20),
    is_international INT,
    decline_reason VARCHAR(50),
    distance_km DECIMAL(10, 2),
    FOREIGN KEY (card_id) REFERENCES credit_card(id),
    FOREIGN KEY (business_id) REFERENCES company(company_id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__european_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, birth_date, country, city, postal_code, address, signup_date, user_segment, income_band)
SET region = 'Europa';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__american_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, birth_date, country, city, postal_code, address, signup_date, user_segment, income_band)
SET region = 'America';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, card_id, business_id, timestamp, amount, declined, product_ids, user_id, lat, longitude, discount_amount, tax_amount, shipping_amount, channel, campaign_id, device_type, is_international, decline_reason, distance_km);



# Ejercicio 9
# Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules

SELECT user_id, count(user_id) as TOTAL_TRANSACTIONS
FROM transaction
WHERE declined = 0
GROUP BY user_id
having count(user_id) > 80;

SELECT *
FROM user u
WHERE u.id IN (
 SELECT user_id
 FROM transaction
 WHERE declined = 0
 GROUP BY user_id
 having count(user_id) > 80
);

# Ejercicio 10
# Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules

SELECT iban, avg(amount)
FROM company c
JOIN transaction t
on c.company_id = t.business_id
JOIN credit_card cr
on t.card_id = cr.id
WHERE company_name = 'Donec Ltd'
GROUP BY iban;

# NIVELL 2

# Ejercicio 1
# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes


SELECT 
    t.*, 
    top_dies.total_vendes
FROM 
    transaction t
     JOIN (
    SELECT 
        DATE(timestamp) AS dia, 
        SUM(amount) AS total_vendes
    FROM 
        transaction
	WHERE declined = 0
    GROUP BY 
        DATE(timestamp)
    ORDER BY 
        total_vendes DESC
    LIMIT 5
) AS top_dies ON DATE(t.timestamp) = top_dies.dia
ORDER BY 
    top_dies.total_vendes DESC, 
    t.timestamp ASC;
    
# Ejercicio 2
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 
# 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat:

SELECT c.company_name, c.phone, c.country, DATE(timestamp) as fecha, t.amount as cantidad
from company c
JOIN transaction t 
on c.company_id = t.business_id
WHERE DATE(timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13') and t.amount BETWEEN 350 and 400 and t.declined = 0 
ORDER BY cantidad desc;

# Ejercicio 3
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació 
# sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on 
# especifiquis si tenen igual o més de 400 transaccions o menys.

SELECT c.company_name, count(t.id) AS total_transacciones,
 CASE 
        WHEN COUNT(t.id) >= 400 THEN 'Sí (400 o más)'
        ELSE 'No (Menos de 400)'
    END AS supera_objetivo
FROM transaction t
JOIN company c
on t.business_id = c.company_id
GROUP by business_id;

# Ejercicio 4
# Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades


DELETE from transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

# Ejercicio 5
# La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. S'ha sol·licitat crear una vista que proporcioni 
# detalls clau sobre les companyies i les seves transaccions. Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
# Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, 
# ordenant les dades de major a menor mitjana de compra

CREATE VIEW VistaMarketing AS
SELECT
 c.company_name,
 c.phone,
 c.country,
 AVG(amount) AS Media_compra
FROM company c
JOIN 
 transaction t ON c.company_id = t.business_id
GROUP BY c.company_id, company_name, c.phone, c.country;

SELECT * FROM VistaMarketing
ORDER BY Media_compra DESC;

# NIVELL 3
# Ejercicio 1
# Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat declinades aleshores és inactiu, 
# si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:
# Quantes targetes estan actives?

CREATE TABLE estat_targetes AS
WITH UltimesTransaccions AS (
    SELECT 
        card_id,
        declined,
        ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY timestamp DESC) AS ordre_transaccio
    FROM transaction
)
SELECT 
    card_id,
    CASE 
        WHEN SUM(declined) = 3 THEN 'inactiu'
        ELSE 'actiu'
    END AS estat
FROM UltimesTransaccions
WHERE ordre_transaccio <= 3 
GROUP BY card_id;

SELECT COUNT(*) AS total_targetes_actives
FROM estat_targetes
WHERE estat = 'actiu';

# Ejercicio 2

CREATE TABLE product (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    colour VARCHAR(10),
    weight DECIMAL(5,2),
    warehouse_id VARCHAR(10),
    category VARCHAR(50),
    brand VARCHAR(50),
    cost DECIMAL(10,2),
    launch_date DATE
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, product_name, @price, colour, weight, warehouse_id, category, brand, @cost, launch_date)
SET 
    price = REPLACE(@price, '$', ''),
    cost = REPLACE(@cost, '$', '');
    
CREATE TABLE transaction_product (
    transaction_id CHAR(36) NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction (id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

INSERT INTO transaction_product (transaction_id, product_id)
SELECT
    t.id AS transaction_id,
    jt.product_id
FROM transaction t
CROSS JOIN JSON_TABLE(
    CONCAT('[', REPLACE(t.product_ids, ' ', ''), ']'), 
    '$[*]' COLUMNS (
        product_id INT PATH '$'
    )
) AS jt;


SELECT product_id AS Id,
    (SELECT product_name
     FROM product
     WHERE product.id = transaction_product.product_id) AS Producto,
    COUNT(transaction_id) AS Venta
FROM transaction_product
WHERE transaction_id = (SELECT id
                        FROM transaction
                        WHERE transaction.id = transaction_product.transaction_id
                        AND declined = 0)
GROUP BY product_id
ORDER BY Venta DESC;
