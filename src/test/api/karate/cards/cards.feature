Feature: Cards


  Background:

    * def signIn = call read('../common/getToken.feature') { username: 'tso1-operator'}
    * def authToken = signIn.authToken
    * def signInUserWithNoGroupNoEntity = call read('../common/getToken.feature') { username: 'userwithnogroupnoentity'}
    * def authTokenUserWithNoGroupNoEntity = signInUserWithNoGroupNoEntity.authToken

  Scenario: Post card

    * def card =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"a message"}
}
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'

    And request card
    When method post
    Then status 201
    And match response.count == 1



  Scenario: Post a new version of the card

    * def card =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"new message"}
}
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 1

#get card with user tso1-operator
    Given url opfabUrl + 'cards/cards/api_test.process1'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And match response.card.data.message == 'new message'
    And def cardUid = response.uid
	And match response.card.publisherType == "EXTERNAL"

    #get card without  authentication
    Given url opfabUrl + 'cards/cards/api_test.process1'
    When method get
    Then status 401


  Scenario: Delete the card

#get card with user tso1-operator
    Given url opfabUrl + 'cards/cards/api_test.process1'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And def cardUid = response.uid

# delete card
    Given url opfabPublishCardUrl + 'cards/api_test.process1'
    When method delete
    Then status 200

# delete card
    Given url opfabPublishCardUrl + 'cards/not_existing_card_id'
    When method delete
    Then status 404


  Scenario: Post two cards in one request

    * def card =
"""
[
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process2card1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "COMPLIANT",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"new message (card 1)"}
},
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process2card2",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "COMPLIANT",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"new message (card2) "}
}
]
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 2


  Scenario: Post two cards in one request, including one card in wrong format (severity field missing in second card)

    * def card =
"""
[
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process2CardsIncludingOneCardKO1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "COMPLIANT",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"new message (card 1)"}
},
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process2CardsIncludingOneCardKO2",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"new message (card2) "}
}
]
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 0


  Scenario:  Post card with new attribute externalRecipients

    * def card =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"externalRecipients" : ["api_test2","api_test165"],
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title2"},
	"data" : {"message":"test externalRecipients"}
}
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 1

#get card with user tso1-operator and new attribute externalRecipients
    Given url opfabUrl + 'cards/cards/api_test.process1'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And match response.card.externalRecipients[1] == "api_test165"
    And def cardUid = response.uid

Scenario:  Post card with no recipient but entityRecipients

    * def card =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process2",
	"state": "messageState",
	"entityRecipients" : ["TSO1"],
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"a message"}
}
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 1

Scenario:  Post card with parentCardUid not correct

    * def card =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title2"},
	"data" : {"message":"test externalRecipients"},
	"parentCardUid": "1"
}
"""

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 0
    And match response.message contains "The parentCardUid 1 is not the uid of any card"

Scenario:  Post card with correct parentCardUid

    #get parent card uid
    Given url opfabUrl + 'cards/cards/api_test.process1'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And def cardUid = response.card.uid

	* def card =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title2"},
	"data" : {"message":"test externalRecipients"}
}
"""
	* card.parentCardUid = cardUid

# Push card
    Given url opfabPublishCardUrl + 'cards'
    And request card
    When method post
    Then status 201
    And match response.count == 1
    And match response.message == "All pushedCards were successfully handled"

Scenario: Push card and its two child cards, then get the parent card

    * def parentCard =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "process1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title2"},
	"data" : {"message":"test externalRecipients"}
}
"""

# Push parent card
    Given url opfabPublishCardUrl + 'cards'
    And request parentCard
    When method post
    Then status 201
    And match response.count == 1
    And match response.message == "All pushedCards were successfully handled"

#get parent card uid
    Given url opfabUrl + 'cards/cards/api_test.process1'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And def parentCardUid = response.card.uid

# Push two child cards
    * def childCard1 =
"""
{
	"publisher" : "api_test",
	"processVersion" :"1",
	"process"  :"api_test",
	"processInstanceId" : "processChild1",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title2"},
	"data" : {"message":"test externalRecipients"}
}
"""
	* childCard1.parentCardUid = parentCardUid

	* def childCard2 =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "processChild2",
	"state": "messageState",
	"recipient" : {
				"type" : "GROUP",
				"identity" : "TSO1"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title2"},
	"data" : {"message":"test externalRecipients"}
}
"""
	* childCard2.parentCardUid = parentCardUid

# Push the two child cards
    Given url opfabPublishCardUrl + 'cards'
    And request childCard1
    When method post
    Then status 201
    And match response.count == 1
    And match response.message == "All pushedCards were successfully handled"

# Push the two child cards
    Given url opfabPublishCardUrl + 'cards'
    And request childCard2
    When method post
    Then status 201
    And match response.count == 1
    And match response.message == "All pushedCards were successfully handled"

# Get the parent card with its two child cards

    Given url opfabUrl + 'cards/cards/api_test.process1'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
	And assert response.childCards.length == 2


Scenario: Push a card for a user with no group and no entity

    * def cardForUserWithNoGroupNoEntity =
"""
{
	"publisher" : "api_test",
	"processVersion" : "1",
	"process"  :"api_test",
	"processInstanceId" : "processForUserWithNoGroupNoEntity",
	"state": "messageState",
	"recipient" : {
				"type" : "USER",
				"identity" : "userwithnogroupnoentity"
			},
	"severity" : "INFORMATION",
	"startDate" : 1553186770681,
	"summary" : {"key" : "defaultProcess.summary"},
	"title" : {"key" : "defaultProcess.title"},
	"data" : {"message":"a message for user with no group and no entity"}
}
"""

# Push card for user with no group and no entity
    Given url opfabPublishCardUrl + 'cards'
    And request cardForUserWithNoGroupNoEntity
    When method post
    Then status 201
    And match response.count == 1

#get card with user userwithnogroupnoentity
    Given url opfabUrl + 'cards/cards/api_test.processForUserWithNoGroupNoEntity'
    And header Authorization = 'Bearer ' + authTokenUserWithNoGroupNoEntity
    When method get
    Then status 200
    And match response.card.data.message == 'a message for user with no group and no entity'
    And def cardUid = response.card.uid

#get card from archives with user userwithnogroupnoentity
    Given url opfabUrl + 'cards/archives/' + cardUid
    And header Authorization = 'Bearer ' + authTokenUserWithNoGroupNoEntity
    When method get
    Then status 200
    And match response.data.message == 'a message for user with no group and no entity'