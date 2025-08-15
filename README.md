# Good Night Application

"**Good Night**" application to let users track when they go to bed and when they wake up.

## 🚀 Features

1. Clock In & Clock Out operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records of a user's All following users' sleep records. from the previous week, which are sorted based on the duration of All friends sleep length.

## 🛠 Tech Stack

- **Framework**: Ruby on Rails 7.x
- **Database**: SQLite3 (development/test)
- **Cache/Queue**: Redis
- **Testing**: RSpec
- **API Documentation**: RSwag

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.1+ (check with `ruby --version`)
- Rails 7.x (check with `rails --version`)
- Redis server

### Installing Redis

**macOS (using Homebrew):**

```bash
brew install redis
brew services start redis
```

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

**Windows:**

```bash
# Using WSL2 or download from GitHub releases
```

**Test Redis connection in Rails console**

```ruby
redis = Redis.new(url: "redis://localhost:6379/1")
redis.set("mykey", "hello world")
redis.get("mykey") # => "hello world"
```

## 🔧 Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/AankTia/good-night-app.git
   cd good-night-app
   ```

2. **Install Dependencies**

   ```bash
   bundle install
   ```

3. **Set up the database**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

   or

   ```bash
   rails db:prepare
   ```

   This will:

   - Create databases for all environments (development, test)
   - Run migrations
   - Load schema (if needed)

4. **Start Redis server** (if not already running)

   ```bash
   redis-server
   ```

5. **Start the Rails server**

   ```bash
   rails server
   ```

6. **Visit the application**

   Open your browser and navigate to `http://localhost:3000`

## 🧪 Testing

Run the test suite

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/sleep_record_spec.rb
```

## API Documentation

This application uses **RSwag** to generate interactive API documentation.

### Viewing the API Documentation

1. **Generate the Swagger documentation** (after running tests):

   ```bash
   bundle exec rspec --pattern "spec/requests/**/*_spec.rb"
   ```

2. **Access the interactive API docs**:
   - Start your Rails server (`rails server`)
   - Visit `http://localhost:3000/api-docs` in your browser
   - Explore and test API endpoints directly from the browser

### Alternative Documentation

You can also refer to the static [API Documentation](API_Documentation.md) for quick reference.

### Updating API Documentation

The API documentation is automatically generated from RSpec request specs. To update the documentation:

1. Modify the relevant request specs in `spec/requests/`
2. Run the specs to regenerate the documentation:
   ```bash
   bundle exec rspec --pattern "spec/requests/**/*_spec.rb"
   ```
3. The Swagger JSON will be updated automatically
