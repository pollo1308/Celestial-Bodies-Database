#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo Enter your username:
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
if [[ -z $USER_ID ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME');")
  echo Welcome, $USERNAME! It looks like this is your first time here.
else
  USER_GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID;")
  USER_BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID;")
  echo Welcome back, $USERNAME! You have played $USER_GAMES_PLAYED games, and your best game took $USER_BEST_GAME guesses.
fi
SECRET_NUMBER=25
#$(( RANDOM % 1000 + 1 ))
echo Guess the secret number between 1 and 1000:
read USER_NUMBER
USER_ATTEMPS=1
while [[ $USER_NUMBER != $SECRET_NUMBER  ]]
do
  if [[ $USER_NUMBER =~ ^[0-9]+$ ]]
  then
    if (( $USER_NUMBER > $SECRET_NUMBER ))
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
  else
   echo "That is not an integer, guess again:"
  fi
  read USER_NUMBER
  USER_ATTEMPS=$(($USER_ATTEMPS + 1 ))
done
ADD_GAME_PLAYED=$($PSQL "UPDATE users SET games_played=games_played+1  WHERE username='$USERNAME';")
echo "You guessed it in $USER_ATTEMPS tries. The secret number was $SECRET_NUMBER. Nice job!"
USER_BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")
if [[ -z $USER_BEST_GAME ]]
then
  UPDATE_GAMES=$($PSQL "UPDATE users SET best_game=$USER_ATTEMPS WHERE username='$USERNAME';")
elif ((  $USER_BEST_GAME > $USER_ATTEMPS ))
then
  UPDATE_GAMES=$($PSQL "UPDATE users SET best_game=$USER_ATTEMPS WHERE username='$USERNAME';")
fi