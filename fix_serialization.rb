#! /usr/bin/env ruby

#####################################################################
#                     Wordpress Fix Serialization                   #
#                       Created by: Will Sizoo                      #
#                            Version: 1.0                           #
#####################################################################

require 'rubygems'
require 'mysql2'

# Server Parameters
$server_ip = ''
$server_user = ''
$server_password = ''
$database_name = ''

# Query Parameters
$table = '' # $table = 'wp_options'
$column = '' # $column = 'option_value'
$column_identifier = '' # $column_identifier = 'option_name'
$column_identifier_value = '' # $column_identifier_value = 'scss_settings' (can be set to int (id) if needed, converted to string in query)

# Queries the value that needs to be fixed
def query_data

  begin
    client = Mysql2::Client.new(:host => $server_ip, :username => $server_user, :password => $server_password, :database => $database_name )
    query = client.query("SELECT #{$column} FROM #{$table} WHERE #{$column_identifier} LIKE '#{$column_identifier_value.to_s}'")
  rescue Mysql2::Error => e
    puts "Initial Query Failed."
    puts e.error
  ensure
    client.close if client
  end

  $content_to_fix = query.first["#{$column}"]

  # Uncomment to view original value
  # puts $content_to_fix
  # puts "=*"*30

end # End query_data

# Reserializes every entry in returned value
def reserialize

  $fixed_content = $content_to_fix.gsub!(/s:([0-9]+):\"((.|\n)*?)\";/) {"s:#{$2.bytesize}:\"#{$2}\";"}

  # Uncomment to view fixed value
  # puts $fixed_content
  # puts "=*"*30

end # End reserialize

# Updates value with correct serialization
def mysql_update

  begin
    client = Mysql2::Client.new(:host => $server_ip, :username => $server_user, :password => $server_password, :database => $database_name )
    # Ensures content passed through does not break query
    escaped_fix_content = client.escape($fixed_content)
    query = client.query("UPDATE #{$table} SET #{$column} = '#{escaped_fix_content}' WHERE #{$column_identifier} LIKE '#{$column_identifier_value}'")
    puts "Fixed #{$column} for #{$column_identifier_value}."
  rescue Mysql2::Error => e
    puts "Update Failed."
    puts e.error
  ensure
    client.close if client
  end

end # End mysql_update

def fix_serialiation
  query_data
  reserialize
  mysql_update
end

# Fix it!
fix_serialiation
