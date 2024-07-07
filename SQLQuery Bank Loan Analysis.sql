SELECT * FROM bank_loan_data

 --For Dashboard 1 (KPI Requirements)

 -- 1) Total Loan Applications
 SELECT COUNT(id) as Total_Loan_Applications FROM bank_loan_data
 -- MTD Loan Applications
 SELECT COUNT(id) as MTD_Total_Loan_Applications FROM bank_loan_data
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
 --PMTD Loan Applications
 SELECT COUNT(id) as MTD_Total_Loan_Applications FROM bank_loan_data
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 -- 2) Total Funded Amounts
 SELECT SUM(loan_amount) as Total_Funded_Amounts FROM bank_loan_data
 -- MTD Total Funded Amounts
 SELECT SUM(loan_amount) as MTD_Total_Funded_Amounts FROM bank_loan_data
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
 --PMTD Loan Applications
 SELECT SUM(loan_amount) as PMTD_Total_Funded_Amounts FROM bank_loan_data
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 -- 3) Total Amount Received
 SELECT SUM(total_payment) as Total_Amount_Received FROM bank_loan_data
 --MTD Total Amount Received
 SELECT SUM(total_payment) as MTD_Total_Funded_Amounts FROM bank_loan_data
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
 --PMTD Total Amount Received
 SELECT SUM(total_payment) as PMTD_Total_Funded_Amounts FROM bank_loan_data
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 -- 4) Average Interest Rate
 SELECT AVG(int_rate)*100 as Avg_Interest_Rate FROM bank_loan_data
 -- Convert to 2 decimal places
 SELECT ROUND(AVG(int_rate),4)*100 as Avg_Interest_Rate FROM bank_loan_data
 --MTD Average Interest Rate
 SELECT ROUND(AVG(int_rate),4)*100 as MTD_Avg_Interest_Rate FROM bank_loan_data
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
 --PMTD Average Interest Rate
 SELECT ROUND(AVG(int_rate),4)*100 as PMTD_Avg_Interest_Rate FROM bank_loan_data
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 -- 5) Average Debt-to-Income (DTI) Ratio
 SELECT ROUND(AVG(dti),4) *100 as Avg_DTI FROM bank_loan_data
 --MTD Average Debt-to-Income (DTI) Ratio
 SELECT ROUND(AVG(dti),4) *100 as MTD_Avg_DTI FROM bank_loan_data
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
 --PMTD Average Debt-to-Income (DTI) Ratio
 SELECT ROUND(AVG(dti),4) *100 as PMTD_Avg_DTI FROM bank_loan_data
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 --For Dashboard 1 (Good Loan vs Bad Loan KPI's)

 -- *For Good Loan*--
 --1) Good Loan Application Percentage
 SELECT
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)*100)
	/
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data

--2) Good Loan Application
SELECT COUNT(id) as Good_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--3) Good Loan Funded Amount
SELECT SUM(loan_amount) as Good_Loan_Funded_Amounts FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--4) Good Loan Total Received Amount
SELECT SUM(total_payment) as Good_Loan_Total_Received_Amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- *For Bad Loan*--
--1) Bad Loan Application Percentage
SELECT
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100.0)
	/
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data

--2) Bad Loan Applications
SELECT COUNT(id) as Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--3) Bad Loan Funded Amount
SELECT SUM(loan_amount) as Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--4) Bad Loan Total Received Amounnt
SELECT SUM(total_payment) as Bad_Loan_Amount_Received FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--Loan Status Grid View

SELECT 
		loan_status,
		COUNT(id) as Total_Loan_Applications,
		SUM(total_payment) as Total_Amount_Received,
		SUM(loan_amount) as Total_Funded_Amount,
		AVG(int_rate *100) as Interest_Rate,
		AVG(dti*100) as DTI
		FROM 
			bank_loan_data
		GROUP BY
			loan_status

SELECT 
		loan_status,
		SUM(total_payment) as MTD_Total_Amount_Received,
		SUM(loan_amount) as MTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) =12
GROUP BY loan_status

--  For Dashboard 2 (Charts)

--1) Monthly Trends
SELECT
	MONTH(issue_date) as Month_Number,
	DATENAME(MONTH,issue_date) as Month_Name,
	COUNT(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH,issue_date)
ORDER BY MONTH(issue_date)

--2) Regional Analysis
SELECT
	address_state,
	COUNT(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY address_state
ORDER BY Total_Funded_Amount DESC

--3) Loan Term Analysis
SELECT
	term,
	COUNT(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY term
ORDER BY term

--4) Employee Length
SELECT
	emp_length,
	COUNT(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY emp_length
ORDER BY Total_Loan_Applications DESC

--5) Loan Purpose Breakdown
SELECT
	purpose,
	COUNT(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY purpose
ORDER BY Total_Loan_Applications DESC

--6) Home Ownership
SELECT
	home_ownership,
	COUNT(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY Total_Loan_Applications DESC
