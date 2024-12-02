#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")"

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals 
do
if [[ "$year" != "year" ]];
then
winner_exists=$($PSQL "SELECT name FROM teams WHERE name = '$winner'")
opponent_exists=$($PSQL "SELECT name FROM teams WHERE name = '$opponent'")
if [[ -z "$winner_exists" ]];
then
echo $($PSQL "INSERT INTO teams(name) VALUES('$winner')")
fi
if [[ -z "$opponent_exists" ]];
then
echo $($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
fi
fi
echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $($PSQL "SELECT team_id FROM teams WHERE name = '$winner'"), $($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'"), $winner_goals, $opponent_goals)")"
done