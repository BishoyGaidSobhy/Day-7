use company2
--1.	Use Try … Catch with any query and in catch print the @@Error value and Error message
go
begin try
delete Employee where EmpNo = '1'
end try
begin catch
raiserror('can not delete record ,is used in other tables',404,1)
end catch



--2-Soft Delete
go
alter table dbo.Project 
add  isDeleted bit
go
create or alter trigger tr_delete
on project
instead of delete
as
declare @proj_num int
select @proj_num=proj_num from deleted
update Project
set isDeleted=1
where @proj_num=proj_num

delete Project where proj_num=5 

select * from  project 
go
create or alter view Projects
as
select * from  project
where isDeleted is null

select * from Projects



---3
go
create table BudgetChangeAudit(
 id int primary key Identity (1,1) ,
 ProjectNo varchar(10),
 UserName varchar(150),
 ModifiedDate date default getdate(),
 Budget_Old float ,
 Budget_New float
)
go
create or alter trigger tr_insertfor
on project
after update
as
begin
	declare @id int
	declare @newbudg float
	declare @oldbudg float
	select @id= proj_num, @newbudg=budget from inserted
	update project

	set budget=@newbudg
	where  proj_num=@id
	
	select @id= proj_num, @oldbudg=budget from deleted
	insert into BudgetChangeAudit (ProjectNo,UserName,Budget_New,Budget_Old) values(@id ,SUSER_NAME(),@newbudg,@oldbudg)
	

end
	update Project
	set budget=540000
	where proj_num=505
	select * from BudgetChangeAudit
	select * from Project

