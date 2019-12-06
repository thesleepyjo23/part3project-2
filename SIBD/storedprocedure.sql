delimiter $$

create procedure raise_doctor_salary(in x int)
begin
	update employee 
    set employee_salary = employee_salary + 0.1 * employee_salary
    where employee_VAT in ( 
	    select pd.employee_VAT
	    from permanent_doctor as pd 
	    where  years>= x )
		and employee_VAT in (select doctor_VAT
                             from consultation 
                             where doctor_VAT in(select doctor_VAT
                                                 from consultation
                                                 where year(date_timestamp)=year(now())
                                                 group by doctor_VAT having count(*)>100));
		
	update employee 
    set employee_salary = employee_salary + 0.05 * employee_salary
    where employee_VAT in ( 
	    select pd.employee_VAT
	    from permanent_doctor as pd 
	    where  years>= x ) and employee_VAT not in (select doctor_VAT
                             from consultation 
                             where doctor_VAT in(select doctor_VAT
                                                 from consultation
                                                 where year(date_timestamp)=year(now())
                                                 group by doctor_VAT having count(*)>100));
		
end$$

delimiter;