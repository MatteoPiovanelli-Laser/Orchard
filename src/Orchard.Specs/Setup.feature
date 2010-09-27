Feature: Setup
    In order to install orchard
    As a new user
    I want to setup a new site from the default screen

Scenario: Root request shows setup form
    Given I have a clean site with
            | extension | names |
            | module | Orchard.Setup, Orchard.Users, Orchard.Roles, Orchard.Comments, Orchard.Themes, Orchard.jQuery, TinyMce |
            | core | Common, Contents, ContentsLocation, Dashboard, Feeds, HomePage, Navigation, Routable, PublishLater, Scheduling, Settings, Shapes, XmlRpc  |
            | theme | SafeMode |
    When I go to "/Default.aspx"
    Then I should see "Welcome to Orchard"
        And I should see "Finish Setup"
        And the status should be 200 "OK"

Scenario: Setup folder also shows setup form
    Given I have a clean site with
            | extension | names |
            | module | Orchard.Setup, Orchard.Users, Orchard.Roles, Orchard.Comments, Orchard.Themes, Orchard.jQuery, TinyMce |
            | core | Common, Contents, ContentsLocation, Dashboard, Feeds, HomePage, Navigation, Routable, PublishLater, Scheduling, Settings, Shapes, XmlRpc  |
            | theme | SafeMode |
    When I go to "/Setup"
    Then I should see "Welcome to Orchard"
        And I should see "Finish Setup"
        And the status should be 200 "OK"

Scenario: Some of the initial form values are required
    Given I have a clean site with
            | extension | names |
            | module | Orchard.Setup, Orchard.Users, Orchard.Roles, Orchard.Comments, Orchard.Themes, Orchard.jQuery, TinyMce |
            | core | Common, Contents, ContentsLocation, Dashboard, Feeds, HomePage, Navigation, Routable, PublishLater, Scheduling, Settings, Shapes, XmlRpc  |
            | theme | SafeMode |
    When I go to "/Setup"
        And I hit "Finish Setup"
    Then I should see "<input autofocus="autofocus" class="input-validation-error" id="SiteName" name="SiteName" type="text" value="" />"
        And I should see "<input class="input-validation-error" id="AdminPassword" name="AdminPassword" type="password" />"

Scenario: Calling setup on a brand new install
    Given I have a clean site with
            | extension | names |
            | module | Orchard.Setup, Orchard.Users, Orchard.Roles, Orchard.Comments, Orchard.Themes, Orchard.jQuery, TinyMce |
            | core | Common, Contents, ContentsLocation, Dashboard, Feeds, HomePage, Navigation, Routable, PublishLater, Scheduling, Settings, Shapes, XmlRpc  |
            | theme | SafeMode, Classic |
        And I am on "/Setup"
    When I fill in 
            | name | value |
            | SiteName | My Site |
            | AdminPassword | 6655321 |
            | ConfirmPassword | 6655321 |
        And I hit "Finish Setup"
        And I go to "/Default.aspx"
    Then I should see "My Site"
        And I should see "Welcome"
        And I should see "you've successfully set-up your Orchard site"
