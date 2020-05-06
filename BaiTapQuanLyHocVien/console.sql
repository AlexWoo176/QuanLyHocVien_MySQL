alter table class
modify column StartDate datetime default current_timestamp;

alter table student
modify column Status bit default 1;

alter table mark
add foreign key(SubID) references subject(SubID);

alter table mark
add foreign key(StudentID) references student(StudentID);

insert into class(ClassName, StartDate, Status)
VALUE ('A1','2008/12/20',1), ('A2','2008/12/22',1), ('B3',CURRENT_DATE,0);

insert into student(StudentID, StudentName, Address, Phone, Status, ClassID)VALUE
    (1, 'Hung', 'Ha Noi', '0912113113', 1, 4),
    (2, 'Hoa', 'Hai Phong','', 1, 4),
    (3, 'Manh', 'HCM', '0123113113', 0, 5);

insert into subject(SubName, Credit, Status)VALUE
('CF', 5, 1),
('C' , 6, 1),
('HDJ', 5, 1),
('RDBMS', 10, 1);

alter table mark
drop foreign key mark_ibfk_1,
drop foreign key mark_ibfk_2;

alter table mark
drop constraint Mark_SubID_uindex,
drop constraint Mark_StudentID_uindex;

alter table mark
add foreign key(SubID) references subject(SubID),
add foreign key(StudentID) references student(StudentID);

insert into mark(SubID, StudentID, Mark, ExamTimes) VALUE
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);

update student
set ClassID = 5
where StudentName = 'Hung';

update student
set Phone = 'No Phone'
where Phone = '';
# where phone is null or phone='';

update class
set ClassName = concat('New',ClassName)
where Status = 0;

update class
set ClassName = concat(replace(ClassName, 'New', 'Old'))
where Status = 1 and ClassName like 'New%';

update class
Set Status = 0
WHERE ClassID not in (SELECT ClassID from student);

update subject
Set Status = 0
WHERE SubID not in (SELECT SubID from mark);

SELECT * from student WHERE StudentName LIKE 'h%';

Select * from Class where Month(StartDate) = 12;

alter table mark
add unique (SubID, StudentID);

select max(Credit) as Credit_Max from subject;

select * from subject
where Credit = (select max(Credit) from subject);

select *
from subject
where Credit between 3 and 5;

select class.ClassID, ClassName, StudentName, Address
from class join student on class.ClassID = student.ClassID;

select *
from subject
where SubID not in (select SubID from mark);

select subject.*
from subject inner join mark on subject.SubID = mark.SubID
where Mark = (select MAX(Mark) from mark);

select s.StudentID, StudentName, Address, Phone, Status, ClassID, AVG(Mark) AS Diem_Trung_Binh
from student as s
left join mark as m on s.StudentID = m.StudentID
group by s.StudentID, StudentName, Address, Phone, Status, ClassID;

select s.StudentID, StudentName, Address, Phone, Status, ClassID, AVG(Mark) AS Diem_Trung_Binh,
rank() over (order by avg(Mark) DESC ) as Xep_Hang
from student as s
left join mark as m on s.StudentID = m.StudentID
group by s.StudentID, StudentName, Address, Phone, Status, ClassID;

select s.StudentID, StudentName, Address, Phone, Status, ClassID, AVG(Mark) AS Diem_Trung_Binh
from student as s
left join mark as m on s.StudentID = m.StudentID
group by s.StudentID, StudentName, Address, Phone, Status, ClassID
having avg(Mark>10);

select  student.StudentName, SubName, Mark
from student
inner join mark m on student.StudentID = m.StudentID
inner join subject s on m.SubID = s.SubID
order by Mark desc, StudentName asc;