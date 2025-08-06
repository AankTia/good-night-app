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
