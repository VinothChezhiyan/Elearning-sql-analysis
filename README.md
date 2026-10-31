# E-Learning Platform Purchase Analysis (SQL)

Analysis of learner purchase data across courses, categories and countries using MySQL.

## Database Design
- learners: learner_id, full_name, country
- courses: course_id, course_name, category, unit_price
- purchases: purchase_id, learner_id, course_id, quantity, purchase_date

Dataset: 5 learners, 6 courses (5 categories), 8 purchase transactions.

## SQL Concepts Used
- DDL: CREATE DATABASE, CREATE TABLE, PRIMARY KEY, FOREIGN KEY, constraints
- INNER JOIN, LEFT JOIN, RIGHT JOIN
- GROUP BY, HAVING, ORDER BY, LIMIT
- Aggregate functions: SUM, COUNT(DISTINCT)

## Business Questions Answered
1. Each learner's total spending and country
2. Top 3 most purchased courses by quantity
3. Revenue and unique learners per category
4. Learners who bought from more than one category
5. Courses with no purchases

## Key Insights
- Total revenue: $263.88
- Top spender: Sofia Garcia (Spain), $72.97
- Best-selling course: Python for Beginners (6 units)
- Programming drives about 55% of revenue ($144.93) and reached 4 of 5 learners
- 60% of learners bought from more than one category
- Excel for Business had zero purchases

## Recommendations
- Focus marketing on Programming and add an advanced track to upsell
- Relaunch Excel for Business with a bundle or intro discount
- Promote cross-selling to single-category learners
- Run a targeted acquisition campaign for Data Science

## Files
- Elearning_Analysis.sql: database, tables, data and all queries
- Summary_Report.docx: full summary report

## How to Run
1. Open MySQL Workbench
2. File > Open SQL Script, select Elearning_Analysis.sql
3. Click the lightning icon to run the script

## Tools
MySQL, MySQL Workbench

Author: Vinoth C | linkedin.com/in/vinoth-data
