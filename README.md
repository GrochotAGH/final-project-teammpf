<img alt="Logo" align="right" src="static/logo.png" width="20%" />

# PawsOnDuty

Web app for reporting incidents to the police. 

Project created for Web application programming languages AGH University of Cracow course. 


## Quick Overview

You can input data about the incident you saw or you found out in the form on the home site. Fill the form with info about location, date and hour, incident description, 
count of offender and their description. You can make and log into your own account. You can also browse history of your reports.

The policeman will receive your report and decide what to do. He can search exact info by date by logging into his special account: <br>
**login:** paw2 <br>
**password:** pawpaw2

## Screenshots

<img alt="Home" align="left" src="static/home.png" width="25%"/>

<img alt="Log in" align="left"  src="static/log.png" width="25%"/>

<img alt="Results" align="left" src="static/results.png" width="25%"/>

<img alt="Mobile" src="static/mobile.png" width="9%"/>


## Used Technologies

The project utilizes the following technologies:

- Programming Language: Python 3.8.0
- Web Framework: Flask 2.3.2
- Server: XAMPP (Apache, MySQL, PHP)
- Database Library: mysql-connector-python
- User Interface: HTML5, CSS3, JavaScript

Description of Technologies:

- **Python 3.8.0**: Powerful and versatile programming language known for its simplicity and readability.

- **Flask 2.3.2**:  Lightweight web framework for Python that provides tools and features for building web applications.

- **XAMPP**: Cross-platform software package that includes Apache web server, MySQL database server, and PHP scripting language. It provides a convenient environment for developing and testing web applications locally.

- **mysql-connector-python**: :Library which provides a Python interface to interact with the MySQL database.

- **HTML5, CSS3, JavaScript**: Front-end technologies used for creating the user interface and managing dynamic elements of the webpage.


### Requirements

To run this project, you need to have the following software installed:

- Python 3.8.0
- Flask 2.3.2
- XAMPP (Apache, MySQL, PHP)

### Installation

1. Clone the project repository to your local machine.


### Database Configuration

1. Install XAMPP on your computer, which includes Apache, MySQL, and PHP.
2. Start the XAMPP control panel and make sure the Apache and MySQL services are running.
3. Open a web browser and navigate to `http://localhost/phpmyadmin` to access the phpMyAdmin interface.
4. Create a new database and import the provided SQL file in the project directory.
5. Update the database connection details (host, username, password, database name) in the project configuration file (`app.py`).


### Running the Application

1. Open a terminal and navigate to the project directory.
2. Run the following command to start the Flask development server:
python app.py
3. The application should now be running at `http://localhost:5000`. Open a web browser and navigate to this URL to access the application.


### Using the Application

1. As a civillian use the form to add crime report. You can create an account and view all of your reports.
2. As an officer you can view all of the reports from a specific date and change their status.
3. The application allows tasks such as creating and updating records, as well as browsing data from the MySQL database.
4. Follow the on-screen instructions and use the available forms and buttons to interact with the application's features.



## Credits

### Contributions: <br>
**Maria Mostek** - front-end & back-end development, logo design <br>
**Patrycja Ruda** - back-end develompent <br>
**Filip Kuś** - front-end development 

### Used API: <br>
Maps Javascript API by Google - https://developers.google.com/maps/documentation/javascript/overview?hl=pl

### Used icons - thanks do the authors:
Icons 8 - https://www.iconarchive.com/show/ios7-icons-by-icons8/time-and-date-calendar-icon.html <br>
          https://icons8.com/icons/set/hamburger-button--white 
          
Freepik - https://www.flaticon.com/free-icon/info_1445402?term=info&page=1&position=20&origin=search&related_id=1445402 <br>
          https://www.flaticon.com/free-icon/contact-form_3447545?term=form&page=1&position=5&origin=search&related_id=3447545 <br>
          https://www.flaticon.com/free-icon/policeman_2099783?term=policeman&page=1&position=2&origin=tag&related_id=2099783 <br>
          https://www.flaticon.com/free-icon/user_456212?term=user&page=1&position=1&origin=tag&related_id=456212
          
Gregor Cresnar - https://www.freepik.com/icon/telephone_126341#position=8&page=1&term=phone&fromView=keyword






<br> Cracow, 2023.
