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
import requests
import json

import urllib
import urllib2


# Find these values at https://twilio.com/user/account
account_sid = "xxxx"
auth_token = "xxxx" #Ha, nice try buddy. You're not getting my Twilio credentials...
client = TwilioRestClient(account_sid, auth_token)


firebaseUrl = 'https://ping-im.firebaseio.com/kevin/' #chat room URL
firebase = Firebase(firebaseUrl + "chat")
smsUsers = Firebase(firebaseUrl + "smsUsers")

iosUsers = Firebase(firebaseUrl + "iosUsers")





def checkIOSRegister(token):
    iosUsersArray = iosUsers.get()
    print iosUsersArray

    if iosUsersArray == None:
        nilArray = ['Blank']
        iosUsers.set(nilArray)

    for x in range(0, len(iosUsersArray)):
        if token == iosUsersArray[x]:
            print "iPhone Device token is already registered."
        else:
            check = token in iosUsersArray

            if check == False: 
                iosUsersArray.append(token)

                iosUsers.set(iosUsersArray)



def updateIOSUsers(currentToken, currentName, message):
    iosUsersArray = iosUsers.get()
    print iosUsersArray

    if iosUsersArray == None:
        nilArray = ['Blank']
        iosUsers.set(nilArray)


    for x in range(1, len(iosUsersArray)):
        print "Sending push Notifications..."

        if (currentToken != None):
            if (iosUsersArray[x] != currentToken):
                # print smsUsersArray
                print "Sending Apple Push Notification (APN) to"
                print iosUsersArray[x] if iosUsersArray[x] else "Unknown."

                messageString = " - ".join([currentName, message])

                if (iosUsersArray[x]):
                    sendPushNotification(iosUsersArray[x], messageString)
    
            
        else:

            print "Sending Apple Push Notification (APN) to"
            print iosUsersArray[x] if iosUsersArray[x] else "Unknown."

            messageString = " - ".join([currentName, message])

            if (iosUsersArray[x]):
                sendPushNotification(iosUsersArray[x], messageString)
            



def sendPushNotification(deviceToken, message):
    # headers = {'content-type': 'application/json'}

    url = 'http://lit-cliffs-7047.herokuapp.com/'

    post_data_dictionary = {'name':message, "deviceToken":deviceToken}
     
    #encode the POST data to be sent in a URL
    post_data_encoded = urllib.urlencode(post_data_dictionary)

    request_object = urllib2.Request(url, post_data_encoded)
 
    #make the request using the request object as an argument, store response in a variable
    response = urllib2.urlopen(request_object)
     
    #store request response in a string
    html_string = response.read()

    print "Attempted to push an Apple Notification."






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
        updateIOSUsers(None, user_number, body)
    

    return "I don't think you should be here. Please leave." # No need for a response...




# Non-SMS based clients send messages here
@app.route("/nosms", methods=['GET', 'POST'])

def no_sms():

	token = request.form["token"]
	name = request.form["userName"]
	body = request.form["messageBody"]
	
	print name.encode('utf-8')
	print body.encode('utf-8')

	if (name):
		if (body):
			updateSMSUsers(name, body)
			updateIOSUsers(token, name, body)


	return "I don't think you should be here. Please leave."





@app.route("/registerDeviceTokens", methods=['GET', 'POST'])

def register_iphone():
    deviceToken = request.form["deviceToken"]

    checkIOSRegister(deviceToken)

    # sendPushNotification('3d99a8749c7b72c20f5d195e9ba1fb6cdc1c556a053a42e17489beade2d914c8', 'Yo')
    return "Yo"

 
if __name__ == "__main__":
    app.run(debug=True)




