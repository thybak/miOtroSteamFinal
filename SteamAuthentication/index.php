<?php
    require ('steamauth/steamauth.php');
?>
<!DOCTYPE html>
<html>
<head>
    <title>STEAM OpenID Login</title>
    <link rel="stylesheet" href="styles.css" />
    <link href="https://fonts.googleapis.com/css?family=Londrina+Solid" rel="stylesheet">
</head>
<body>
<?php
if(!isset($_SESSION['steamid'])) {
    echo "<p>¿No sabes tu SteamID?</p><br /><p>No te preocupes, para obtener tu SteamID puedes iniciar sesión:</p><br />";
    loginbutton();
    
}  else {
    include ('steamauth/userInfo.php');
    echo '<p>Tu SteamID es: </p><br /><h2>'.$steamprofile['steamid'].'</h2><br />';
    logoutbutton();
}    
?>  
</body>
</html>
