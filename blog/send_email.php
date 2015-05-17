<?php header("Cache-Control: no-cache, must-revalidate");

$ua=getenv ("HTTP_USER_AGENT");
$ip=getenv ("REMOTE_ADDR");
$host_by_addr=gethostbyaddr (getenv ("REMOTE_ADDR"));

$email=$_POST["email"];

mail ("yurichev+subscribe@googlegroups.com", "", "", "From: ".$email."\r\n");

?>
Thank you for your submission! Now check your email for email from google groups.
