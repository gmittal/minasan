from flask import Flask, request, redirect

import twilio.twiml
from twilio.rest import TwilioRestClient

import math 
import time
from firebase import Firebase
# from firebase import firebase
# import StringIO, httplib
import json
from pprint import pprint
#from firebasin import Firebase
import ws4py


# Find these values at https://twilio.com/user/account
account_sid = "ACba498d91d1312e0f4975eaac513d64be"
auth_token = "7c2bacbc7a9783c496e4af1af1a51a0b"
client = TwilioRestClient(account_sid, auth_token)
 



firebaseUrl = 'https://ping-im.firebaseio.com/kevin/' #chat room URL
firebase = Firebase(firebaseUrl + "chat")
smsUsers = Firebase(firebaseUrl + "smsUsers")

# firebase to pull stuff from the server
#returnChat = Firebase(firebaseUrl)



smsUsersArray = smsUsers.get()

#smsUsersArray = smsUsersArrayBase["-JQ9R3IucdObkPAisKcG"]
print smsUsersArray

if smsUsersArray == None:
    nilArray = ['Blank']
    smsUsers.set(nilArray)



def checkNumberRegister(number):
    for x in range(0, len(smsUsersArray)):
        if number == smsUsersArray[x]:
            print "Number already is registered."
        else:
            check = number in smsUsersArray
            if check == False: 
                smsUsersArray.append(number)
                smsUsers.set(smsUsersArray)
            


def updateSMSUsers(currentUser, message):
    for x in range(1, len(smsUsersArray)):
        if (smsUsersArray[x] != currentUser):
        	messageString = currentUser + ": " + message
        	smsMessage = client.messages.create(to=smsUsersArray[x], from_="+14806481956", body=messageString)



app = Flask(__name__)

# @app.route("/nosms", endpoint="foo-canonical")
@app.route("/", methods=['GET', 'POST'], endpoint="sms-route")


def hello_monkey():
    """Respond to incoming calls with a simple text message."""
    
    user_number = request.values.get('From', None)
    checkNumberRegister(user_number)

    body = request.values.get('Body', None)

    timePosted = time.time()

    r = firebase.push({'name': user_number, 'text': body, 'time': str(int(timePosted))})
    
    if (r):
    	print "Successfully pushed to the database."

    updateSMSUsers(user_number, body)
    

    return "I don't think you should be here. Please leave." # No need for a response...




# Non-SMS based clients send messages here
@app.route("/nosms", methods=['GET', 'POST'])

def no_sms():
	name = request.form["userName"]
	body = request.form["messageBody"]
	
	print name
	print body

	updateSMSUsers(name, body)

	return "I don't think you should be here. Please leave."
 
if __name__ == "__main__":
    app.run(debug=True)
