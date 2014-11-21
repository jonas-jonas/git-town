Feature: Git Sync: syncing a non-feature branch with open changes


  Scenario: no conflict
    Given non-feature branch configuration "qa, production"
    And I am on the "qa" branch
    And the following commits exist in my repository
      | branch | location         | message       | file name   |
      | qa     | local            | local commit  | local_file  |
      | qa     | remote           | remote commit | remote_file |
      | main   | local and remote | main commit   | main_file   |
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git sync`
    Then I am still on the "qa" branch
    And all branches are now synchronized
    And I have the following commits
      | branch | location         | message       | files       |
      | qa     | local and remote | local commit  | local_file  |
      | qa     | local and remote | remote commit | remote_file |
      | main   | local and remote | main commit   | main_file   |
    And now I have the following committed files
      | branch | files                   |
      | qa     | local_file, remote_file |
      | main   | main_file               |
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
