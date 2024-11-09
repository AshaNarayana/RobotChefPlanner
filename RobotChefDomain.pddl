(define (domain RobotChefDomain)
    (:requirements :strips :typing :negative-preconditions :equality :conditional-effects :disjunctive-preconditions)

    (:types
        robot location ingredient tool dish
    )
    (:constants
        storageArea cuttingArea mixingArea cookingArea preparationArea dishwasherArea servingArea - location
        rice fish seaweed - ingredient
        sushi - dish
        knife - tool
    )

    (:predicates
        (robot-at ?r - robot ?loc - location)
        (ingredient-at ?ingredient - ingredient ?loc - location)
        (tool-at ?tool - tool ?loc - location)
        (dish-prepared ?dish - dish)
        (tool-clean ?tool - tool)
        (holding ?ingredient - ingredient)
        (prepared ?ingredient - ingredient)
        (cooked ?ingredient - ingredient)
        (mixed-ingredient ?ingredient - ingredient)
        (adjacent ?loc1 - location ?loc2 - location)
        (order-received ?dish - dish)
        (mixed-dish ?dish - dish)
        (dish-plated ?dish - dish)
    )

    ;; Action: Move the robot to an adjacent location
    (:action move
        :parameters (?r - robot ?loc1 - location ?loc2 - location)
        :precondition (and (robot-at ?r ?loc1) (adjacent ?loc1 ?loc2))
        :effect (and (robot-at ?r ?loc2) (not (robot-at ?r ?loc1)))
    )

    ;; Action: Pick up an ingredient from storage area
    (:action pick-up-ingredient
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r storageArea)
            (ingredient-at ?ingredient storageArea)
            (not (holding ?ingredient))
            (order-received ?dish)
            (or
                (and (= ?dish sushi) (= ?ingredient rice))
                (and (= ?dish sushi) (mixed-ingredient rice) (= ?ingredient fish))
                (and (= ?dish sushi) (mixed-ingredient fish) (= ?ingredient seaweed))
            )
        )
        :effect (and
            (holding ?ingredient)
            (not (ingredient-at ?ingredient storageArea))
        )
    )

    ;; Action: Move to mixing area
    (:action move-to-mixing
        :parameters (?r - robot)
        :precondition (robot-at ?r storageArea)
        :effect (and
            (robot-at ?r mixingArea)
            (not (robot-at ?r storageArea))
        )
    )

    ;; Action: Move to preparation area
    (:action move-to-preparation-general
        :parameters (?r - robot)
        :precondition (robot-at ?r mixingArea)
        :effect (and
            (robot-at ?r preparationArea)
            (not (robot-at ?r mixingArea))
        )
    )

    ;; Action: Move to cooking area
    (:action move-to-cooking
        :parameters (?r - robot)
        :precondition (robot-at ?r preparationArea)
        :effect (and
            (robot-at ?r cookingArea)
            (not (robot-at ?r preparationArea))
        )
    )

    ;; Action: Cook an ingredient
    (:action cook-ingredient
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r cookingArea)
            (holding ?ingredient)
            (order-received ?dish)
            (= ?ingredient rice)
        )
        :effect (and
            (cooked ?ingredient)
            (not (holding ?ingredient))
            (robot-at ?r mixingArea)
            (not (tool-clean knife))
        )
    )

    ;; Action: Mix an ingredient
    (:action mix-ingredient
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r mixingArea)
            (order-received ?dish)
            (cooked rice)
            (not (holding ?ingredient))
        )
        :effect (and
            (mixed-ingredient rice)
            (robot-at ?r storageArea)
        )
    )

    ;; Action: Pick up fish from storage area
    (:action pick-up-fish
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r storageArea)
            (ingredient-at ?ingredient storageArea)
            (not (holding ?ingredient))
            (order-received ?dish)
            (mixed-ingredient rice)
            (= ?ingredient fish)
        )
        :effect (and
            (holding ?ingredient)
            (not (ingredient-at ?ingredient storageArea))
            (robot-at ?r cuttingArea)
        )
    )

    ;; Action: Cut an ingredient
    (:action cut-ingredient
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r cuttingArea)
            (holding ?ingredient)
            (order-received ?dish)
            (= ?ingredient fish)
        )
        :effect (and
            (prepared ?ingredient)
            (not (holding ?ingredient))
            (robot-at ?r mixingArea)
        )
    )

    ;; Action: Mix fish
    (:action mix-fish
        :parameters (?r - robot ?dish - dish)
        :precondition (and
            (robot-at ?r mixingArea)
            (order-received ?dish)
            (prepared fish)

        )
        :effect (and
            (mixed-ingredient fish)
            (robot-at ?r storageArea)
        )
    )

    ;; Action: Pick up seaweed from storage area
    (:action pick-up-seaweed
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r storageArea)
            (ingredient-at ?ingredient storageArea)
            (not (holding ?ingredient))
            (order-received ?dish)
            (mixed-ingredient fish)
            (= ?ingredient seaweed)
        )
        :effect (and
            (holding ?ingredient)
            (not (ingredient-at ?ingredient storageArea))
            (robot-at ?r cookingArea)
        )
    )

    ; ;; Action: Move to preparation area with seaweed
    ; (:action move-to-preparation-seaweed
    ;     :parameters (?r - robot)
    ;     :precondition (robot-at ?r mixingArea)
    ;     :effect (and
    ;         (robot-at ?r preparationArea)
    ;         (not (robot-at ?r mixingArea))
    ;     )
    ; )

    ; ;; Action: Move to cooking area with seaweed
    ; (:action move-to-cooking-seaweed
    ;     :parameters (?r - robot)
    ;     :precondition (robot-at ?r preparationArea)
    ;     :effect (and
    ;         (robot-at ?r cookingArea)
    ;         (not (robot-at ?r preparationArea))
    ;     )
    ; )

    ;; Action: Cook seaweed
    (:action cook-seaweed
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r cookingArea)
            (holding ?ingredient)
            (order-received ?dish)
            (= ?ingredient seaweed)
        )
        :effect (and
            (cooked ?ingredient)
            (not (holding ?ingredient))
            (robot-at ?r mixingArea)
        )
    )

    ;; Action: Mix seaweed
    (:action mix-seaweed
        :parameters (?r - robot ?ingredient - ingredient ?dish - dish)
        :precondition (and
            (robot-at ?r mixingArea)
            (order-received ?dish)
            (cooked seaweed)
            (not (holding ?ingredient))
        )
        :effect (and
            (mixed-ingredient seaweed)
            (mixed-dish sushi)
        )
    )

    ;; Action: Move to preparation area
    (:action move-to-preparation
        :parameters (?r - robot ?dish - dish ?tool - tool)
        :precondition (and
            (robot-at ?r mixingArea)
            (mixed-dish ?dish)
        )
        :effect (and
            (robot-at ?r preparationArea)
            (dish-prepared ?dish)
            (not (tool-clean ?tool))

        )
    )

    ;; Action: Clean tools
    (:action clean-tools
        :parameters (?r - robot ?tool - tool ?dish - dish)
        :precondition (and
            (robot-at ?r preparationArea)
            (not (tool-clean ?tool))
            (dish-prepared ?dish)
        )
        :effect (and
            (tool-clean ?tool)
            (tool-at ?tool dishwasherArea)
        )
    )

    ;; Action: Move to serving area
    (:action move-to-serving
        :parameters (?r - robot ?dish - dish ?tool - tool)
        :precondition (and
            (robot-at ?r preparationArea)
            (dish-prepared ?dish)
            (tool-clean ?tool)
        )
        :effect (and
            (robot-at ?r servingArea)
            (dish-plated ?dish)
        )
    )
)