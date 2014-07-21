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
# import ws4py
import os

# Find these values at https://twilio.com/user/account
account_sid = "ACba498d91d1312e0f4975eaac513d64be"
auth_token = "7c2bacbc7a9783c496e4af1af1a51a0b"
client = TwilioRestClient(account_sid, auth_token)


firebaseUrl = 'https://ping-im.firebaseio.com/kevin/' #chat room URL
firebase = Firebase(firebaseUrl + "chat")
smsUsers = Firebase(firebaseUrl + "smsUsers")


# firebase to pull stuff from the server
#returnChat = Firebase(firebaseUrl)





#smsUsersArray = smsUsersArrayBase["-JQ9R3IucdObkPAisKcG"]
# print smsUsersArray





def checkNumberRegister(number):
    smsUsersArray = smsUsers.get()
    print smsUsersArray

    if smsUsersArray == None:
        nilArray = ['Blank']
        smsUsers.set(nilArray)

    for x in range(0, len(smsUsersArray)):
        if number == smsUsersArray[x]:
            print "Number already is registered."
        else:
            check = number in smsUsersArray
            if check == False: 
                smsUsersArray.append(number)
                # if (len(smsUsersArray) == 2):
                # 	print "A number is now registered, we can delete that blank array index"
                # 	del smsUsersArray[0]

                smsUsers.set(smsUsersArray)
            


def updateSMSUsers(currentUser, message):
    smsUsersArray = smsUsers.get()
    print smsUsersArray

    if smsUsersArray == None:
        nilArray = ['Blank']
        smsUsers.set(nilArray)


    for x in range(1, len(smsUsersArray)):
        if (smsUsersArray[x] != currentUser):
            # print smsUsersArray
        	print "Sending SMS message to"
        	print smsUsersArray[x] if smsUsersArray[x] else "Unknown. Twilio did not recieve the recipient's phone number."

        	messageString = " - ".join([currentUser, message])

        	if (smsUsersArray[x]):
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

    if (user_number):
        updateSMSUsers(user_number, body)
    

    return "I don't think you should be here. Please leave." # No need for a response...




# Non-SMS based clients send messages here
@app.route("/nosms", methods=['GET', 'POST'])

def no_sms():
	name = request.form["userName"]
	body = request.form["messageBody"]
	
	print name
	print body

	if (name):
		if (body):
			updateSMSUsers(name, body)

	return "I don't think you should be here. Please leave."


 
if __name__ == "__main__":
    app.run(debug=True)




