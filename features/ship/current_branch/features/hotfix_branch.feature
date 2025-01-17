Feature: ship hotfixes

  Background:
    Given a perennial branch "production"
    And a feature branch "hotfix" as a child of "production"
    And the commits
      | BRANCH | LOCATION      | MESSAGE       |
      | hotfix | local, origin | hotfix commit |
    And the current branch is "hotfix"
    When I run "git-town ship -m 'hotfix done'"

  Scenario: result
    Then it runs the commands
      | BRANCH     | COMMAND                           |
      | hotfix     | git fetch --prune --tags          |
      |            | git checkout production           |
      | production | git rebase origin/production      |
      |            | git checkout hotfix               |
      | hotfix     | git merge --no-edit origin/hotfix |
      |            | git merge --no-edit production    |
      |            | git checkout production           |
      | production | git merge --squash hotfix         |
      |            | git commit -m "hotfix done"       |
      |            | git push                          |
      |            | git push origin :hotfix           |
      |            | git branch -D hotfix              |
    And the current branch is now "production"
    And the branches are now
      | REPOSITORY    | BRANCHES         |
      | local, origin | main, production |
    And now these commits exist
      | BRANCH     | LOCATION      | MESSAGE     |
      | production | local, origin | hotfix done |
    And no branch hierarchy exists now

  Scenario: undo
    When I run "git-town undo"
    Then it runs the commands
      | BRANCH     | COMMAND                                     |
      | production | git branch hotfix {{ sha 'hotfix commit' }} |
      |            | git push -u origin hotfix                   |
      |            | git revert {{ sha 'hotfix done' }}          |
      |            | git push                                    |
      |            | git checkout hotfix                         |
      | hotfix     | git checkout production                     |
      | production | git checkout hotfix                         |
    And the current branch is now "hotfix"
    And now these commits exist
      | BRANCH     | LOCATION      | MESSAGE              |
      | hotfix     | local, origin | hotfix commit        |
      | production | local, origin | hotfix done          |
      |            |               | Revert "hotfix done" |
    And the initial branches and hierarchy exist
