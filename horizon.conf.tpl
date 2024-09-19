<VirtualHost *:80>
    ServerName ${public_ip}

    Redirect permanent / https://${public_ip}/
</VirtualHost>

<VirtualHost *:443>
    ServerName ${public_ip}

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/devstack/selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/certs/devstack/selfsigned.key

    WSGIScriptAlias /dashboard /opt/stack/horizon/openstack_dashboard/wsgi.py
    WSGIDaemonProcess horizon user=stack group=stack processes=3 threads=10 home=/opt/stack/horizon display-name=%%{GROUP}
    WSGIApplicationGroup %%{GLOBAL}

    SetEnv APACHE_RUN_USER stack
    SetEnv APACHE_RUN_GROUP stack
    WSGIProcessGroup horizon

    DocumentRoot /opt/stack/horizon/.blackhole/
    Alias /dashboard/media /opt/stack/horizon/openstack_dashboard/static
    Alias /dashboard/static /opt/stack/horizon/static

    RedirectMatch "^/$" "/dashboard/"

    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>

    <Directory /opt/stack/horizon/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride None
        <IfVersion < 2.4>
            Order allow,deny
            Allow from all
        </IfVersion>
        <IfVersion >= 2.4>
            Require all granted
        </IfVersion>
    </Directory>

    <IfVersion >= 2.4>
        ErrorLogFormat "%%{cu}t %M"
    </IfVersion>
    ErrorLog /var/log/apache2/horizon_error.log
    LogLevel warn
    CustomLog /var/log/apache2/horizon_access.log combined
</VirtualHost>

WSGIPythonHome /opt/stack/data/venv
WSGISocketPrefix /var/run/apache2
