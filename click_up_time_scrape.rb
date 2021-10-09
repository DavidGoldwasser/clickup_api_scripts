require 'rubygems' if RUBY_VERSION < '1.9'
require 'rest-client'
require 'json'

# load configuration file
require 'yaml'
script_path = File.expand_path(File.dirname(__FILE__))
config_file_path = script_path + "/clickup_api_info.yml"

# todo - make example config file if it doesn't already exist
if(!File.file?(config_file_path)) 
  puts "Yaml file not found, making a place holder #{config_file_path}."
  puts "Please update with your personal information and then re-run the script."
  puts "Your API key can be found under Setting/apps."
  puts "It should not be shared or commited to this repository."
  config = {
    "parameters" => {
      "authorization"=>"asdf",
      "team_id"=>12345
    }
  }
  File.write(config_file_path, config.to_yaml)
  return
end

# load file
config_data = YAML.load_file(config_file_path)

# headers for AP call
headers = {
  :authorization => config_data["parameters"]["authorization"],
  :content_type => 'application/json'
}

# setup for separate API calls for each day of this week and prior week
# todo - store task list across days if it has already been looked up so don't have to hit API extra times
current_date = DateTime.now.to_date
weekday = current_date.wday

# offsetting time in API reqeust to be UTC
current_time = DateTime.now.to_time
utc_offset_milli = current_time.gmt_offset * 1000

# gather days to inspect
num_days_to_gather = weekday + 8 # 7 days of prior week +1
days_to_gather = []
num_days_to_gather.times do
  days_to_gather << current_date
  current_date = current_date.prev_day
end

# store tasks that I already have list for
global_tasks = {}

# loop through days
days_to_gather.each do |current_date|

  # hash to aggregrate data
  tasks = {}

  # parse the current date
  year = current_date.year
  month = current_date.mon
  day = current_date.mday
  weekday = current_date.wday
  weekday_name = current_date.strftime("%A")

  #prev_milli = current_date.prev_day.strftime('%Q').to_i - utc_offset_milli
  today_milli = current_date.strftime('%Q').to_i - utc_offset_milli
  next_milli = current_date.next_day.strftime('%Q').to_i - utc_offset_milli
  #puts current_date
  puts "-------"
  puts "#{weekday_name}: #{month}/#{day}/#{year}"
  #puts today_milli

  response = RestClient.get "https://api.clickup.com/api/v2/team/#{config_data["parameters"]["team_id"]}/time_entries?start_date=#{today_milli}&end_date=#{next_milli}", headers
  response_hash = JSON.parse(response)["data"]
  #puts "#{response_hash.size} Time entires for today"
  #puts response_hash
  response_hash.each do |k,v|
    #puts k
    #puts v

    # key is a hash go into that
    k.each do |k2, v2|
      # uncomment to look at data for each item
      # "#{k2} >>>> #{v2}"
    end

    # todo - items show up multiple times, aggregrate duration for each task and list
    # todo - eventually roll up to project (list) but I wan to keep sub-task
    dur_hours = k["duration"].to_f/(1000*60*60)
    name = k["task"]["name"]
    task_id = k["task"]["id"]
    #puts "Name: #{k["task"]["name"]}, Duration #{dur_hours.round(2)} hours"

    # store data
    if tasks.has_key?(name)
      tasks[name]["dur_hours"] += dur_hours
    elsif global_tasks.has_key?(name)

      # don't need to call API since called on prior day
      tasks[name] = {"dur_hours" => dur_hours, "task_id" => task_id, "list" => global_tasks[name]["list"]}

    else
      # get list for task
      task_response = RestClient.get "https://api.clickup.com/api/v2/task/#{task_id}/", headers
      task_list_name = JSON.parse(task_response)["list"]["name"]

      tasks[name] = {"dur_hours" => dur_hours, "task_id" => task_id, "list" => task_list_name}
      global_tasks[name] = {"dur_hours" => dur_hours, "task_id" => task_id, "list" => task_list_name}
    end

  end

  # in future may dump this to CSV file instead
  strings = []
  tasks.sort.each do |k,v|
    strings << "List: #{v["list"]} \tTask: #{k}, \tDuration: #{v["dur_hours"].round(2)} hours"
  end
  puts strings.sort

end
