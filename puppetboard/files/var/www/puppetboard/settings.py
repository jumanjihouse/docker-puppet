import os

DEV_LISTEN_HOST = '127.0.0.1'
DEV_LISTEN_PORT = 9090
ENABLE_QUERY = True
LOCALISE_TIMESTAMP = True
LOGLEVEL = 'debug'
PUPPETDB_EXPERIMENTAL = False
PUPPETDB_HOST = 'puppetdb.inf.ise.com'
PUPPETDB_PORT = 8081
PUPPETDB_CERT = '/var/lib/puppet/ssl/certs/puppetboard.inf.ise.com.pem'
PUPPETDB_KEY = '/var/lib/puppet/ssl/private_keys/puppetboard.inf.ise.com.pem'
PUPPETDB_SSL_VERIFY = False
PUPPETDB_TIMEOUT = 20
SECRET_KEY = os.urandom(24)
DEV_COFFEE_LOCATION = 'coffee'
OFFLINE_MODE = False
ENABLE_CATALOG = True
REPORTS_COUNT = 40
UNRESPONSIVE_HOURS = 25
GRAPH_FACTS = ['architecture',
               'domain',
               'lsbcodename',
               'lsbdistcodename',
               'lsbdistid',
               'lsbdistrelease',
               'lsbmajdistrelease',
               'netmask',
               'osfamily',
               'puppetversion',
               'processorcount']
INVENTORY_FACTS = [ ('Hostname',       'fqdn'              ),
                    ('IP Address',     'ipaddress'         ),
                    ('OS',             'lsbdistdescription'),
                    ('Architecture',   'hardwaremodel'     ),
                    ('Kernel Version', 'kernelrelease'     ),
                    ('Puppet Version', 'puppetversion'     ), ]
