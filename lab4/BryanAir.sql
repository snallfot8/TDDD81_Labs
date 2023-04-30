/*
BryanAir Project <Jakob Nilsson, Axel Nilsson, Erik Snällfot and jakni322, axeni664, erisn497>
*/

CREATE TABLE person
	(passport_number INTEGER,
	person_name VARCHAR(30),
	CONSTRAINT pk_person PRIMARY KEY (passport_number)
);

CREATE TABLE creditcard_holder
	(passport_number INTEGER,
	creditcard_number BIGINT,
	FOREIGN KEY (passport_number) REFERENCES person(passport_number)
	ON DELETE CASCADE
);

CREATE TABLE profit_factor
	(year INTEGER,
    factor INTEGER,
	CONSTRAINT pk_profit_factor PRIMARY KEY (year)
);

CREATE TABLE destination
	(airport_code VARCHAR(3),
    name VARCHAR(30),
    country VARCHAR(30),
    
    CONSTRAINT pk_destination
		PRIMARY KEY (airport_code)
);

CREATE TABLE route
	(departure_airport_code VARCHAR(3), -- Här kan vi genom airport code kolla vilken destination det gäller?
    arrival_airport_code VARCHAR(3),
    year INTEGER,
    routeprice DOUBLE,
    
    CONSTRAINT pk_route
		PRIMARY KEY(departure_airport_code, arrival_airport_code, year),
	CONSTRAINT fk_destination_departure
		FOREIGN KEY(departure_airport_code) REFERENCES destination(airport_code),
	CONSTRAINT fk_destination_arrival
		FOREIGN KEY(arrival_airport_code) REFERENCES destination(airport_code)
);

CREATE TABLE weekly_schedule
	(schedule_id INTEGER AUTO_INCREMENT,
    year INTEGER,
    day VARCHAR(10),
    departure_time TIME,
    departure_airport_code VARCHAR(3),
    arrival_airport_code VARCHAR(3),

    CONSTRAINT pk_weekly_schedule
		PRIMARY KEY (schedule_id),
	CONSTRAINT fk_route
		FOREIGN KEY (departure_airport_code, arrival_airport_code, year) REFERENCES route(departure_airport_code, arrival_airport_code, year)
	ON DELETE CASCADE

);

CREATE TABLE flight 
	(flight_number INTEGER AUTO_INCREMENT,
    week_number INTEGER,
    booked_passengers INTEGER DEFAULT 0,
    schedule_id INTEGER,
    
    CONSTRAINT pk_flight 
		PRIMARY KEY (flight_number),
	CONSTRAINT fk_scheduled
		FOREIGN KEY (schedule_id) REFERENCES weekly_schedule(schedule_id)
	ON DELETE CASCADE
);

CREATE TABLE reservation 
	(reservation_number INTEGER AUTO_INCREMENT,
    payment_time TIME,
    number_of_passengers INTEGER DEFAULT 0,
    ref_flight_number INTEGER,
    CONSTRAINT pk_reservations 
		PRIMARY KEY (reservation_number),
	CONSTRAINT fk_reservation_flight_number
		FOREIGN KEY (ref_flight_number) REFERENCES flight(flight_number)
	ON DELETE CASCADE
);


CREATE TABLE passenger 
	(passport_number INTEGER,
    ref_reservation_nr INTEGER,
    
   /* 
    CONSTRAINT fk_passenger_reservation_number
		FOREIGN KEY (ref_reservation_nr) REFERENCES reservation(reservation_number),*/
    
    CONSTRAINT fk_passenger_passport_number
		FOREIGN KEY (passport_number) REFERENCES person(passport_number)
	ON DELETE CASCADE
);


CREATE TABLE contact_person
	(phone_number BIGINT,
    email VARCHAR(30),
    ref_reservation_number INTEGER,
    ref_passport_number INTEGER,
   
   CONSTRAINT pk_contact_person
		PRIMARY KEY(ref_reservation_number, ref_passport_number),
	CONSTRAINT fk_contact_reservation
		FOREIGN KEY (ref_reservation_number) REFERENCES reservation(reservation_number),
	CONSTRAINT fk_contact_passenger 
		FOREIGN KEY (ref_passport_number) REFERENCES passenger(passport_number)
	ON DELETE CASCADE
);

CREATE TABLE booking_confirmed
    (ref_reservation_number INTEGER,
    ref_passport_number INTEGER,
    ticket_number INTEGER,
   
   CONSTRAINT pk_booking_confirmed
		PRIMARY KEY(ref_reservation_number, ref_passport_number),
	CONSTRAINT fk_booking_reservation
		FOREIGN KEY (ref_reservation_number) REFERENCES reservation(reservation_number),
	CONSTRAINT fk_booking_passenger 
		FOREIGN KEY (ref_passport_number) REFERENCES passenger(passport_number)
	ON DELETE CASCADE
);
    
CREATE TABLE weekday_factor
	(year INTEGER,
    day VARCHAR(10),
    factor DOUBLE,
    
    CONSTRAINT pk_weekday_factor
		PRIMARY KEY (year, day)
);

CREATE TABLE payment
	(amount INTEGER,
    cardholder_name VARCHAR(30),
    credit_card_number BIGINT,
    ref_reservation_number INTEGER,
    
    
    CONSTRAINT pk_weekday_factor
		PRIMARY KEY (credit_card_number, ref_reservation_number),
	
    CONSTRAINT fk_reservation_number
		FOREIGN KEY (ref_reservation_number) REFERENCES reservation(reservation_number)
	ON DELETE CASCADE   
);


CREATE VIEW allFlights AS
	SELECT (40-flight.booked_passengers) AS nr_of_free_seats, route.routeprice AS current_price_per_seat, flight.week_number AS departure_week, weekly_schedule.day AS departure_day, weekly_schedule.departure_time AS departure_time, weekly_schedule.year AS departure_year , 
    departure_city_name.name AS departure_city_name, arrival_city_name.name AS arrival_city_name FROM flight, weekly_schedule, route, destination AS departure_city_name, destination AS arrival_city_name
	WHERE
	flight.schedule_id = weekly_schedule.schedule_id AND
	weekly_schedule.departure_airport_code = route.departure_airport_code AND
	weekly_schedule.arrival_airport_code = route.arrival_airport_code AND
    route.departure_airport_code = departure_city_name.airport_code AND
    route.arrival_airport_code = arrival_city_name.airport_code AND
    weekly_schedule.year = route.year
    ;
    airport_code

DELIMITER //

CREATE PROCEDURE addYear(IN year INTEGER, IN factor DOUBLE)
	BEGIN
		INSERT INTO profit_factor (year, factor)
		VALUES (year, factor);
	END; 
//

CREATE PROCEDURE addDay(IN year INTEGER, IN day VARCHAR(10), IN factor DOUBLE)
	BEGIN
		INSERT INTO weekday_factor (year, day, factor)
        VALUES (year, day, factor);
	END;
//

CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN name VARCHAR(30), IN country VARCHAR(30))
	BEGIN
		INSERT INTO destination (airport_code, name, country)
        VALUES (airport_code, name, country);
	END;
//

CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN routeprice DOUBLE)
	BEGIN
		INSERT INTO route (departure_airport_code, arrival_airport_code, year, routeprice) 
        VALUES (departure_airport_code, arrival_airport_code, year, routeprice);
	END;
//

CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN day VARCHAR(10), IN departure_time TIME)
	BEGIN
		DECLARE schedule_id INTEGER;
        DECLARE temp_week_number INTEGER DEFAULT 1;
		INSERT INTO weekly_schedule (year, day, departure_time, departure_airport_code, arrival_airport_code) -- Skapar EN weekly schedule
			VALUES (year, day, departure_time, departure_airport_code, arrival_airport_code);
		SET schedule_id = LAST_INSERT_ID();
        
        insert_weekly_flights: LOOP -- Skapar 52 weekly flights
			INSERT INTO flight (schedule_id, week_number)
				VALUES (schedule_id, temp_week_number);
			SET temp_week_number = temp_week_number + 1;
            IF (temp_week_number > 52) THEN
				LEAVE insert_weekly_flights;
			END IF;
		END LOOP;
	END; -- Avslutar procedure addFlight
//

CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN week INTEGER, IN day VARCHAR(10), IN temp_time TIME, IN number_of_passengers INTEGER, OUT output_reservation_nr INTEGER)
	BEGIN
    DECLARE temp_flight_number INTEGER;
	SET temp_flight_number = (SELECT flight.flight_number FROM flight, weekly_schedule WHERE  
		weekly_schedule.departure_airport_code  = departure_airport_code AND weekly_schedule.arrival_airport_code  = arrival_airport_code AND weekly_schedule.year = year
		AND weekly_schedule.day = day AND weekly_schedule.departure_time = temp_time AND flight.week_number = week AND flight.schedule_id = weekly_schedule.schedule_id);
	IF (temp_flight_number IS NOT NULL) THEN
		IF (calculateFreeSeats(temp_flight_number) >= number_of_passengers) THEN
			SELECT SLEEP(5);
			INSERT INTO reservation(ref_flight_number) 
				VALUES (temp_flight_number);
           	SET output_reservation_nr = LAST_INSERT_ID();
            -- (SELECT reservation.reservation_number FROM reservation WHERE
		-- reservation.ref_flight_number = temp_flight_number);  
		ELSE
			SELECT "There are not enough seats available on the chosen flight" as "Message";
		END IF;
	ELSE
		SELECT "There exist no flight for the given route, date and time" as "Message";
	END IF;
	END;
//

CREATE PROCEDURE addPassenger(IN reservation_nr INTEGER, IN passport_number INTEGER, IN name VARCHAR(30))
	BEGIN
	/*Gör först en person*/
	DECLARE temp_passport_number INTEGER;
    IF NOT EXISTS (SELECT person.passport_number FROM person WHERE person.passport_number = passport_number) THEN
		INSERT INTO person(passport_number, person_name)
			VALUES(passport_number, name); 
		SELECT person.person_name FROM person WHERE person.passport_number = passport_number;
		/*Gör personen till en passenger*/
	END IF;
	
    IF EXISTS (SELECT reservation.reservation_number FROM reservation WHERE reservation.reservation_number = reservation_nr) THEN
		IF EXISTS (SELECT payment.ref_reservation_number FROM payment WHERE payment.ref_reservation_number = reservation_nr) THEN
			SELECT "The booking has already been payed and no futher passengers can be added" AS "Message";
        ELSE
			INSERT INTO passenger(passport_number, ref_reservation_nr)
				VALUES(passport_number, reservation_nr);
			UPDATE reservation
				SET number_of_passengers = number_of_passengers + 1
					WHERE reservation_number = reservation_nr;
		END IF;
	ELSE
		SELECT "The given reservation number does not exist" as "Message";
	END IF;
	END;
//

CREATE PROCEDURE addContact(IN reservation_nr INTEGER, IN passport_number INTEGER, IN email VARCHAR(30), IN phone BIGINT)
	BEGIN
	DECLARE is_added INTEGER;
    
    IF EXISTS (SELECT reservation.reservation_number FROM reservation WHERE reservation.reservation_number = reservation_nr) THEN
		IF EXISTS (SELECT passenger.passport_number FROM passenger WHERE passenger.passport_number = passport_number AND passenger.ref_reservation_nr = reservation_nr LIMIT 1) THEN
			INSERT INTO contact_person(phone_number, email, ref_reservation_number, ref_passport_number)
				VALUES(phone, email, reservation_nr, passport_number);
		ELSE
			SELECT "The person is not a passenger of the reservation" as "Message";
		END IF;
	ELSE
		SELECT "The given reservation number does not exist" as "Message";
	END IF;
    
	END;
//

CREATE PROCEDURE addPayment(IN reservation_nr INTEGER, IN cardholder_name VARCHAR(30), IN credit_card_number BIGINT)
	BEGIN
    DECLARE has_contact INTEGER;
    DECLARE temp_flight_number INTEGER;
	DECLARE temp_price INTEGER;
    DECLARE number_of_passengers INTEGER;
    
    IF EXISTS (SELECT reservation.reservation_number FROM reservation WHERE reservation.reservation_number = reservation_nr) THEN
		IF EXISTS (SELECT contact_person.ref_reservation_number FROM contact_person WHERE contact_person.ref_reservation_number = reservation_nr) THEN
			SET temp_flight_number = (SELECT reservation.ref_flight_number FROM reservation WHERE reservation.reservation_number = reservation_nr);
            SET number_of_passengers = (SELECT reservation.number_of_passengers FROM reservation WHERE reservation.reservation_number = reservation_nr);
			IF (calculateFreeSeats(temp_flight_number) >= number_of_passengers) THEN
				SELECT SLEEP(5);
				SET temp_price = calculatePrice(temp_flight_number);
                INSERT INTO payment(amount, cardholder_name, credit_card_number, ref_reservation_number)
					VALUES(temp_price, cardholder_name, credit_card_number, reservation_nr);
				UPDATE flight
					SET booked_passengers = booked_passengers + number_of_passengers
						WHERE flight_number = temp_flight_number;
			ELSE
				SET FOREIGN_KEY_CHECKS=0;
				DELETE FROM reservation WHERE reservation.reservation_number = reservation_nr; 
                SET FOREIGN_KEY_CHECKS=1;
				SELECT "There are not enough seats available on the flight anymore, deleting reservation" AS "Message";
			END IF;
		ELSE
			SELECT "The reservation has no contact yet" as "Message";
		END IF;
	ELSE
		SELECT "The given reservation number does not exist" as "Message";
    END IF;
    
    
    END;
//

-- Functions
CREATE FUNCTION calculateFreeSeats(temp_flightnumber INTEGER)
	RETURNS INTEGER
	NOT DETERMINISTIC
    BEGIN
		DECLARE seat_capacity INTEGER DEFAULT 40;
		DECLARE booked_seats INTEGER;
		SET booked_seats = (SELECT booked_passengers FROM flight WHERE flight_number = temp_flightnumber);
        RETURN (seat_capacity - booked_seats);
    END;
//

CREATE FUNCTION calculatePrice(temp_flightnumber INTEGER)
	RETURNS DOUBLE
    NOT DETERMINISTIC
    BEGIN
		DECLARE totalprice DOUBLE;
        DECLARE routeprice DOUBLE;
        DECLARE weekdayfactor DOUBLE;
        DECLARE booked_passengers INTEGER DEFAULT 0;
        DECLARE profitfactor DOUBLE;
        
        SET routeprice = (SELECT route.routeprice FROM route, flight, weekly_schedule WHERE 
			flight.flight_number = temp_flightnumber AND flight.schedule_id = weekly_schedule.schedule_id 
            AND weekly_schedule.departure_airport_code  = route.departure_airport_code AND weekly_schedule.arrival_airport_code  = route.arrival_airport_code AND weekly_schedule.year = route.year);
		
        SET weekdayfactor = (SELECT weekday_factor.factor FROM weekday_factor, flight, weekly_schedule WHERE
			flight.flight_number = temp_flightnumber AND flight.schedule_id = weekly_schedule.schedule_id 
            AND weekday_factor.day = weekly_schedule.day);
		
        SET booked_passengers = (40 - calculateFreeSeats(temp_flightnumber));
        
        SET profitfactor = (SELECT profit_factor.factor FROM profit_factor, flight, weekly_schedule WHERE
			flight.flight_number = temp_flightnumber AND flight.schedule_id = weekly_schedule.schedule_id 
            AND weekly_schedule.year = profit_factor.year);
            
		SET totalprice = (routeprice*weekdayfactor*((booked_passengers+1)/40)*profitfactor);
        return totalprice;
	END;
//
        
CREATE TRIGGER createTicketNumber
	AFTER INSERT ON booking_confirmed
    FOR EACH ROW
    INSERT INTO booking_confirmed
    SET ACTION = 'insert',
	booking_confirmed.ticket_number = rand();
//
    
DELIMITER ;	



	

    


    
    
