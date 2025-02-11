# Firestore data model

- User
    - Path: `/user-data/{userID}`
    - Structure:
        - `sites`: List of IDs to `Site`

- Sites
    - Path: `/sites/{siteID}`
    - Structure:
        - `plants`: List of IDs to `GardenPlant`

- GardenPlant
    - Path: `/garden-plants/{gardenPlantID}`
    - Structure:
        - name: String

- TimeLine
    - Path: `/timeline/{timeLineID}`
    - For every `{gardenPlantID}`, there is a single `TimeLine` document.
    - Structure:
        - `events`: List of `Event` documents.

- Plant
    - Path: `/plants/{plantID}`
  - src: `/lib/model/plant_model.dart`
