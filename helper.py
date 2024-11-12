import sqlparse
import os
from dotenv import load_dotenv
from vanna.chromadb import ChromaDB_VectorStore
from vanna.google import GoogleGeminiChat


def load_env_vars(env_file=".env"):
    load_dotenv(dotenv_path=env_file)


load_env_vars()


class MyVanna(ChromaDB_VectorStore, GoogleGeminiChat):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(
            self,
            config={
                "language": "pt",
                "system_prompt": """Você é um assistente prestativo que gera SQL com base em perguntas.
                Sempre responda em Português. Quando você não entender a pergunta, peça esclarecimentos em Português.
                Quando explicar o SQL gerado, faça-o em Português.""",
            },
        )
        GoogleGeminiChat.__init__(
            self,
            config={
                "model": os.getenv("MODEL_NAME"),
                "language": "pt",
                "system_prompt": """Você é um assistente prestativo que traduz perguntas em linguagem natural para SQL.
                Sempre responda em Português. Explique os resultados em Português de forma clara e concisa.
                Se você não entender algo, peça esclarecimentos em Português.""",
            },
        )


def read_sql_queries(filepath):
    with open(filepath, "r") as f:
        sql_file = f.read()

    queries = []
    for statement in sqlparse.split(sql_file):
        if statement.strip():
            queries.append(statement.strip())
    return queries


def get_vanna_model():
    model = MyVanna()
    return model
