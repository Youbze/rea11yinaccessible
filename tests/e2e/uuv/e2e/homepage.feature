Feature: Homepage

  Scenario: Homepage
    When I visit path "/fr"
    Then I should see a title named "Bienvenue sur Rea11y Inaccessible"
     And I should see a title named "Contexte"
     And I should see a title named "Thématiques abordées"
     And I should see a title named "Conseils"
     And I should see a button named "Débuter la partie"

  Scenario: Waiting room 1/2
    Given I visit path "/fr"
    When I click on button named "Débuter la partie"
    Then I should see an element with content "Le temps presse, regarde la vidéo pour comprendre la situation..."
     And I should see a button named "Continuer"

  Scenario: Waiting room 2/2
    Given I visit path "/fr/waitingroom"
    When I click on button named "Continuer"
    Then I should not see a button named "Continuer"
     And I set timeout with value 60000
     And I should see a title named "Bienvenu(e) à toi !"
     And I should see a title named "Scénario"
     And I should see a title named "Objectif"
     And I should see a link named "ici"
     And I should see a button named "Continuer"
  