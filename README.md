# clickup_api_scripts
Place to share scripts that call clickup_api 

`click_up_time_scrape.rb` 
<br>Creates a basic time log for each day of the current week and each day of the prior week. It sorts by the list the task is assigned to. It requires a YAML file with individualized configuration that should not be shared. This is stored in `clickup_api_info.yml` which is not committed ot the repository but is used by the script. The fist time you run the script it will generate a stub version of this. Likley update to this measure will be to write a CSV or Excel file instead of just writing ot the console. I will also probably list a total hours each day by list, and then by sub-list which is custom just for my use. Sub-list is when a task has (#) at the end. I need to track a project by those sub tasks.

Possible future scrips could perform custom filtering like tasks that have been open for more than two weeks and are overdue, or some custom filter like that. Another possible script could be to make or change tasks, maybe adding triage tag to tasks that have been open, or making new tasks. There is already integration with GitHub, and email to for example make a task by emailing it, but there are limits to that with free account, and I may want to do something custom. I could for example run tests that if they fail make a task to follow up on it.
