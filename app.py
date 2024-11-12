import os
from vanna.flask import VannaFlaskApp
from helper import load_env_vars, get_vanna_model, read_sql_queries

load_env_vars()

vn = get_vanna_model()

vn.connect_to_bigquery(project_id=os.getenv("BIG_QUERY_PROJECT"))

info_schemas = read_sql_queries("training_data/information_schema.sql")

for schema in info_schemas:
    df = vn.run_sql(schema)
    plan = vn.get_training_plan_generic(df)
    vn.train(plan=plan)

queries = read_sql_queries("training_data/training.sql")

for query in queries:
    vn.train(sql=query)

app = VannaFlaskApp(
    vn,
    allow_llm_to_see_data=True,
    debug=False,
    ask_results_correct=False,
)
app.run()
