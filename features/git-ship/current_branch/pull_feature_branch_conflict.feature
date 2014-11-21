Feature: Git Ship: handling conflicting remote feature branch updates when shipping the current feature branch


  Background:
    Given I am on the "feature" branch
    And the following commits exist in my repository
      | branch  | location | message                   | file name          | file content               |
      | feature | remote   | remote conflicting commit | conflicting_file   | remote conflicting content |
      | feature | local    | local conflicting commit  | conflicting_file   | local conflicting content  |
    And I run `git ship` while allowing errors


  Scenario: result
    Then I am still on the "feature" branch
    And my repo has a merge in progress
    And there is an abort script for "git ship"


  Scenario: aborting
    When I run `git ship --abort`
    Then I am still on the "feature" branch
    And there is no merge in progress
    And there is no abort script for "git ship" anymore
    And I still have the following commits
      | branch  | location | message                   | files              |
      | feature | local    | local conflicting commit  | conflicting_file   |
      | feature | remote   | remote conflicting commit | conflicting_file   |
    And I still have the following committed files
      | branch  | files              | content                   |
      | feature | conflicting_file   | local conflicting content |
