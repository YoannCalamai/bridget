# Bridget

A budget management application that helps you track and analyze your personal finances through automated transaction categorization and visual reporting.

## Overview

Bridget is a web-based budget application that allows you to import bank transaction data, automatically categorize expenses, and visualize your financial data through comprehensive reports and graphs. Built with simplicity and efficiency in mind, it leverages SQLPage and PostgreSQL to provide a lightweight yet powerful financial tracking solution.

## Features

- **CSV Import**: Import transaction data directly from bank-exported CSV files
- **Automatic Categorization**: Intelligent auto-categorization of transactions based on patterns and merchant information
- **Visual Reports**: Generate detailed financial reports with multiple visualization options
- **Interactive Graphs**: Visualize spending patterns, income trends, and category breakdowns
- **Transaction Management**: Review, edit, and manually categorize transactions as needed
- **PostgreSQL Backend**: Reliable and scalable data storage

## Supported Banks

Currently, Bridget supports CSV imports from:

- **Caisse d'Épargne** (France)

Additional bank support is planned for future releases.

## Technology Stack

- **SQLPage**: Dynamic web application framework for building database-driven websites
- **PostgreSQL**: Robust relational database for transaction storage and analysis
- **SQL**: Database queries and business logic

## Prerequisites

Before installing Bridget, ensure you have the following installed:

- PostgreSQL (version 12 or higher)
- SQLPage (latest version)
- Web browser (modern version with JavaScript enabled)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/bridget.git
   cd bridget
   ```

2. Set up the environnement variables
    ```bash
   cp env.exemple .env
   ```

3. Start by docker compsoe
   ```bash
   docker compose up -d
   ```

4. Access the application in your web browser at `http://localhost:8080`

## Usage

### Importing Transactions

1. Export your transaction data from Caisse d'Épargne as a CSV file
2. Navigate to the Import section in Bridget
3. Upload your CSV file
4. Review the imported transactions and verify auto-categorization

### Viewing Reports

Access various financial reports through the Reports menu:

- date range spending overview
- Category breakdown
- Income vs. expenses comparison
- Trend analysis over time

### Managing Categories

The application includes default categories for common expense types. You can:

- View all transactions by category
- Manually recategorize transactions
- Review auto-categorization accuracy

## License

This project is licensed under the GNU General Public License v3.0 (GPLv3). See the [LICENSE](LICENSE) file for details.

This means you are free to:
- Use the software for any purpose
- Study and modify the source code
- Share the software with others
- Share your modifications

Under the conditions that:
- You must disclose the source code when you distribute the software
- Any modifications must also be licensed under GPLv3
- You must include the original license and copyright notice

## Contributing

Contributions are welcome! Whether you want to add support for additional banks, improve categorization algorithms, or enhance the reporting features, your input is valuable.

Please ensure that any contributions comply with the GPLv3 license.

## Future Development

Planned features include:
- Support for additional French and international banks

## Support

For issues, questions, or suggestions, please open an issue on the project repository.

---

**Note**: Bridget is provided as-is under the GPLv3 license.