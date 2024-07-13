from django.db import models
from django.contrib.auth.models import AbstractUser

class Account (AbstractUser):
    pass

class Role (models.Model):
    name = models.CharField(max_length=50)

