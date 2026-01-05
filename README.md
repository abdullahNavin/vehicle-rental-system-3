# Vehicle Rental System

## Project Overview

The **Vehicle Rental System** is a comprehensive database application designed to manage vehicle rentals efficiently. This system enables users to book vehicles, track bookings, and manage vehicle inventory. It provides a robust backend solution with role-based access control and real-time vehicle availability tracking.

### Key Features
- **User Management**: Support for Admin and Customer roles
- **Vehicle Inventory**: Track vehicle details, types, rental prices, and maintenance status
- **Booking Management**: Create, track, and manage vehicle bookings with confirmation and completion status
- **Advanced Queries**: Powerful SQL queries for reporting and analytics

---

## Database Schema

### Tables

#### 1. **users**
Stores customer and admin information
```sql
CREATE TABLE users(
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,
  phone VARCHAR(15) NOT NULL,
  role VARCHAR(25) DEFAULT 'Customer' CHECK(role IN ('Admin','Customer'))
);
```
- **user_id**: Unique identifier for each user
- **name**: User's full name
- **email**: User's email address (unique)
- **phone**: Contact phone number
- **role**: User type (Admin or Customer)

---

#### 2. **vehicles**
Manages vehicle inventory and details
```sql
CREATE TABLE vehicles(
  vehicle_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  type VARCHAR(50) NOT NULL,
  model INT NOT NULL,
  registration_number VARCHAR(25) NOT NULL,
  rental_price DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'available' 
    CHECK(status IN ('available','rented','maintenance'))
);
```
- **vehicle_id**: Unique identifier for each vehicle
- **name**: Vehicle model name
- **type**: Category (e.g., Car, SUV, Van)
- **model**: Manufacturing year
- **registration_number**: License plate/registration number
- **rental_price**: Daily rental cost
- **status**: Current availability status (available, rented, or maintenance)

---

#### 3. **bookings**
Records all vehicle rental transactions
```sql
CREATE TABLE bookings(
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  vehicle_id INT REFERENCES vehicles(vehicle_id),
  start_date TIMESTAMP DEFAULT NOW(),
  end_date TIMESTAMP NOT NULL,
  status VARCHAR(50) CHECK(status IN ('confirmed','completed','pending','cancelled')),
  total_cost DECIMAL(10,2)
);
```
- **booking_id**: Unique booking identifier
- **user_id**: Foreign key referencing users table
- **vehicle_id**: Foreign key referencing vehicles table
- **start_date**: Rental start date and time
- **end_date**: Rental end date and time
- **status**: Booking status (confirmed, completed, pending, or cancelled)
- **total_cost**: Total rental cost for the booking period

---

## SQL Queries

### Query 1: Get All Bookings with Customer and Vehicle Details

**Purpose**: Retrieve a comprehensive list of all bookings with associated customer names, vehicle information, and booking status.

**Solution**:
```sql
SELECT 
  b.booking_id,
  u.name AS customer_name,
  v.name AS vehicle_name,
  b.start_date,
  b.end_date,
  b.status
FROM bookings AS b
INNER JOIN users AS u ON b.user_id = u.user_id
INNER JOIN vehicles AS v ON b.vehicle_id = v.vehicle_id;
```

**Explanation**:
- Uses INNER JOINs to combine data from three tables
- Displays booking details along with customer and vehicle names
- Useful for generating booking reports and tracking rental history

**Output**: A detailed booking report showing all active and completed rentals

---

### Query 2: Find Vehicles Never Booked

**Purpose**: Identify vehicles that have never been rented (new stock or rarely requested vehicles).

**Solution**:
```sql
SELECT * FROM vehicles AS v
WHERE NOT EXISTS 
  (SELECT * FROM bookings AS b
   WHERE v.vehicle_id = b.vehicle_id
  );
```

**Explanation**:
- Uses NOT EXISTS to find vehicles without any booking records
- Subquery checks if a vehicle appears in the bookings table
- Helps identify vehicles that may need promotion or pricing adjustment

**Output**: All vehicles with zero rental history

---

### Query 3: Find Available Cars

**Purpose**: Display all available cars ready for immediate rental.

**Solution**:
```sql
SELECT * FROM vehicles
WHERE status = 'available' AND type ILIKE 'car';
```

**Explanation**:
- Filters vehicles by status 'available' and type 'car'
- Uses ILIKE for case-insensitive text matching
- Provides quick access to available inventory for customers

**Output**: List of all cars currently available for rent

---

### Query 4: Identify Most Frequently Booked Vehicles

**Purpose**: Find vehicles that have been booked more than twice, indicating high-demand inventory.

**Solution**:
```sql
SELECT 
  v.name AS vehicle_name,
  COUNT(*) AS total_bookings 
FROM bookings AS b
INNER JOIN vehicles AS v ON b.vehicle_id = v.vehicle_id
GROUP BY b.vehicle_id, v.name 
HAVING COUNT(*) > 2;
```

**Explanation**:
- Groups bookings by vehicle and counts occurrences
- Uses HAVING clause to filter vehicles with more than 2 bookings
- Identifies best-performing vehicles for business analytics
- Useful for resource allocation and maintenance scheduling

**Output**: Vehicle names with their total booking count (only those booked more than 2 times)

---

## Usage

### Prerequisites
- PostgreSQL or compatible SQL database
- SQL client for executing queries

### Setup Instructions
1. Create a new database for the vehicle rental system
2. Execute the table creation statements in order (users → vehicles → bookings)
3. Insert sample data into the tables
4. Run the provided queries to retrieve information

### Common Use Cases
- **Administrator**: Use Query 1 to track all bookings and Query 4 for analytics
- **Operations Manager**: Use Query 3 to manage available inventory and Query 2 to identify unused stock
- **Customer Service**: Use Query 1 to access booking details and history

---

## Best Practices

1. **Data Integrity**: Always maintain referential integrity through foreign keys
2. **Status Management**: Keep vehicle and booking statuses updated in real-time
3. **Performance**: Add indexes on frequently queried columns (user_id, vehicle_id, status)
4. **Backup**: Regularly backup the database to prevent data loss
5. **Validation**: Validate user input before inserting into the database

---

## Future Enhancements

- Add payment tracking and transaction history
- Implement vehicle maintenance scheduling
- Add customer ratings and reviews
- Create advanced analytics dashboard
- Implement multi-location support
- Add insurance and damage tracking

---

## License

This project is provided as-is for educational and assignment purposes.

---

## Contact

For questions or support regarding this vehicle rental system, please refer to the project documentation or contact the development team.
