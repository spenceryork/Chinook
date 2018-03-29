-- 1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.

SELECT FirstName, LastName, CustomerId, Country
FROM Customer
Where Country != "USA"

-- 2. Provide a query only showing the Customers from Brazil.

SELECT *
FROM Customer
Where Country = "Brazil"

-- 3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.

SELECT Customer.FirstName, Customer.LastName, Invoice.InvoiceId, Invoice.InvoiceDate, Invoice.BillingCountry
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
WHERE Customer.Country = "Brazil"

-- 4. Provide a query showing only the Employees who are Sales Agents.

SELECT *
FROM Employee
WHERE title = "Sales Support Agent"

-- 5. Provide a query showing a unique list of billing countries from the Invoice table.

SELECT DISTINCT BillingCountry
FROM Invoice

-- 6. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.

SELECT Employee.FirstName, Employee.LastName, Invoice.InvoiceId
FROM Invoice
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId

-- 7. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.

SELECT Invoice.Total, Customer.FirstName, Customer.LastName, Customer.Country, Employee.FirstName, Employee.LastName
FROM Customer 
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId

-- 8. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?

SELECT strftime('%Y' , Invoice.InvoiceDate) AS 'YearInvoiced', COUNT(Invoice.InvoiceId), SUM(Invoice.Total)
FROM Invoice
WHERE Invoice.InvoiceDate LIKE '%2009%'
OR Invoice.InvoiceDate LIKE '%2011%'
GROUP BY YearInvoiced

-- 9. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.

SELECT COUNT(InvoiceLine.InvoiceLineId)
FROM InvoiceLine
WHERE InvoiceLine.InvoiceId = 37

-- 10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: [GROUP BY](http://www.sqlite.org/lang_select.html#resultset)

SELECT COUNT(InvoiceLine.InvoiceLineId)
FROM InvoiceLine
GROUP BY InvoiceLine.InvoiceId

-- 11. Provide a query that includes the track name with each invoice line item.

SELECT InvoiceLine.*, Track.Name
FROM InvoiceLine
JOIN Track ON Track.TrackId = InvoiceLine.TrackId

-- 12. Provide a query that includes the purchased track name AND artist name with each invoice line item.

SELECT InvoiceLine.*, Track.Name AS 'Track Name', Artist.Name AS 'Artist Name'
FROM InvoiceLine
JOIN Track ON Track.TrackId = InvoiceLine.TrackId
JOIN Album ON Album.AlbumId = Track.AlbumId
JOIN Artist ON Artist.ArtistId = Album.ArtistId

-- 13. Provide a query that shows the # of invoices per country. HINT: [GROUP BY](http://www.sqlite.org/lang_select.html#resultset)

SELECT COUNT(Invoice.InvoiceId), Invoice.BillingCountry
FROM Invoice
GROUP BY Invoice.BillingCountry

-- 14. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be included on the resultant table.

SELECT COUNT(Track.TrackId), Playlist.Name
FROM PlaylistTrack
JOIN Playlist ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
JOIN Track ON PlaylistTrack.TrackId = Track.TrackId
GROUP BY Playlist.Name

-- 15. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.

SELECT Track.Name AS 'Track Name', Album.Title AS 'Album Title', MediaType.Name AS 'Media Type', Genre.Name AS 'Genre'
FROM Track
JOIN Album ON Album.AlbumId = Track.AlbumId
JOIN MediaType ON MediaType.MediaTypeId = Track.MediaTypeId
JOIN Genre ON Genre.GenreId = Track.GenreId

-- 16. Provide a query that shows all Invoices but includes the # of invoice line items.

SELECT Invoice.*, COUNT(InvoiceLine.InvoiceId)
FROM Invoice
JOIN InvoiceLine ON InvoiceLine.InvoiceLineId = Invoice.InvoiceId
GROUP BY Invoice.InvoiceId

-- 17. Provide a query that shows total sales made by each sales agent.

SELECT Employee.EmployeeId, COUNT(Invoice.InvoiceId)
FROM Invoice WHERE strftime('%Y' , Invoice.InvoiceDate) = 2009
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId
GROUP BY Employee.EmployeeId

-- 18. Which sales agent made the most in sales in 2009?

SELECT Employee.EmployeeId, SUM(Invoice.Total)
FROM Invoice 
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId
WHERE Invoice.InvoiceDate LIKE '%2009%'
GROUP BY Employee.EmployeeId
ORDER BY SUM(Invoice.Total) desc
LIMIT 1

-- 19. Which sales agent made the most in sales in 2010?

SELECT Employee.EmployeeId, SUM(Invoice.Total)
FROM Invoice 
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId
WHERE Invoice.InvoiceDate LIKE '%2010%'
GROUP BY Employee.EmployeeId
ORDER BY SUM(Invoice.Total) desc
LIMIT 1

-- 20. Which sales agent made the most in sales over all?

SELECT Employee.EmployeeId, SUM(Invoice.Total)
FROM Invoice 
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId
GROUP BY Employee.EmployeeId
ORDER BY SUM(Invoice.Total) desc
LIMIT 1

-- 21. Provide a query that shows the # of customers assigned to each sales agent.

SELECT Employee.EmployeeId, COUNT(Customer.CustomerId)
FROM Employee
JOIN Customer ON Customer.SupportRepId = Employee.EmployeeId
GROUP BY Employee.EmployeeId

-- 22. Provide a query that shows the total sales per country. Which country's customers spent the most?

SELECT Invoice.BillingCountry, SUM(Invoice.Total)
FROM Invoice
GROUP BY Invoice.BillingCountry
ORDER BY SUM(Invoice.Total)
-- Add To Show only country with the highest total
LIMIT 1

-- 23. Provide a query that shows the most purchased track of 2013.

SELECT Track.TrackId, Track.Name, COUNT(InvoiceLine.Quantity)
FROM Track
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
WHERE Invoice.InvoiceDate LIKE '%2013%'
GROUP BY Track.Name
ORDER BY COUNT(InvoiceLine.Quantity) desc

-- 24. Provide a query that shows the top 5 most purchased tracks over all.

SELECT Track.TrackId, Track.Name, COUNT(InvoiceLine.Quantity)
FROM Track
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name
ORDER BY COUNT(InvoiceLine.Quantity) desc
LIMIT 5

-- 25. Provide a query that shows the top 3 best selling artists.

SELECT Artist.Name, COUNT(InvoiceLine.Quantity)
FROM Artist
JOIN Album ON Album.ArtistId = Artist.ArtistId
JOIN Track ON Track.AlbumId = Album.ArtistId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Artist.Name
ORDER BY COUNT(InvoiceLine.Quantity) desc
LIMIT 3

-- 26. Provide a query that shows the most purchased Media Type.

SELECT MediaType.Name, COUNT(InvoiceLine.TrackId)
FROM MediaType
JOIN Track ON Track.MediaTypeId = MediaType.MediaTypeId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY MediaType.Name
ORDER BY COUNT(InvoiceLine.Quantity) desc
LIMIT 1

-- 27. Provide a query that shows the number tracks purchased in all invoices that contain more than one genre.

SELECT COUNT(Track.TrackId), Invoice.InvoiceId, COUNT(DISTINCT Genre.Genreid)
FROM Track
JOIN Invoiceline ON InvoiceLine.TrackId = Track.TrackId
JOIN Invoice ON Invoice.Invoiceid = Invoiceline.Invoiceid 
JOIN Genre ON Genre.GenreId = Track.GenreId 
GROUP BY Invoice.Invoiceid
HAVING COUNT(DISTINCT Genre.Genreid) > 1