Feature: Update existing perimeter (endpoint tested : PUT /perimeters/{id})

  Background:
   #Getting token for admin and tso1-operator user calling getToken.feature
    * def signIn = call read('../../common/getToken.feature') { username: 'admin'}
    * def authToken = signIn.authToken
    * def signInAsTSO = call read('../../common/getToken.feature') { username: 'tso1-operator'}
    * def authTokenAsTSO = signInAsTSO.authToken

           #defining perimeters
    * def perimeter =
"""
{
  "id" : "perimeterKarate1_2",
  "process" : "process1",
  "state" : "state2",
  "rights" : "Read"
}
"""

    * def perimeterUpdated =
"""
{
  "id" : "perimeterKarate1_2",
  "process" : "process1",
  "state" : "state2",
  "rights" : "ReadAndWrite"
}
"""

    * def perimeterError =
"""
{
  "virtualField" : "virtual"
}
"""

  Scenario: Update the perimeter (it doesn't exist so it will be created)
    #Update the perimeter, expected response 201
    Given url opfabUrl + 'users/perimeters/' + perimeter.id
    And header Authorization = 'Bearer ' + authToken
    And request perimeter
    When method put
    Then status 201
    And match response.id == perimeter.id
    And match response.process == perimeter.process
    And match response.state == perimeter.state
    And match response.rights == perimeter.rights

  Scenario: Update the perimeter
    #Update the perimeter, expected response 200
    Given url opfabUrl + 'users/perimeters/' + perimeterUpdated.id
    And header Authorization = 'Bearer ' + authToken
    And request perimeterUpdated
    When method put
    Then status 200
    And match response.id == perimeterUpdated.id
    And match response.process == perimeterUpdated.process
    And match response.state == perimeterUpdated.state
    And match response.rights == perimeterUpdated.rights

  Scenario: Without authentication
    # authentication required, response expected 401
    Given url opfabUrl + 'users/perimeters/' + perimeterUpdated.id
    And request perimeterUpdated
    When method put
    Then status 401

  Scenario: With a simple user
    # update perimeter wrong user response expected 403
    Given url opfabUrl + 'users/perimeters/' + perimeterUpdated.id
    And header Authorization = 'Bearer ' + authTokenAsTSO
    And request perimeterUpdated
    When method put
    Then status 403

  Scenario: error 400 : bad request format
    Given url opfabUrl + 'users/perimeters/' + perimeterUpdated.id
    And header Authorization = 'Bearer ' + authToken
    And request perimeterError
    When method put
    Then status 400

  Scenario: error 400 : perimeter id in path not corresponding to the one in body
    Given url opfabUrl + 'users/perimeters/perimeterIdNotCorresponding'
    And header Authorization = 'Bearer ' + authToken
    And request perimeterUpdated
    When method put
    Then status 400
    And match response.status == 'BAD_REQUEST'
    And match response.message == 'Payload Perimeter id does not match URL Perimeter id'