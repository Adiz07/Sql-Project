Questiom set 1
q1 :
select * from employee
order by levels desc
limit 1

q2 :
select count(*) as c, billing_country from invoice 
group by billing_country
order by c desc

q3 :
select total from invoice order by total desc
limit 3

q4:
select sum(total) as invoice_total,billing_city from invoice
group by billing_city order by invoice_total desc

q5:
select customer.customer_id,customer.first_name,customer.last_name ,sum(invoice.total) as total from customer
Join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id 
order by total desc
limit 1

Questiom set 2
q1 :
select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id In(
 select track_id from track
join genre on track.genre_id=genre.genre_id
where genre.name Like 'Rock'
)
order by email

q2:
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10

q3 :
select name, milliseconds
from track
where milliseconds > (
 select avg (milliseconds) as avg_track_lenght
from track)
order by milliseconds desc;

Questiom set 3
q1:
with best_selling_artist As(
 select artist.artist_id as artist_id,artist.name as artist_name,
 sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
 from invoice_line
 join track on track.track_id=invoice_line.track_id
 join album on album.album_id = track.album_id
 join artist on artist.artist_id=album.artist_id
 group by 1
 order by 3 desc
 limit 1
)

select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
Join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc


q2:
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

q3:
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

