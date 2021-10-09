# clickup_api_scripts
Place to share scripts that call clickup_api 

`click_up_time_scrape.rb` 
<br>Creates a basic time log for each day of the current week and each day of the prior week. It sorts by the list the task is assigned to. It requires a YAML file with individualized configuration that should not be shared. This is stored in `clickup_api_info.yml` which is not committed ot the repository but is used by the script. The fist time you run the script it will generate a stub version of this. Likley update to this measure will be to write a CSV or Excel file instead of just writing ot the console. I will also probably list a total hours each day by list, and then by sub-list which is custom just for my use. Sub-list is when a task has (#) at the end. I need to track a project by those sub tasks.

Possible future scrips could perform custom filtering like tasks that have been open for more than two weeks and are overdue, or some custom filter like that. Another possible script could be to make or change tasks, maybe adding triage tag to tasks that have been open, or making new tasks. There is already integration with GitHub, and email to for example make a task by emailing it, but there are limits to that with free account, and I may want to do something custom. I could for example run tests that if they fail make a task to follow up on it.


Here is an example of current script console output. When multiple tasks are worked on in the same list on a given day, a breakdwon for that list by task is provided after the daily summary.
```
-------
Friday: 10/8/2021
Hours: 1.95 	 ABC Facade Retrofit (10232 - 10.10) 	 Beta Intro (10)
Hours: 3.49 	 ABC Facade Retrofit (10232 - 10.40) 	 Follow up on close out of his economics tasks (40)
Hours: 1.13 	 Intelligent Campus (10052 - 07.01.01) 	 GIS Deployment
Hours: 0.79 	 OpenStudio Tasks (10136 - 01.02) 	 OS Release Support Misc (02)
Hours: 1.3 	 OpenStudio Tasks (10136 - 01.03) 	 Look at Bar surface matching issue (03)
Hours: 0.67 	 OpenStudio Tasks (10136 - 01.14) 	 OS BEM engagement Misc(14)
Hours: 0.27 	 PSU BENEFIT FOA Award (10232 - 25.01.00) 	 Provide PSU any updates on indirect rate for budget justification
Hours: 9.61 	 (Daily Total)
-------
Thursday: 10/7/2021
Hours: 0.94 	 ABC Facade Retrofit (10232 - 10.10) 	 Beta Intro (10)
Hours: 1.37 	 ABC Facade Retrofit (10232 - 10.40) 	 Follow up on close out of his economics tasks (40)
Hours: 2.01 	 Intelligent Campus (10052 - 07.01.01) 	 GIS Deployment
Hours: 2.37 	 Misc non-project related 	 ClickUp API testing, Workday Timesheets
Hours: 0.94 	 OpenStudio Tasks (10136 - 01.14) 	 Digital Building Roundtable Talks (14)
Hours: 7.64 	 (Daily Total)

Details for Misc non-project related
Hours: 1.16 	 Task: ClickUp API testing
Hours: 1.22 	 Task: Workday Timesheets
```
