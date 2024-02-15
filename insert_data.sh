#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE teams, games"
FILE="/workspace/project/games.csv"

while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    QUERYING_TEAM="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
    
    if [[ -z $QUERYING_TEAM ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES ('$WINNER')"
    fi

    QUERYING_TEAM="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"

    if [[ -z $QUERYING_TEAM ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')"
    fi
  fi
done < $FILE  


while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    ID_WINNER="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    ID_OPPONENT="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $ID_WINNER, $ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done < $FILE

