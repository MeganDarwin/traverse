# Traverse

## Overview

Traverse is a web application that allows users to share and log their travel experiences. You can create travel entries, upload photos, and leave comments. It includes authentication and authorization, so only you can edit or delete your own entries and comments.

## Features

- User authentication and authorization
- Create, edit, and delete travels
- Upload and display images for each travel entry
- Add and manage comments on travels
- Responsive design using Tailwind CSS
- Turbo Frames and Turbo Streams for dynamic updates

## Local Development Setup

### Prerequisites

- Ruby (version 3.4.1 or later)
- Rails (version 8.0 or later)
- PostgreSQL
- NPM

### Getting Started

1. **Clone the repository:**

   ```sh
   git clone https://github.com/your-username/travel-app.git
   cd travel-app
   ```

2. **Install Dependencies:**

   ```sh
   bundle install
   npm install
   ```

3. **Set up the database:**

   ```sh
   rails db:create
   rails db:migrate
   ```

4. **Seed the database (optional):**

   ```sh
   rails db:seed
   ```

5. **Start the Rails server:**

   ```sh
   rails server
   ```

6. **Visit the application:**

   Open your web browser and go to http://localhost:3000.

### Environment Variables

Create a `.env` file in the root directory of the project and add any necessary environment variables. For example:

```
DATABASE_USERNAME=your_database_username
DATABASE_PASSWORD=your_database_password
```

### Running Tests

To run the test suite, use the following command:

```sh
rails test
```

### Linting and Formatting

To check for code style issues, use RuboCop:

```sh
bundle exec rubocop
```

To automatically fix code style issues, use:

```sh
bundle exec rubocop -a
```