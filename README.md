## What is a canary token, and why bother?

Canary tokens are a free, quick, painless way to help defenders discover they've been breached.

A canary token is a file, URL, API key, or other resource once that resource has been accessed an alert is triggered to notify the owner of that resource.

Canary tokens are used within an environment to help defenders identify a compromised system. They are the last line of defence that can notice you that your environment has been compromised.

Imagine an attacker finding a file "Adminpasswords.docx", surely the attacker will be tempted to open this file.
At the point of file access, an email or some other type of notification can be triggered to notify the system 
Owner and then appropriate responses can occur.

Unfortunately network breaches happen. Fortunately canary tokens make sure you can find it out rather sooner than later.

## About the script
This is a simple shell script that will create and place canary tokens.
To optimize for your own environment, some changes will be necessary.

#### randomize file type
The array filenames is where you can choose the names of the files (tokens) that will be created.
You might want to change them to something viable in your environment.

#### System owner email address
Use the Email address that needs to get notified when a token gets triggered.

#### Get the hostname for memo 
Change the way to, personalize the "memo" that will be sent with notify email so you know which system 
has been compromised.


For more info:
(https://www.canarytokens.org) 
