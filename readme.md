## Vanna AI SQL Demo

This repository contains a simple demonstration of using Vanna AI to interact with a SQL database using Google BigQuery and Gemini model.

**Features:**

* Load SQL queries from files for training
* Train a Vanna AI model on information schema and custom SQL queries
* Interactive web interface for natural language querying through Flask
* BigQuery integration for data storage and retrieval

**Requirements:**

* Python 3.10+
* Google Cloud Project with BigQuery enabled
* Google Gemini API access
* Required Python packages (install with `pip install -r requirements.txt`)

**Setup:**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jcsn13/vanna-ai-demo.git
   cd vanna-ai-sql-demo
   ```

2. **Create a `.env` file from the `.env_example`:**
   ```plaintext
   BIG_QUERY_PROJECT=your_gcp_project_id
   MODEL_NAME=gemini-pro
   LANGUAGE=pt  # or your preferred language
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

**Project Structure:**
```
vanna-ai-sql-demo/
├── training_data/
│   ├── information_schema.sql  # Database schema queries
│   └── training.sql           # Custom training queries
├── helper.py         # Utility functions and Vanna model setup
├── app.py            # Flask web application
├── .env              # Environment variables
├── requirements.txt  # Project dependencies
├── Dockerfile        # Docker file for Cloud Run
├── deploy.sh         # Cloud Run deployment script
└── .env_example      # Example .env file

```

**Usage:**

1. **Prepare your SQL queries:**
   * Place your schema queries in `training_data/information_schema.sql`
   * Place your training queries in `training_data/training.sql`

2. **Start the web interface(Local):**
   ```bash
   python app.py
   ```
   This will launch a Flask web application where you can:
   * Connect to your BigQuery project
   * Train the model on your database schema
   * Train on your custom SQL queries
   * Input natural language queries
   * Get SQL translations
   * View query results

**Deployment:**

1. **Run the `deploy.sh`:**
   ```bash
   sh deploy.sh
   ```
   The script will:
   * Enable required Google Cloud APIs
   * Build and push the Docker image
   * Deploy to Cloud Run
   * Configure environment variables
   * Display the service URL upon completion

**Cloud Run Configuration:**

   The deployment script configures the following for your Cloud Run service:

   * CPU: 1 core
   * Memory: 2GB
   * Minimum instances: 0 (scale to zero)
   * Maximum instances: 1
   * Port: 8084
   * Public access enabled
   * Automatic environment variable configuration from .env file

**Notes:**
* The training process must be completed before running the web application
* Make sure your BigQuery project has the necessary permissions set up
* The web interface runs in debug mode by default for development purposes
* Refer to the [Vanna AI documentation](https://vanna.ai/docs) for more advanced usage and customization options

**Environment Variables:**

| Variable | Description |
|----------|-------------|
| `BIG_QUERY_PROJECT` | Your Google Cloud project ID |
| `MODEL_NAME` | The Gemini model to use (default: gemini-pro) |
| `LANGUAGE` | The language for queries and responses |

**Contributing:**
Contributions are welcome! Please feel free to submit a Pull Request.