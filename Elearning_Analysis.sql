
DROP DATABASE IF EXISTS elearning_platform;
CREATE DATABASE elearning_platform;
USE elearning_platform;




-- Table 1: learners
CREATE TABLE learners (
    learner_id   INT PRIMARY KEY AUTO_INCREMENT,
    full_name    VARCHAR(100) NOT NULL,
    country      VARCHAR(50)  NOT NULL
);

-- Table 2: courses
CREATE TABLE courses (
    course_id    INT PRIMARY KEY AUTO_INCREMENT,
    course_name  VARCHAR(100)   NOT NULL,
    category     VARCHAR(50)    NOT NULL,
    unit_price   DECIMAL(8,2)   NOT NULL
);

-- Table 3: purchases (links learners and courses)
CREATE TABLE purchases (
    purchase_id   INT PRIMARY KEY AUTO_INCREMENT,
    learner_id    INT NOT NULL,
    course_id     INT NOT NULL,
    quantity      INT NOT NULL DEFAULT 1,
    purchase_date DATE NOT NULL,
    CONSTRAINT fk_purchases_learner
        FOREIGN KEY (learner_id) REFERENCES learners(learner_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_purchases_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
);




-- 5 learners
INSERT INTO learners (learner_id, full_name, country) VALUES
(1, 'Aarav Sharma',  'India'),
(2, 'Emily Johnson', 'USA'),
(3, 'Liam Smith',    'UK'),
(4, 'Sofia Garcia',  'Spain'),
(5, 'Noah Brown',    'Canada');

-- 6 courses across 5 categories (one course, "Excel for Business",
-- is deliberately never purchased -- used to answer Q5)
INSERT INTO courses (course_id, course_name, category, unit_price) VALUES
(101, 'Python for Beginners',   'Programming',   19.99),
(102, 'Data Science with SQL',  'Data Science',  29.99),
(103, 'Digital Marketing 101',  'Marketing',     15.99),
(104, 'Advanced Java',          'Programming',   24.99),
(105, 'Graphic Design Basics',  'Design',        12.99),
(106, 'Excel for Business',     'Productivity',   9.99);

-- 8 purchase records
INSERT INTO purchases (purchase_id, learner_id, course_id, quantity, purchase_date) VALUES
(1001, 1, 101, 2, '2024-01-05'),
(1002, 1, 103, 1, '2024-01-10'),
(1003, 2, 102, 1, '2024-01-12'),
(1004, 2, 104, 1, '2024-02-01'),
(1005, 3, 101, 1, '2024-02-05'),
(1006, 4, 102, 2, '2024-02-10'),
(1007, 4, 105, 1, '2024-03-01'),
(1008, 5, 101, 3, '2024-03-05');




-- 4a. INNER JOIN
-- Purpose: show only purchases that have a matching learner AND course
-- (this is the "core" purchase detail report)
SELECT
    l.full_name                              AS learner_name,
    l.country                                AS country,
    c.course_name                            AS course_name,
    c.category                               AS category,
    p.quantity                               AS quantity,
    FORMAT(p.quantity * c.unit_price, 2)     AS total_amount,
    p.purchase_date                          AS purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses  c ON p.course_id  = c.course_id
ORDER BY p.quantity * c.unit_price DESC;

-- 4b. LEFT JOIN
-- Purpose: show ALL learners, even ones with zero purchases
-- (none in our sample data, but the query is correct/future-proof)
SELECT
    l.full_name                                        AS learner_name,
    l.country                                          AS country,
    c.course_name                                      AS course_name,
    c.category                                         AS category,
    p.quantity                                         AS quantity,
    FORMAT(COALESCE(p.quantity * c.unit_price, 0), 2)  AS total_amount,
    p.purchase_date                                    AS purchase_date
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses  c  ON p.course_id  = c.course_id
ORDER BY l.full_name, p.purchase_date;

-- 4c. RIGHT JOIN
-- Purpose: show ALL courses, even ones nobody bought
-- (Excel for Business will appear with NULL purchase data)
SELECT
    l.full_name                                        AS learner_name,
    l.country                                          AS country,
    c.course_name                                      AS course_name,
    c.category                                         AS category,
    p.quantity                                         AS quantity,
    FORMAT(COALESCE(p.quantity * c.unit_price, 0), 2)  AS total_amount,
    p.purchase_date                                    AS purchase_date
FROM purchases p
RIGHT JOIN courses c  ON p.course_id  = c.course_id
LEFT JOIN  learners l ON p.learner_id = l.learner_id
ORDER BY c.course_name;





-- Q1. Each learner's total spending (quantity x unit_price) + country

SELECT
    l.full_name                              AS learner_name,
    l.country                                AS country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses  c  ON p.course_id  = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;


-- Q2. Top 3 most purchased courses by total quantity sold

SELECT
    c.course_name       AS course_name,
    c.category           AS category,
    SUM(p.quantity)       AS total_quantity_sold
FROM courses c
JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name, c.category
ORDER BY total_quantity_sold DESC, c.course_id ASC
LIMIT 3;


-- Q3. Each category's total revenue + number of unique learners

SELECT
    c.category                                   AS category,
    FORMAT(SUM(p.quantity * c.unit_price), 2)    AS total_revenue,
    COUNT(DISTINCT p.learner_id)                  AS unique_learners
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY SUM(p.quantity * c.unit_price) DESC;


-- Q4. Learners who purchased courses from MORE THAN ONE category
-
SELECT
    l.full_name                        AS learner_name,
    l.country                          AS country,
    COUNT(DISTINCT c.category)         AS categories_purchased
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses  c  ON p.course_id  = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
HAVING COUNT(DISTINCT c.category) > 1
ORDER BY categories_purchased DESC;


-- Q5. Courses that have NOT been purchased at all

SELECT
    c.course_id     AS course_id,
    c.course_name   AS course_name,
    c.category      AS category
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;


