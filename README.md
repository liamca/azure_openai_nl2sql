# SQL Server Schema Description and Query Generation  
  
This project provides a set of tools to generate descriptions for SQL Server tables, create SQL queries based on user questions, and execute those queries to retrieve and display data. It leverages OpenAI's GPT models for generating descriptions and queries.  
  
## Features  
  
- Generate detailed descriptions for SQL Server tables.  
- Create SQL queries based on user questions.  
- Execute SQL queries and display results in markdown format.  
- Generate textual answers based on query results.  
  
## Setup  
  
### Prerequisites  
  
- Python 3.7 or higher  
- Required Python packages: `pyodbc`, `openai`, `pandas`, `IPython`  
  
### Installation  
  
1. Clone the repository:  
    ```sh  
    git clone [https://github.com/liamca/azure_openai_nl2sql](https://github.com/liamca/azure_openai_nl2sql)  
    cd azure_openai_nl2sql  
    ```  
  
2. Install the required Python packages:  
    ```sh  
    pip install pyodbc openai pandas ipython  
    ```  
  
3. Configure your environment variables:  
    - `openai_gpt_api_base`  
    - `openai_gpt_api_key`  
    - `openai_gpt_api_version`  
    - `openai_gpt_model`  
    - `openai_embedding_api_base`  
    - `openai_embedding_api_key`  
    - `openai_embedding_api_version`  
    - `openai_embedding_model`  
    - `server`  
    - `database`  
    - `username`  
    - `password`  
  
## Usage  
  
### Generate Schema Information  
  
To generate schema information for your SQL Server database, use the `get_sql_server_schema_info` function:  
  
```python  
schema_info = get_sql_server_schema_info(server, database, username, password)  
