LOAD DATA LOCAL INFILE 'download/US.txt'
INTO TABLE postal_code
CHARACTER SET 'UTF8'
(
    @country,
    @postal_code,
    @name,
    @admin1_name,
    @admin1_code,
    @admin2_name,
    @admin2_code,
    @admin3_name,
    @admin3_code,
    @latitude,
    @longitude,
    @accuracy
)
SET
    `city` = @name,
    `state` = @admin1_code,
    `zip` = @postal_code,
    `state_full` = @admin1_name,
    `county_full` = @admin2_name,
    `county_fips_code` = @admin2_code,
    `latitude` = @latitude,
    `longitude` =  @longitude,
    `accuracy` = @accuracy
;