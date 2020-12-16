<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="../css/app.css">
  <title>Twitter : : Clone</title>
</head>
<body>
  <div id="signup-container">
    <div id="signup-container__content">
      <div id="twitter-logo-signup">
        <svg viewBox="0 0 24 24">
          <path
            d="M23.643 4.937c-.835.37-1.732.62-2.675.733.962-.576 1.7-1.49 2.048-2.578-.9.534-1.897.922-2.958 1.13-.85-.904-2.06-1.47-3.4-1.47-2.572 0-4.658 2.086-4.658 4.66 0 .364.042.718.12 1.06-3.873-.195-7.304-2.05-9.602-4.868-.4.69-.63 1.49-.63 2.342 0 1.616.823 3.043 2.072 3.878-.764-.025-1.482-.234-2.11-.583v.06c0 2.257 1.605 4.14 3.737 4.568-.392.106-.803.162-1.227.162-.3 0-.593-.028-.877-.082.593 1.85 2.313 3.198 4.352 3.234-1.595 1.25-3.604 1.995-5.786 1.995-.376 0-.747-.022-1.112-.065 2.062 1.323 4.51 2.093 7.14 2.093 8.57 0 13.255-7.098 13.255-13.254 0-.2-.005-.402-.014-.602.91-.658 1.7-1.477 2.323-2.41z">
          </path>
        </svg>
      </div>
      <h1>Signup</h1>
      <form action="../api/api-sign-up.php" method="POST">
        <div class="signup-container__form">
          <input type="text" name="name" placeholder="first name" required>
        </div>
        <div class="signup-container__form">
          <input type="text" name="lastName" placeholder="last name" required>
        </div>
        <div class="signup-container__form">
          <input type="text" name="profileName" placeholder="profile name" required>
        </div>
        <div class="signup-container__form">
          <input type="text" name="email" placeholder="email" required>
        </div>
        <div class="signup-container__form">
          <input type="password" name="password" placeholder="password" required>
        </div>
        <button>Sign up</button>
      </form>
      <div class="redirect-to-login">
        <p class="redirect-to-login__text">Already have a user?</p>
        <a href="../login/login.php">Go to login</a>
      </div>
    </div>
  </div>
</body>
</html>