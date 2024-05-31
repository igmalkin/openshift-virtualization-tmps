#!/bin/bash

# Install httpd
sudo dnf install httpd -y

# Start the httpd service
sudo systemctl start httpd

# Enable httpd service to start on boot
sudo systemctl enable httpd

# Create index.html with "hello world" content
echo "<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Display current date and time</title>
  </head>
  <body>
    <h1>This is "$HOSTNAME". Current date and time:</h1>
    <span id="datetime"></span>

    <script>
      // create a function to update the date and time
      function updateDateTime() {
        // create a new `Date` object
        const now = new Date();

        // get the current date and time as a string
        const currentDateTime = now.toLocaleString();

        // update the `textContent` property of the `span` element with the `id` of `datetime`
        document.querySelector('#datetime').textContent = currentDateTime;
      }

      // call the `updateDateTime` function every second
      setInterval(updateDateTime, 1000);
    </script>
  </body>
</html>" | sudo tee /var/www/html/index.html > /dev/null

# Restart httpd to ensure it picks up the new index.html
sudo systemctl restart httpd

# Print status of httpd service
sudo systemctl status httpd
