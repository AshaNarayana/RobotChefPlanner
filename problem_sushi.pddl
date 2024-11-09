(define (problem problem_sushi)
    (:domain RobotChefDomain)

    (:objects
        robot1 - robot
    )

    (:init
        (robot-at robot1 storageArea)
        (ingredient-at rice storageArea)
        (ingredient-at fish storageArea)
        (ingredient-at seaweed storageArea)
        (tool-at knife cuttingArea)
        (tool-clean knife)
        (adjacent storageArea cuttingArea)
        (adjacent cuttingArea storageArea)
        (adjacent cuttingArea mixingArea)
        (adjacent mixingArea cuttingArea)
        (adjacent storageArea mixingArea)
        (adjacent mixingArea storageArea)
        (adjacent mixingArea preparationArea)
        (adjacent preparationArea mixingArea)
        (adjacent preparationArea dishwasherArea)
        (adjacent dishwasherArea preparationArea)
        (adjacent preparationArea cookingArea)
        (adjacent cookingArea preparationArea)
        (adjacent dishwasherArea cookingArea)
        (adjacent cookingArea dishwasherArea)
        (adjacent cookingArea servingArea)
        (adjacent servingArea cookingArea)
        (order-received sushi)
    )

    (:goal
        (and
            (dish-plated sushi)
        )
    )
)