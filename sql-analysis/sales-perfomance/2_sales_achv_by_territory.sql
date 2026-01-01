WITH   
    actual_amt AS(
        SELECT
            f.trr_code,
            f.trr_name,
            a.fiscal_year,
            a.fiscal_period,
            SUM(a.qty * d.unit_price) AS trr_actual_amt

        FROM order_dtl a

        JOIN order_head b
            ON a.order_num = b.order_num
        
        JOIN customer c
            ON b.cust_num = c.cust_num

        JOIN part d
            ON a.part_num = d.part_num
        
        JOIN sales_rep e
            ON c.sales_rep_id = e.sales_rep_id
        
        JOIN territory f
            ON  c.trr_code = f.trr_code
        
        GROUP BY
            f.trr_code,
            f.trr_name,
            a.fiscal_year,
            a.fiscal_period
    ),

    target_amt AS(
        SELECT
            f.trr_code,
            f.trr_name,
            g.fiscal_year,
            g.fiscal_period,
            SUM(g.target_amt) AS trr_target_amt

        FROM sales_target g 

        JOIN sales_rep e
            ON g.sales_rep_id = e.sales_rep_id
        
        JOIN territory f 
            ON e.trr_code = f.trr_code
        
        GROUP BY
            f.trr_code,
            f.trr_name,
            g.fiscal_year,
            g.fiscal_period
    )

    SELECT
        h.trr_code,
        h.trr_name,
        h.fiscal_year,
        h.fiscal_period,
        h.trr_actual_amt,
        i.trr_target_amt,
        ROUND(
            (h.trr_actual_amt / NULLIF(i.trr_target_amt, 0)) * 100,
            2
            ) AS trr_achv_pct

    FROM actual_amt h 

    JOIN target_amt i
        ON h.trr_code = i.trr_code
        AND h.fiscal_year = i.fiscal_year
        AND h.fiscal_period = i.fiscal_period
    
    GROUP BY
        h.trr_code,
        h.trr_name,
        h.fiscal_year,
        h.fiscal_period,
        h.trr_actual_amt,
        i.trr_target_amt
    
       ORDER BY
        h.trr_code,
        h.fiscal_year,
        h.fiscal_period
;
