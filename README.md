## Instalacja ##
1. W folderze wybranym uruchom:
    `virtualenv venv`
    `source venv/bin/activate`
2. Sprawdź czy Django jest zainstalowane: 
    `pip list`
3. Jeśli nie, zainstaluj: 
    `pip install django`
4. Stwórz projekt Dajngo:
    `django-admin startproject <nazwa_projektu>`
5. `cd nazwa_projektu`
6. `python manage.py runserver`
7. Jeśli pojawi się błąd o niemożliwości importu Django:
    `python -m pip install --upgrade pip`
    `python -m pip install django`
8. Zrób migrację:
    `python manage.py migrate`
9. Stwórz aplikację:
    `django-admin startapp <nazwa_aplikacji>`
10. W settings.py dodaj `todo` do sekcji INSTALLED_APPS.

## Wyświetlenie strony głównej ##

1. Stwórz katalog 'templates' a w nim plik index.html.
2. W settings.py uzupełnij sekcję TEMPLATES - DIRS wskazując na katalog dla szablonów (konieczny `import os`).
3. Stwórz plik todo/urls.py i wyszczególnij w nim url dla strony głównej.
4. W pliku simply/urls.py zaimportuj 'include' i dodaj path dla ścieżki ''.
5. W pliku simply/views.py dodaj metodę dla widoku głównego.

## Pliki statyczne ##

1. Stwórz katalog 'static' a w nim pliki dla css i js.
2. W pliku settings.py ustaw DIR dla static.
3. W index.html załaduj static (load static) i zrób odniesienia dla plików css i js.

##  Struktura aplikacji ##

1. Dodaj widoki w views.py dla register, my_login, dashboard, user_logout.
2. Dodaj scieżki dla widoków w todo/urls.py 

## Register ##
1. Stwórz plik todo/forms.py 
2. W views.py dodaj import z forms.py i uzupełnij metodę register.
3. Stwórz plik register.html

## Login ##
1. Dodaj metodę LoginForm w pliku forms.py
2. W views.py uzupełnij metodę my-login
3. Stwórz szablon dla logowania.

## Logout ##
1. W pliku views.py uzupełnij metodę user_logout.

## Navigation i dashboard ##
1. Stwórz plik dashboard.html

## AWS ##
1. Stwórz konto root na AWS i konto IAM
2. Dodaj users group i stwórz usera.
3. S3 - do przechowywania plików statycznych (objects) w folderach (buckets).
    a. Przejdź do S3 i wybierz 'Create bucket'
    b. Podaj nazwę
    c. Wybierz region
    d. Usuń zaznaczenie w 'Block public access' i potwierdź ostrzeżenie.
    e. Create
    f. Po utworzeniu bucketa kliknij na niego i przejdź do 'Permissions'.
    g. W Bucket policy kliknij 'edit':
        * otwórz Policy generator w nowym oknie:
            ~ Select Type of Policy: S3 Bucket Policy
            ~ Principal: *
            ~ Actions: GetObject
            ~ ARN: adres arn twojego bucketa. Dodaj /* na końcu.
            ~ Add statement
            ~ Create i przekopiuj do S3.
4. Zainstaluj `pip install -U boto3` (SDK dla AWS), i `pip install -U django-storages`:
    a. -U oznacza, że chcesz zainstalować najnowszą wersję.
    b. W settings.py dodaj 'storages' do aplikacji zainstalowanych.
    c. W settings.py dodaj konfigurację dla Amazon S3
5. Zainstaluj AWS Cli i skonfiguruj w terminalu `aws configure`.
6. W settings.py dodaj 'storages' do aplikacji zainstalowanych.
7. `python manage.py collectstatic` - pliki statyczne zostaną przeniesione na S3 w AWS.

## RDS ##
1. Zainstaluj psycopg `pip install psycopg2-binary`.
    Przygotuj ustawienia DATABASE dla postrgesql w settings.py. Aby uzupełnić wszystkie potrzebne jest uruchomienie bazy danych na RDS.
2. Uruchom RDS na AWS - ustaw region odpowiedni.
    a. Enginie: PostgreSQL
    b. Templates: Free Tier
    c. DB instance id - popraw nazwę (wpisz ponownie np. 1) bo inaczej będzie marudzić
    d. Master Username: np amostoriDB (dodaj do settings.py od razu)
    e. Password: j.w
    f. Public acces zaznacz
    g. Additional configuration: wpisać 5432
    h. Drugie Additional configuration: 
        * initial database name - przepisz do settings.py
    i. Create (10 - 15 min)
    j. Po utworzeniu bazy kliknij jej nazwę i skopiuj Endpoint - dodaj do settings.py jako HOST
    k. Otwórz w nowym oknie Security group:
        * kliknij nazwę serucity group
        * edit inbound rules
            ~ add rule
                ^ type: PostgresSQL
                ^ 0.0.0.0/0
            ~ add rule
                ^ type: PostgresSQL
                ^ ::/0
            ~ save rules
3. Zakomentuj defaultową bazę danych w settings.py.
4. runserver - pojawią się rzeczy do migracji
    a. `python manage.py makemigrations`
    b. `python manage.py migrate`
    c. `python manage.py createsuperuser` (crmsn, Pln)

## Route 53 - domena ##

## Styling Register i Login ##

1. Zainstaluj `pip install django-crispy-forms==1.14.0`.
2. W settings.py dodaj aplikację crispy_forms i wpis CRISPY_TEMPLATE_PACK.
3. W pliku register.html dokonaj zmian.

## Dockerizering ##
1. `pip install gunicorn`
2. `pip freeze > requirements.txt`
3. Napisz Dockerfile i .dockerignore
4. Stwórz folder 'nginx' i Dockerfile w nim.
5. Przygotuj plik nginx.conf
6. W settings.py dopisz 'SECURE_PROXY_SSL_HEADER'
7. Napisz plik docker-compose.yml
8. `docker compose build`
9. `docker compose up` by uruchomić aplikację - jest dostępna pod adresem '127.0.0.1'
10. Aby posprzą†ać po testach zatrzymaj kontener z aplikacją i usuń go oraz obrazy (aplikacja Docker Desktop) następnie uruchom polecenie w terminalu: `docker system prune`.

## Deployment ##

1. W settings.py ustaw Debug na False, dodaj AllowedHosts i CSRF_Trusted_origins
2. Stwórz plik .env poza projektem i w settings.py zamień wrażliwe dane z pliku .env
3. Posprzątaj dockera (docker system prune)
4. `docker compose build`
5. Stwórz repozytorium na ECR dla nginx i django
6. Na AWS wejdź na repo dla aplikacji django i kliknij View push commands.
Wykonaj w terminalu (głównym, nie venv) pierwszą komendę (logowanie), drugiej nie rób (budowanie image), w trzeciej zmień tag na taki jak widnieje w DockerDesktop (np nginx:latest), a czwartą komendę wykonaj bez zmian.
7. Load balancer i DNS records
    a. Przejdź na EC2 i do sekcji Load Balancer kliknij Create Load Balancer.
    b. Wybierz Application Load Balancer, nadaj mu nazwę, skonfiguruj Mappings, stwórz Security Groups (usuń domyślną)
        * nadaj nazwę i uzupełnij pole description (nazwa)
        * add rule:
            ~ type: http
            ~ source: 0.0.0.0/0
        * add rule:
            ~ type: http
            ~ source: ::/0
        * add rule:
            ~ type: https
            ~ source: 0.0.0.0/0
        * add rule:
            ~ type: https
            ~ source: ::/0
    Dodaj Listeners and Routing (otwórz w nowym oknie 'create target group'):
        * nadaj nazwę
        * kliknij next i create
    Dodaj drugiego Listenera, tym razem dla https (port 443) i wybierz mu ten sam target group
    W Default SSL wybierz certyfikat dla twojej strony
    c. Przejdź do Route 53 i kliknij hosted zone
    d. Kliknij domenę
    e. W sekcji records kliknij create record
        * kliknij 'alias' i wybierz Alias to Application and Classic Load Balancer
        * ustaw region taki jak dla Load Balancera
        * ustaw load balancera  
        * kliknij 'add another record' i ustaw wszystko tak samo dla subdomeny z 'www'
    f. Przejdź do EC2 i Load Balancer i zaznacz twojego load balancera.
    g. W sekcji Listeners and rules zaznacz listener dla http i wybierz z listy edit listener.
        * W sekcji Action Types wybierz 'Redirect to Url' i wpisz port 443 dla HTTPS
8. Security Group dla ECS
    a. Przejdź do EC2, Security Groups i kliknij 'create security group'
        * nadaj nazwę i description (np ESC-SG)
        * kliknij 'add rule'
            ~ type: All TCP
            ~ source: twoj Load Balance
        * klinij create
    
9. Zdefiniuj task
    a. Przejdź do ESC i task definition. Kliknij 'creat task definition with JSON'
    b. Z pliku uzupełnij task definition zastępując elementy z url image nginx i aplikacji django pobierając URI z ECR (kontenery na Amazon)
    c. Kliknij 'create'
    d. Przejdź do Task definition i kilknij create revision i dodaj Environments Variables dla kontenera z aplikacją (drugi). Kliknij create.
10. Stwórz ECS cluster i service.
    a. Przejdź do ECS i kliknij create cluster
        * nadaj nazwę
        * W Infrastructe wybierz Amazon EC2
            ~ operating system: Amazon Linux 2023
            ~ EC2 instance type: t3.micro
        * W Subnets odznacz wszystko i zaznacz w kolejności alfabetycznej
        * W Security Groups odznacz defaultową i wybierz stworzoną w punkcie 8 (ESC-SG)
        * W auto-assign public IP wybierz turn on
        * create
        * za pierwszym razem pojawi się błąd (bug) - należy powtórzyć tworzenie clustera
    b. Kliknij twój cluster - przeniesiesz się do serviców. Wybierz create
        * W task definition wybierz Family i 'application-stack' z ostatnią revizją.
        * nadaj nazwę
        * wybierz LoadBalancer
            ~ type: Application Load Balancer
            ~ load balancer:  wybierz swój, stworzony wcześniej
            ~ target group: Use existing i wybierz swój target group
            ~ listener: Use existing i powinno wskoczyć 443
            ~ create
    c. Stiky session
        * EC2 => Target Groups. Zaznacz twój Target i w actions wybierz 'Edit target attributes'
        * Przejdź do Stickness i ustaw.

## Clean up ##

1. Usuń service.
2. Dopiero gdy zniknie draining z clustera będzie można go usunąć.
3. W S3 zaznacz twój bucket i opróżnij i następnie usuń
4. W RDS usuń bazę danych bez tworzenia kopi zapasowej.
5. W IAM kliknij users i w Security deactivate i następnie usuń acces keys
6. W EC2 przejdź do Load balancer i usuń go. 
7. Target group i Security group są bezpłatne, ale też można je usunąć po usunięciu clustera.
8. W Route 53 przejdź do Hosted zones i następnie twojej domeny
9. Usuń rekordy A.
10. W ECR zaznacz resources i usuń