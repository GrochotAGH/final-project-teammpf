from flask import Flask, render_template, request, session, redirect, url_for
import mysql.connector
from datetime import datetime
import hashlib

app = Flask(__name__)

# Konfiguracja połączenia z bazą danych
db_config = {
    'user': 'administrator',
    'password': 'haslo',
    'host': '127.0.0.1',
    'database': 'bezpieczenstwopublicznedb',
    'raise_on_warnings': True
}
app.secret_key = 'super_secret_key'

@app.route('/rejestracja.html', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # Pobranie danych z formularza
        imie = request.form['imie']
        nazwisko = request.form['nazwisko']
        email = request.form['email']
        login = request.form['login']
        haslo = request.form['haslo']
        rola = request.form['rola']

        haslo = haslo.encode('utf-8')
        haslo = hashlib.sha256(haslo).hexdigest()
        # Dodanie danych do tabeli użytkownicy
        cnx = mysql.connector.connect(**db_config)
        cursor = cnx.cursor()
        insert_query = "INSERT INTO `użytkownicy` (`login`, `hasło`, `rola`, `email`, `imię`, `nazwisko`) VALUES (%s, %s, %s, %s, %s, %s)"
        insert_values = (login, haslo, rola, email, imie, nazwisko)
        cursor.execute(insert_query, insert_values)
        cnx.commit()

        # Zwrócenie potwierdzenia rejestracji
        return "Rejestracja zakończona pomyślnie!"

    # Renderowanie szablonu formularza rejestracji
    return render_template('rejestracja.html')



@app.route('/logowanie.html', methods=['GET', 'POST'])
def logowanie():
    if request.method == 'POST':
        login = request.form['login']
        haslo = request.form['hasło']

        haslo = haslo.encode('utf-8')
        haslo = hashlib.sha256(haslo).hexdigest()
        # Szyfrowanie hasła

        # Sprawdzenie danych logowania w bazie danych
        if sprawdz_dane_logowania(login, haslo):
            session['zalogowany'] = True
            return redirect(url_for('zgloszenie'))
        else:
            return "Błędny login lub hasło"

    return render_template('logowanie.html')


# Funkcja sprawdzająca dane logowania w bazie danych
def sprawdz_dane_logowania(login, haslo):
    # Połączenie z bazą danych (tu można dodać odpowiednie dane dostępowe)

    # Przykładowe zapytanie do bazy danych w celu sprawdzenia danych logowania
    # Należy dostosować zapytanie do struktury swojej bazy danych


    cnx = mysql.connector.connect(**db_config)
    cursor = cnx.cursor()

    query = "SELECT COUNT(*) FROM `użytkownicy` WHERE `login` = %s AND `hasło` = %s"
    values = (login, haslo)

    cursor.execute(query, values)
    result = cursor.fetchone()

    cnx.commit()

    # Jeśli zapytanie zwraca wartość większą niż 0, to dane logowania są poprawne
    if result and result[0] > 0:
        return True
    else:
        return False
    
@app.route('/wyloguj', methods=['GET'])
def wyloguj():
    # Usunięcie flagi zalogowania z sesji
    session.pop('zalogowany', None)
    return redirect(url_for('zgloszenie'))
    

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
            cursor.execute(insert_query, insert_values)
            cnx.commit()

            # Pobranie ostatnio wstawionego identyfikatora zgłoszenia
            zgloszenie_id = cursor.lastrowid

            # Wstawienie danych do tabeli cechyzdarzenia z wykorzystaniem pobranego zgloszenie_id
            insert_query = "INSERT INTO cechyzdarzenia (zgloszenie_id, opis_sprawcy, opis_zdarzenia, liczba_sprawcow, miejsce, godzina) " \
                        "VALUES (%s, %s, %s, %s, %s, %s)"
            insert_values = (zgloszenie_id, opis_sprawcy, opis, liczba_sprawcow, miejsce, godzina)
            cursor.execute(insert_query, insert_values)
            cnx.commit()

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

    return render_template('index.html', zalogowany=session.get('zalogowany'))

if __name__ == '__main__':
    app.run()
