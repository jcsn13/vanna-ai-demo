-- Media de gorjedas do ano de 2022 agrupada por mês
SELECT
    avg(taxi_trips.tips) AS avg_tips,
    EXTRACT(MONTH FROM taxi_trips.trip_start_timestamp) AS month
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips` AS taxi_trips
  WHERE EXTRACT(YEAR FROM taxi_trips.trip_start_timestamp) = 2022
  GROUP BY 2;

-- Quais as 5 empresas mais lucrativas?
SELECT
    company,
    sum(trip_total) AS total_profit
  FROM
    `jose-genai-demos.chicago_taxi_trips.taxi_trips` AS taxi_trips
  GROUP BY 1
ORDER BY
  total_profit DESC
LIMIT 5;

-- Quais é a média de duração das viagens em novembro de 2022 agrupadas por empresa?
SELECT
    company,
    AVG(trip_seconds) AS average_trip_duration
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) BETWEEN '2022-11-01' AND '2022-11-30'
  GROUP BY 1;