# SQL Server Schema Description and Query Generation using NL2SQL
  
This project provides a set of tools to generate descriptions for SQL Server tables, create SQL queries based on user natural language questions (NL2SQL), and execute those queries to retrieve and display data. It leverages OpenAI's GPT4 model for generating descriptions and queries.  

*NOTE*: This code has only been tested on Linux (Ubuntu) and may need changes to work on other OS's.



## Features  
  
- Generate detailed descriptions for SQL Server tables to assist Azure OpenAI in generating highly accuracte queries.
- Create SQL queries based on user questions.  
- Execute SQL queries and display results in markdown format.  
- Generate textual answers based on query results.  
  
## Setup  
  
### Prerequisites  
  
- Python 3.7 or higher  
- Required Python packages: `pyodbc`, `openai`, `pandas`, `IPython`, `tabulate`  
  
### Installation and Usage
  
1. Clone the repository:  
    ```sh  
    git clone [https://github.com/liamca/azure_openai_nl2sql](https://github.com/liamca/azure_openai_nl2sql)  
    cd azure_openai_nl2sql  
    ```  
  
2. Install the required Python packages and Microsoft SQL ODBC Drivers:  
    ```sh  
    pip install pyodbc openai pandas ipython

    sudo apt-get update
    sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
    # optional: for bcp and sqlcmd
    sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
    source ~/.bashrc
    # optional: for unixODBC development headers
    sudo apt-get install -y unixodbc-dev
    # optional: kerberos library for debian-slim distributions
    sudo apt-get install -y libgssapi-krb5-2
    ```  

3. Open the demo notebook [nl2sql.ipynb]([nl2sql.ipynb](https://github.com/liamca/azure_openai_nl2sql/blob/main/nl2sql.ipynb))
  
4. Locate the Configuration cell and configure your environment variables:  
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

### Example SQL Query Generation
![image](https://github.com/user-attachments/assets/50eac200-a567-4887-8e6e-95f2f94e4335)

