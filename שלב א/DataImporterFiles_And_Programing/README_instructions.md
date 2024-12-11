# README

## Step-by-Step Instructions

### 1. Run `extractAndGenerateData.ipynb`

- **Purpose**: This notebook generates data and exports it into CSV files.
- **Output**: CSV files are created and stored in the `Files` directory.
- **Instructions**:
  1. Open `extractAndGenerateData.ipynb` in your Jupyter environment.
  2. Execute all cells in the notebook.
  3. Ensure that the `Files` directory is populated with the required CSV files upon successful execution.

### 2. Run `create_sql_insert_files.ipynb`

- **Purpose**: This notebook processes the CSV files generated in the previous step and creates SQL `INSERT` statements.
- **Output**: The following files will be generated:
  - Individual `INSERT` SQL files for each table.
  - A combined SQL file named `insertTables.sql` that includes all `INSERT` statements in one place.
- **Instructions**:
  1. Ensure that all required CSV files are present in the `Files` directory before proceeding.
  2. Open `create_sql_insert_files.ipynb` in your Jupyter environment.
  3. Execute all cells in the notebook.
  4. Verify that the generated SQL files are saved in the Files folder.
