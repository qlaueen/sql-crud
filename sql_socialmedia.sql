create table users (
  id INTEGER PRIMARY KEY,
  email TEXT,
  passwords TEXT,
  handle TEXT
);
.tables
.schema users
.mode csv
.import data/users.csv users

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
.tables
.schema posts
.mode csv
.import data/posts.csv posts

-- Messages become invisible immediately after view and don't show up in the app thereafter.
-- Stories become invisible 24 hours after posting and don't show up in the app thereafter.

-- Register a new User.
insert into users (id, email, passwords, handle) values (1001, 'lml9279@nyu.edu', '795NYUpass12', 'lml9279');
select * from users where id=1001;

-- Create a new Message sent by a particular User to a particular User (pick any two Users for example).
-- fist, must delete the users from stories. 
update posts set user_received=null where content_type="Story";
select * from posts where content_type="Story";

-- now, merge the tables and find the messages
select users.handle, posts.content from users inner join posts on users.id=posts.user_sent where user_sent=100 and user_received=527;

-- Create a new Story by a particular User (pick any User for example).
insert into posts (id, date_created, time_created, content_type, content, user_sent, user_received, viewed) values (1001, '10/22/2021', '10:00', 'Story', 'This is a new story!', 100, null, 0);

-- Show the 10 most recent visible Messages and Stories, in order of recency.
select * from posts where content_type='Message' and viewed=0 order by date_created desc limit 10;
select * from posts where content_type='Story' and viewed=0 order by date_created desc limit 10;

-- Show the 10 most recent visible Messages sent by a particular User to a particular User (pick any two Users for example), in order of recency.
select users.handle, posts.content from users inner join posts on users.id=posts.user_sent where user_sent=286 and user_received=268 and viewed=0 order by time_created desc;

-- Make all Stories that are more than 24 hours old invisible
update posts set viewed=1 where time_created=(ROUND((JULIANDAY('now') - JULIANDAY('2021-02-21 12:50:00')) * 24)) > 24 and content_type='Story'; 

-- Show all invisible Messages and Stories, in order of recency.
select * from posts where viewed=1 order by date_created and time_created desc;

-- Show the number of posts by each User.
select count(content) from posts group by(user_sent);

-- Show the post text and email address of all posts and the User who made them within the last 24 hours.
select users.email, posts.content from users inner join posts on users.id=posts.user_sent where time_created=(ROUND((JULIANDAY('now') - JULIANDAY('2021-02-25 12:00:00')) * 24));

-- Show the email addresses of all Users who have not posted anything yet.
select users.email, posts.content from users left join posts on users.id=posts.user_sent where posts.content is null;