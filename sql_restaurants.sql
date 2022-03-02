create table restaurants (
  id INTEGER PRIMARY KEY,
  res_name TEXT,
  food_type TEXT,
  neighborhood TEXT,
  price TEXT,
  average_rating REAL,
  good_kids BOOLEAN,
  opening NUMERIC
);
.tables
.schema restaurants
.mode csv
.import data/restaurants.csv restaurants

-- Find all cheap restaurants in a particular neighborhood (pick any neighborhood as an example).
select res_name from restaurants where price = "Cheap" and neighborhood = "Upper East Side";

-- Find all restaurants in a particular genre (pick any genre as an example) with 3 stars or more, ordered by the number of stars in descending order.
select res_name from restaurants where food_type = "Korean" and average_rating >= 3 order by average_rating desc;

-- Find all restaurants that are open now 
select res_name from restaurants where opening > strftime('%H:%M', 'now');

-- Leave a review for a restaurant
update restaurants set average_rating=0.2 where id=15;

-- Delete all restaurants that are not good for kids
delete from restaurants where good_kids=false;

-- Find the number of restaurants in each NYC neighborhood
select count(id) from restaurants where neighborhood = "Upper East Side";