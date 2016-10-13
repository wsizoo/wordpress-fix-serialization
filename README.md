# Wordpress Fix Serialization
This script is meant to fix all serializations inside a given table value.


## Instructions
### Setup
**Download Repo**
```
git clone git@github.com:wsizoo/wordpress-fix-serialization.git
```

**Open Directory**
```
cd wordpress-fix-serialization
```

**Edit Server & Query Parameters**
```ruby
# Server Parameters
$server_ip = '1.1.1.1'
$server_user = 'username'
$server_password = 'password'
$database_name = 'dbname'

# Query Parameters
$table = 'wp_options'
$column = 'option_value'
$column_identifier = 'option_name'
$column_identifier_value = 'scss_settings' (can be set to int (id) if needed, converted to string in query)
```

**Install Gems**
```
gem install mysql2
```

### Run Script

**_I do not take responsibility for any issue that occur with your data. Please make a backup before running._**

**Start Script**
```
ruby fix_serialization.rb
```