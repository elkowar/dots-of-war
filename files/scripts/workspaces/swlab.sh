#!/bin/bash

xdg-open 'https://jira-student.it.hs-heilbronn.de/secure/RapidBoard.jspa?rapidView=323&projectKey=RUNDUM&selectedIssue=RUNDUM-141'
cd ~/coding/studium/swlab/backend_studez/ || exit
#docker-compose stop
#docker-compose rm -f
docker-compose up -d 
nohup ~/intelliJInstall/bin/idea.sh ~/coding/studium/swlab/backend_studez/studez_backend &

kitty @ launch --keep-focus --type=tab --cwd ~/coding/studium/swlab/frontend_studez/studez_frontend/ npm start
cd ~/coding/studium/swlab/frontend_studez/studez_frontend/src || exit
git fetch
kitty @ send-text "cd ~/coding/studium/swlab/frontend_studez/studez_frontend/src\ngit checkout "
