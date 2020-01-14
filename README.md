# travel_time

Example of an app using the CityMapper API through a simple web interface

To run the application, you'll need to:
  - to create a .env (and a .env.test if you want to run the test)
  You'll use the following model: 
  ```ISAD_DB_NAME=your database name
    ISAD_DB_HOST=your database host
    ISAD_DB_USERNAME=your username
    ISAD_DB_PASSWORD=your password
    ISAD_DB_PORT=3306
    CITYMAPPER_KEY=your citymapper key
    GOOGLE_KEY=your google maps key for the static map
```
  - run the migration for the prod and test databases to create the table 'travels' in both
