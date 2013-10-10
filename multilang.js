function set_english()
{
	var elems = document.getElementsByName("multilang");
	for (var i=0; i<elems.length; i++)
	{
		elems[i].innerHTML=elems[i].getAttribute("data-en");
	}
}
function set_russian()
{
	var elems = document.getElementsByName("multilang");
	for (var i=0; i<elems.length; i++)
	{
		elems[i].innerHTML=elems[i].getAttribute("data-ru");
	}
}
window.onload = set_english;
