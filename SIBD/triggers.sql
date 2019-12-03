/*trigger 1 - update the age*/
create trigger update_age after insert on appointment
for each row 
begin
    
    update client 
    set client_age=timestampdiff(year, now(), client_birth_date)*(-1);

end;

/*triggers 2a) - ensure receptionist or nurse can't simultaneously be a doctor*/
create trigger distinct_profession_ins before insert on doctor        
for each row   
begin
    if exists(select * 
              from nurse as n, receptionist as r
              where n.employee_VAT=new.employee_VAT or r.employee_VAT=new.employee_VAT)  
    then 
            
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Receptionists and nurses cant also be doctors!';
    end if;
end;

create trigger distinct_profession_up before update on doctor        
for each row   
begin
    if exists(select * 
              from nurse as n, receptionist as r
              where n.employee_VAT=new.employee_VAT or r.employee_VAT=new.employee_VAT)  
    then 
            
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Receptionists and nurses cant also be doctors!';
    end if;
end;

/*triggers 2b) - ensure doctors can't be trainees and permanent staff*/

create trigger trainee_or_permanent_ins before insert on permanent_doctor
for each row
begin
    if exists(select * 
              from trainee_doctor as td
              where td.employee_VAT=new.employee_VAT)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'doctors cannot simultaneously be trainees and permanent staff!';
    end if;
end;
    
create trigger permanent_or_trainee_ins before insert on trainee_doctor
for each row
begin
    if exists(select * 
              from permanent_doctor as pd
              where pd.employee_VAT=new.employee_VAT)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'doctors cannot simultaneously be trainees and permanent staff!';
    end if;
end;

create trigger trainee_or_permanent_up before update on permanent_doctor
for each row
begin
    if exists(select * 
              from trainee_doctor as td
              where td.employee_VAT=new.employee_VAT)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'doctors cannot simultaneously be trainees and permanent staff!';
    end if;
end;
    
create trigger permanent_or_trainee_up before update on trainee_doctor
for each row
begin
    if exists(select * 
              from permanent_doctor as pd
              where pd.employee_VAT=new.employee_VAT)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'doctors cannot simultaneously be trainees and permanent staff!';
    end if;
end;

/*trigger 3 - ensure that individuals can't have the same phone number*/
create trigger different_number_employee_ins before insert on phone_number_employee        
for each row  
begin
    if exists(select * 
              from phone_number_client as pc, phone_number_employee as pe 
              where pc.client_phone_number=new.employee_phone_number or pe.employee_phone_number=new.employee_phone_number)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'different individuals (doctors or clients) cannot have the same phone number!';
    end if;
end;

create trigger different_number_employee_up before update on phone_number_employee        
for each row  
begin
    if exists(select * 
              from phone_number_client as pc, phone_number_employee as pe 
              where pc.client_phone_number=new.employee_phone_number or pe.employee_phone_number=new.employee_phone_number)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'different individuals (doctors or clients) cannot have the same phone number!';
    end if;
end;

create trigger different_number_client_ins before insert on phone_number_client    
for each row  
begin
    if exists(select * 
              from phone_number_employee as pe, phone_number_client as pc
              where pe.employee_phone_number=new.client_phone_number or pc.client_phone_number=new.client_phone_number)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = ' different individuals (doctors or clients) cannot have the same phone number';
    end if;
end;

create trigger different_number_client_up before update on phone_number_client    
for each row  
begin
    if exists(select * 
              from phone_number_employee as pe, phone_number_client as pc
              where pe.employee_phone_number=new.client_phone_number or pc.client_phone_number=new.client_phone_number)  
    then 
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = ' different individuals (doctors or clients) cannot have the same phone number';
    end if;
end;