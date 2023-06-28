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


@app.route('/index.html')
def przekierowanieZgloszenie():
    try:
        if session['rola']=='funkcjonariusz':
            return render_template('przegladanie.html', zalogowany=session.get('zalogowany'), imie=session.get('imie'))
        else:
            return render_template('index.html', zalogowany=session.get('zalogowany'), imie=session.get('imie'))
    except:
        return render_template('index.html')
    

@app.route('/przegladanie.html')
def przegladanie():
    return render_template('przegladanie.html', zalogowany=session.get('zalogowany'), imie=session.get('imie'))


@app.route('/rejestracja.html', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # Pobranie danych z formularza
        imie = request.form['imie']
        nazwisko = request.form['nazwisko']
        email = request.form['email']
        login = request.form['login']
        haslo = request.form['hasło']
        rola = 'cywil'

        haslo = haslo.encode('utf-8')
        haslo = hashlib.sha256(haslo).hexdigest()
        # Dodanie danych do tabeli użytkownicy
        cnx = mysql.connector.connect(**db_config)
        cursor = cnx.cursor()
        insert_query = "INSERT INTO `użytkownicy` (`login`, `hasło`, `rola`, `email`, `imię`, `nazwisko`) VALUES (%s, %s, %s, %s, %s, %s)"
        insert_values = (login, haslo, rola, email, imie, nazwisko)
        cursor.execute(insert_query, insert_values)
        cnx.commit()
        return redirect(url_for('logowanie'))
    

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
        # Pobranie user_id z bazy danych
            user_id = pobierz_user_id(login)
            rola = pobierz_role_uzytkownika(login)
        # Dodanie user_id do sesji
            session['user_id'] = user_id
            session['zalogowany'] = True
            session['rola'] = rola
            session['imie'] = pobierz_imie_uzytkownika(login)  # Funkcja pobierz_imie_uzytkownika() powinna zwrócić imię użytkownika na podstawie loginu
            if rola == 'cywil':
                return redirect(url_for('zgloszenie'))
            else:
                return redirect(url_for('przegladanie'))
        else:
            session['komunikat'] = 'Nieprawidłowy login lub hasło'
            return redirect(url_for('logowanie'))
    komunikat = session.pop('komunikat', None)
    return render_template('logowanie.html', komunikat=komunikat)

# Funkcja pomocnicza do pobierania user_id z bazy danych na podstawie loginu
def pobierz_user_id(login):
    cnx = mysql.connector.connect(**db_config)
    cursor = cnx.cursor()
    query = "SELECT user_id FROM `użytkownicy` WHERE `login` = %s"
    cursor.execute(query, (login,))
    result = cursor.fetchone()
    cnx.close()
    if result:
        return result[0]
    else:
        return None

def pobierz_imie_uzytkownika(login):
    cnx = mysql.connector.connect(**db_config)
    cursor = cnx.cursor()
    query = "SELECT imię FROM `użytkownicy` WHERE `login` = %s"
    cursor.execute(query, (login,))
    result = cursor.fetchone()
    cnx.close()
    if result:
        return result[0]
    else:
        return ""
    
# Funkcja pomocnicza do pobierania roli użytkownika na podstawie loginu
def pobierz_role_uzytkownika(login):
    cnx = mysql.connector.connect(**db_config)
    cursor = cnx.cursor()
    query = "SELECT rola FROM `użytkownicy` WHERE `login` = %s"
    cursor.execute(query, (login,))
    result = cursor.fetchone()
    cnx.close()
    if result:
        return result[0]
    else:
        return None


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
    session.pop('user_id', None)  # Usunięcie również user_id z sesji
    session.pop('rola', None) #usunięcie roli z sesji
    return redirect(url_for('logowanie'))

@app.route('/', methods=['GET', 'POST'])
# def przekierowanie():
#     if session.get('rola') == 'funkcjonariusz':
#         return redirect(url_for('przegladanie'))
#     else:
#         return redirect(url_for('zgloszenie'))
def zgloszenie():
    if request.method == 'POST':
        #opis_sprawcy = request.form['sprawca']
        opis = request.form['opis']
        liczba_sprawcow = request.form['liczba']
        godzina = request.form['godzina']
        data = request.form['data']
        adres = request.form['location-input']
        numer_lokalu = request.form['numer_lokalu']
        miasto = request.form['locality-input']
        wojewodztwo = request.form['administrative_area_level_1-input']
        kod_pocztowy = request.form['postal_code-input']
        # Pobranie aktualnej daty i godziny
        data_zgloszenia = datetime.now().date()
        godzina_zgloszenia = datetime.now().time()

                # Sprawdzenie, czy użytkownik jest zalogowany
        if session.get('zalogowany'):
            # Pobranie user_id z sesji
            user_id = session.get('user_id')
        else:
            user_id = None

        # Utworzenie połączenia z bazą danych
        cnx = mysql.connector.connect(**db_config)
        cursor = cnx.cursor()

        try:
            # Wstawienie danych do tabeli zgłoszenia
            insert_query = "INSERT INTO zgłoszenia (tytuł, user_id, godzina_zgloszenia, data_zgloszenia, status) " \
                           "VALUES ('', %s, %s, %s, 'przyjęte')"
            insert_values = (user_id, godzina_zgloszenia, data_zgloszenia)
            cursor.execute(insert_query, insert_values)
            cnx.commit()

            # Pobranie ostatnio wstawionego identyfikatora zgłoszenia
            zgloszenie_id = cursor.lastrowid

            # Wstawienie danych do tabeli cechyzdarzenia z wykorzystaniem pobranego zgloszenie_id
            insert_query = "INSERT INTO cechyzdarzenia (zgloszenie_id, opis_sprawcy, opis_zdarzenia, liczba_sprawcow, adres, godzina_zdarzenia, data_zdarzenia, numer_lokalu, miasto, wojewodztwo, kod_pocztowy) " \
                        "VALUES (%s, NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            insert_values = (zgloszenie_id, opis, liczba_sprawcow, adres, godzina, data, numer_lokalu, miasto, wojewodztwo, kod_pocztowy)
            cursor.execute(insert_query, insert_values)
            cnx.commit()


            # Wstawienie danych do tabeli sprawcy
            insert_query = "INSERT INTO sprawcy (zgloszenie_id, imie, nazwisko, data_urodzenia, opis) " \
                         "VALUES (%s, '', '', NULL, '')"
            insert_values = (zgloszenie_id,)
            cursor.execute(insert_query, insert_values)
            cnx.commit()

            # Zapisanie komunikatu do sesji
            session['komunikat'] = 'Dziękujemy za przesłanie zgłoszenia'

            # Przekierowanie na stronę zgłoszenia
            return redirect(url_for('zgloszenie'))

        except mysql.connector.Error as error:
            cnx.rollback()
            return 'Błąd podczas dodawania zgłoszenia do bazy danych: {}'.format(error)

        finally:
            cursor.close()
            cnx.close()
        
    # Pobranie komunikatu z sesji i usunięcie go
    komunikat = session.pop('komunikat', None)
    return render_template('index.html', zalogowany=session.get('zalogowany'), imie=session.get('imie'), komunikat=komunikat)

if __name__ == '__main__':
    app.run()
