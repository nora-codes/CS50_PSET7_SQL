-- Fiftyville Crime Scene Investigation: The CS50 Duck has been stolen!

-- What we know:
    -- The theft took place on July 28, 2020
    -- On Chamberlin Street
    -- The thief stole the duck and then, shortly afterwards, took a flight out of town
    -- With an accomplice

-- What to find out:
    -- Who the thief is
    -- What city the thief escaped to
    -- Who the thief’s accomplice is who helped them escape

------------------------------------------------------------------------------------------

-- Action: Find crime scene reports that match the date and location of the crime
-- Information Avaliable: month, day, street
-- Required Data: crime description

SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28
AND street = "Chamberlin Street";

-- Information Acquired:
-- Time of theft 10:15am
-- Location of theft: Chamberlin Street courthouse
-- Three witnesses conducted interviews - who were present at the time
-- Each of their interview transcripts mentions the courthouse

-- Next steps: Look into interviews and courthouse security

------------------------------------------------------------------------------------------

-- Action: Gather more inforation from from three witnesses
-- Information Avaliable: month, day
-- Required Data: name, transcript

SELECT name, transcript
FROM interviews
WHERE month = 7 AND day = 28;

-- Information Acquired:
-- Theif left courthouse carpark between 10.15am and 10.25am
-- Eugene is an acquaintance of the theif
-- Before the theft, the theif withdrew some money from the ATM on Fifer Street
-- Between 10.15am and 10.25am the theif made a call for less than a minute
-- Theif plans to take the earliest flight on 29 July
-- The receiver of the phone call is the accomplice

-- Next steps: Look into courthouse security at specific time,
-- ATM transactions, phone calls and flights

------------------------------------------------------------------------------------------

-- Action: Investigate activity at the courthouse when the theif left the courthouse
-- Information Avaliable: month, day, hour, minute (exit)
-- Required Data: names

SELECT name from people
WHERE license_plate IN (
    SELECT license_plate
    FROM courthouse_security_logs
    WHERE month = 7 AND day = 28 AND hour = 10
    AND minute BETWEEN 14 AND 25
    AND activity = "exit"
)
ORDER BY name;

-- Suspects from this investigation:
    -- Amber
    -- Danielle
    -- Elizabeth
    -- Ernest
    -- Evelyn
    -- Patrick
    -- Roger
    -- Russell

------------------------------------------------------------------------------------------

-- Action: Find users of the Fifer Street ATM on the morning of the crime
-- Information Avaliable: month, day, location, type - withraw
-- Required Data: names

SELECT name
FROM people
WHERE id IN (
    SELECT person_id
    FROM bank_accounts
    WHERE account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE month = 7 AND day = 28
        AND atm_location = "Fifer Street"
        AND transaction_type = "withdraw"
    )
)
ORDER BY name;

-- Suspects from this investigation:
    -- Bobby
    -- Danielle
    -- Elizabeth
    -- Ernest
    -- Madison
    -- Roy
    -- Russell
    -- Victoria

-- Suspects mutual with all other investigations
    -- Danielle
    -- Elizabeth
    -- Ernest
    -- Russell

------------------------------------------------------------------------------------------

-- Action: Investigate phone calls made between 10.15am and 10.25am
-- Information Avaliable: month, day, duration
-- Required Data: names of callers and receivers

-----------
-- Callers:
-----------

SELECT name, phone_number
FROM people
WHERE phone_number IN (
    SELECT caller
    FROM phone_calls
    WHERE month = 7 AND day = 28
    AND duration < 60
)
ORDER BY name;

-- Suspects from this investigation:
    -- Bobby | (826) 555-1652
    -- Ernest | (367) 555-5533
    -- Evelyn | (499) 555-9472
    -- Kimberly | (031) 555-6622
    -- Madison | (286) 555-6063
    -- Roger | (130) 555-0289
    -- Russell | (770) 555-1861
    -- Victoria | (338) 555-6650

-- Suspects mutual with all other investigations
    -- Ernest | (367) 555-5533
    -- Russell | (770) 555-1861

-------------
-- Receivers:
-------------

-- Ernest's call:
SELECT name
FROM people
WHERE phone_number IN (
    SELECT receiver
    FROM phone_calls
    WHERE month = 7 AND day = 28
    AND duration < 60
    AND caller = "(367) 555-5533"
);

-- Russell's call:
SELECT name
FROM people
WHERE phone_number IN (
    SELECT receiver
    FROM phone_calls
    WHERE month = 7 AND day = 28
    AND duration < 60
    AND caller = "(770) 555-1861"
);

-- Receivers of suspects calls:
    -- Ernest > Berthold
    -- Russell > Philip

------------------------------------------------------------------------------------------

-- Action: Find first flights on 29 July
-- Information Avaliable: month, day
-- Required Data: destination city

SELECT city
FROM airports
WHERE id = (
    SELECT destination_airport_id
    FROM flights
    WHERE month = 7 AND day = 29
    ORDER BY hour, minute
    LIMIT 1
);

-- Information Acquired: destination London

------------------------------------------------------------------------------------------

-- Action: Find passengers on first flight on 29th July
-- Information Avaliable: flight id
-- Required Data: name

SELECT name
FROM people
WHERE passport_number IN (
    SELECT passport_number
    FROM passengers
    WHERE flight_id = (
        SELECT id
        FROM flights
        WHERE month = 7 AND day = 29
        ORDER BY hour, minute
        LIMIT 1
    )
)
ORDER BY name;

-- Suspects from this investigation:
    -- Bobby
    -- Danielle
    -- Doris
    -- Edward
    -- Ernest
    -- Evelyn
    -- Madison
    -- Roger

-- Suspects mutual with all other investigations
    -- Ernest

------------------------------------------------------------------------------------------

------------------
-- Mystery solved:
------------------

-- Theif: Ernest
-- Accomplice: Berthold
-- Destination: London


