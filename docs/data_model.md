# Firestore data model

- Users
    - Path: `/user-data/{uid}`

- Sites
    - Path: `/user-data/{uid}/sites/{siteName}`
    - Structure:
        - `plants`: List of `GardenPlant`

- GardenPlant
    - Path: `/user-data/{uid}/sites/{siteName}/plants/{gardenPlantID}`
    - Structure:
        - name: String

- Plant
    - Path: `/plants/{plantID}`
