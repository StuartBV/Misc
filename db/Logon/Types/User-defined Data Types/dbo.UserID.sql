CREATE TYPE [dbo].[UserID] FROM varchar (50) NOT NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[UserID] TO [public]
GO
