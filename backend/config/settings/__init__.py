import os

environment = os.environ.get("DJANGO_SETTINGS_MODULE", "config.settings.dev")

if environment == "config.settings.prod":
    from .prod import *
else:
    from .dev import *
