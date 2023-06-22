from flask import Flask, render_template, request
import mysql.connector
from datetime import datetime

app = Flask(__name__)

# Konfiguracja połączenia z bazą danych
db_config = {
    'user': 'administrator',
    'password': 'haslo',
    'host': '127.0.0.1',
    'database': 'bezpieczenstwopublicznedb',
    'raise_on_warnings': True
}

@app.route('/rejestracja.html')
def rejestracja():
    return render_template('rejestracja.html')

@app.route('/logowanie.html')
def logowanie():
    return render_template('logowanie.html')

# Obsługa żądania POST z formularza
@app.route('/', methods=['GET', 'POST'])
def zgloszenie():
    if request.method == 'POST':
        opis_sprawcy = request.form['sprawca']
        opis = request.form['opis']
        liczba_sprawcow = request.form['liczba']
        miejsce = request.form['miejsce']
        godzina = request.form['godzina']

        
        # Pobranie aktualnej daty i godziny
        data_zgloszenia = datetime.now().date()
        godzina_zgloszenia = datetime.now().time()

        # Utworzenie połączenia z bazą danych
        cnx = mysql.connector.connect(**db_config)
        cursor = cnx.cursor()

        try:
            # Wstawienie danych do tabeli zgłoszenia
            insert_query = "INSERT INTO zgłoszenia (tytuł, godzina_zgloszenia, data_zgloszenia, status) VALUES ('', %s, %s, 'przyjęte')" ##tu trzeba dać jeszcze user_id który powinien gdzieś być przechowywany przy zalogowaniu 
            insert_values = (godzina_zgloszenia, data_zgloszenia)

            insert_query = "INSERT INTO użytkownicy (login, hasło, rola, email, imię, nazwisko) " \
                        "VALUES ('', '', '','','','')"
            insert_values = ()
            cursor.execute(insert_query, insert_values)
            cnx.commit()            
            
            cursor.execute("SELECT LAST_INSERT_ID()")
            user_id = cursor.fetchone()[0]

            insert_query = "INSERT INTO zgłoszenia (user_id, tytuł, godzina_zgloszenia, data_zgloszenia, status) VALUES (%s,'', %s, %s, 'przyjęte')" ##tu trzeba dać jeszcze user_id który powinien gdzieś być przechowywany przy zalogowaniu 
            insert_values = (user_id, godzina_zgloszenia, data_zgloszenia)

            cursor.execute(insert_query, insert_values)
            cnx.commit()

            # Pobranie ostatnio wstawionego identyfikatora zgłoszenia
            zgloszenie_id = cursor.lastrowid

            # Wstawienie danych do tabeli cechyzdarzenia z wykorzystaniem pobranego zgloszenie_id
            insert_query = "INSERT INTO cechyzdarzenia (zgloszenie_id, opis_sprawcy, opis_zdarzenia, liczba_sprawcow, miejsce_zdarzenia, godzina_zdarzenia, data_zdarzenia) " \
                        "VALUES (%s, %s, %s, %s, %s, %s,NULL)"
            insert_values = (zgloszenie_id, opis_sprawcy, opis, liczba_sprawcow, miejsce, godzina)
            cursor.execute(insert_query, insert_values)
            cnx.commit()

            #wstawianie danych do tabeli użytkownicy


            # Wstawienie danych do tabeli sprawcy
            insert_query = "INSERT INTO sprawcy (zgloszenie_id, imie, nazwisko, data_urodzenia, opis) " \
                        "VALUES (%s, '', '', NULL, %s)"
            insert_values = (zgloszenie_id, opis_sprawcy)
            cursor.execute(insert_query, insert_values)
            cnx.commit()

            return 'Zgłoszenie dodane do bazy danych.'

        except mysql.connector.Error as error:
            cnx.rollback()
            return 'Błąd podczas dodawania zgłoszenia do bazy danych: {}'.format(error)

        finally:
            cursor.close()
            cnx.close()

    return render_template('index.html')

if __name__ == '__main__':
    app.run()
