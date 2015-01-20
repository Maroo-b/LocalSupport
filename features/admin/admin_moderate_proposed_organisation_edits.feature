Feature: Members of HCN may propose edits to organisations
  As the site admin for the Harrow Community Network
  So I can improve the accuracy of HCN and to save time
  I want to be able to moderate proposed edits to organisations listed on the HCN

  Background: organisations have been added to database
    Given the following addresses exist:
      | address                 |
      | 30 pinner road          |
    Given the following organisations exist:
      | name              | description             | address        | publish_address | postcode | telephone | website             | email             | publish_phone | publish_address | donation_info  |
      | Friendly          | Bereavement Counselling | 30 pinner road | true            |HA1 4HZ  | 020800000 | http://friendly.org | admin@friendly.xx | true          |  false          | www.donate.com |
    And the following users are registered:
      | email                         | password | organisation        | confirmed_at         | admin |
      | registered_user-2@example.com | pppppppp |                     | 2007-01-01  10:00:00 | false |
      | admin@harrowcn.org.uk         | pppppppp |                     | 2007-01-01  10:00:00 | true  |
    And the following proposed edits exist:
      |original_name | editor_email                  | name       | description             | address        | postcode | telephone | website               | email               | donation_info  | archived|
      |Friendly      | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org | admin@unfriendly.xx | www.pleasedonate.com | false |
      |Friendly      | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org | admin@unfriendly.xx | www.pleasedonate.com | true |
 
    And cookies are approved

  Scenario: Nonadmins do not see all proposed edits link
    Given I am signed in as an non-admin
    And I visit the home page
    Then I should not see the all proposed edits link

  Scenario: Moderate a proposed edit
    Given I am signed in as an admin
    And I visit the home page
    And I click on the all proposed edits link
    And I should not see links for archived edits
    And I click on view details for the proposed edit for the organisation named "Friendly"
    And I should see a link or button "Accept Edit"
    And I should see a link or button "Reject Edit"

  Scenario: Accept a proposed edit
    Given I am signed in as an admin
    And I visit the most recently created proposed edit for "Friendly"
    When I press "Accept Edit"
    Then I should be on the show page for the organisation named "Unfriendly"
    And "Friendly" should be updated as follows:
    | name       | description         | address        | postcode | telephone | website               | email               | donation_info               |
    | Unfriendly | Mourning loved ones | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org | admin@unfriendly.xx | http://www.pleasedonate.com |
    And the most recently updated proposed edit for "Unfriendly" should be updated as follows:
      | archived | accepted |
      | true     | true     |
    And I should see "The edit you accepted has been applied and archived"

  Scenario: Reject a proposed edit
    Given I am signed in as an admin
    And I visit the most recently created proposed edit for "Friendly"
    When I press "Reject Edit"
    Then I should be on the show page for the organisation named "Friendly"
    And the most recently updated proposed edit for "Friendly" should be updated as follows:
      | archived | accepted |
      | true     | false    |
    And I should see "The edit you rejected has been archived"
