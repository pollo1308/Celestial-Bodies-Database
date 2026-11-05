#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align -t -c"
MAIN_MENU(){
  SERVICES=$($PSQL "SELECT * FROM services;")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    if [[ ! ($SERVICE_ID = "service_id" || -z $SERVICE_NAME) ]]
    then  
      echo "$SERVICE_ID) $SERVICE_NAME"
    fi
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  #if no exist  the service
  if [[ -z $SERVICE_NAME_SELECTED ]]
  then
    MAIN_MENU
  else
    echo -e "\nIntroduzca numero de telefono:"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nIntroduzca su nombre:"
      read CUSTOMER_NAME
      INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
      echo -e "\nResultado de la insercion: $INSERT_NEW_CUSTOMER"
    fi
    echo -e "\nIntroduzca horario"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE';")
    INSERT_NEW_APPOINTMENT=$($PSQL"INSERT INTO appointments(customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID;")
    echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME." 
  fi
}
MAIN_MENU