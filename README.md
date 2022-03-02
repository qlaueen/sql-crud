# SQL CRUD

An assignment to design relational database tables with particular applications in mind.

The contents of this file will be deleted and replaced with the content described in the [instructions](./instructions.md)

# Part 1: Restaurant finder

The first step for part 1 was to generate a mock database, which can be found [here](/data/restaurants.csv). After that, the next step was to create the table with SQL. The query used can be found below. 

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

In order to check if the table was created correctly, the following queries were used.
```
        .tables
        .schema restaurants
```

After checking if the table had the correct columns, it was necessary to import the data from the csv database. In order to do so, the following query was used:
```
        .mode csv
        .import data/restaurants.csv restaurants
```

## Queries

1. Find all cheap restaurants in a particular neighborhood (pick any neighborhood as an example).
```
        select res_name from restaurants where price = "Cheap" and neighborhood = "Upper East Side";
```

2. Find all restaurants in a particular genre (pick any genre as an example) with 3 stars or more, ordered by the number of stars in descending order.
```
        select res_name from restaurants where food_type = "Korean" and average_rating >= 3 order by average_rating desc;
```

3. Find all restaurants that are open now 
```
        select res_name from restaurants where opening > strftime('%H:%M', 'now');
```
4. Leave a review for a restaurant\
```
        update restaurants set average_rating=0.2 where id=15;
```
5. Delete all restaurants that are not good for kids
```
        delete from restaurants where good_kids=false;
```
6. Find the number of restaurants in each NYC neighborhood
```
        select count(id) from restaurants where neighborhood = "Upper East Side";
```

# Part 2: Social Media App
The first step for part 2 was to generate two mock databases,one for users that can be found [here](data/users.csv) and one for posts which can be found [here](/data/posts.csv). After that, the next step was to create the table with SQL. The query used can be found below. 
### Table 1: users
```
        create table users (
        id INTEGER PRIMARY KEY,
        email TEXT,
        passwords TEXT,
        handle TEXT
        );
```
### Table 2: posts
```
        create table posts (
        id INTEGER PRIMARY KEY,
        date_created NUMERIC,
        time_created NUMERIC,
        content_type TEXT,
        content TEXT,
        user_sent NUMERIC,
        user_received NUMERIC, 
        viewed BOOLEAN
        );
```
In order to check if the table was created correctly, the following queries were used.
```
        .tables
        .schema users
        .schema posts
```

After checking if the table had the correct columns, it was necessary to import the data from the csv database. In order to do so, the following query was used:
```
        .mode csv
        .import data/users.csv users
        .import data/posts.csv posts
```
## Queries

1. Register a new User.
```
        insert into users (id, email, passwords, handle) values (1001, 'lml9279@nyu.edu', '795NYUpass12', 'lml9279');
        select * from users where id=1001;
```
2. Create a new Message sent by a particular User to a particular User (pick any two Users for example).
First, I had to delete the users from stories since stories are not received by any specific users. 
```
        update posts set user_received=null where content_type="Story";
        select * from posts where content_type="Story";
```
Then, it was necessary to merge the tables and find the messages
```
        select users.handle, posts.content from users inner join posts on users.id=posts.user_sent where user_sent=100 and user_received=527;
```
1. Create a new Story by a particular User (pick any User for example).
```
        insert into posts (id, date_created, time_created, content_type, content, user_sent, user_received, viewed) values (1001, '10/22/2021', '10:00', 'Story', 'This is a new story!', 100, null, 0);
```
2. Show the 10 most recent visible Messages and Stories, in order of recency.
```
        select * from posts where content_type='Message' and viewed=0 order by date_created desc limit 10;
        select * from posts where content_type='Story' and viewed=0 order by date_created desc limit 10;
```
3. Show the 10 most recent visible Messages sent by a particular User to a particular User (pick any two Users for example), in order of recency.
```
        select users.handle, posts.content from users inner join posts on users.id=posts.user_sent where user_sent=286 and user_received=268 and viewed=0 order by time_created desc;
```
4. Make all Stories that are more than 24 hours old invisible
```
        update posts set viewed=1 where time_created=(ROUND((JULIANDAY('now') - JULIANDAY('2021-02-21 12:50:00')) * 24)) > 24 and content_type='Story'; 
```
1. Show all invisible Messages and Stories, in order of recency.
```
        select * from posts where viewed=1 order by date_created and time_created desc;
```
2. Show the number of posts by each User.
```
        select count(content) from posts group by(user_sent);
```
3. Show the post text and email address of all posts and the User who made them within the last 24 hours.
```
        select users.email, posts.content from users inner join posts on users.id=posts.user_sent where time_created=(ROUND((JULIANDAY('now') - JULIANDAY('2021-02-25 12:00:00')) * 24));
```
4. Show the email addresses of all Users who have not posted anything yet.
```
        select users.email, posts.content from users left join posts on users.id=posts.user_sent where posts.content is null;
```