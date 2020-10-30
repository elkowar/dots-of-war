#! /bin/sh

xdg-open 'https://jira-student.it.hs-heilbronn.de/secure/RapidBoard.jspa?rapidView=323&projectKey=RUNDUM&selectedIssue=RUNDUM-141'
cd "$HOME/coding/studium/swlab/backend_studez/" || exit
#docker-compose stop
#docker-compose rm -f
docker-compose up -d
nohup "$HOME/intelliJInstall/bin/idea.sh" "$HOME/coding/studium/swlab/backend_studez/studez_backend" &

kitty @ launch --keep-focus --type=tab --cwd "$HOME/coding/studium/swlab/frontend_studez/studez_frontend/" npm start
cd "$HOME/coding/studium/swlab/frontend_studez/studez_frontend/src" || exit
git fetch
kitty @ send-text "cd $HOME/coding/studium/swlab/frontend_studez/studez_frontend/src\ngit checkout "
