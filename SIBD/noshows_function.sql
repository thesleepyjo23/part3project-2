create function no_shows(gender char(1), year_of_appointment int,
age_upper_limit int, age_lower_limit int)
returns int
begin
    declare num_noshows int;
    
    select count(*)
    from consultation as cn 
    inner join appointment as a on cn.doctor_VAT=a.doctor_VAT
    inner join client as ct on a.client_VAT=ct.client_VAT
    where (year(cn.date_timestamp)=year_of_appointment) 
    and ct.client_gender=gender and ct.client_age>= age_lower_limit 
    and ct.client_age<= age_upper_limit
    into num_noshows;
    
    return num_noshows;
 
end