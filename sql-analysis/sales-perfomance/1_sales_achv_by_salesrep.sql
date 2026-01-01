SELECT
    e.sales_rep_id,
    CONCAT(e.first_name, ' ', e.last_name) AS sales_rep_name,
    f.fiscal_year,
    f.fiscal_period,
    SUM(a.qty * d.unit_price) AS actual_amt,
    f.target_amt,
    ROUND(
        SUM((a.qty * d.unit_price) / NULLIF(f.target_amt,0)) * 100,
        2
        ) AS achv_pct

FROM order_dtl a 

JOIN order_head b
    ON a.order_num = b.order_num

JOIN customer c
    ON b.cust_num = c.cust_num 

JOIN part d
    ON a.part_num = d.part_num 

JOIN sales_rep e
    ON c.sales_rep_id = e.sales_rep_id

JOIN sales_target f
    ON e.sales_rep_id = f.sales_rep_id 
   AND a.fiscal_period = f.fiscal_period
   AND a.fiscal_year = f.fiscal_year

GROUP BY
    e.sales_rep_id,
    sales_rep_name,
    f.fiscal_year,
    f.fiscal_period,
    f.target_amt

ORDER BY
    e.sales_rep_id,
    f.fiscal_year,
    f.fiscal_period
;