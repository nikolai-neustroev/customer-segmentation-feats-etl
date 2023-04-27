WITH
  users_base AS (
    SELECT
      id as user_id,
      age,
      country,
      state,
      latitude,
      longitude
    FROM
      `bigquery-public-data.thelook_ecommerce.users`
  ),
  distribution_centers AS (
    SELECT
      id AS distribution_center_id,
      latitude AS dc_latitude,
      longitude AS dc_longitude
    FROM
      `bigquery-public-data.thelook_ecommerce.distribution_centers`
  ),
  user_orders AS (
    SELECT
      user_id,
      order_id,
      created_at,
      returned_at,
      COUNT(order_id) OVER (PARTITION BY user_id) AS total_orders,
      COUNTIF(returned_at IS NOT NULL) OVER (PARTITION BY user_id) AS total_returns
    FROM
      `bigquery-public-data.thelook_ecommerce.orders`
    WHERE
      DATE_DIFF(CURRENT_DATE(), DATE(created_at), YEAR) = 1
  ),
  user_order_summary AS (
    SELECT
      oi.user_id,
      total_returns / total_orders AS product_return_rate_last_year,
      SUM(sale_price) AS total_purchase_last_year
    FROM
      `bigquery-public-data.thelook_ecommerce.order_items` oi
    INNER JOIN
      user_orders uo
    ON
      oi.user_id = uo.user_id
      AND oi.order_id = uo.order_id
    GROUP BY
      oi.user_id,
      total_returns,
      total_orders
  ),
  user_nearest_dc AS (
    SELECT
      ub.user_id,
      ub.age,
      ub.country,
      ub.state,
      dc.distribution_center_id,
      RANK() OVER (PARTITION BY ub.user_id ORDER BY ST_DISTANCE(ST_GEOGPOINT(ub.longitude, ub.latitude), ST_GEOGPOINT(dc.dc_longitude, dc.dc_latitude))) AS nearest_dc_rank
    FROM
      users_base ub
    CROSS JOIN
      distribution_centers dc
  ),
  user_nearest_dc_filtered AS (
    SELECT
      user_id,
      distribution_center_id AS nearest_distribution_center
    FROM
      user_nearest_dc
    WHERE
      nearest_dc_rank = 1
  )
SELECT
  ub.user_id,
  ub.age,
  ub.country,
  ub.state,
  und.nearest_distribution_center,
  uos.product_return_rate_last_year,
  CASE
    WHEN uos.total_purchase_last_year <= 50 THEN 'Level 1'
    WHEN uos.total_purchase_last_year > 50 AND uos.total_purchase_last_year <= 150 THEN 'Level 2'
    ELSE 'Level 3'
  END AS customer_profit_level_last_year
FROM
  users_base ub
JOIN
  user_order_summary uos
ON
  ub.user_id = uos.user_id
JOIN
  user_nearest_dc_filtered und
ON
  ub.user_id = und.user_id
