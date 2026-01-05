
create table users(
  user_id serial primary key,
  name varchar(50) not null,
  email varchar(50) not null unique,
  phone varchar(15) not null,
  role varchar(25) default 'Customer' check(role in ('Admin','Customer'))
)


create table vehicles(
  vehicle_id serial primary key,
  name varchar(50) not null,
  type varchar(50) not null,
  model int not null,
  registration_number varchar(25) not null,
  rental_price decimal(10,2) not null,
  status varchar(50) default 'available' check(status in ('available','rented','maintenance'))
)


create table bookings(
  booking_id serial primary key,
  user_id int references users(user_id),
  vehicle_id int references vehicles(vehicle_id),
  start_date timestamp default now(),
  end_date timestamp not null,
  status varchar(50) check(status in ('confirmed','completed','pending','cancelled')),
  total_cost decimal(10,2)
)


select  booking_id,
  u.name as customer_name,
  v.name as vehicle_name,
  start_date,
  end_date,
  b.status
from bookings as b
inner join users as u on b.user_id = u.user_id
inner join vehicles as v on b.vehicle_id = v.vehicle_id


select * from vehicles as v
where not exists 
  (select * from bookings as b
  where v.vehicle_id = b.vehicle_id
  )


select * from vehicles
where status = 'available' and type ilike 'car'


select v.name as vehicle_name,count(*) as total_bookings from bookings as b
inner join vehicles as v on b.vehicle_id = v.vehicle_id
group by b.vehicle_id,v.name having count(*) > 2
