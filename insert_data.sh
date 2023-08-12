#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE teams, games")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do 
  if [[ $WINNER != "winner" ]]
    then
      # get winner id 
      WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      echo $WINNER_TEAM
      # if not found
      if [[ -z $WINNER_TEAM ]]
        then
          INSERT_NAME_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          #WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi

      # get opponant id
      OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      echo $OPPONENT_TEAM
      # if not found
      if [[ -z $OPPONENT_TEAM ]]
        then
          INSERT_NAME_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          #OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
      WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      INSERT_GAMES_INFO=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM, $OPPONENT_TEAM, $WINNERGOALS, $OPPONENTGOALS)")
  fi
done
