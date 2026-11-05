#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games,teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR = "year" ]]
  then
    echo No se toma la primera linea
  else
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      RESULT_INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
      echo -e "INSERT OPPONENT: $OPPONENT in teams \nResult:$RESULT_INSERT_TEAM"
    else
      echo "The team OPPONENT: $OPPONENT exist in teams"
    fi
    TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    if [[ -z $TEAM_WIN_ID ]]
    then
      RESULT_INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
      echo -e "INSERT WINNER: $WINNER in teams \nResult:$RESULT_INSERT_TEAM"
    else
      echo "The team WINNER: $WINNER exist in teams"
    fi
  #INSERT GAMES
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
  echo $WINNER_ID $OPPONENT_ID $INSERT_GAME_RESULT
  fi
done