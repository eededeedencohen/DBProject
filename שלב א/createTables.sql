CREATE TABLE BookCategories (
    Category_id INT PRIMARY KEY, 
    Category VARCHAR2(50) NOT NULL, 
    Subcategory VARCHAR2(50) NOT NULL, 
    Description CLOB 
);

CREATE TABLE BookAuthors (
    Author_id INT PRIMARY KEY, 
    Author_academic_title VARCHAR2(10),
    Author_first_name VARCHAR2(100) NOT NULL, 
    Author_last_name VARCHAR2(100) NOT NULL, 
    Author_birth_date DATE NOT NULL, 
    Nationality VARCHAR2(50) NOT NULL, 
    Biography CLOB 
);

CREATE TABLE Librarians (
    Librarian_id INT PRIMARY KEY, 
    Librarian_first_name VARCHAR2(100) NOT NULL, 
    Librarian_last_name VARCHAR2(100) NOT NULL, 
    Librarian_birth_date DATE NOT NULL, 
    Email VARCHAR2(100) NOT NULL, 
    Phone VARCHAR2(40) NOT NULL, 
    Hire_date DATE NOT NULL 
);

CREATE TABLE Books (
    Book_id INT PRIMARY KEY, 
    Book_name VARCHAR2(255) NOT NULL,
    Publication_date DATE NOT NULL, 
    Category_id INT NOT NULL, 
    Author_id INT NOT NULL, 
    Language VARCHAR2(50) NOT NULL, 
    Book_description CLOB, 
    FOREIGN KEY (Category_id) REFERENCES BookCategories(Category_id),
    FOREIGN KEY (Author_id) REFERENCES BookAuthors(Author_id)
);

CREATE TABLE BookStatuses (
    Book_id INT NOT NULL, 
    Status VARCHAR2(50) NOT NULL, -- available, borrowed, lost, damaged
    Number_of_copies INT NOT NULL,
    PRIMARY KEY (Book_id, Status),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id)
);

CREATE TABLE Students ( 
    Student_id INT PRIMARY KEY,  
    Student_first_name VARCHAR2(100) NOT NULL, 
    Student_last_name VARCHAR2(100) NOT NULL, 
    Email VARCHAR2(100) NOT NULL, 
    Phone VARCHAR2(40) NOT NULL, 
    Birth_date DATE NOT NULL, 
    Degree VARCHAR2(50) NOT NULL, 
    Start_date DATE NOT NULL 
);


CREATE TABLE Lent (
    Book_id INT NOT NULL, 
    Student_id INT NOT NULL, 
    Status VARCHAR2(50) NOT NULL,
    Fine_amount INT NOT NULL, 
    Borrow_date DATE NOT NULL, 
    Return_date DATE NOT NULL, 
    PRIMARY KEY (Book_id, Student_id, Borrow_date), 
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id),
    FOREIGN KEY (Student_id) REFERENCES Students(Student_id)
);


CREATE TABLE Reviews (
    Book_id INT NOT NULL, 
    Reviewer_id INT NOT NULL, 
    Review_text CLOB NOT NULL,
    Rating INT NOT NULL,
    Review_date DATE NOT NULL,
    Review_title VARCHAR2(255) NOT NULL,
    PRIMARY KEY (Book_id, Reviewer_id),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id) ON DELETE CASCADE,
    FOREIGN KEY (Reviewer_id) REFERENCES Students(Student_id) ON DELETE CASCADE
);


CREATE TABLE StudyRooms (
    Room_number INT PRIMARY KEY, 
    Library_floor INT NOT NULL, 
    Library_section VARCHAR2(50) NOT NULL, 
    Room_capacity INT NOT NULL,
    Board VARCHAR2(1) NOT NULL,  -- Y, N
    Screen VARCHAR2(1) NOT NULL  -- Y, N
);


CREATE TABLE RequestsRooms (
    Student_id INT NOT NULL, 
    Request_time DATE NOT NULL, 
    Start_time DATE NOT NULL, 
    Duration_hours NUMBER(2,1) NOT NULL, 
    Number_of_people INT NOT NULL,
    Board VARCHAR2(1) NOT NULL, 
    Screen VARCHAR2(1) NOT NULL, 
    Handled_Librarian INT, 
    Assigned_room INT,
    Status VARCHAR2(50) NOT NULL,
    PRIMARY KEY (Student_id, Request_time),
    FOREIGN KEY (Student_id) REFERENCES Students(Student_id),
    FOREIGN KEY (Handled_Librarian) REFERENCES Librarians(Librarian_id) ON DELETE SET NULL,
    FOREIGN KEY (Assigned_room) REFERENCES StudyRooms(Room_number)
);


CREATE TABLE LibraryRequests (
    Request_id INT PRIMARY KEY, 
    Request_type VARCHAR2(50) NOT NULL, 
    Request_description CLOB NOT NULL, 
    Request_date DATE NOT NULL,
    Request_librarian INT, 
    Request_status VARCHAR2(50) NOT NULL, 
    FOREIGN KEY (Request_librarian) REFERENCES Librarians(Librarian_id) ON DELETE SET NULL
);

CREATE TABLE RequestAssignments (
    Request_id INT PRIMARY KEY, 
    Assigned_librarian INT, 
    Completion_date DATE, 
    FOREIGN KEY (Request_id) REFERENCES LibraryRequests(Request_id) ON DELETE CASCADE, 
    FOREIGN KEY (Assigned_librarian) REFERENCES Librarians(Librarian_id) ON DELETE SET NULL
);
