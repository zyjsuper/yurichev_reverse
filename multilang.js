function set_english()
{
	var elements = document.getElementsByClassName('ru')
	for (var i = 0; i < elements.length; i++)
		elements[i].style.display = 'none';

	var elements = document.getElementsByClassName('eng')
	for (var i = 0; i < elements.length; i++)
		elements[i].style.display = 'block';
}
function set_russian()
{
	var elements = document.getElementsByClassName('ru')
	for (var i = 0; i < elements.length; i++)
		elements[i].style.display = 'block';

	var elements = document.getElementsByClassName('eng')
	for (var i = 0; i < elements.length; i++)
		elements[i].style.display = 'none';
}
window.onload = set_english;
