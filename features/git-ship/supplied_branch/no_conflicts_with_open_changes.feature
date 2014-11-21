Feature: Git Ship: shipping the supplied feature branch with open changes


  Scenario: local feature branch
    Given I have feature branches named "feature" and "other_feature"
    And the following commit exists in my repository
      | branch   | location | file name    | file content    |
      | feature | local    | feature_file | feature content |
    And I am on the "other_feature" branch
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git ship feature -m 'feature done'`
    Then I end up on the "other_feature" branch
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
    And there is no "feature" branch
    And I have the following commits
      | branch  | location         | message      | files        |
      | main    | local and remote | feature done | feature_file |
    And now I have the following committed files
      | branch | files        |
      | main   | feature_file |


  Scenario: feature branch with non-pulled updates in the repo
    Given I have feature branches named "feature" and "other_feature"
    And the following commit exists in my repository
      | branch   | location | file name    | file content    |
      | feature | remote   | feature_file | feature content |
    And I am on the "other_feature" branch
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git ship feature -m 'feature done'`
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
    Then I end up on the "other_feature" branch
    And there is no "feature" branch
    And I have the following commits
      | branch  | location         | message      | files        |
      | main    | local and remote | feature done | feature_file |
    And now I have the following committed files
      | branch | files        |
      | main   | feature_file |